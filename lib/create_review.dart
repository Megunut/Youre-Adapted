import 'package:flutter/material.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.title});

  final String title;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // constructor
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 500,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 234, 218, 204), // Background color of the container
            borderRadius: BorderRadius.circular(10), // Rounded corners with a radius of 10
          ),
          child: const Column(
          children: [
            SizedBox(height: 20),
            // Displays username
          ],
        ),
      )
    )
  );
    
  }
}