// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaxicheck/shared/constants.dart';
import 'package:vaxicheck/shared/loading.dart';
import 'package:intl/intl.dart';

class NewVaccinePage extends StatefulWidget {
  const NewVaccinePage({Key? key}) : super(key: key);

  @override
  State<NewVaccinePage> createState() => _NewVaccinePageState();
}

class _NewVaccinePageState extends State<NewVaccinePage> {
  String currentDate =
      DateFormat('yyyy-MM-dd – kk:mm:ss').format(DateTime.now());
  final firestoreInstance = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String vaccine = '';
  int doses = 0;
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.blue[50],
            appBar: AppBar(
              backgroundColor: Colors.blue[800],
              title: Text("Add a record"),
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
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Vaccine Name'),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter Vaccine name' : null,
                        onChanged: (val) {
                          setState(() {
                            vaccine = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.numberWithOptions(),
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Doses'),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter number of doses' : null,
                        onChanged: (val) {
                          setState(() {
                            doses = int.parse(val);
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
                            var firebaseUser =
                                FirebaseAuth.instance.currentUser;
                            firestoreInstance
                                .collection("users")
                                .doc(firebaseUser?.uid)
                                .set({
                              vaccine: {
                                "vaccName": vaccine,
                                "date": currentDate,
                                "doses": doses,
                                "searchKey":
                                    vaccine.substring(0, 1).toUpperCase(),
                              }
                            }, SetOptions(merge: true)).then((_) {
                              print("success!");
                              Navigator.pop(context);
                              setState(() {
                                loading = false;
                              });
                            });
                          }
                        },
                        child: Text("Submit"),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
