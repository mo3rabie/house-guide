// ignore_for_file: use_build_context_synchronously, file_names, avoid_function_literals_in_foreach_calls, deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:untitled/pages/modules/house.dart';


class UserService {
  static const String baseUrl = 'http://192.168.43.114:3000/api/';

Future<String?> createUserWithEmailAndPassword(String email, String password, String userName, String phoneNumber, BuildContext context) async {
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

    if (response.statusCode == 200) {
      // Handle success
    } else {
      // Handle other status codes
      final errorMessage = response.data['error'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage != null ? errorMessage.toString() : 'An error occurred during registration'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  } on DioError catch (e) {
    // Handle Dio error
    if (e.response?.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unauthorized request. Please check your credentials.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      // Print the error message for debugging
      if (kDebugMode) {
        print('DioError: $e');
        print('Request payload: ${e.requestOptions.data}');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('faild!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  } catch (e) {
    // Handle other errors
    // Print the error message for debugging
    if (kDebugMode) {
      print('Error: $e');
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('An unexpected error occurred'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
  return null;
}




static Future<String?> signInWithEmailAndPassword(String email, String password, BuildContext context) async {
  try {
    final dio = Dio();
    final Response<Map<String, dynamic>> response  = await dio.post(
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User is login successfully!'),
          backgroundColor: Colors.lightBlueAccent,
        ),
      );
      Navigator.of(context).pushReplacementNamed("home_screen");
      return token;
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred during login'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  } on DioError catch (e) {
    if (e.response?.statusCode == 401) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unauthorized request. Please check your credentials.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } else {
      if (kDebugMode) {
        print('DioError: $e');
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An unexpected error occurred'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error: $e');
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An unexpected error occurred'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
  return null;
}



}

class HouseService{

  static const String baseUrl = 'http://192.168.43.114:3000/api/';

    static Future<List<House>> getAllHouses() async {
    try {
      final dio = Dio();
      final response = await dio.get('$baseUrl/house/');
      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        List<House> houses = [];
        responseData.forEach((houseData) {
          houses.add(House.fromMap(houseData as Map<String, dynamic>));
        });
        return houses;
      } else {
        throw Exception('Failed to load houses');
      }
    } catch (error) {
      throw Exception('Error fetching houses: $error');
    }
  }
}