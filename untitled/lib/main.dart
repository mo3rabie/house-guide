



import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:untitled/pages/home_screen.dart';
import 'package:untitled/pages/loginScreen.dart';
import 'package:untitled/pages/regScreen.dart';
import 'package:untitled/pages/welcomeScreen.dart';
void main() async {
WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyCzVlAScTIXuoS_LDxxUVgIXCSVEw1zX5I",
            appId: "1:684628214910:android:8b194fe7ea5afbb7ee842f",
            messagingSenderId: "684628214910",
            projectId: "house-guide",
          ),
        )
      : Firebase.initializeApp();

  await Firebase.initializeApp();

// Ideal time to initialize
//await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  
  runApp(const MyApp());
}
 
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('>>>>>>>>>>>>>>User is currently signed out!');
    } else {
      print('>>>>>>>>>>>>>>User is signed in!');
    }
  });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),

        home: FirebaseAuth.instance.currentUser == null ?
         WelcomeScreen() : HomeScreen(),  
        routes: {
          'welcomeScreen': (context) => WelcomeScreen(),
          'regScreen': (context) => RegScreen(),
          'loginScreen': (context) => LoginScreen(),
          'home_screen': (context) => HomeScreen(),

        },
    );
  }
}
