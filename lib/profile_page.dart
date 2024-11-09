// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   final _supabase = Supabase.instance.client;
//
//   // User details to be fetched and displayed
//   String? _userEmail;
//   String? _userName;
//
//   // TextControllers for editable fields
//   final _nameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _emailController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserDetails();
//   }
//
//   // Fetch user details from Supabase
//   Future<void> _getUserDetails() async {
//     final user = _supabase.auth.currentUser;
//
//     if (user != null) {
//       setState(() {
//         _userEmail = user.email;
//         _userName = user.userMetadata?['full_name'];
//         _emailController.text = _userEmail ?? '';
//         _nameController.text = _userName ?? '';
//       });
//     }
//   }
//
//   // Update user profile (e.g., name and email)
//   Future<void> _updateProfile() async {
//     final user = _supabase.auth.currentUser;
//
//     if (user != null) {
//       final updatedMetadata = {'full_name': _nameController.text};
//
//       // Update email (if changed)
//       if (_emailController.text != _userEmail) {
//         final UserResponse res = await _supabase.(
//           UserAttributes(
//             password: 'new password',
//           ),
//         );
//         final User? updatedUser = res.user;
//         if (emailResponse.error != null) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating email')));
//           return;
//         }
//       }
//
//       // Update metadata (name)
//       final metadataResponse = await _supabase.auth.updateUser(
//         UserAttributes(data: updatedMetadata),
//       );
//
//       if (metadataResponse.error == null) {
//         setState(() {
//           _userName = _nameController.text;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating profile')));
//       }
//     }
//   }
//
//   // Change password logic
//   Future<void> _changePassword() async {
//     final user = _supabase.auth.currentUser;
//
//     if (user != null) {
//       final passwordResponse = await _supabase.auth.updateUser(
//         UserAttributes(password: _passwordController.text),
//       );
//
//       if (passwordResponse.error == null) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password changed successfully')));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error changing password')));
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile Settings'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // User Information Display
//             Text('Email: $_userEmail', style: TextStyle(fontSize: 18)),
//             SizedBox(height: 10),
//             Text('Name: $_userName', style: TextStyle(fontSize: 18)),
//             SizedBox(height: 20),
//
//             // Edit Name
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: 'Full Name'),
//             ),
//             SizedBox(height: 20),
//
//             // Edit Email
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email Address'),
//             ),
//             SizedBox(height: 20),
//
//             // Change Password Section
//             TextField(
//               controller: _passwordController,
//               obscureText: true,
//               decoration: InputDecoration(labelText: 'New Password'),
//             ),
//             SizedBox(height: 20),
//
//             // Buttons for updating profile and changing password
//             ElevatedButton(
//               onPressed: _updateProfile,
//               child: Text('Update Profile'),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: _changePassword,
//               child: Text('Change Password'),
//             ),
//             SizedBox(height: 20),
//
//             // Profile Picture Upload Option
//             // Implement image upload functionality here
//             ElevatedButton(
//               onPressed: () {
//                 // Logic to change profile picture
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Change Profile Picture functionality')));
//               },
//               child: Text('Change Profile Picture'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
