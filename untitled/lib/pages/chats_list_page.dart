// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:untitled/pages/chat_page.dart';
import 'package:untitled/pages/setting.dart';

class ChatsList extends StatelessWidget {
  const ChatsList({super.key});

  @override
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
}

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        titleTextStyle: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 134, 172),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No chats yet.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot chat = snapshot.data!.docs[index];
              List<dynamic> participants = chat['participants'];
              String titleId = '';

              // Check if the current user is in the participants list
              if (participants.contains(currentUser?.uid)) {
                // Set the titleId based on the user's input (first or second index)
                if (participants.indexOf(currentUser?.uid) == 0) {
                  titleId = participants[1];
                } else {
                  titleId = participants[0];
                }
                // Display the chat if the current user is a participant
                if (participants.contains(currentUser?.uid)) {
                  return ChatListItem(
                    userUid: titleId,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(userId:titleId),
                        ),
                      );
                    },
                  );
                } else {
                  // Exclude chats where the current user is not a participant
                  return const SizedBox.shrink();
                }
              }
              return null;
            },
          );
        },
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  final String userUid;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.userUid,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userUid).get(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox
              .shrink(); // Return an empty widget while data is loading
        }

        if (!userSnapshot.hasData) {
          return const SizedBox
              .shrink(); // Handle the case when user data is not available
        }

        // Get user data
        String profilePicture = userSnapshot.data!['profilePicture'] ??
            ''; // Replace 'profilePicture' with the actual field name
        String username = userSnapshot.data!['username'] ??
            ''; // Replace 'username' with the actual field name

        // Return the ChatListItem with user data
        return ListTile(
          title: Row(
            children: [
              // Display the profile picture (you can use a CircleAvatar or Image widget)
              CircleAvatar(
                radius: 40,
                backgroundImage: profilePicture.isNotEmpty
                    ? NetworkImage(profilePicture)
                    : const AssetImage('asset/images/person.jpg')
                        as ImageProvider<Object>,
              ),
              const SizedBox(width: 8),
              // Display the username of the other user
              Text(
                username,
                style: const TextStyle(
                  fontSize: 20, // Adjust the font size as needed
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          onTap: onTap,
        );
      },
    );
  }
}
