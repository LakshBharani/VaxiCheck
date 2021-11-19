// ignore_for_file: deprecated_member_use, avoid_unnecessary_containers, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vaxicheck/screens/feedback.dart';
import 'package:vaxicheck/services/auth.dart';
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
  bool loading = false;
  bool isReady = false;
  String error = '';

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.cancel,
              color: Colors.red,
            ),
            SizedBox(
              width: 20,
            ),
            Text(error),
          ],
        ),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

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
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: "",
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
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          // height: isReady ? null : 0,
                          child: FlatButton(
                            onPressed: () {
                              // loading = true;
                              sendPwdResetEmail(email);
                            },
                            color: Colors.blue[800],
                            child: Container(
                              child: const Text(
                                "Send Reset Email",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // body: SingleChildScrollView(
            //   padding: const EdgeInsets.all(15),
            //   child: Form(
            //     key: _formKey,
            //     child: Center(
            //       child: Column(
            //         children: [
            //           TextFormField(
            //             initialValue: "",
            //             keyboardType: TextInputType.emailAddress,
            //             decoration: textInputDecoration.copyWith(
            //               hintText: 'Email',
            //               prefixIcon: const Icon(Icons.email_rounded),
            //             ),
            //             validator: (val) =>
            //                 val!.isEmpty ? 'Enter an email' : null,
            //             onChanged: (val) {
            //               if (val != "") {
            //                 setState(() {
            //                   email = val;
            //                 });
            //               }
            //             },
            //             onEditingComplete: () {
            //               setState(() {
            //                 isReady = true;
            //               });
            //             },
            //           ),
            //           const SizedBox(
            //             height: 20,
            //           ),
            //     Container(
            //       height: isReady ? null : 0,
            //       child: FlatButton(
            //         onPressed: () {
            //           loading = true;
            //           sendPwdResetEmail(email);
            //         },
            //         color: Colors.blue[800],
            //         child: Container(
            //           child: const Text(
            //             "Send Reset Email",
            //             style: TextStyle(color: Colors.white),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // ),
            // ),
            // ),
          );
  }
}

Future sendPwdResetEmail(String email) async {
  return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}
