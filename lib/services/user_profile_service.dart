import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetches the user profile from Firestore based on the userID
  Future<UserProfile> getUserProfile(String userID) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(userID).get();
    if (doc.exists) {
      return UserProfile.fromFirestore(doc);
    } else {
      throw Exception("User profile not found");
    }
  }

  // Updates the user profile in Firestore
  Future<void> updateUserProfile(UserProfile userProfile) async {
    await _firestore.collection('users').doc(userProfile.userID).set(userProfile.toFirestore(), SetOptions(merge: true));
  }
}
