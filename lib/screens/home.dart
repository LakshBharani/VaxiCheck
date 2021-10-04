// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_unnecessary_containers, prefer_is_empty, sized_box_for_whitespace, unused_label
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:vaxicheck/screens/new_vacc.dart';
import 'package:vaxicheck/services/auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = false;
  final AuthService _auth = AuthService();
  var firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[800],
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NewVaccinePage()));
        },
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: !isSearching
            ? Text("VaxiCheck")
            : TextField(
                // onChanged: (val) {
                //   initiateSearch(val);
                // },
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser?.uid)
            .collection('Vaccines')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.08,
                  height: MediaQuery.of(context).size.height / 7.5,
                  child: Card(
                    elevation: 10,
                    color: Colors.white,
                    shadowColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Center(
                                child: Text(
                                  document['vaccName'],
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          Positioned.fill(
                            child: Text("Date : " + document['date']),
                            left: 10,
                            top: 30,
                          ),
                          Positioned.fill(
                            child: Text("Doses : " + document['doses']),
                            left: 10,
                            top: 53,
                          ),
                          Positioned(
                            child: FlatButton(
                              height: MediaQuery.of(context).size.height / 7.5,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    title: Text('Delete?'),
                                    content: Container(
                                      height: 50,
                                      child: Row(
                                        // ignore: prefer_const_literals_to_create_immutables
                                        children: [
                                          Text(
                                              'This will delete the current record'),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: FlatButton(
                                          color: Colors.redAccent,
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(firebaseUser?.uid)
                                                .collection('Vaccines')
                                                .doc(document['vaccName']
                                                    .toString()
                                                    .toLowerCase())
                                                .delete();
                                            Navigator.of(context).pop(false);
                                          },
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                      CupertinoDialogAction(
                                        child: FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ],
                                    elevation: 24,
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.delete,
                                size: 30,
                                color: Colors.red,
                              ),
                            ),
                            right: 0,
                            top: -10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
