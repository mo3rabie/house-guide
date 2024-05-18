// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/API/houseServices.dart';
import 'package:untitled/API/userServices.dart';
import 'package:untitled/pages/house_card.dart';
import 'package:untitled/pages/modules/house.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.token});

  final String token;

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late String userId = "";
  late Map<String, dynamic>? user;
  late Future<void> _fetchUserDataFuture;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with empty strings
    usernameController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
    user = {};
    _fetchUserDataFuture = fetchUserData();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> fetchUserData() async {
    try {
      final userData = await UserService().getUserDataByToken(widget.token);
      if (userData is Map<String, dynamic>) {
        if (!_isDisposed) {
          setState(() {
            user = userData;
            userId = userData['_id'];
            // Update controllers with fetched data
            usernameController.text = userData['username'] ?? '';
            emailController.text = userData['email'] ?? '';
            phoneNumberController.text = userData['phoneNumber'] ?? '';
          });
        }
      } else {
        throw Exception('Invalid user data format');
      }
    } catch (e) {
      if (!_isDisposed) {
        if (kDebugMode) {
          print('Failed to fetch user data: $e');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch user data: $e')),
        );
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image to upload')),
      );
      return;
    }

    bool success = await UserService().uploadProfilePicture(widget.token, _image!);
    if (success) {
      await fetchUserData();
      if (!_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture uploaded successfully'),
              backgroundColor: Colors.lightBlueAccent),
        );
      }
    } else {
      if (!_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload profile picture')),
        );
      }
    }
  }

  Future<void> _updateUserData() async {
    Map<String, dynamic> userData = {
      'username': usernameController.text,
      'email': emailController.text,
      'phoneNumber': phoneNumberController.text,
    };

    bool success = await UserService().updateUserProfile(widget.token, userData);
    if (success) {
      await fetchUserData();
      if (!_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User data updated successfully'),
              backgroundColor: Colors.lightBlueAccent),
        );
      }
    } else {
      if (!_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update user data')),
        );
      }
    }
  }

  Future<void> _deleteHouse(String houseId) async {
    try {
      await HouseService.deleteHouseById(houseId);
      await fetchUserData();
      if (!_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('House deleted successfully'),
              backgroundColor: Colors.lightBlueAccent),
        );
      }
    } catch (e) {
      if (!_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete house')),
        );
      }
    }
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
              leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
        Navigator.of(context).pushReplacementNamed(
          "home_screen",
          arguments: {'token': widget.token},
        );
        },
      ),
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
                      : (user!['profilePicture'] != null)
                          ? NetworkImage(
                              'http://192.168.43.114:3000/${user!['profilePicture']}')
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                    fillColor: const Color(0xFFF7F8F8),
                    filled: true,
                    isDense: true,
                    prefixIcon: const Icon(Icons.person_2_outlined),
                    prefixIconColor: const Color.fromARGB(255, 0, 134, 172),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(style: BorderStyle.none),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                child: TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter email";
                    }
                    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter your Email",
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                    fillColor: const Color(0xFFF7F8F8),
                    filled: true,
                    isDense: true,
                    prefixIcon: const Icon(Icons.email_outlined),
                    prefixIconColor: const Color.fromARGB(255, 0, 134, 172),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(style: BorderStyle.none),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                child: TextFormField(
                  controller: phoneNumberController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter phone number";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "PhoneNumber",
                    hintText: "Enter your PhoneNumber",
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                    fillColor: const Color(0xFFF7F8F8),
                    filled: true,
                    isDense: true,
                    prefixIcon: const Icon(Icons.phone_enabled_outlined),
                    prefixIconColor: const Color.fromARGB(255, 0, 134, 172),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(style: BorderStyle.none),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _updateUserData,
                child: const Text('Update User Data'),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Houses You Created:',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Color.fromARGB(255, 0, 134, 172),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              FutureBuilder<void>(
                future: _fetchUserDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Error fetching user data:',
                          style: TextStyle(color: Colors.red),
                        ),
                        Text(
                          '${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _fetchUserDataFuture = fetchUserData();
                            });
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    );
                  } else {
                    return FutureBuilder<List<House>>(
                      future: HouseService.getHousesByOwnerId(userId),
                      builder: (BuildContext context, AsyncSnapshot<List<House>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Error fetching houses:',
                                style: TextStyle(color: Colors.red),
                              ),
                              Text(
                                '${snapshot.error}',
                                style: const TextStyle(color: Colors.red),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {});
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          );
                        } else {
                          List<House> houses = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: houses.length,
                            itemBuilder: (context, index) {
                              final house = houses[index];
                              return Column(
                                children: [
                                  HouseCard(
                                    house: house,
                                    onTap: () {},
                                    key: null,
                                    token: widget.token,
                                  ),
                                  const SizedBox(height: 10.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      _deleteHouse(house.houseId!);
                                    },
                                    child: const Text('Delete House'),
                                  ),
                                  const SizedBox(height: 20.0),
                                ],
                              );
                            },
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
