import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:untitled/pages/housing_page.dart';
import 'package:untitled/pages/menu_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: ZoomDrawer(
        angle: 0.0,
        mainScreen: HousingPage(),
        menuScreen: MenuPage(),
      ),
      /*const Center(
    child: Text("Welcome"),),*/
    );
  }
}
