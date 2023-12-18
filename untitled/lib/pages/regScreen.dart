
// ignore_for_file: use_build_context_synchronously


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
                  "Sing up",
                  style: TextStyle(fontSize: 30, 
                  fontWeight: FontWeight.bold,
                  color:Color.fromARGB(255,0, 134, 172) ),
                ),
                Container(height: 30),
                Padding(padding: 
                const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  child: TextFormField(
                    controller:userName,
                    decoration: InputDecoration(
                       labelText: "UserName",
                      hintText: "Enter your UserName",
                      contentPadding: const EdgeInsets.symmetric(vertical:20,horizontal: 60),
                      fillColor: const Color(0xFFF7F8F8),
                      filled: true,
                     isDense: true,
                     border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)
                       
                      ),
                        enabledBorder:OutlineInputBorder(
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
                      contentPadding: const EdgeInsets.symmetric(vertical:20,horizontal: 60),
                      fillColor: const Color(0xFFF7F8F8),
                      filled: true,
                     isDense: true,
                     border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)
                      ),
                        enabledBorder:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                                style: BorderStyle.none
                            )
                        )
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
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
                     contentPadding: const EdgeInsets.symmetric(vertical:20,horizontal: 60),
                      prefixIconConstraints: const BoxConstraints(minWidth: 20),
                      prefixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
               isPasswordHidden
               ? Icons.visibility
               : Icons.visibility_off,
               color: Theme.of(context).primaryColorDark,
               ),
            onPressed: () {
               // Update the state i.e. toogle the state of passwordVisible variable
               setState(() {
                   isPasswordHidden = !isPasswordHidden;
               });
                        },
                        
                      ),
                   enabledBorder:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                                style: BorderStyle.none
                            )
                        )
                    ),
                  ),
                ),
                     const SizedBox(height: 30),
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
                          Color.fromARGB(255,0, 134, 172),
                        ],
                      ),
                      color: const Color.fromARGB(255,0, 134, 172),
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
                        minimumSize: MaterialStateProperty.all(const Size(330, 50)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        // elevation: MaterialStateProperty.all(3),
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()){
                           try {
                          
                          await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email.text,
                              password: password.text,
                            );Navigator.of(context).pushReplacementNamed('home_screen');
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              if (kDebugMode) {
                                print('The password provided is too weak.');
                              }
                            } else if (e.code == 'email-already-in-use') {
                              if (kDebugMode) {
                                print(
                                  'The account already exists for that email.');
                              }
                            }
                          } catch (e) {
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
                          "Sing up",
                          style: TextStyle(
                            fontSize: 18,
                            // fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),   
                InkWell(
                    onTap: (){
                      Navigator.of(context).pushReplacementNamed("loginScreen");
                    },
                    child: const Center(
                      child:Text.rich(TextSpan(children:[
                        TextSpan(text: "Have an Account ?"),
                        TextSpan(text: ' Login',style: TextStyle(color:Color.fromARGB(255,0, 134, 172),
                        fontWeight:FontWeight.bold,))   ],
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