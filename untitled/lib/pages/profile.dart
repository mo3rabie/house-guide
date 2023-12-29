// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/pages/house_card.dart';
import 'package:untitled/pages/modules/house.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user;
  Map<String, dynamic>? userData; // Initialize to null
  late List<String> addedHouses;
  File? _image;
  final picker = ImagePicker();
  late Completer<void> _fetchUserDataCompleter;
  final _formKey = GlobalKey<FormState>();
  bool isPasswordHidden = true;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController passwordController;
  
  @override
  void initState() {
    super.initState();
    _fetchUserDataCompleter = Completer<void>();
    user = FirebaseAuth.instance.currentUser!;
    fetchUserData();

    // Initialize controllers with user data
    usernameController =TextEditingController(text: userData?['username'] ?? '');
    emailController = TextEditingController(text: userData?['email'] ?? '');
    phoneNumberController =TextEditingController(text: userData?['phoneNumber'] ?? '');
    passwordController =TextEditingController(text: userData?['password'] ?? '');
  }

  Future<void> fetchUserData() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      setState(() {
        userData = userDoc.data();
        addedHouses = List<String>.from(userData?['addedHouse'] ?? []);

        // Set initial values for the text editing controllers
        usernameController.text = userData?['username'] ?? '';
        emailController.text = userData?['email'] ?? '';
        phoneNumberController.text = userData?['phoneNumber'] ?? '';
        passwordController.text = userData?['password'] ?? '';
      });
    } finally {
      if (!_fetchUserDataCompleter.isCompleted) {
        _fetchUserDataCompleter.complete();
      }
    }
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
    final reference = storage.ref().child('profile_pictures/${user.uid}.jpg');

    await reference.putFile(_image!);

    final downloadUrl = await reference.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'profilePicture': downloadUrl});

    await fetchUserData();
  }

  Future<void> _updateUserData() async {
    // Update user data in Firestore
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'username': usernameController.text,
      'email': emailController.text,
      'phoneNumber': phoneNumberController.text,
      'password': passwordController.text,
    });

    // Fetch updated user data
    await fetchUserData();
  }

  Future<void> _deleteHouse(String houseId) async {
    // Remove the house from the user's addedHouses list
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'addedHouse': FieldValue.arrayRemove([houseId]),
    });

    // Fetch updated user data
    await fetchUserData();
  }

  @override
  void dispose() {
    if (!_fetchUserDataCompleter.isCompleted) {
      _fetchUserDataCompleter.completeError('Disposed');
    }

    // Dispose text editing controllers
    usernameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 134, 172),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 80.0,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : (userData != null && userData?['profilePicture'] != null)
                          ? NetworkImage(userData?['profilePicture'])
                          : const AssetImage('asset/images/person.jpg')
                              as ImageProvider<Object>?,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _uploadProfilePicture,
                child: const Text('Upload Profile Picture'),
              ),
              const SizedBox(height: 16.0),
              _fetchUserDataCompleter.isCompleted
                  ? userData == null
                      ? const CircularProgressIndicator()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                Container(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 16,
                  ),
                  child: TextFormField(
                    controller: usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter UserName";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "UserName",
                      hintText: "Enter your UserName",
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 60,
                      ),
                      fillColor: const Color(0xFFF7F8F8),
                      filled: true,
                      isDense: true,
                      prefixIcon: const Icon(Icons.person_2_outlined),
                      prefixIconColor: Color.fromARGB(255, 0, 134, 172),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Pleas enter email";
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return "Pleas enter a valid email address";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Enter your Email",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 60),
                        fillColor: const Color(0xFFF7F8F8),
                        filled: true,
                        isDense: true,
                        prefixIcon: Icon(Icons.email_outlined),
                        prefixIconColor: Color.fromARGB(255, 0, 134, 172),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                const BorderSide(style: BorderStyle.none))),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 16),
                    child: TextFormField(
                        controller: phoneNumberController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Phone Number';
                          }
                          if (value.length <= 1) {
                            return "The Phone Number cannot be less than or equle 1 ";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Phone Number",
                            hintText: "Enter your Phone Number",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 60),
                            fillColor: const Color(0xFFF7F8F8),
                            filled: true,
                            isDense: true,
                            prefixIcon: Icon(Icons.phone_enabled_outlined),
                            prefixIconColor: Color.fromARGB(255, 0, 134, 172),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    style: BorderStyle.none
                                    )
                                    )
                                    )
                                    )
                                    ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: isPasswordHidden,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Pleas enter a password";
                      }
                      if (value.length <= 4) {
                        return "password should be more than 4 char";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        fillColor: const Color(0xFFF7F8F8),
                        filled: true,
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 60),
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 20),
                        prefixIconColor: Color.fromARGB(255, 0, 134, 172),
                        prefixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            isPasswordHidden
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              isPasswordHidden = !isPasswordHidden;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                const BorderSide(style: BorderStyle.none))),
                  ),
                ),
                            const SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: _updateUserData,
                              child: const Text('Update User Data'),
                            ),
                            const SizedBox(height: 16.0),
                            const Text(
                              'Houses You Created:',
                              style: TextStyle(
                                  fontSize: 20.0, color: Color.fromARGB(255, 0, 134, 172),
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10.0),
                            addedHouses.isEmpty
                                ? const Text(
                                    'You have not created any houses yet.')
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
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
                                            return const CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else if (!snapshot.hasData ||
                                              snapshot.data == null) {
                                            return const Text('House not found.');
                                          } else {
                                            final houseData = snapshot.data!
                                                .data() as Map<String, dynamic>;
        
                                            return Column(
                                              children: [
                                                ItemCard(
                                                  house: House.fromMap(houseData),
                                                  onTap: () {},
                                                  key: null,
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    _deleteHouse(
                                                        addedHouses[index]);
                                                  },
                                                  child:
                                                      const Text('Delete House'),
                                                ),
                                                const SizedBox(
                                                  height: 20.0,
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                          ],
                        )
                  : Container(), // Placeholder widget while data is loading
            ],
          ),
        ),
      ),
    );
  }
}
