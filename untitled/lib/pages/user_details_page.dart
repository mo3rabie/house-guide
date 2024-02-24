import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/pages/chat_page.dart';
import 'package:untitled/pages/house_card.dart';
import 'package:untitled/pages/modules/house.dart';

class UserDetailsPage extends StatelessWidget {
  final String userId;

  const UserDetailsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 134, 172),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Display user profile picture and name
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Loading indicator while fetching data
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError || snapshot.data == null) {
                      // Handle error or null data
                      return const Text('Error fetching user data.');
                    }

                    final userData = snapshot.data!.data() as Map<String, dynamic>?;

                    if (userData != null) {
                      final userPhoto = userData['profilePicture'] as String?;
                      final userName = userData['username'] as String?;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: userPhoto != null ? NetworkImage(userPhoto) : null,
                            radius: 80,
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            userName ?? 'Unknown User',
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 134, 172),
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Handle the case when userData is null
                      return const Text('Invalid user data.');
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                // Chat Icon
                IconButton(
                  icon: const Icon(Icons.chat),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(userId: userId),
                      ),
                    );
                  },
                  color: const Color.fromARGB(255, 0, 134, 172),
                  iconSize: 40.0,
                ),
                const SizedBox(height: 20.0),

                // Display houses added by the user
                const Text(
                  'Houses Added by User:',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 134, 172),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Loading indicator while fetching data
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError || snapshot.data == null) {
                      // Handle error or null data
                      return const Text('Error fetching user data.');
                    }

                    final userData = snapshot.data!.data() as Map<String, dynamic>?;

                    if (userData != null) {
                      final houses = userData['addedHouse'] as List<dynamic>?;

                      if (houses != null && houses.isNotEmpty) {
                        return Column(
                          children: houses.map<Widget>((houseId) {
                            return FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance.collection('houses').doc(houseId).get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  // Loading indicator while fetching data
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError || snapshot.data == null) {
                                  // Handle error or null data
                                  return const Text('Error fetching house data.');
                                }

                                final houseData = snapshot.data!.data() as Map<String, dynamic>?;

                                if (houseData != null) {
                                  return ItemCard(
                                    house: House.fromMap(houseData),
                                    onTap: () {},
                                    key: null,
                                  );
                                } else {
                                  // Handle the case when houseData is null
                                  return Container(); // Return an empty container
                                }
                              },
                            );
                          }).toList(),
                        );
                      } else {
                        return const Text('No houses added by this user.');
                      }
                    } else {
                      // Handle the case when userData is null
                      return const Text('Invalid user data.');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
