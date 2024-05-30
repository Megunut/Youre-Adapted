import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String description;
  final VoidCallback onPressed;

  const BookCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.description,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(subtitle),
            trailing: Icon(Icons.favorite_border),
          ),
          SizedBox(height: 16),
          Center(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.6, // Adjust image width based on screen width
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "Similarity",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange),
                      Text("4.5 (44 reviews)"),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 40),
              Column(
                children: [
                  Text(
                    "Rating",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange),
                      Text("3.2 (23 reviews)"),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            "Summary",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Divider(),
          Text(description),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
