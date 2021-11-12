// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PrivacyPol extends StatefulWidget {
  const PrivacyPol({Key? key}) : super(key: key);

  @override
  _PrivacyPolState createState() => _PrivacyPolState();
}

class _PrivacyPolState extends State<PrivacyPol> {
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
        backgroundColor: Colors.blue[800],
      ),
      url:
          "https://github.com/LakshBharani/cubix-privacy/blob/main/privacy-policy.md",
      withZoom: true,
    );
  }
}
