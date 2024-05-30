import 'package:flutter/material.dart';
import '../services/user_profile_service.dart';
import '../models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserProfileService _userProfileService = UserProfileService();
  late UserProfile _userProfile;
  bool _isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  // Fetches the user profile when the screen is initialized
  void _fetchUserProfile() async {
    try {
      String userID = FirebaseAuth.instance.currentUser?.uid ?? '';
      UserProfile userProfile =
          await _userProfileService.getUserProfile(userID);
      setState(() {
        _userProfile = userProfile;
        _nameController.text = userProfile.name;
        _bioController.text = userProfile.bio;
        _isLoading = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print("User profile not found: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Updates the user profile with the values from the text fields
  void _updateUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    _userProfile.name = _nameController.text;
    _userProfile.bio = _bioController.text;
    await _userProfileService.updateUserProfile(_userProfile);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: _bioController,
                    decoration: const InputDecoration(labelText: 'Bio'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateUserProfile,
                    child: const Text('Update Profile'),
                  ),
                ],
              ),
            ),
    );
  }
}
