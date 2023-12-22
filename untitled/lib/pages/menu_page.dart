// ignore_for_file: prefer_const_constructors

import "package:flutter/material.dart";
import "package:flutter_zoom_drawer/flutter_zoom_drawer.dart";
import 'package:firebase_auth/firebase_auth.dart';


class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}
/*class MenuOptions{
  static const home = MenuOption( Icons.home_outlined, "Home");
  static const profile = MenuOption(Icons.person_2_outlined, "Profile");
  static const nearby = MenuOption(Icons.location_on_outlined, "Nearby");

  static const bookmark = MenuOption(Icons.bookmark_border, "Bookmark");
  static const notification = MenuOption(Icons.notifications_none_rounded, "Notification");
  static const message = MenuOption(Icons.messenger_outline, "Message");

  static const setting = MenuOption(Icons.settings_outlined, "Setting");
  static const help = MenuOption(Icons.help_outline, "Help");
  static const logout = MenuOption(Icons.power_settings_new_outlined, "Logout");

  static const allOptions =[
   home,
   profile,
   nearby,
   bookmark,
   notification,
   message,
   setting,
   help,
   logout,
  ];

}
*/

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255,0, 134, 172),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                ///////////////////////////////////////////////////////////
                Padding(
                  
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.home_outlined),
                          onPressed: () {
                            ZoomDrawer.of(context)!.toggle();
                            //Navigator.push(context, MaterialPageRoute(builder: (context)=> HousingPage()));
                          },
                        ),
                        const Text('Home', style: TextStyle(color: Colors.white)),
                      ],
                    )),
                ///////////////////////////////////////////////////////////////////////
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.person_2_outlined),
                          onPressed: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=> profile()));
                          },
                        ),
                        const Text('Profile', style: TextStyle(color: Colors.white)),
                      ],
                    )),
                ///////////////////////////////////////////////////////////
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.location_on_outlined),
                          onPressed: () {
                            // Handle button press
                          },
                        ),
                        const Text('Nearby', style: TextStyle(color: Colors.white)),
                      ],
                    )),
                  
                SizedBox(
                  height: 1, // Adjust the height of the line
                  width: double
                      .infinity, // Set the line width to match the parent width
                  child: Container(
                    color: Colors.grey[200], // Set the color of the line
                  ),
                ),
                  
                //////////////////////////////////////////////////
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.bookmark_border),
                          onPressed: () {
                            // Handle button press
                          },
                        ),
                        const Text('Bookmark', style: TextStyle(color: Colors.white)),
                      ],
                    )),
                ////  ////////////////////////////////////////////////////////////////////
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.notifications_none_rounded),
                          onPressed: () {
                            // Handle button press
                          },
                        ),
                        const Text('Notification', style: TextStyle(color: Colors.white)),
                      ],
                    )),
                ///////////////////////////////////////////////////////////////////////
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.messenger_outline),
                          onPressed: () {
                            // Handle button press
                          },
                        ),
                        const Text('Message', style: TextStyle(color: Colors.white)),
                      ],
                    )),
                ////////////////////////////////////////////////////////////////
                SizedBox(
                  height: 1, // Adjust the height of the line
                  width: double
                      .infinity, // Set the line width to match the parent width
                  child: Container(
                    color: Colors.grey[200], // Set the color of the line
                  ),
                ),
                  
                //////////////////////////////////////////////////
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.settings_outlined),
                          onPressed: () {
                            // Handle button press
                          },
                        ),
                        const Text('Settings', style: TextStyle(color: Colors.white)),
                      ],
                    )),
                ////  ////////////////////////////////////////////////////////////////////
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.help_outline),
                          onPressed: () {
                            // Handle button press
                          },
                        ),
                        const Text('Help', style: TextStyle(color: Colors.white)),
                      ],
                    )),
                ///////////////////////////////////////////////////////////////////////
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.power_settings_new_outlined),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                "welcomeScreen", (route) => false);
                          },
                        ),
                        const Text('Logout', style: TextStyle(color: Colors.white)),
                      ],
                    )),
                  
                // ...MenuOptions.allOptions.map(optionsList).toList()
              ],
            ),
          ),
        ));
  }
  /* Widget optionsList(MenuOption item){
    return ListTile(
    leading: Icon(     ///mmkal akhlihaa actions
      item.IconButton,
      color:Colors.white,
    ),
    title: Text(item.title,style: TextStyle(color: Colors.white70)),
    minLeadingWidth: 10,
    
       
    },
    );
  }*/
}
