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
    return   ZoomDrawer(
      menuBackgroundColor: Color.fromARGB(255,0, 134, 172),
        //controller: ZoomDrawerController,
         angle: 0.0,
        mainScreen: HousingPage(),
        menuScreen: MenuPage(),
        showShadow: true,
        style: DrawerStyle.defaultStyle,

      );
    
  }
}
