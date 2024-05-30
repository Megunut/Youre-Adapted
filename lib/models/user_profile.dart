import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String userID;
  String email;
  String name;
  String bio;
  List<String> favorites;
  List<String> recentReviews;

  UserProfile({
    required this.userID,
    required this.email,
    required this.name,
    required this.bio,
    required this.favorites,
    required this.recentReviews,
  });

  // Factory constructor to create a UserProfile instance from a Firestore document
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};
    return UserProfile(
      userID: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      bio: data['bio'] ?? '',
      favorites: List<String>.from(data['favorites'] ?? []),
      recentReviews: List<String>.from(data['recentReviews'] ?? []),
    );
  }

  // Converts a UserProfile instance to a Map to store in Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'bio': bio,
      'favorites': favorites,
      'recentReviews': recentReviews,
    };
  }
}
