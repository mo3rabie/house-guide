// ignore: file_names
import 'package:flutter/material.dart';

class SubcollectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> subcollectionData;

   const SubcollectionWidget(this.subcollectionData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Subcollection Data',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        const SizedBox(height: 8.0),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: subcollectionData.length,
          itemBuilder: (context, index) {
            var item = subcollectionData[index];
            return ListTile(
              title: Text(item['title'] ?? ''),
              // Add more fields if needed
              // subtitle: Text(item['subtitle'] ?? ''),
            );
          },
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
