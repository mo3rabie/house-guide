// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import "dart:async";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:untitled/API/userServices.dart";
import "package:untitled/pages/HelpPage.dart";
import "package:untitled/pages/book_marks_page.dart";
import 'package:untitled/pages/chats_list_page.dart';
import "package:untitled/pages/profile.dart";
import "package:untitled/pages/setting.dart";

class MenuPage extends StatefulWidget {
  final String token; // User token parameter

  const MenuPage({super.key, required this.token});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Map<String, dynamic>? _userData;
  late Completer<void> _fetchUserDataCompleter;
  String hoveredOption = '';
  @override
  void initState() {
    super.initState();
    _fetchUserDataCompleter = Completer<void>();
    _userData = {};
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final userService = UserService();
      final responseBody = await userService.getUserDataByToken(widget.token);
      if (responseBody != null) {
        setState(() {
          _userData = responseBody;
        });
      } else {
        setState(() {
          _userData = {}; // Reset user data
        });
      }
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
                // Profile Section
                FutureBuilder<void>(
                  future: _fetchUserDataCompleter.future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      if (_userData != null) {
                        // Check if _userData is not null
                        String? profilePictureUrl =
                            _userData!['profilePicture'];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfilePage(token: widget.token),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: profilePictureUrl != null
                                      ? NetworkImage(
                                          'http://192.168.43.114:3000/$profilePictureUrl')
                                      : AssetImage('asset/images/person.jpg')
                                          as ImageProvider,
                                ),
                                const SizedBox(width: 2.0),
                                Text(
                                  _userData!['username'] ?? 'Guest',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        // Handle the case where _userData is null
                        return Text(
                          'User data not available',
                          style: TextStyle(color: Colors.white),
                        );
                      }
                    }
                  },
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(
                      "home_screen",
                      arguments: {'token': widget.token},
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.home_outlined),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                              "home_screen",
                              arguments: {'token': widget.token},
                            );
                          },
                        ),
                        const Text('Home',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(token: widget.token),
                      ),
                    );
                  },
                  child: Padding(
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
                                builder: (context) =>
                                    ProfilePage(token: widget.token),
                              ),
                            );
                          },
                        ),
                        const Text('Profile',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 1, // Adjust the height of the line
                  width: double
                      .infinity, // Set the line width to match the parent width
                  child: Container(
                    color: Colors.grey[200], // Set the color of the line
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookmarksPage(token: widget.token),
                      ),
                    );
                  },
                  child: Padding(
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
                                builder: (context) =>
                                    BookmarksPage(token: widget.token),
                              ),
                            );
                          },
                        ),
                        const Text('Bookmark',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatListPage(token: widget.token),
                      ),
                    );
                  },
                  child: Padding(
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
                                builder: (context) =>
                                    ChatListPage(token: widget.token),
                              ),
                            );
                          },
                        ),
                        const Text('Message',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
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
// Dark Mode
                InkWell(
                  onTap: () {
                          context.read<ThemeProvider>().toggleTheme();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.dark_mode),
                          onPressed: () {
                          context.read<ThemeProvider>().toggleTheme();
                          },
                        ),
                        Text(
                          'Dark Mode',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 20),
                        Switch(
                          value: context.watch<ThemeProvider>().isDarkMode,
                          onChanged: (value) {
                            context.read<ThemeProvider>().toggleTheme();
                          },
                        )
                      ],
                    ),
                  ),
                ),
// Help
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HelpPage(),
                      ),
                    );
                  },
                  child: Padding(
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
                                builder: (context) => HelpPage(),
                              ),
                            );
                          },
                        ),
                        const Text('Help',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
// Logout
                InkWell(
                  onTap: () async {
                    // Call the logout method from the UserService class
                    await UserService().logout(context, token: widget.token);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.power_settings_new_outlined),
                          onPressed: () async {
                            // Call the logout method from the UserService class
                            await UserService()
                                .logout(context, token: widget.token);
                          },
                        ),
                        const Text('Logout',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
