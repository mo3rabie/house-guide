import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:untitled/pages/modules/house.dart';

class UserProfile {
  String id;
  String email;
  String password;
  String username;
  String phoneNumber;
  String? profilePicture;
  List<House>? addedHouses;
   List<String>? bookmarks; 

  UserProfile({
    required this.id,
    required this.email,
    required this.password,
    required this.username,
    required this.phoneNumber,
    this.profilePicture,
    this.addedHouses,
    this.bookmarks,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'],
      email: json['email'],
      password: json['password'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      profilePicture: json['profilePicture'],
      addedHouses: json['addedHouses'] != null
          ? List<House>.from(
              json['addedHouses'].map((model) => House.fromMap(model)))
          : null,
      bookmarks: json['bookMark'] != null
          ? List<String>.from(json['bookMark'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'password': password,
      'username': username,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'addedHouses': addedHouses != null
          ? addedHouses!.map((house) => house.toMap()).toList()
          : null,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'email': email,
      'password': password,
      'username': username,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'addedHouses': addedHouses != null
          ? addedHouses!.map((house) => house.toMap()).toList()
          : null,
      'bookMark': bookmarks, 
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['_id'],
      email: map['email'],
      password: map['password'],
      username: map['username'],
      phoneNumber: map['phoneNumber'],
      profilePicture: map['profilePicture'],
      addedHouses: map['addedHouses'] != null
          ? List<House>.from(
              map['addedHouses'].map((model) => House.fromMap(model)))
          : null,
    );
  }
}

class UserProfileProvider with ChangeNotifier {
  UserProfile? _userProfile;

  UserProfile? get userProfile => _userProfile;

  void setUserProfile(UserProfile userProfile) {
    _userProfile = userProfile;
    notifyListeners();
  }

  void setUserProfileFromJson(String jsonStr) {
    final Map<String, dynamic> parsedJson = json.decode(jsonStr);
    final userProfile = UserProfile.fromJson(parsedJson);
    setUserProfile(userProfile);
  }

  String getUserProfileJson() {
    return json.encode(_userProfile!.toJson());
 
  }
}
