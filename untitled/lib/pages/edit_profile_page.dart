// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:untitled/pages/modules/user_profile.dart';
// import 'package:untitled/pages/modules/user_profile_provider.dart';

// class EditProfilePage extends StatefulWidget {
//   @override
//   _EditProfilePageState createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   TextEditingController _usernameController = TextEditingController();
//   TextEditingController _phoneNumberController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final userProfileProvider = Provider.of<UserProfileProvider>(context);
//     final userProfile = userProfileProvider.currentUserProfile;

//     if (userProfile != null) {
//       _usernameController.text = userProfile.username;
//       _phoneNumberController.text = userProfile.phoneNumber ?? '';
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _usernameController,
//               decoration: const InputDecoration(labelText: 'Username'),
//             ),
//             const SizedBox(height: 16.0),
//             TextField(
//               controller: _phoneNumberController,
//               decoration: const InputDecoration(labelText: 'Phone Number'),
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 // Implement logic to update user profile
//                 userProfileProvider.setCurrentUserProfile(
//                   UserProfile(
//                     email: userProfile!.email,
//                     username: _usernameController.text,
//                     phoneNumber: _phoneNumberController.text,
//                     profilePicture: userProfile.profilePicture,
//                     addedHouses: userProfile.addedHouses,
//                   ),
//                 );
//                 Navigator.pop(context); // Go back to the profile page
//               },
//               child: const Text('Save Changes'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
