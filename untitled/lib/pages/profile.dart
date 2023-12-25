// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, library_private_types_in_public_api

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/pages/house_card.dart';
import 'package:untitled/pages/modules/house.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user;
  late Map<String, dynamic> userData;
  late List<String> addedHouses;
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Fetch user data and addedHouses using FirebaseAuth and FirebaseFirestore
    user = FirebaseAuth.instance.currentUser!;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    setState(() {
      userData = userDoc.data()!;
      addedHouses = List<String>.from(userData['addedHouse'] ?? []);
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProfilePicture() async {
    if (_image == null) {
      // Handle case where no image is selected
      return;
    }

    final storage = FirebaseStorage.instance;
    final reference =
        storage.ref().child('profile_pictures/${user.uid}.jpg');

    await reference.putFile(_image!);

    final downloadUrl = await reference.getDownloadURL();

    // Update the user's profile picture URL in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'profilePicture': downloadUrl});

    // Fetch updated user data
    await fetchUserData();
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Profile Page'),
        titleTextStyle:  TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        centerTitle: true,
        backgroundColor:  Color.fromARGB(255, 0, 134, 172),
    ),
    body: SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 60.0,
              backgroundImage: _image != null
                  ? FileImage(_image!)
                  : (userData != null && userData['profilePicture'] != null)
                      ? NetworkImage(userData['profilePicture'])
                      : AssetImage('asset/images/person.jpg') as ImageProvider<Object>?,
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _uploadProfilePicture,
            child: Text('Upload Profile Picture'),
          ),
          const SizedBox(height: 16.0),
          userData == null
              ? CircularProgressIndicator() // Show a loading indicator
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Username: ${userData['username'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Email: ${userData['email'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Phone Number: ${userData['phoneNumber'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Houses You Created:',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    addedHouses.isEmpty
                        ? Text('You have not created any houses yet.')
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: addedHouses.length,
                            itemBuilder: (context, index) {
                              return FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('houses')
                                    .doc(addedHouses[index])
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return Text('House not found.');
                                  } else {
                                    final houseData =
                                        snapshot.data!.data() as Map<String, dynamic>;

                                    return Column(
                                      children: [
                                        ItemCard(
                                          house: House.fromMap(houseData),
                                          onTap: () {},
                                          key: null,
                                        ),
                                        const SizedBox(
                                          height: 30.0,
                                        ),
                                      ],
                                    );
                                  }
                                },
                              );
                            },
                          ),
                  ],
                ),
        ],
      ),
    ),
  );
}


}