// ignore_for_file: use_build_context_synchronously, file_names, unused_local_variable, prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isPasswordHidden = true;
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        backgroundColor: Colors.white,
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
                    "Login",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 134, 172)),
                  ),
                  Container(height: 60),
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
                  Container(
                    alignment: Alignment.topRight,
                    child: const Text(
                      'Forgot Password ?       ',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 70),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 5.0)
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
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60.0),
                            ),
                          ),
                          minimumSize:
                              MaterialStateProperty.all(const Size(330, 50)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          shadowColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email.text,
                                      password: password.text);
                                      
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text(' >>>User is login successfully!'),
                                backgroundColor: Colors.lightBlueAccent,
                              ),
                            );
                              Navigator.of(context)
                                  .pushReplacementNamed("home_screen");
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
                        child: const Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: Text(
                            "Login",
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
                      Navigator.of(context).pushReplacementNamed("regScreen");
                    },
                    child: const Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "Don't have an Account ?"),
                            TextSpan(
                                text: ' Sing up',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 134, 172),
                                  fontWeight: FontWeight.bold,
                                ))
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
      ),
    );
  }
}
