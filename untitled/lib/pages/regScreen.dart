// ignore_for_file: file_names, use_build_context_synchronously, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({super.key});

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isPasswordHidden = false;
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Image.asset(
                  "asset/images/logo1.png",
                  width: 300,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 134, 172),
                  ),
                ),
                Container(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 16,
                  ),
                  child: TextFormField(
                    controller: userName,
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
                    controller: email,
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
                        controller: phoneNumber,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Phone Number';
                          }
                          if (value.length <= 11) {
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
                    controller: password,
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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 5.0,
                        )
                      ],
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.0, 1.0],
                        colors: [
                          Color.fromARGB(255, 105, 146, 157),
                          Color.fromARGB(255, 0, 134, 172),
                        ],
                      ),
                      color: const Color.fromARGB(255, 0, 134, 172),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60.0),
                        ),
                        backgroundColor: Colors.transparent,
                        minimumSize: const Size(330, 50),
                        elevation: 3,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email.text,
                              password: password.text,
                            );

                            final db = FirebaseFirestore.instance;
                            await db
                                .collection('users')
                                .doc(credential.user!.uid)
                                .set({
                              'email': email.text,
                              'username': userName.text,
                              'phoneNumber': phoneNumber.text,
                              'password': password.text,
                              'addedHouse': [],
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text(' >>>User is signed in successfully!'),
                                backgroundColor: Colors.lightBlueAccent,
                              ),
                            );
                            Navigator.of(context)
                                .pushReplacementNamed('home_screen');
                          } on FirebaseAuthException catch (e) {
                            // Handle FirebaseAuthException
                            // Display SnackBar with error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.message ?? 'An error occurred',
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          } catch (e) {
                            // Handle other exceptions
                            if (kDebugMode) {
                              print(e);
                            }
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed("loginScreen");
                  },
                  child: const Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: "Have an Account ?"),
                          TextSpan(
                            text: ' Login',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 134, 172),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
