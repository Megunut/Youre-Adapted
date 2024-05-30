import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
              GoogleProvider(clientId: "506382140602-5nercnd65poa9rn870km523kk5usq09a.apps.googleusercontent.com"),
            ],
            actions: [
              AuthStateChangeAction<UserCreated>((context, state) async {
                await _createUserProfileIfNeeded(state.credential.user);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInScreen(
                      providers: [
                        EmailAuthProvider(),
                        GoogleProvider(clientId: "506382140602-5nercnd65poa9rn870km523kk5usq09a.apps.googleusercontent.com"),
                      ],
                    ),
                  ),
                );
              }),
              AuthStateChangeAction<SignedIn>((context, state) {
                _createUserProfileIfNeeded(state.user);
              }),
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('assets/flutterfire_300x.png'),
                ),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                    ? const Text('Welcome to FlutterFire, please sign in!')
                    : const Text('Welcome to Flutterfire, please sign up!'),
              );
            },
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'By signing in, you agree to our terms and conditions.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
            sideBuilder: (context, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('flutterfire_300x.png'),
                ),
              );
            },
          );
        }

        return const BottomNavBar();
      },
    );
  }

  Future<void> _createUserProfileIfNeeded(User? user) async {
    if (user != null) {
      DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      DocumentSnapshot docSnapshot = await userDoc.get();
      if (!docSnapshot.exists) {
        await userDoc.set({
          'email': user.email,
          'name': user.displayName ?? '',
          'bio': '',
          'favorites': [],
          'recentReviews': [],
        });
      }
    }
  }
}
