import 'package:flutter/material.dart';
import 'package:untitled/API/houseServices.dart';
import 'package:untitled/API/userServices.dart';
import 'package:untitled/pages/chat_page.dart';
import 'package:untitled/pages/house_card.dart';
import 'package:untitled/pages/modules/house.dart';

class UserDetailsPage extends StatefulWidget {
  final String userId;
  final String token;
  const UserDetailsPage({super.key, required this.userId, required this.token});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
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
                FutureBuilder<Map<String, dynamic>>(
                  future: UserService().getUserById(widget.userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Loading indicator while fetching data
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      // Handle error
                      return Text(
                          'Error fetching user data: ${snapshot.error}');
                    } else if (snapshot.data == null) {
                      // Handle null data
                      return const Text('No user data available.');
                    }

                    late Map<String, dynamic>? user = snapshot.data;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: user!['profilePicture'] != null
                              ? NetworkImage(
                                  'http://192.168.1.8:3000/${user['profilePicture']}')
                              : null,
                          radius: 80,
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          user['username'],
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 134, 172),
                          ),
                        ),
                      ],
                    );
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
                        builder: (context) => ChatPage(userId: widget.userId, token: widget.token),
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
                FutureBuilder<List<House>>(
                  future: HouseService.getHousesByOwnerId(widget.userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Loading indicator while fetching data
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError || snapshot.data == null) {
                      // Handle error or null data
                      return const Text('Error fetching user data.');
                    }

                    final houses = snapshot.data!;

                    if (houses.isNotEmpty) {
                      return Column(
                        children: houses.map<Widget>((house) {
                          return HouseCard(
                            house: house,
                            onTap: () {},
                            key: null, token: widget.token,
                          );
                        }).toList(),
                      );
                    } else {
                      return const Text('No houses added by this user.');
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
