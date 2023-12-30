// bookmarks_page.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/pages/models/house.dart';
import 'package:untitled/pages/house_card.dart'; // Import your HouseCard widget

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        titleTextStyle:  const TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        centerTitle: true,
        backgroundColor:  const Color.fromARGB(255, 0, 134, 172),
      ),
      body: _buildBookmarksList(),
    );
  }

  Widget _buildBookmarksList() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
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
          Map<String, dynamic>? userData = snapshot.data?.data();
          if (userData != null && userData['bookmarks'] != null) {
            List<String> bookmarkedHouseIds = List<String>.from(userData['bookmarks']);

            if (bookmarkedHouseIds.isEmpty) {
              return const Center(
                child: Text('No bookmarks found.'),
              );
            }

            return ListView.builder(
              itemCount: bookmarkedHouseIds.length,
              itemBuilder: (context, index) {
                return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection('houses')
                      .doc(bookmarkedHouseIds[index])
                      .get(),
                  builder: (context, houseSnapshot) {
                    if (houseSnapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (houseSnapshot.hasError) {
                      return Text('Error: ${houseSnapshot.error}');
                    } else {
                      House house = House.fromMap(houseSnapshot.data!.data()!);
                      return ItemCard(house: house, onTap: () {
                        // Handle house card tap if needed
                      }, key: null,);
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
