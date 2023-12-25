import 'package:flutter/material.dart';
import 'package:untitled/pages/modules/user_profile.dart';
import 'house.dart'; // Import your House model

class UserProfileProvider extends ChangeNotifier {
  UserProfile? _currentUserProfile;

  UserProfile? get currentUserProfile => _currentUserProfile;

  void setCurrentUserProfile(UserProfile userProfile) {
    _currentUserProfile = userProfile;
    notifyListeners();
  }

  // Implement methods for updating user profile, adding/deleting houses, etc.
}
