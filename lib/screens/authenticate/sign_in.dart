// ignore_for_file: deprecated_member_use, prefer_const_constructors, avoid_print, unused_field, use_key_in_widget_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:vaxicheck/services/auth.dart';
import 'package:vaxicheck/shared/constants.dart';
import 'package:vaxicheck/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool isPwdVis = false;

  String email = '';
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
              title: Text("Sign in to VaxiCheck"),
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
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            body: Center(
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
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                error = 'Incorrect Email or Password';
                                loading = false;
                              });
                              _showToast(context);
                            }
                          }
                        },
                        child: Text("Sign In"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
