// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_unnecessary_containers, prefer_is_empty, sized_box_for_whitespace, unused_label, avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:in_app_review/in_app_review.dart';
// import 'package:vaxicheck/screens/edit_vacc.dart';
import 'package:vaxicheck/screens/expanded_view_image.dart';
import 'package:vaxicheck/screens/new_vacc.dart';
import 'package:vaxicheck/screens/vacc_ed.dart';
import 'package:vaxicheck/services/auth.dart';
import 'package:vaxicheck/services/searchservice.dart';
import 'package:badges/badges.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var queryResultSet = [];
  var tempSearchStore = [];
  bool isSearching = false;
  File? file;
  int imageCount = 1;
  int notifCounter = 1;

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
            drawer: Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://t3.ftcdn.net/jpg/04/53/77/50/360_F_453775063_7wL8UuP3ZKKcIlBOTxyph9q8vMeqR5C3.jpg"),
                          fit: BoxFit.cover),
                    ),
                    padding: EdgeInsets.all(0),
                    child: Container(
                      padding: EdgeInsets.all(25),
                      // color: Colors.blue[900],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue[900],
                            child: ClipOval(
                                child: firebaseUser!.photoURL == null
                                    ? Icon(
                                        Icons.account_circle,
                                        size: 70,
                                      )
                                    : Image.network(firebaseUser!.photoURL!)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          firebaseUser!.email == null
                              ? Text(
                                  "No Email Found",
                                  style: TextStyle(color: Colors.white),
                                )
                              : Text(
                                  firebaseUser!.email!,
                                  style: TextStyle(color: Colors.white),
                                ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: const [
                        Text(
                          "Add Account",
                          style: TextStyle(color: Colors.transparent),
                        ),
                        SizedBox(
                          width: 160,
                        ),
                        Icon(
                          Icons.add,
                          color: Colors.transparent,
                        )
                      ],
                    ),
                  ),
                  Divider(color: Colors.transparent),
                  Container(
                    height: MediaQuery.of(context).size.height - 510,
                    color: Colors.transparent,
                    child: SingleChildScrollView(
                      child: Column(
                        children: const [],
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.info_outline_rounded,
                            color: Colors.blue[900]),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "About",
                          style: TextStyle(color: Colors.blue[900]),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      showAboutDialog(
                          context: context,
                          applicationName: 'VaxiCheck',
                          applicationVersion: '2.0.0',
                          applicationIcon: Container(
                            height: 40,
                            child: Image.asset('lib/assets/logo.png'),
                          ),
                          applicationLegalese:
                              '''VaxiCheck is an application that lets users keep track of their general vaccination and inoculation schedules. Children across the world up to 20 years of age are administered a variety of preventive vaccination from birth to build their long term immunity from a variety of life-threatening diseases. Vaccination schedules are spread over a long period of time ranging from a few weeks to a few years which makes it hard for the parents to track these over many years. Additionally - doctors, record-keeping books lack standards across many regions and countries and records are hard to read, follow and maintain over time.

This app intends to simplify book keeping for how General Vaccination schedules are tracked, maintained and referred after these are administered on the advice of practising physicians. 

Legal Disclaimer :
This android application is created only for the purpose of digitally organising and tracking information. The application does not intend to provide any specific medical recommendation or professional advice. Users are suggested to follow professional vaccination advice from their respective medical practitioners. This tool should be used as an aid to digitally track the vaccination schedule as suggested by the respective practitioner. The app does not provide any medical advice directly or indirectly.

In no event, the developer of the application will be liable in any manner for any direct, indirect, incidental, consequential, indirect or punitive damages arising out of your access, use or inability to use the application or any errors/omission in the information on this application. The creator of the application reserves the right at any time and from time to time to add, modify and update or discontinue, temporarily or permanently the application (or any part thereof) with or without notice. The creator of the application shall not be liable to you or to any third party for any addition, modification, suspension or discontinuation of this application.''');
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.book, color: Colors.blue[900]),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Vaccine Dictionary (Beta)",
                          style: TextStyle(color: Colors.blue[900]),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => VaccEdPage()));
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.feedback, color: Colors.blue[900]),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Feedback",
                          style: TextStyle(color: Colors.blue[900]),
                        ),
                      ],
                    ),
                    onTap: () async {
                      final InAppReview inAppReview = InAppReview.instance;
                      inAppReview
                          .openStoreListing()
                          .then((value) => Navigator.of(context).pop());
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red[900]),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Logout",
                          style: TextStyle(color: Colors.red[900]),
                        ),
                      ],
                    ),
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text('Logout'),
                                content: Text('You will have to sign in again'),
                                actions: [
                                  ButtonBar(
                                    children: [
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      FlatButton(
                                          color: Colors.red,
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            await _auth.signOut();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              "Logout",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                          ))
                                    ],
                                  ),
                                ],
                              ));
                    },
                  ),
                ],
              ),
            ),
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
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        notifCounter = 0;
                      });
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                actionsPadding: EdgeInsets.all(0),
                                title: Text('Coming Soon...'),
                                content: Text('''
1. Vaccination Reminders
2. Family profiles'''),
                                actions: [
                                  ButtonBar(
                                    buttonPadding: EdgeInsets.all(0),
                                    children: [
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("OK"),
                                      ),
                                    ],
                                  ),
                                ],
                              ));
                    },
                    child: Badge(
                      position: BadgePosition(top: 0, end: 0),
                      toAnimate: true,
                      showBadge: notifCounter > 0 ? true : false,
                      animationType: BadgeAnimationType.slide,
                      badgeContent: Text(
                        '$notifCounter',
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                      child: Icon(Icons.notifications),
                    ),
                  ),
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
                  return snapshot.data!.docs.isNotEmpty
                      ? ListView(
                          children: snapshot.data!.docs.map(
                            (document) {
                              return Card(
                                elevation: 10,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Container(
                                          child: ExpansionTile(
                                            key: GlobalKey(),
                                            tilePadding: EdgeInsets.all(10),
                                            backgroundColor: Colors.white,
                                            collapsedBackgroundColor:
                                                Colors.white,
                                            textColor: Colors.black,
                                            collapsedTextColor: Colors.black,
                                            title: Column(
                                              children: [
                                                Text(
                                                  document['vaccName'],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Doses : " +
                                                      document['doses'],
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            children: [
                                              Column(
                                                children: [
                                                  document
                                                          .data()
                                                          .toString()
                                                          .contains('imageUrl')
                                                      ? GestureDetector(
                                                          child: ConstrainedBox(
                                                            constraints:
                                                                BoxConstraints(
                                                              maxHeight: 135,
                                                              minHeight: 0,
                                                            ),
                                                            child: Container(
                                                              color: Colors
                                                                  .amber[100],
                                                              child: Image.network(
                                                                  document[
                                                                      'imageUrl']),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => ExpandedViewImage(
                                                                      imageUrl:
                                                                          document[
                                                                              'imageUrl'],
                                                                      vaccName:
                                                                          document[
                                                                              'vaccName'],
                                                                      doses: document[
                                                                          'doses'],
                                                                      date: document[
                                                                          'date']),
                                                                ));
                                                          },
                                                        )
                                                      : Container(),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      // Padding(
                                                      //   padding:
                                                      //       const EdgeInsets
                                                      //               .only(
                                                      //           top: 10,
                                                      //           right: 10,
                                                      //           bottom: 5),
                                                      //   child: FlatButton(
                                                      //     minWidth: 0,
                                                      //     color:
                                                      //         Colors.blue[800],
                                                      //     onPressed: () {
                                                      //       showDialog(
                                                      //         context: context,
                                                      //         builder: (_) =>
                                                      //             AlertDialog(
                                                      //           shape:
                                                      //               RoundedRectangleBorder(
                                                      //             borderRadius:
                                                      //                 BorderRadius
                                                      //                     .circular(
                                                      //                         12),
                                                      //           ),
                                                      //           title: Text(
                                                      //               'Edit'),
                                                      //           content:
                                                      //               Container(
                                                      //             child: Text(
                                                      //                 'This action can not be undone.'),
                                                      //           ),
                                                      //           actions: [
                                                      //             FlatButton(
                                                      //               onPressed:
                                                      //                   () {
                                                      //                 Navigator.of(
                                                      //                         context)
                                                      //                     .pop(
                                                      //                         false);
                                                      //               },
                                                      //               child: Text(
                                                      //                 'Cancel',
                                                      //                 style: TextStyle(
                                                      //                     color: Colors
                                                      //                         .blue,
                                                      //                     fontSize:
                                                      //                         15),
                                                      //               ),
                                                      //             ),
                                                      //             FlatButton(
                                                      //               color: Colors
                                                      //                       .blue[
                                                      //                   800],
                                                      //               onPressed:
                                                      //                   () {
                                                      //                 Navigator
                                                      //                     .push(
                                                      //                   context,
                                                      //                   MaterialPageRoute(
                                                      //                     builder: (context) =>
                                                      //                         EditVaccPage(
                                                      //                       date:
                                                      //                           document['date'],
                                                      //                       doses:
                                                      //                           document['doses'],
                                                      //                       vaccName:
                                                      //                           document['vaccName'],
                                                      //                       imageUrl:
                                                      //                           document['imageUrl'],
                                                      //                     ),
                                                      //                   ),
                                                      //                 ).then((value) =>
                                                      //                     Navigator.of(context)
                                                      //                         .pop());
                                                      //               },
                                                      //               child: Text(
                                                      //                 'Next',
                                                      //                 style: TextStyle(
                                                      //                     color: Colors
                                                      //                         .white,
                                                      //                     fontSize:
                                                      //                         15),
                                                      //               ),
                                                      //             ),
                                                      //             SizedBox(
                                                      //               width: 5,
                                                      //             ),
                                                      //           ],
                                                      //           elevation: 24,
                                                      //         ),
                                                      //       );
                                                      //     },
                                                      //     child: Icon(
                                                      //       Icons.edit,
                                                      //       color: Colors.white,
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10,
                                                                right: 10,
                                                                bottom: 5),
                                                        child: FlatButton(
                                                          color: Colors.red,
                                                          minWidth: 0,
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
                                                                title: Text(
                                                                    'Delete'),
                                                                content:
                                                                    Container(
                                                                  child: Text(
                                                                      'This action can not be undone.'),
                                                                ),
                                                                actions: [
                                                                  FlatButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(
                                                                              false);
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
                                                                    color: Colors
                                                                        .red,
                                                                    onPressed:
                                                                        () {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "users")
                                                                          .doc(firebaseUser
                                                                              ?.uid)
                                                                          .collection(
                                                                              'vaccines')
                                                                          .doc(document['vaccName']
                                                                              .toString()
                                                                              .toLowerCase())
                                                                          .delete();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(
                                                                              false);

                                                                      var uid =
                                                                          firebaseUser
                                                                              ?.uid;
                                                                      Reference ref = FirebaseStorage
                                                                          .instance
                                                                          .ref()
                                                                          .child(
                                                                              "images/")
                                                                          .child(
                                                                              "$uid/")
                                                                          .child(document['vaccName']
                                                                              .toString()
                                                                              .toLowerCase());
                                                                      ref.delete();
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
                                                          child: Icon(
                                                            Icons.delete,
                                                            color: Colors.white,
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
                        )
                      : Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Stack(
                            children: [
                              Positioned(
                                child: Center(
                                  child: Container(
                                    width: 500,
                                    child: Card(
                                      elevation: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  5,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Image.asset(
                                                  "lib/assets/welcomeCards/$imageCount.png")),
                                          ButtonBar(
                                            children: [
                                              imageCount < 4
                                                  ? FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        NewVaccinePage()));
                                                      },
                                                      child: Text("Skip"),
                                                    )
                                                  : SizedBox(width: 0),
                                              imageCount > 1
                                                  ? FlatButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          imageCount >= 1
                                                              ? imageCount -= 1
                                                              : null;
                                                        });
                                                      },
                                                      child: Text("Previous"),
                                                    )
                                                  : SizedBox(width: 0),
                                              FlatButton(
                                                onPressed: () {
                                                  setState(() {
                                                    imageCount < 4
                                                        ? imageCount += 1
                                                        : Navigator.of(context)
                                                            .push(MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        NewVaccinePage()));
                                                  });
                                                },
                                                child: Text("Next"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              imageCount == 2
                                  ? Positioned(
                                      bottom: 20,
                                      right: 40,
                                      child: Container(
                                        height: 75,
                                        child: Image.asset(
                                            "lib/assets/arrows.png"),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        );
                },
              ),
            ),
          )
        : MaterialApp(
            home: Scaffold(
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
                        autofocus: true,
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
                      : Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isSearching = !isSearching;
                                });
                              },
                              icon: Icon(Icons.search_rounded),
                            ),
                          ],
                        ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                    childAspectRatio: (1 / .65),
                    crossAxisCount: MediaQuery.of(context).size.width ~/ 165,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    primary: false,
                    shrinkWrap: true,
                    children: tempSearchStore.map((element) {
                      return buildResultCard(element, context);
                    }).toList()),
              ),
            ),
          );
  }
}

// search result card widget
Widget buildResultCard(element, context) {
  return GestureDetector(
    child: Card(
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
                  element['vaccName'],
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
              Text('Tap for more details'),
            ],
          ),
        ),
      ),
    ),
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExpandedViewImage(
                imageUrl: element['imageUrl'],
                vaccName: element['vaccName'],
                doses: element['doses'],
                date: element['date']),
          ));
    },
  );
}
