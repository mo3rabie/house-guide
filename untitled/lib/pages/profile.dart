import 'package:flutter/material.dart';

class profile extends StatefulWidget {
  //profile profile(String e, String p)
  String email = "";
  String password = "";
  profile(String e, String p) {
    this.email = e;
    this.password = p;
  }
  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.blue[800],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Hello,",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Hello,", //el mafrod hna h7t el user name fa wait m3ana..
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(this.widget.email),
          Text(this.widget.password),
        ],
      ),
    );
  }
}
