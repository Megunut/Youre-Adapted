import 'package:flutter/material.dart';
import '../services/user_profile_service.dart';
import '../models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../splash.dart';

class ProfileScreen extends StatefulWidget {
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
      UserProfile userProfile = await _userProfileService.getUserProfile(userID);
      setState(() {
        _userProfile = userProfile;
        _nameController.text = userProfile.name;
        _bioController.text = userProfile.bio;
        _isLoading = false;
      });
    } catch (e) {
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

  // Logs out the user and navigates to the login screen
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SplashScreen()), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: _bioController,
                    decoration: InputDecoration(labelText: 'Bio'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateUserProfile,
                    child: Text('Update Profile'),
                  ),
                  SizedBox(height: 20), // Add some spacing between buttons
                  ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Set the button color to red
                    ),
                    child: Text('Logout'),
                  ),
                ],
              ),
            ),
    );
  }
}
