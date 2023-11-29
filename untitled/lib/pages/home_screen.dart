import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home"),
      actions: [
        IconButton(onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.of(context).pushNamedAndRemoveUntil("welcomeScreen", (route) => false);
        }, icon: const Icon(Icons.exit_to_app))
      ],
      ),
      body: const Center(
        child: Text("Welcome"),
      ),
    );
  }
}
