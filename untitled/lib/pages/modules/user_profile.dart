import 'package:flutter/material.dart';
import 'package:untitled/pages/modules/house.dart';

class UserProfile {
  String email;
  String password;
  String username;
  String phoneNumber;
  String? profilePicture;
  List<House>? addedHouses;

  UserProfile({
    required this.email,
    required this.password,
    required this.username,
    required this.phoneNumber,
    this.profilePicture,
    this.addedHouses,
  });
}
class UserProfileProvider extends ChangeNotifier {
  UserProfile? _currentUserProfile;

  UserProfile? get currentUserProfile => _currentUserProfile;

  void setCurrentUserProfile(UserProfile userProfile) {
    _currentUserProfile = userProfile;
    notifyListeners();
  }

}
