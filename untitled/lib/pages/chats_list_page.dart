// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/API/chatService.dart';
import 'package:untitled/API/userServices.dart';
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
  const ChatListPage({super.key,required this.token});
  final String token; 

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late List<dynamic> chats = [];
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    // Fetch user data when the page initializes
    fetchUserData();
    // Fetch chat data
    ChatService().getChat(widget.token).then((value) {
      setState(() {
        chats = value ?? [];
      });
    }).catchError((error) {
      print('Error fetching chat data: $error');
    });
  }

  // Function to fetch current user's data
  Future<void> fetchUserData() async {
    try {
      final userData = await UserService().getUserDataByToken(widget.token);
      if (userData is Map<String, dynamic>) {
        setState(() {
          currentUserId = userData['_id'];
        });
      } else {
        throw Exception('Invalid user data format');
      }
    } catch (e) {
      // Handle error
      print('Failed to fetch user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user data: $e')),
      );
    }
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
      body: _buildChatList(),
    );
  }

  Widget _buildChatList() {
    // Set to store unique foreign user IDs
    Set<String> uniqueForeignUserIds = <String>{};

    // Iterate through chats to gather unique foreign user IDs
    chats.forEach((chat) {
      List<dynamic> participantsId = chat['participants'] ?? [];
      participantsId.forEach((id) {
        if (id != currentUserId) {
          uniqueForeignUserIds.add(id);
        }
      });
    });

    // Build ChatListItems for each unique foreign user ID
    return ListView(
      children: uniqueForeignUserIds.map((foreignUserId) {
        return ChatListItem(
          userId: foreignUserId,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  userId: foreignUserId,
                  token: widget.token,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}




class ChatListItem extends StatelessWidget {
  final String userId;
  final VoidCallback onTap;

  const ChatListItem({
    super.key, 
    required this.userId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: UserService().getUserById(userId),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink(); // Return an empty widget while data is loading
        }

        if (!userSnapshot.hasData) {
          return const SizedBox.shrink(); // Handle the case when user data is not available
        }

        // Get user data
        Map<String, dynamic> userData = userSnapshot.data!;
        String profilePicture = userData['profilePicture'] ?? '';
        String username = userData['username'] ?? '';

        // Return the ChatListItem with user data
        return ListTile(
          title: Row(
            children: [
              // Display the profile picture (you can use a CircleAvatar or Image widget)
              CircleAvatar(
                radius: 40,
                backgroundImage: profilePicture.isNotEmpty
                    ? NetworkImage('http://192.168.43.114:3000/$profilePicture')
                    : const AssetImage('asset/images/person.jpg') as ImageProvider<Object>,
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

