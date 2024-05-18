import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/API/chatService.dart';
import 'package:untitled/API/userServices.dart';
import 'package:untitled/pages/home_screen.dart';
import 'package:untitled/pages/loginScreen.dart';
import 'package:untitled/pages/regScreen.dart';
import 'package:untitled/pages/setting.dart';
import 'package:untitled/pages/welcomeScreen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ChatService()), // Provide ChatService
        ChangeNotifierProvider(create: (_) => UserService()), // Provide UserService
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: context.watch<ThemeProvider>().isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      home: const WelcomeScreen(),
      routes: {
        'welcomeScreen': (context) => const WelcomeScreen(),
        'regScreen': (context) => const RegScreen(),
        'loginScreen': (context) => const LoginScreen(),
        'home_screen': (context) => const HomeScreen(),
      },
    );
  }
}
