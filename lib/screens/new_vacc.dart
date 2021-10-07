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
  String message = "Vaccine record saved";

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
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final firestoreInstance = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool isImageAdded = false;

  String vaccine = '';
  String doses = '';
  String imageUrl = '';
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
                                doses = (val);
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 150,
                            width: 290,
                            color: Colors.amber[50],
                            child: isImageAdded
                                ? MaterialButton(
                                    onPressed: () {},
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [],
                                    ),
                                  )
                                : MaterialButton(
                                    onPressed: () {},
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: [
                                        Icon(
                                          Icons.camera_alt_rounded,
                                          color: Colors.blue[800],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text('Click here to upload image'),
                                      ],
                                    ),
                                  ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlatButton(
                                padding: EdgeInsets.only(left: 6, right: 6.5),
                                color: Colors.blue[800],
                                textColor: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    isImageAdded = false;
                                  });
                                },
                                child: Row(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    Icon(
                                      Icons.replay_circle_filled_outlined,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text("Retake Image"),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              FlatButton(
                                padding: EdgeInsets.only(right: 0, left: 7),
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
                                        .collection("vaccines")
                                        .doc(vaccine.toLowerCase())
                                        .set({
                                      "vaccName": vaccine
                                              .substring(0, 1)
                                              .toUpperCase() +
                                          vaccine.substring(1),
                                      "date": currentDate,
                                      "doses": doses,
                                      "searchKey":
                                          vaccine.substring(0, 1).toUpperCase(),
                                      "imageUrl": imageUrl
                                    }).then((_) {
                                      print("success!");
                                      Navigator.pop(context);
                                      setState(() {
                                        loading = false;
                                      });
                                      _showToast(context);
                                    });
                                  }
                                },
                                child: Row(
                                  // ignore: prefer_const_literals_to_create_immutables
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
                          SizedBox(
                            height: 12,
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
