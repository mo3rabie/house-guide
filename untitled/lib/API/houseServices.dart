// ignore_for_file: file_names, avoid_print, avoid_function_literals_in_foreach_calls

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:untitled/pages/modules/house.dart';

class HouseService {
  static final Dio _dio = Dio();
  static const String baseUrl = 'http://192.168.1.8:3000/api/house';
  static Future<List<House>> getAllHouses() async {
    try {
      final response = await Dio().get('$baseUrl/');
      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        return responseData
            .map(
                (houseData) => House.fromMap(houseData as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException('Failed to load houses', response.statusCode!);
      }
    } catch (error) {
      throw NetworkException('Error fetching houses: $error');
    }
  }

  static Future<Map<String, dynamic>> createHouse(
      String token, Map<String, dynamic> body, List<String> files) async {
    try {
      final formData = FormData();

      // Add text fields
      body.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      // Add files
      for (String filePath in files) {
        String fileName = filePath.split('/').last;
        formData.files.add(MapEntry(
          'images',
          await MultipartFile.fromFile(filePath, filename: fileName),
        ));
      }

      if (kDebugMode) {
        print('Request Data:');
      }
      formData.fields.forEach((field) {
        print('${field.key}: ${field.value}');
      });
      formData.files.forEach((file) {
        print('File: ${file.key}: ${file.value.filename}');
      });

      final response = await Dio().post(
        '$baseUrl/', 
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        }),
      );

      print('Response Data: ${response.data}');

      if (response.statusCode == 201) {
        return {'message': response.data['message']};
      } else {
        throw Exception('Failed to create house');
      }
    } catch (error) {
      print('Error creating house: $error');
      throw Exception('Error creating house: $error');
    }
  }

  static Future<House> getHouseById(String id) async {
    try {
      final response = await _dio.get('$baseUrl/$id');
      if (response.statusCode == 200) {
        return House.fromMap(response.data as Map<String, dynamic>);
      } else {
        throw ApiException('Failed to load house', response.statusCode!);
      }
    } catch (error) {
      throw NetworkException('Error fetching house: $error');
    }
  }

  static Future<void> deleteHouseById(String id) async {
    try {
      final response = await _dio.delete('$baseUrl/$id');
      if (response.statusCode != 204) {
        throw ApiException('Failed to delete house', response.statusCode!);
      }
    } catch (error) {
      throw NetworkException('Error deleting house: $error');
    }
  }

  static Future<List<House>> searchHousesByAddress(String address) async {
    try {
      final response = await _dio.get('$baseUrl/searchHouse/$address');
      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        return responseData
            .map(
                (houseData) => House.fromMap(houseData as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException('Failed to search houses', response.statusCode!);
      }
    } catch (error) {
      throw NetworkException('Error searching houses: $error');
    }
  }

  static Future<List<House>> getHousesByOwnerId(String ownerId) async {
    try {
      final response = await _dio.get('$baseUrl/owner/$ownerId');
      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        return responseData
            .map(
                (houseData) => House.fromMap(houseData as Map<String, dynamic>))
            .toList();
      } else {
        if (kDebugMode) {
          print('Failed to load houses. Status code: ${response.statusCode}');
        }
        throw ApiException('Failed to load houses', response.statusCode!);
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching houses: $error');
      }
      throw NetworkException('Error fetching houses: $error');
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}
