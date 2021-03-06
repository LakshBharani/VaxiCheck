// ignore_for_file: prefer_const_constructors, unused_import

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:vaxicheck/models/user.dart';
import 'package:vaxicheck/screens/wrapper.dart';
import 'package:vaxicheck/services/auth.dart';
import 'models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance
      .activate(webRecaptchaSiteKey: 'recaptcha-v3-site-key');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    final newVersion = NewVersion(
      iOSId: 'org.cubix.vaxicheck',
      androidId: 'org.cubix.vaxicheck',
    );

    const simpleBehavior = true;
    if (simpleBehavior) {
      basicStatusCheck(newVersion);
    } else {
      print("UP TO DATE VERSION");
    }
  }

  basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Wrapper(),
      ),
    );
  }
}
