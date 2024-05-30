import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'title_card.dart';
import 'carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "You're Adapted",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
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
