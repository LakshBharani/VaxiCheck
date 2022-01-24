// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VaccEdPage extends StatefulWidget {
  const VaccEdPage({Key? key}) : super(key: key);

  @override
  _VaccEdPageState createState() => _VaccEdPageState();
}

var firebaseUser = FirebaseAuth.instance.currentUser;

class _VaccEdPageState extends State<VaccEdPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("Vaccine Dictionary"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("edInfo").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
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
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              child: ExpansionTile(
                                key: GlobalKey(),
                                childrenPadding:
                                    EdgeInsets.fromLTRB(10, 0, 10, 15),
                                tilePadding: EdgeInsets.all(10),
                                backgroundColor: Colors.white,
                                collapsedBackgroundColor: Colors.white,
                                textColor: Colors.black,
                                collapsedTextColor: Colors.black,
                                title: Column(
                                  children: [
                                    Text(
                                      document['name'],
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "For individual above : " +
                                          document['age_low'] +
                                          " years",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "About : " + document['about'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Dosage : " + document['dosage'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Column(
                                    children: [
                                      (document
                                              .data()
                                              .toString()
                                              .contains('imageUrl'))
                                          ? GestureDetector(
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxHeight: 135,
                                                  minHeight: 0,
                                                ),
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Image.network(
                                                      document['imageUrl']),
                                                ),
                                              ),
                                            )
                                          : Container(),
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
    );
  }
}
