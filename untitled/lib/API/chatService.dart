// ignore_for_file: file_names, avoid_print, deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ChatService with ChangeNotifier{
  final Dio _dio = Dio();
  final String baseUrl = 'http://192.168.43.114:3000/api';

Future<String?> createChat(String token, String receiverId) async {
  try {
    final response = await _dio.post(
      '$baseUrl/chat',
      data: {'receiverId': receiverId},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode == 201) {
      print('ChatID creation: ${response.data["chat"]["_id"]}');
      return response.data["chat"]["_id"];
    } else {
      // Handle unexpected status codes
      print('Unexpected status code: ${response.statusCode}');
      return null;
    }
  } catch (error) {
    if (error is DioError) {
      // Handle DioError specifically
      final dioError = error;
      if (dioError.response?.statusCode == 404) {
        // Handle 404 error (Not Found)
        print('Chat creation failed: Chat not found.');
      } else {
        // Handle other DioErrors
        print('Chat creation failed: ${dioError.message}');
      }
    } else {
      // Handle other types of errors
      print('Error creating chat: $error');
    }
    return null;
  }
}


  Future<dynamic> sendMessage(String token, String chatId, String content) async {
    try {
      final response = await _dio.post(
        '$baseUrl/chat/$chatId/send',
        data: {'content': content},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
          if (response.statusCode == 200) {
      print('send chat Message: ${response.data["chat"]}');
      return response.data["chat"];
    } else {
      // Handle unexpected status codes
      print('Unexpected status code: ${response.statusCode}');
      return null;
    }// Assuming the response contains the updated chat object
    } catch (error) {
    if (error is DioError) {
      // Handle DioError specifically
      final dioError = error;
      if (dioError.response?.statusCode == 404) {
        // Handle 404 error (Not Found)
        print('send chat Message: send Chat not found.');
      } else {
        // Handle other DioErrors
        print('send chat Message: ${dioError.message}');
      }
    } else {
      // Handle other types of errors
      print('Error send chat Message: $error');
    }
    return null;
  }
  }

  Future<List<dynamic>?> getChat(String token) async {
    try {
      final response = await _dio.get(
        '$baseUrl/chat',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data; // Assuming the response is a list of chats
    } catch (error) {
      if (kDebugMode) {
        print('Error getting chat: $error');
      }
      return null;
    }
  }
}
