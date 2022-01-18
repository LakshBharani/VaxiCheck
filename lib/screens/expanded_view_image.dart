// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ExpandedViewImage extends StatelessWidget {
  const ExpandedViewImage(
      {Key? key, required this.imageUrl, required this.vaccName})
      : super(key: key);
  final String imageUrl;
  final String vaccName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text(vaccName),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: InteractiveViewer(
              panEnabled: true,
              // boundaryMargin: const EdgeInsets.all(40),
              minScale: 0.5,
              maxScale: 4,
              child: Image.network(imageUrl)),
        ),
      ),
    );
  }
}
