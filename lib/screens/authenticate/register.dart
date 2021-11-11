// ignore_for_file: prefer_const_constructors, deprecated_member_use, unused_field, avoid_print, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:vaxicheck/services/auth.dart';
import 'package:vaxicheck/shared/constants.dart';
import 'package:vaxicheck/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool isSignedup = false;
  bool isPwdVis = false;

  String email = '';
  String pwd1 = '';
  String pwd2 = '';
  String password = '';
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
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.blue[50],
            appBar: AppBar(
              backgroundColor: Colors.blue[800],
              title: Text("Register to VaxiCheck"),
              actions: [
                FlatButton.icon(
                  highlightColor: Colors.blue,
                  onPressed: () {
                    widget.toggleView();
                  },
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Sign In",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
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
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: password,
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPwdVis = !isPwdVis;
                                });
                              },
                              child: isPwdVis
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                            ),
                          ),
                          validator: (val) => val!.length < 6
                              ? 'Password must contain 6 or more characters'
                              : null,
                          obscureText: !isPwdVis,
                          onChanged: (val) {
                            setState(() {
                              pwd1 = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Repeat Password',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isPwdVis = !isPwdVis;
                                  });
                                },
                                child: SizedBox(
                                  height: 0,
                                  width: 0,
                                )),
                          ),
                          validator: (val) =>
                              pwd1 != pwd2 ? "Passwords don't match" : null,
                          obscureText: !isPwdVis,
                          onChanged: (val) {
                            setState(() {
                              pwd2 = val;
                              password = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        FlatButton(
                          color: Colors.blue[800],
                          textColor: Colors.white,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result =
                                  await _auth.resgisterWithEmailAndPassword(
                                      email, password);
                              if (result == null) {
                                setState(() {
                                  error = 'Please enter a valid email';
                                  loading = false;
                                });
                              }
                            }
                          },
                          child: Text("Register"),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(error),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
