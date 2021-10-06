// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_unnecessary_containers, prefer_is_empty, sized_box_for_whitespace, unused_label, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:vaxicheck/screens/new_vacc.dart';
import 'package:vaxicheck/services/auth.dart';
import 'package:vaxicheck/services/searchservice.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var queryResultSet = [];
  var tempSearchStore = [];
  bool isSearching = false;
  final AuthService _auth = AuthService();
  var firebaseUser = FirebaseAuth.instance.currentUser;

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
          setState(() {
            tempSearchStore.add(queryResultSet[i]);
          });
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['vaccName'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isSearching
        ? Scaffold(
            drawer: Drawer(),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue[800],
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => NewVaccinePage()));
              },
              child: Icon(Icons.add),
            ),
            backgroundColor: Colors.blue[50],
            appBar: AppBar(
              backgroundColor: Colors.blue[800],
              title: !isSearching
                  ? Text("VaxiCheck")
                  : TextField(
                      onChanged: (val) {
                        initiateSearch(val);
                      },
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                        ),
                        hintText: 'Search a vaccine record',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
              actions: [
                isSearching
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            isSearching = !isSearching;
                          });
                        },
                        icon: Icon(Icons.cancel),
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            isSearching = !isSearching;
                            queryResultSet = [];
                            tempSearchStore = [];
                          });
                        },
                        icon: Icon(Icons.search_rounded),
                      ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () async {
                        await _auth.signOut();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.blue[900]),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Logout",
                            style: TextStyle(color: Colors.blue[900]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(firebaseUser?.uid)
                    .collection('vaccines')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView(
                    children: snapshot.data!.docs.map(
                      (document) {
                        return Card(
                          elevation: 10,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 1),
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                    child: ExpansionTile(
                                      tilePadding: EdgeInsets.all(10),
                                      backgroundColor: Colors.white,
                                      collapsedBackgroundColor: Colors.white,
                                      textColor: Colors.black,
                                      collapsedTextColor: Colors.black,
                                      title: Column(
                                        children: [
                                          Text(
                                            document['vaccName'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Date : " + document['date'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Doses : " + document['doses'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              height: 150,
                                              color: Colors.amber[100],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          right: 10,
                                                          bottom: 5),
                                                  child: FlatButton(
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            AlertDialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          title:
                                                              Text('Delete?'),
                                                          content: Container(
                                                            child: Text(
                                                                'This will delete the current record'),
                                                          ),
                                                          actions: [
                                                            FlatButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(false);
                                                              },
                                                              child: Text(
                                                                'Cancel',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            ),
                                                            FlatButton(
                                                              color: Colors.red,
                                                              onPressed: () {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "users")
                                                                    .doc(firebaseUser
                                                                        ?.uid)
                                                                    .collection(
                                                                        'vaccines')
                                                                    .doc(document[
                                                                            'vaccName']
                                                                        .toString()
                                                                        .toLowerCase())
                                                                    .delete();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(false);
                                                              },
                                                              child: Text(
                                                                'Delete',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                          ],
                                                          elevation: 24,
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  );
                },
              ),
            ),
          )
        : MaterialApp(
            home: Scaffold(
              drawer: Drawer(),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blue[800],
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NewVaccinePage()));
                },
                child: Icon(Icons.add),
              ),
              backgroundColor: Colors.blue[50],
              appBar: AppBar(
                backgroundColor: Colors.blue[800],
                title: !isSearching
                    ? Text("VaxiCheck")
                    : TextField(
                        onChanged: (val) {
                          initiateSearch(val);
                        },
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.search_rounded,
                            color: Colors.white,
                          ),
                          hintText: 'Search a vaccine record',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                actions: [
                  isSearching
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              isSearching = !isSearching;
                            });
                          },
                          icon: Icon(Icons.cancel),
                        )
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              isSearching = !isSearching;
                            });
                          },
                          icon: Icon(Icons.search_rounded),
                        ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () async {
                          await _auth.signOut();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.blue[900]),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Logout",
                              style: TextStyle(color: Colors.blue[900]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                    childAspectRatio: (1 / .65),
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    primary: false,
                    shrinkWrap: true,
                    children: tempSearchStore.map((element) {
                      return buildResultCard(element);
                    }).toList()),
              ),
            ),
          );
  }
}

// search result card widget
Widget buildResultCard(data) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 2,
    child: Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                data['vaccName'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Record Found',
              style: TextStyle(color: Colors.green[700]),
            ),
            SizedBox(
              height: 5,
            ),
            Text('Go back to home for more details'),
          ],
        ),
      ),
    ),
  );
}
