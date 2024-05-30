import 'package:flutter/material.dart';
import 'all_titles.dart';
import 'profile.dart';
import 'home.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Colors.black,
          height: 70,
          child: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: "Home",
              ),
              Tab(
                icon: Icon(Icons.search),
                text: "All Titles",
              ),
              Tab(
                icon: Icon(Icons.photo_library_outlined),
                text: "Profile",
              ),
            ],
            unselectedLabelColor: Color(0xFF999999),
            labelColor: Colors.white,
            indicatorColor: Colors.transparent,
          ),
        ),
        body: const TabBarView(
          children: [
            HomeScreen(),
            AllTitlesScreen(),
            ProfileScreen(),
          ],
        ),
      ),
    );
  }
}
