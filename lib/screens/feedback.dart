// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_print,prefer_const_literals_to_create_immutables, invalid_use_of_visible_for_testing_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vaxicheck/screens/home.dart';
import 'package:vaxicheck/shared/constants.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({Key? key}) : super(key: key);

  @override
  _FeedBackState createState() => _FeedBackState();
}

final _formKey = GlobalKey<FormState>();
String topic = '';
String body = '';
String initValue = '';
String message = '';
String errorMessage = '';
bool isTopicReady = false;
bool isBodyReady = false;

final firestoreInstance = FirebaseFirestore.instance;

var firebaseUser = FirebaseAuth.instance.currentUser;

void _showToast(BuildContext context) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: Colors.greenAccent,
          ),
          SizedBox(
            width: 20,
          ),
          Text(message),
        ],
      ),
      action:
          SnackBarAction(label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

class _FeedBackState extends State<FeedBack> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("Feedback"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: initValue,
                      validator: (val) =>
                          val!.isEmpty ? 'Topic cannot be empty' : null,
                      decoration: textInputDecoration.copyWith(
                        labelText: "Topic",
                        errorText:
                            isTopicReady ? null : 'Topic cannot be empty',
                      ),
                      onChanged: (val) {
                        setState(() {
                          topic = val;
                          topic.isEmpty
                              ? isTopicReady = false
                              : isTopicReady = true;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: initValue,
                      maxLines: null,
                      decoration: textInputDecoration.copyWith(
                        labelText: "Body",
                        errorText: isBodyReady ? null : 'Body cannot be empty',
                      ),
                      onChanged: (val) {
                        setState(() {
                          body = val;
                          body.isEmpty
                              ? isBodyReady = false
                              : isBodyReady = true;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                      padding: EdgeInsets.only(right: 0, left: 7),
                      color: Colors.blue[800],
                      textColor: Colors.white,
                      onPressed: () async {
                        isBodyReady & isTopicReady
                            ? firestoreInstance
                                .collection("users")
                                .doc(firebaseUser?.uid)
                                .collection("feedback")
                                .doc(topic)
                                .set({
                                "feedback": body,
                              }).then((_) {
                                Navigator.pop(context);
                                setState(() {
                                  message = "Feedback submitted";
                                  initValue = "";
                                  topic = "";
                                  body = "";
                                });
                                _showToast(context);
                              }).whenComplete(() => {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Home()),
                                        (Route<dynamic> route) => false,
                                      ),
                                    })
                            : null;
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Submit"),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
