// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:untitled/API/houseServices.dart';
import 'package:untitled/API/userServices.dart';
import 'package:untitled/pages/modules/house.dart';
import 'package:untitled/pages/house_card.dart'; // Import your HouseCard widget

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key,  required this.token});

  final String token;

  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  late Future<Map<String, dynamic>?> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = UserService().getUserDataByToken(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        titleTextStyle: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 134, 172),
      ),
      body: _buildBookmarksList(),
    );
  }

  Widget _buildBookmarksList() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          Map<String, dynamic>? userData = snapshot.data;
          if (userData != null && userData['bookMark'] != null) { // Change here
            List<String> bookmarkedHouseIds =
                List<String>.from(userData['bookMark']); // Change here

            if (bookmarkedHouseIds.isEmpty) {
              return const Center(
                child: Text('No bookmarks found.'),
              );
            }

            return ListView.builder(
              itemCount: bookmarkedHouseIds.length,
              itemBuilder: (context, index) {
                return FutureBuilder<House>(
                  future: HouseService.getHouseById(bookmarkedHouseIds[index]),
                  builder: (context, houseSnapshot) {
                    if (houseSnapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (houseSnapshot.hasError) {
                      return Text('Error: ${houseSnapshot.error}');
                    } else {
                      House house = houseSnapshot.data!;
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  // Assuming ItemCard takes a House model as a parameter
                  HouseCard(
                    house: house,
                    onTap: () {},
                    key: null, token: widget.token,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                ],
              );
                    }
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text('No bookmarks found.'),
            );
          }
        }
      },
    );
  }
}
