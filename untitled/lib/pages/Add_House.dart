// ignore_for_file: use_build_context_synchronously, file_names

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:untitled/pages/modules/house.dart';
import 'package:untitled/pages/setting.dart';
class AddHouse extends StatefulWidget {
  const AddHouse({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddHouseState createState() => _AddHouseState();
}
Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: context.watch<ThemeProvider>().isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,

        
    );
  }

class _AddHouseState extends State<AddHouse> {
  List<File> _images = [];
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  House house = House(ownerId: '');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 100.0,
        title:  const Text('Add New House'),
        titleTextStyle:  const TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        centerTitle: true,
        backgroundColor:  const Color.fromARGB(255, 0, 134, 172),
      ),
      body: Padding(
        padding:  const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                    "asset/images/logo.png",
                    height: 200,),
                if (_images.isNotEmpty)
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(
                            _images[index],
                            height: 100,
                          ),
                        );
                      },
                    ),
                  ),
                ElevatedButton(
                  onPressed: () {
                    _pickImages();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 134, 172), // Set button color to blue
                  ),
                  child: const Text(
                    'Pick Images',
                    style: TextStyle(color: Colors.white), // Set text color to white
                  ),
                ),
                Container(height: 30),

                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter House Name';
                    }
                    if (value.length < 3) {
                        return "The name cannot be less than 3";
                      }
                    return null;
                  },
                    maxLines: 1,
                    maxLength: 30,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2)),
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: Icon(Icons.house_outlined),
                      suffixIconColor: Color.fromARGB(255, 0, 134, 172),
                      labelText: "House Name",
                      labelStyle: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 14,
                      ),
                    ),
                  onSaved: (value) {
                    house.name = value;
                  },
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    if (value.length < 11) {
                        return "The name cannot be less than 11";
                      }
                   if (value.length > 11) {
                        return "The name cannot be more than 11";
                      }
                    return null;
                  },
                    maxLines: 1,
                    maxLength: 11,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2)),
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: Icon(Icons.phone_enabled_outlined),
                      suffixIconColor: Color.fromARGB(255, 0, 134, 172),
                      labelText: "Phone",
                      labelStyle: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 14,
                      ),
                    ),
                  onSaved: (value) {
                    house.phone = value;
                  },
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter address';
                    }
                    return null;
                  },
                  maxLines: 1,
                  maxLength: 40,
                    keyboardType: TextInputType.streetAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2)),
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: Icon(Icons.location_on_outlined),
                      suffixIconColor: Color.fromARGB(255, 0, 134, 172),
                      labelText: "Address",
                      labelStyle: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 14,
                      ),
                      hintStyle: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                  onSaved: (value) {
                    house.address = value;
                  },
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter price';
                    }
                   if (value.length <= 1) {
                      return "The name cannot be less than or equle 1 ";
                      }
                    return null;
                  },
                  maxLines: 1,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2)),
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: Icon(Icons.price_check),
                      suffixIconColor: Color.fromARGB(255, 0, 134, 172),
                      labelText: "Price",
                      labelStyle: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 14,
                      ),
                      hintStyle: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                    
                  onSaved: (value) {
                    house.price = value ;
                  },
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                  maxLines: 5,
                  maxLength: 200,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2)),
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Icon(Icons.description_outlined),
                    suffixIconColor: Color.fromARGB(255, 0, 134, 172),
                    labelText: "Desciption",
                    labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 14,
                    ),
                    hintStyle: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                  onSaved: (value) {
                    house.description = value;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 134, 172), // Set button color to blue
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white), // Set text color to white
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pickImages() async {
    final pickedFiles = await picker.pickMultiImage();

    // ignore: unnecessary_null_comparison
    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
    }
  }
Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    try {
      final db = FirebaseFirestore.instance;
      final storage = FirebaseStorage.instance;

      // Ensure images list is initialized (empty list if it's null)
      house.images ??= [];

      for (var imageFile in _images) {
        final imageRef =
            storage.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await imageRef.putFile(imageFile);
        final downloadUrl = await imageRef.getDownloadURL();
        house.images!.add(downloadUrl);
      }

      // // Convert name and address to lowercase
      // house.name = house.name!.toLowerCase();
      // house.address = house.address!.toLowerCase();

      // Set ownerId to the UID of the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        house.ownerId = user.uid;
      }

      // Save house data to Firestore
        final houseDocRef = await db.collection('houses').add(house.toMap());
        await db.collection('houses').doc(houseDocRef.id).update({
          'houseId': houseDocRef.id,
        });

        // Get the ID of the created house
        final houseUid = houseDocRef.id;

      // Update addedHouse field in the user's document
      if (user != null) {
        await db.collection('users').doc(user.uid).update({
          'addedHouse': FieldValue.arrayUnion([houseUid]),
        });

      }

      // Clear form and show success message
      _formKey.currentState?.reset();
      setState(() {
        _images = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data submitted successfully!'),
          backgroundColor: Colors.lightBlueAccent,
        ),
      );

      Navigator.pop(context);

    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error submitting data. Please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}

}
