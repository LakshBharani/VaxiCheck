// ignore_for_file: deprecated_member_use, avoid_unnecessary_containers, prefer_const_constructors, avoid_print

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vaxicheck/shared/constants.dart';
import 'package:vaxicheck/shared/loading.dart';

class ResetPwd extends StatefulWidget {
  const ResetPwd({Key? key}) : super(key: key);

  @override
  _ResetPwdState createState() => _ResetPwdState();
}

class _ResetPwdState extends State<ResetPwd> {
  final _formKey = GlobalKey<FormState>();

  String email = "";
  bool timeUp = true;
  bool loading = false;
  bool isReady = false;
  String error = '';
  int seconds = 30;

  Timer? timer;
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          timeUp = false;
          seconds--;
          if (seconds > 0) {
            print(seconds);
          } else {
            print("Time up");
            if (mounted) {
              setState(() {
                timeUp = true;
                seconds = 30;
              });
            }

            timer!.cancel();
          }
        });
      }
    });
  }

  bool success = false;
  bool emailValid = true;

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.blue[50],
            appBar: AppBar(
              title: const Text('Reset Password'),
              backgroundColor: Colors.blue[800],
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        success
                            ? Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.amber.shade800,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error,
                                      color: Colors.amber[800],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                          "Email sent. If you have not received it please check email and try again."),
                                    ),
                                  ],
                                ))
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email_rounded),
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                        ),
                        emailValid
                            ? Container()
                            : Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    Text(
                                      "Invalid Email",
                                      style: TextStyle(
                                        color: Colors.red,
                                        decoration: TextDecoration.underline,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        emailValid
                            ? SizedBox(
                                height: 20,
                              )
                            : SizedBox(
                                height: 10,
                              ),
                        Container(
                          child: FlatButton(
                            onPressed: timeUp
                                ? () {
                                    setState(() {
                                      emailValid = RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(email);
                                    });
                                    if (email.isNotEmpty & emailValid) {
                                      print("Email: " + email);
                                      setState(() {
                                        loading = true;
                                      });
                                      sendPwdResetEmail(email).whenComplete(() {
                                        setState(() {
                                          loading = false;
                                          success = true;
                                          timeUp = false;
                                        });
                                        startTimer();
                                        // Timer timer = Timer.periodic(
                                        //     Duration(seconds: 5), (timer) {
                                        //   setState(() {
                                        //     timeUp = false;
                                        //     seconds--;
                                        //   });
                                        //   print(seconds);

                                        //   timer.cancel();
                                        //   setState(() {
                                        //     timeUp = true;
                                        //   });
                                        //   print("Time up");
                                        // });
                                      });
                                    }
                                  }
                                : () {},
                            color: timeUp ? Colors.blue[800] : Colors.grey[300],
                            child: Container(
                              child: timeUp
                                  ? Text(
                                      "Send Reset Email",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text("Try again in $seconds seconds"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}

Future sendPwdResetEmail(String email) async {
  return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}
