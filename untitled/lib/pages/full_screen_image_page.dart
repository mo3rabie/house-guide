// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImagePage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Pop the FullScreenImagePage when the image is tapped
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'fullscreenImage', // Use a unique tag
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
