// ignore_for_file: prefer_const_constructors

import "dart:async";
import "dart:io";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter_zoom_drawer/flutter_zoom_drawer.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:provider/provider.dart";
import "package:untitled/pages/HelpPage.dart";
import "package:untitled/pages/book_marks_page.dart";
import 'package:untitled/pages/chats_list_page.dart';
import "package:untitled/pages/home_screen.dart";
import "package:untitled/pages/housing_page.dart";
import "package:untitled/pages/profile.dart";
import "package:untitled/pages/setting.dart";

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late User? user; // Make the user nullable
  Map<String, dynamic>? userData;
  File? _image;
  late Completer<void> _fetchUserDataCompleter;
  String hoveredOption = '';

  get title => null;

  get trailing => null;
  @override
  void initState() {
    super.initState();
    _fetchUserDataCompleter = Completer<void>();
    getUser();
  }

  Future<void> getUser() async {
    user = FirebaseAuth.instance.currentUser;
    await fetchUserData(); // Call fetchUserData after retrieving the user
    _fetchUserDataCompleter.complete(); // Complete the future
  }

  Future<void> fetchUserData() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get();

      setState(() {
        userData = userDoc.data();
        userData?['username'] ?? '';
        userData?['profilePicture'] ?? '';
      });
    } finally {
      if (!_fetchUserDataCompleter.isCompleted) {
        _fetchUserDataCompleter.complete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 0, 134, 172),
        body: SafeArea(
          child: SingleChildScrollView(
          
            child: Column(
              children: [
                 SizedBox(
                  height: 65, // Adjust the height of the line
                  width: double
                      .infinity, // Set the line width to match the parent width
                  
                ),
                // Profile Section
                FutureBuilder<void>(
                  future: _fetchUserDataCompleter.future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show a loading indicator while waiting for user data
                      return CircularProgressIndicator();
                    } else {
                      if (user != null) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage()),
                            );
                          },
                         
                          child: Padding(
                            
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: _image != null
                                      ? FileImage(_image!)
                                      : (userData != null &&
                                              userData?['profilePicture'] !=
                                                  null)
                                          ? NetworkImage(
                                              userData?['profilePicture'])
                                          : const AssetImage(
                                                  'asset/images/person.jpg')
                                              as ImageProvider<Object>?,
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  userData?['username'] ??
                                      user!.displayName ??
                                      'Guest',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        // Handle the case where the user is null
                        return Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'You are not logged in.', // Customize this message
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                    }
                  },
                ),

                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.home_outlined),
                          onPressed: () {
                            ZoomDrawer.of(context)!.toggle();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          },
                        ),
                        const Text('Home',
                            style: TextStyle(color: Colors.white)),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.person_2_outlined),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage()));
                          },
                        ),
                        const Text('Profile',
                            style: TextStyle(color: Colors.white)),
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
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.bookmark_border),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookmarksPage()),
                            );
                          },
                        ),
                        const Text('Bookmark',
                            style: TextStyle(color: Colors.white)),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.messenger_outline),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatListPage()),
                            );
                          },
                        ),
                        const Text('Message',
                            style: TextStyle(color: Colors.white)),
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
                          icon: const Icon(Icons.dark_mode),
                          onPressed: () {
                            
                          },
                        ),
                        Text('Dark Mode',
                        style: TextStyle(
                             color: Colors.white,
                             
                             ),
                            
                        ),
                        SizedBox(width: 25.5),
                        Switch(
                            value: context.watch<ThemeProvider>().isDarkMode,
                            onChanged: (value) {
                              context.read<ThemeProvider>().toggleTheme();
                            })
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HelpPage()),
                            );
                          },
                        ),
                        const Text('Help',
                            style: TextStyle(color: Colors.white)),
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
                        const Text('Logout',
                            style: TextStyle(color: Colors.white)),
                      ],
                    )),
              ],
            ),
          ),
        ));
  }
}
