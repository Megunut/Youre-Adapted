import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

// ApplicationState class that extends ChangeNotifier to manage authentication state
class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    // Initialize Firebase and set up listeners on creation of the ApplicationState object
    init();
  }

  bool _loggedIn = false; // Private variable to track logged-in state
  bool get loggedIn => _loggedIn; // Getter for the logged-in state

  // Method to initialize Firebase and set up authentication state listeners
  Future<void> init() async {
    // Initialize Firebase with options specific to the current platform
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    // Configure FirebaseUIAuth to use EmailAuthProvider for authentication
    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    // Listen to changes in the authentication state
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        // User is logged in
        _loggedIn = true;
      } else {
        // User is logged out
        _loggedIn = false;
      }
      // Notify listeners of changes to the logged-in state
      notifyListeners();
    });
  }
}
