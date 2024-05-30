import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'title_card.dart';
import 'carousel.dart';
import '../screens/profile_screen.dart' as profilescreen;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => profilescreen.ProfileScreen(),
                ),
              );
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/dash.png'),
            Text(
              'Welcome!',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SignOutButton(),
          ],
        ),
        body: const SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Carousel(),
          SizedBox(
            height: 20,
          ),
          SizedBox(
              height: 220,
              child: TitleCard(
                listTitle: 'Highest Rated Source Materials',
              )),
          SizedBox(
            height: 20,
          ),
          SizedBox(
              height: 220,
              child: TitleCard(listTitle: 'Highest Rated Movie Adaptations')),
          SizedBox(
            height: 20,
          ),
          SizedBox(
              height: 220,
              child: TitleCard(listTitle: 'Highest Similarity Scores')),
        ])));
  }
}
