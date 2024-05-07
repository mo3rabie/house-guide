// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:untitled/pages/setting.dart';
import 'package:untitled/pages/user_details_page.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});
  
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

class ChatPage extends StatefulWidget {
  final String userId;

  const ChatPage({super.key, required this.userId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String chatId = ''; // Declare this variable to store the chat ID
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String recipientName = '';
  String recipientProfilePicture = '';

  @override
  void initState() {
    super.initState();
    fetchOrCreateChat();
    fetchRecipientData();
  }
Future<void> fetchOrCreateChat() async {
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Query to find an existing chat
      QuerySnapshot<Map<String, dynamic>> existingChatQuery = await FirebaseFirestore.instance
          .collection('chats')
          .where('participants', arrayContainsAny: [currentUser.uid, widget.userId])
          .get();

      if (existingChatQuery.docs.isNotEmpty) {
        // If a chat exists, use its ID
        setState(() {
          chatId = existingChatQuery.docs[0].id;
        });
      } else {
        // If a chat doesn't exist, create a new one
        DocumentReference<Map<String, dynamic>> newChatRef = await FirebaseFirestore.instance.collection('chats').add({
          'participants': [currentUser.uid, widget.userId],
          'title': widget.userId, 
        });

        setState(() {
          chatId = newChatRef.id; // Use the new chat document ID
        });
      }
    }
  } catch (error) {
    if (kDebugMode) {
      print('Error fetching or creating chat: $error');
    }
  }
}




  Future<void> fetchRecipientData() async {
    try {
      // Fetch recipient's data from Firestore
      DocumentSnapshot recipientSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();

      // Update recipient's name and profile picture
      setState(() {
        recipientName = recipientSnapshot['username'];
        recipientProfilePicture = recipientSnapshot['profilePicture'] ?? '';
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching recipient data: $error');
      }
    }
  }

  @override
 Widget build(BuildContext context) {
if (chatId.isEmpty) {
      // If chatId is not initialized, display a loading indicator or handle it accordingly
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

      return Scaffold(
    appBar: AppBar(
      title: GestureDetector(
        onTap: () {
          // Navigate to user details page when the image or username is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailsPage(userId: widget.userId),
            ),
          );
        },
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: recipientProfilePicture.isNotEmpty
                  ? NetworkImage(recipientProfilePicture)
                  : const AssetImage('asset/images/person.jpg') as ImageProvider<Object>,
              radius: 28,
            ),
            const SizedBox(width: 8),
            Text(recipientName),
          ],
        ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 134, 172),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var messages = snapshot.data!.docs.reversed;

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages.elementAt(index).data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text(message['text']),
                      subtitle: Text(message['senderName']),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: const Color.fromARGB(255, 0, 134, 172),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
     );
  }

  void _sendMessage() async {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      try {
        // Get the current user
        User? currentUser = FirebaseAuth.instance.currentUser;

        // Check if the current user is authenticated
        if (currentUser != null) {
          // Get the sender's name from the current user
          String? senderName = await _getSenderName(currentUser);

          // Check if the display name is empty
          if (senderName == null || senderName.isEmpty) {
            // If the display name is empty, use the email as an alternative
            senderName = currentUser.email ?? 'Unknown Sender';
          }

          // Add the message to the recipient's messages collection
          await FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').add({
            'text': messageText,
            'senderName': senderName,
            'timestamp': FieldValue.serverTimestamp(),
          });

          _messageController.clear();
          _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
        } else {
          // Handle the case when the user is not authenticated
          if (kDebugMode) {
            print('Current user is not authenticated.');
          }
        }
      } catch (error) {
        if (kDebugMode) {
          print('Error sending message: $error');
        }
      }
    }
  }

  Future<String?> _getSenderName(User user) async {
    // You can implement your own logic to fetch the user's name
    // For example, you might have a 'users' collection where you store additional user details
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return userSnapshot['userName'];
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching user name: $error');
      }
      return null;
    }
  }
}
