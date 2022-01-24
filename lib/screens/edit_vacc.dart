// // ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_print,prefer_const_literals_to_create_immutables, invalid_use_of_visible_for_testing_member

// import 'dart:io';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:vaxicheck/shared/constants.dart';
// import 'package:vaxicheck/shared/loading.dart';
// import 'package:intl/intl.dart';

// class EditVaccPage extends StatefulWidget {
//   const EditVaccPage({
//     Key? key,
//     required this.vaccName,
//     required this.doses,
//     required this.date,
//     required this.imageUrl,
//   }) : super(key: key);
//   final String vaccName;
//   final String doses;
//   final String date;
//   final String imageUrl;

//   @override
//   State<EditVaccPage> createState() => _EditVaccPageState();
// }

// class _EditVaccPageState extends State<EditVaccPage> {
//   String message = "Vaccine record saved";
//   String errorMessage = "Please upload an image";

//   void _showToast(BuildContext context) {
//     final scaffold = ScaffoldMessenger.of(context);
//     scaffold.showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(
//               Icons.check_circle_rounded,
//               color: Colors.greenAccent,
//             ),
//             SizedBox(
//               width: 20,
//             ),
//             Text(message),
//           ],
//         ),
//         action: SnackBarAction(
//             label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
//       ),
//     );
//   }

//   void _showToastError(BuildContext context) {
//     final scaffold = ScaffoldMessenger.of(context);
//     scaffold.showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(
//               Icons.cancel,
//               color: Colors.redAccent,
//             ),
//             SizedBox(
//               width: 20,
//             ),
//             Text(errorMessage),
//           ],
//         ),
//         action: SnackBarAction(
//             label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
//       ),
//     );
//   }

//   String currentDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
//   final firestoreInstance = FirebaseFirestore.instance;
//   final _formKey = GlobalKey<FormState>();
//   bool loading = false;
//   bool isImageAdded = true;
//   bool isGallery = true;
//   bool isDummyFileUsed = false;
//   bool isUploading = true;
//   String initValueText = '';
//   String initValueInt = '';
//   bool vaccNameChanged = false;
//   bool dosesChanged = false;
//   bool dateChanged = false;
//   bool imageChanged = false;

//   var firebaseUser = FirebaseAuth.instance.currentUser;

//   File? file;

//   String vaccine = '';
//   String doses = '';
//   String error = '';
//   String imageUrl = '';

//   @override
//   Widget build(BuildContext context) {
//     imageUrl = widget.imageUrl;

