// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_print,prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
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

  String currentDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
  final firestoreInstance = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool isImageAdded = false;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  File? file;

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
                            color: Colors.white,
                            child: isImageAdded
                                ? SizedBox()
                                : SizedBox(
                                    child: Center(
                                      child: Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.blue[800],
                                      ),
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
                                  selectFile();
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.upload_file_rounded,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text("Upload Image"),
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
                                    uploadFile();

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
                                      "imageUrl": imageUrl,
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

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) {
      setState(() {
        isImageAdded = false;
      });
    } else {
      final path = result.files.single.path!;
      setState(() {
        isImageAdded = true;
        file = File(path);
      });
      print(file);
    }
  }

  Future uploadFile() async {
    var uid = firebaseUser?.uid;
    if (file == null) {
      return;
    }

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("images/")
        .child("$uid/")
        .child(vaccine.toLowerCase());
    await ref.putFile(file!);
    if (mounted) {
      setState(() async {
        imageUrl = await ref.getDownloadURL();
      });
    }
    print("image Url:" + imageUrl);
  }
}
