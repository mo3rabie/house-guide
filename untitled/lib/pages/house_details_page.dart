// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/pages/full_screen_image_page.dart';
import 'package:untitled/pages/modules/house.dart';
import 'package:untitled/pages/user_details_page.dart';

class HouseDetailsPage extends StatelessWidget {
  final House item;

  const HouseDetailsPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name ?? 'House Details'),
        elevation: 100.0,
        titleTextStyle: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 134, 172),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display user profile picture and name
                GestureDetector(
                  onTap: () {
                    // Navigate to UserDetailsPage when user profile is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailsPage(userId: item.ownerId),
                      ),
                    );
                  },
                  child: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(item.ownerId)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        final userPhoto = userData['profilePicture'] as String?;
                        final userName = userData['username'] as String?;

                        return Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    userPhoto != null ? NetworkImage(userPhoto) : null,
                                radius: 50,
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                userName ?? 'Unknown User',
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 134, 172)),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Loading indicator while fetching data
                        return const CircularProgressIndicator();
                    }
                  },
                ),),
                const SizedBox(height: 20.0),
                // Display all house images in a ListView
                SizedBox(
                  height: 300.0,
                  child: Center(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: item.images!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Navigate to the FullScreenImagePage when image is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImagePage(
                                  imageUrl: item.images![index],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 380.0,
                            margin: const EdgeInsets.only(right: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.shade200,
                              image: DecorationImage(
                                image: NetworkImage(item.images![index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                Row(
                  children: [
                    Text(
                      'Name: ${item.name}',
                      style: const TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 134, 172)),
                    ),
                    const SizedBox(width: 80.0),
                    
                  ],
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.blueGrey),
                    const SizedBox(width: 10.0),
                    Text(
                      'Address: ${item.address}',
                      style: const TextStyle(fontSize: 24.0, color: Colors.blueGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    const Icon(Icons.phone_callback_outlined, color: Colors.blueGrey),
                    const SizedBox(width: 10.0),
                    Text(
                      'Phone: +2${item.phone}',
                      style: const TextStyle(fontSize: 24.0, color: Colors.blueGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Price: ${item.price} L.E/ Month',
                  style: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 134, 172)),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Description: ${item.description}',
                  style: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                     color: Color.fromARGB(255, 0, 134, 172)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