//     return loading
//         ? Loading()
//         : Scaffold(
//             backgroundColor: Colors.blue[50],
//             appBar: AppBar(
//               backgroundColor: Colors.blue[800],
//               title: Text("Edit Record"),
//             ),
//             body: SingleChildScrollView(
//               child: Center(
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
//                   child: Form(
//                     key: _formKey,
//                     child: Center(
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: 20,
//                           ),
//                           TextFormField(
//                             initialValue: vaccNameChanged
//                                 ? initValueText
//                                 : widget.vaccName,
//                             decoration: textInputDecoration.copyWith(
//                                 hintText: 'Vaccine Name'),
//                             validator: (val) =>
//                                 val!.isEmpty ? 'Enter Vaccine name' : null,
//                             onChanged: (val) {
//                               setState(() {
//                                 vaccine = val;
//                                 initValueText = vaccine;
//                                 vaccNameChanged = true;
//                               });
//                             },
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           TextFormField(
//                             initialValue:
//                                 dosesChanged ? initValueInt : widget.doses,
//                             keyboardType: TextInputType.numberWithOptions(),
//                             decoration:
//                                 textInputDecoration.copyWith(hintText: 'Doses'),
//                             validator: (val) =>
//                                 val!.isEmpty ? 'Enter number of doses' : null,
//                             onChanged: (val) {
//                               setState(() {
//                                 doses = (val);
//                                 initValueInt = doses;
//                                 dosesChanged = true;
//                               });
//                             },
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Container(
//                             height: 30,
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(5)),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.max,
//                               children: [
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Text(
//                                   "Date :",
//                                   style: TextStyle(
//                                       color: Colors.grey[700],
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w400),
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Text(
//                                   dateChanged ? currentDate : widget.date,
//                                   style: TextStyle(
//                                       color: Colors.grey[700],
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w400),
//                                 ),
//                                 Spacer(),
//                                 Container(
//                                   decoration: BoxDecoration(
//                                       color: Colors.blue[800],
//                                       borderRadius: BorderRadius.circular(5)),
//                                   child: IconButton(
//                                     onPressed: () {
//                                       pickDate(context);
//                                     },
//                                     icon: Icon(
//                                       Icons.edit,
//                                       color: Colors.white,
//                                       size: 15,
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Container(
//                             height: 200,
//                             width: MediaQuery.of(context).size.width,
//                             color: Colors.white,
//                             child: isImageAdded
//                                 ? Image.network(imageUrl)
//                                 : Image.network(widget.imageUrl),
//                           ),
//                           SizedBox(
//                             height: 25,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               FlatButton(
//                                 padding: EdgeInsets.only(left: 6, right: 6.5),
//                                 color: Colors.blue[800],
//                                 textColor: Colors.white,
//                                 onPressed: () {
//                                   showModalBottomSheet(
//                                     context: context,
//                                     builder: ((builder) => bottomSheet()),
//                                   );
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Icon(
//                                       isImageAdded
//                                           ? Icons.autorenew_rounded
//                                           : Icons.upload_file_rounded,
//                                     ),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     isImageAdded
//                                         ? Text("Retake Image")
//                                         : Text("Upload image"),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               FlatButton(
//                                 padding: EdgeInsets.only(right: 0, left: 7),
//                                 color: Colors.blue[800],
//                                 textColor: Colors.white,
//                                 onPressed: () async {
//                                   if (_formKey.currentState!.validate() &&
//                                       isImageAdded) {
//                                     setState(() {
//                                       loading = true;
//                                     });
//                                     isDummyFileUsed
//                                         ? uploadFile().whenComplete(() =>
//                                             firestoreInstance
//                                                 .collection("users")
//                                                 .doc(firebaseUser?.uid)
//                                                 .collection("vaccines")
//                                                 .doc(vaccine.toLowerCase())
//                                                 .set({
//                                               "vaccName": vaccine
//                                                       .substring(0, 1)
//                                                       .toUpperCase() +
//                                                   vaccine.substring(1),
//                                               "date": currentDate,
//                                               "doses": doses,
//                                               "searchKey": vaccine
//                                                   .substring(0, 1)
//                                                   .toUpperCase(),
//                                               "imageUrl": imageUrl,
//                                             }).then((_) {
//                                               print("success!");
//                                               Navigator.pop(context);
//                                               setState(() {
//                                                 loading = false;
//                                               });
//                                               _showToast(context);
//                                             }))
//                                         : firestoreInstance
//                                             .collection("users")
//                                             .doc(firebaseUser?.uid)
//                                             .collection("vaccines")
//                                             .doc(vaccine.toLowerCase())
//                                             .set({
//                                             "vaccName": vaccine
//                                                     .substring(0, 1)
//                                                     .toUpperCase() +
//                                                 vaccine.substring(1),
//                                             "date": currentDate,
//                                             "doses": doses,
//                                             "searchKey": vaccine
//                                                 .substring(0, 1)
//                                                 .toUpperCase(),
//                                             "imageUrl": imageUrl,
//                                           }).then((_) {
//                                             print("success!");
//                                             Navigator.pop(context);
//                                             setState(() {
//                                               loading = false;
//                                             });
//                                             _showToast(context);
//                                           });
//                                   } else if (_formKey.currentState!
//                                           .validate() &&
//                                       !isImageAdded) {
//                                     _showToastError(context);
//                                   }
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Text("Submit"),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     Icon(
//                                       Icons.arrow_forward_ios_rounded,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 12,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//   }

//   Future selectFile() async {
//     var pickedImage = await ImagePicker.platform.pickImage(
//       source: isGallery ? ImageSource.gallery : ImageSource.camera,
//       imageQuality: 25,
//     );
//     if (pickedImage == null) {
//       _showToastError(context);
//     } else {
//       File? croppedFile = await ImageCropper.cropImage(
//           sourcePath: pickedImage.path,
//           aspectRatioPresets: [
//             CropAspectRatioPreset.square,
//             CropAspectRatioPreset.ratio3x2,
//             CropAspectRatioPreset.original,
//             CropAspectRatioPreset.ratio4x3,
//             CropAspectRatioPreset.ratio16x9
//           ],
//           androidUiSettings: AndroidUiSettings(
//               toolbarTitle: 'Crop Image',
//               toolbarColor: Colors.blue[900],
//               activeControlsWidgetColor: Colors.lightBlue[700],
//               toolbarWidgetColor: Colors.white,
//               initAspectRatio: CropAspectRatioPreset.original,
//               lockAspectRatio: false),
//           iosUiSettings: IOSUiSettings(
//             minimumAspectRatio: 1.0,
//           ));
//       var path = "";
//       if (croppedFile != null) {
//         setState(() {
//           path = croppedFile.path;
//         });
//       } else {
//         path = pickedImage.path;
//       }
//       setState(() {
//         isImageAdded = true;
//         file = File(path);
//       });
//       print(file);
//       setState(() {
//         loading = true;
//       });
//       if (initValueText.isEmpty) {
//         uploadDummyFile().whenComplete(() {
//           setState(() {
//             loading = false;
//             isDummyFileUsed = true;
//             message = "Vaccine record saved";
//           });
//         });
//       } else {
//         setState(() {
//           uploadFile().whenComplete(() {
//             setState(() {
//               loading = false;
//               isDummyFileUsed = false;
//               message = "Vaccine record saved";
//             });
//           });
//         });
//       }
//     }
//   }

//   Future uploadFile() async {
//     var uid = firebaseUser?.uid;
//     if (file == null) {
//       return;
//     }

//     Reference ref = FirebaseStorage.instance
//         .ref()
//         .child("images/")
//         .child("$uid/")
//         .child(vaccine.toLowerCase());
//     await ref.putFile(file!);
//     if (mounted) {
//       imageUrl = await ref.getDownloadURL().whenComplete(
//             () => setState(() {
//               isImageAdded = true;
//               message = "Image Uploaded";
//               _showToast(context);
//             }),
//           );
//     }
//     print("image Url:" + imageUrl);
//   }

//   Future uploadDummyFile() async {
//     var uid = firebaseUser?.uid;

//     if (file == null) {
//       return;
//     }

//     if (isUploading == true) {
//       Reference ref = FirebaseStorage.instance
//           .ref()
//           .child("images/")
//           .child("$uid/")
//           .child("dummyFile");
//       await ref.putFile(file!);
//       if (mounted) {
//         imageUrl = await ref.getDownloadURL().whenComplete(
//               () => setState(() {
//                 isImageAdded = true;
//                 message = "Image Uploaded";
//                 _showToast(context);
//               }),
//             );
//       }
//       print("image Url:" + imageUrl);
//     } else {
//       Reference ref =
//           FirebaseStorage.instance.ref().child("images/").child("dummyFiles/");
//       ref.delete();
//     }
//   }

//   Future pickDate(BuildContext context) async {
//     final initialDate = DateTime.now();
//     final newDate = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(DateTime.now().year - 70),
//       lastDate: DateTime(DateTime.now().year + 1),
//     );

//     newDate == null
//         ? setState(() {
//             currentDate = DateFormat('dd MMMM yyyy').format(initialDate);
//           })
//         : setState(() {
//             currentDate = DateFormat('dd MMMM yyyy').format(newDate);
//             dateChanged = true;
//           });
//   }

//   Widget bottomSheet() {
//     return Card(
//       child: Container(
//         height: 122,
//         width: MediaQuery.of(context).size.width,
//         padding: EdgeInsets.only(top: 20, bottom: 20),
//         child: Column(
//           children: [
//             Text(
//               'Choose Image',
//               style: TextStyle(
//                 color: Colors.blue[900],
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 FlatButton.icon(
//                   color: Colors.blue[900],
//                   onPressed: () {
//                     setState(() {
//                       isGallery = false;
//                     });
//                     selectFile();
//                     Navigator.pop(context);
//                   },
//                   icon: Icon(
//                     Icons.camera,
//                     color: Colors.white,
//                   ),
//                   label: Text(
//                     'Camera',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 FlatButton.icon(
//                   color: Colors.blue[900],
//                   onPressed: () {
//                     setState(() {
//                       isGallery = true;
//                     });
//                     selectFile();
//                     Navigator.pop(context);
//                   },
//                   icon: Icon(
//                     Icons.image,
//                     color: Colors.white,
//                   ),
//                   label: Text(
//                     'Gallery',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
