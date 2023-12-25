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
