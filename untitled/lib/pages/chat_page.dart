// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/API/chatService.dart';
import 'package:untitled/API/userServices.dart';
import 'package:untitled/pages/user_details_page.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  final String token;
  const ChatPage({super.key, required this.userId, required this.token});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String chatId = '';
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String recipientName = '';
  String recipientProfilePicture = '';
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    fetchOrCreateChat();
    fetchRecipientData();
  }

  Future<void> fetchOrCreateChat() async {
    try {
      final chatService = Provider.of<ChatService>(context, listen: false);
      final newChatId = await chatService.createChat(widget.token, widget.userId);
      setState(() {
        chatId = newChatId ?? '';
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching or creating chat: $error');
      }
    }
  }

  Future<void> fetchRecipientData() async {
    try {
      final userService = Provider.of<UserService>(context, listen: false);
      final userData = await userService.getUserById(widget.userId);

      setState(() {
        recipientName = userData['username'];
        recipientProfilePicture = userData['profilePicture'] ?? '';
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserDetailsPage(userId: widget.userId, token: widget.token),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: recipientProfilePicture.isNotEmpty
                    ? NetworkImage('http://192.168.1.8:3000/$recipientProfilePicture')
                    : const AssetImage('asset/images/person.jpg') as ImageProvider<Object>,
                radius: 20,
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
            child: SingleChildScrollView(
              controller: _scrollController,
              reverse: true, // Scroll to bottom initially
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildMessages(),
              ),
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

Future<void> _sendMessage() async {
  try {
    final chatService = Provider.of<ChatService>(context, listen: false);
    final sentMessage = await chatService.sendMessage(widget.token, chatId, _messageController.text.trim());
    
    if (sentMessage != null && sentMessage['messages'] != null) {
      setState(() {
        messages.clear(); // Clear existing messages
        for (var message in sentMessage['messages']) {
          final content = message['content'];
          if (content != null) {
            messages.add({'content': content});
          }
        }
      });
    }

    _messageController.clear();
    _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  } catch (error) {
    // ignore: avoid_print
    print('Error sending message: $error');
  }
}




List<Widget> _buildMessages() {
  List<Widget> messageWidgets = [];
  for (var message in messages) {
    if ( message['content'] != null) {
      messageWidgets.add(_buildMessage(message['content']));
    }
  }
  return messageWidgets;
}


  Widget _buildMessage(String messageContent) {
    return ListTile(
      title: Text(messageContent),
    );
  }
}
