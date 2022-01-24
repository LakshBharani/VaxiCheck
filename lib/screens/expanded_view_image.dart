// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ExpandedViewImage extends StatelessWidget {
  const ExpandedViewImage({
    Key? key,
    required this.imageUrl,
    required this.vaccName,
    required this.doses,
    required this.date,
  }) : super(key: key);
  final String imageUrl;
  final String vaccName;
  final String doses;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text(vaccName),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4,
                child: Image.network(imageUrl),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.date_range),
                  const SizedBox(width: 5),
                  const Text(
                    "Record Created on : ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(date),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.article),
                  const SizedBox(width: 5),
                  const Text(
                    "Doses : ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(doses),
                ],
              ),
            ),
            // const Divider(),
            // const Text("About", style: TextStyle(fontWeight: FontWeight.bold)),
            // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            //   stream: FirebaseFirestore.instance
            //       .collection('edInfo')
            //       .doc(vaccName.toString().toLowerCase())
            //       .snapshots(),
            //   builder: (_, snapshot) {
            //     return Padding(
            //       padding: const EdgeInsets.all(10),
            //       child: Text(snapshot.data!.data()!['about']),
            //     );
            //   },
            // ),
            // const Text("For Ages",
            //     style: TextStyle(fontWeight: FontWeight.bold)),
            // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            //   stream: FirebaseFirestore.instance
            //       .collection('edInfo')
            //       .doc(vaccName.toString().toLowerCase())
            //       .snapshots(),
            //   builder: (_, snapshot) {
            //     return Padding(
            //       padding: const EdgeInsets.all(10),
            //       child: Text(
            //           snapshot.data!.data()!['age_low'] + " year(s) and above"),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
