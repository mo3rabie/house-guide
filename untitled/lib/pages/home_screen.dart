import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:untitled/pages/housing_page.dart';
import 'package:untitled/pages/menu_page.dart';
import 'package:untitled/pages/setting.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: context.watch<ThemeProvider>().isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
         );
        }
      }


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String?>;

    if (args['token']!= null) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255,0, 134, 172),
        body: ZoomDrawer(
          angle: 0.0,
          mainScreen: HousingPage(token: args['token']!),
          menuScreen: MenuPage(token: args['token']!), // Pass the token value to MenuPage
        ),
      );
    } else {
      // Handle the case when the token is null
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Token is null')),
      );
    }
  }
}