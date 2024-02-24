



// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/pages/home_screen.dart';
import 'package:untitled/pages/loginScreen.dart';
import 'package:untitled/pages/modules/user_profile_provider.dart';
import 'package:untitled/pages/regScreen.dart';
import 'package:untitled/pages/setting.dart';
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
  
  runApp(
    
    ChangeNotifierProvider(
      create: (context) => UserProfileProvider(),
      child: MyApp(),
    ),
    
  ); 
runApp(
    
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider(),
        ),
      ],
      child: MyApp(),
    ),
  ); }
 
class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
      if (kDebugMode) {
        print('>>>>>>>>>>>>>>User is currently signed out!');
      }
    } else {
      if (kDebugMode) {
        print('>>>>>>>>>>>>>>User is signed in!');
      }
    }
  });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: context.watch<ThemeProvider>().isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,

        home: FirebaseAuth.instance.currentUser == null ?
         const WelcomeScreen() : const HomeScreen(),  
        routes: {
          'welcomeScreen': (context) => const WelcomeScreen(),
          'regScreen': (context) => const RegScreen(),
          'loginScreen': (context) => const LoginScreen(),
          'home_screen': (context) => const HomeScreen(),

        },
    );
  }
}