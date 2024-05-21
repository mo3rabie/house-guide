// ignore_for_file: use_build_context_synchronously, file_names, avoid_function_literals_in_foreach_calls, deprecated_member_use

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class UserService with ChangeNotifier {
  static const String baseUrl = 'http://192.168.43.114:3000/api';

  Future<void> createUserWithEmailAndPassword(String email, String password,
      String userName, String phoneNumber, BuildContext context) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        '$baseUrl/register',
        data: {
          'email': email,
          'password': password,
          'username': userName,
          'phoneNumber': phoneNumber,
        },
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 201) {
        // Handle success

        final responseBody = response.data;
        final token = responseBody!['token'] as String?;
        final message = response.data!['message'] as String?;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message!),
            backgroundColor: Colors.lightBlueAccent,
          ),
        );
        Navigator.of(context).pushReplacementNamed(
          "home_screen",
          arguments: {'token': token},
        );
      }
    } on DioError catch (e) {
      // Handle Dio error

      if (e.response?.data != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.response!.data['error'])));
        }
      }
    }
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final dio = Dio();
      final Response<Map<String, dynamic>> response = await dio.post(
        '$baseUrl/login',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 200) {
        final responseBody = response.data;
        final token = responseBody!['token'] as String?;
        final message = response.data!['message'] as String?;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message!),
            backgroundColor: Colors.lightBlueAccent,
          ),
        );
        Navigator.of(context).pushReplacementNamed(
          "home_screen",
          arguments: {'token': token},
        );
      } else {
        throw Exception('Failed to sign in: ${response.data}');
      }
    } on DioError catch (e) {
      if (e.response?.data != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.response!.data['error'])),
        );
      } else {
        if (kDebugMode) {
          print('Dio error: ${e.message}');
        }
        throw Exception('Dio error: ${e.message}');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      throw Exception('Error: $error');
    }
  }

    Future<void> logout( BuildContext context, {required String token}) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        '$baseUrl/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 200) {
        // Clear session data associated with the user

        // Show logout success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout successful'),
            backgroundColor: Colors.lightBlueAccent,
          ),
        );
        // Navigate to login screen or any other screen as needed
        Navigator.of(context).pushReplacementNamed("welcomeScreen");
      } else {
        // Handle other status codes if needed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to logout'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle Dio error or other exceptions
      if (kDebugMode) {
        print('Error logging out: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging out: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


Future<Map<String, dynamic>?> getUserDataByToken(
  String token,
) async {
  try {
    final dio = Dio();
    final response = await dio.get(
      '$baseUrl/user/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          contentType: Headers.jsonContentType,
        ),
    );

    if (response.statusCode == 200) {
      final responseBody = response.data;
      if (kDebugMode) {
        print('get user data By Token: ${response.data}');
      }
      return responseBody as Map<String, dynamic>;
    } else {
      throw Exception('Failed to get user data: ${response.data}');
    }
  } on DioError catch (e) {
    if (e.response?.data != null) {
      // Handle Dio error with response
      throw Exception('Dio error: ${e.response!.data}');
    } else {
      // Handle other Dio errors
      throw Exception('Dio error: ${e.message}');
    }
  } catch (error) {
    // Handle generic errors
    throw Exception('Error: $error');
  }
}


  Future<bool> updateUserProfile(
      String token, Map<String, dynamic> userData) async {
    final dio = Dio();
    try {
      final response = await dio.put(
        '$baseUrl/user/',
        data: userData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          contentType: Headers.jsonContentType,
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      // Handle Dio error
      if (kDebugMode) {
        print('Error updating user data: $e');
      }
      return false;
    }
  }

Future<bool> uploadProfilePicture(String token, File imageFile) async {
  final dio = Dio();
  try {
    String fileName = imageFile.path.split('/').last;
    FormData formData = FormData.fromMap({
      "profilePicture": await MultipartFile.fromFile(imageFile.path, filename: fileName),
    });

    final response = await dio.post(
      '$baseUrl/user/profile-picture',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    return response.statusCode == 200;
  } catch (e) {
    if (kDebugMode) {
      print('Error uploading profile picture: $e');
    }
    return false;
  }
}


  static Future<Map<String, dynamic>> toggleBookmark(String token, String houseId,) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        '$baseUrl/user/bookmark/$houseId',
                options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          contentType: Headers.jsonContentType,
        ),
      );
      return {
        'success': response.statusCode == 200,
        'message': response.data['message'], // Assuming the response contains a message
      };
    } catch (e) {
      // Handle Dio error
      if (kDebugMode) {
        print('Error toggling bookmark: $e');
      }
      return {
        'success': false,
        'message': 'Error toggling bookmark: $e',
      };
    }
  }

Future<Map<String, dynamic>> getUserById(String userId) async {
  final dio = Dio();
  try {
    final response = await dio.get(
      '$baseUrl/user/$userId',
    );

    if (response.statusCode == 200) {
      // Handle success
      final responseBody = response.data;
      return responseBody;
    }
  } on DioError catch (e) {
    // Handle Dio error
    if (kDebugMode) {
      print('Error fetching user data by ID: $e');
    }
  }
  throw 'Failed to fetch user data';
}

}
