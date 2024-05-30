import 'package:flutter/material.dart';

// A widget that represents a book card with details and a button to submit a review.
class BookCard extends StatelessWidget {
  // Properties for the book card
  final String title; // Title of the book or movie
  final String subtitle; // Subtitle (author or director)
  final String imageUrl; // URL of the image
  final String description; // Description of the book or movie
  final VoidCallback onPressed; // Callback function for the button

  // Constructor to initialize the book card properties
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
      padding: const EdgeInsets.all(16.0), // Padding around the entire card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero, // No padding for the list tile
            title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)), // Display the title
            subtitle: Text(subtitle), // Display the subtitle
            trailing: Icon(Icons.favorite_border), // Display a favorite icon
          ),
          SizedBox(height: 16), // Add vertical space
          Center(
            child: Image.network(
              imageUrl, // Display the image from the URL
              fit: BoxFit.cover, // Cover the available space
              width: MediaQuery.of(context).size.width * 0.6, // Adjust image width based on screen width
            ),
          ),
          SizedBox(height: 16), // Add vertical space
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center the row contents
            children: [
              Column(
                children: [
                  Text(
                    "Similarity",
                    style: TextStyle(fontWeight: FontWeight.bold), // Bold text style
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange), // Star icon with orange color
                      Text("4.5 (44 reviews)"), // Similarity rating
                    ],
                  ),
                ],
              ),
              SizedBox(width: 40), // Add horizontal space
              Column(
                children: [
                  Text(
                    "Rating",
                    style: TextStyle(fontWeight: FontWeight.bold), // Bold text style
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange), // Star icon with orange color
                      Text("3.2 (23 reviews)"), // Rating
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16), // Add vertical space
          Text(
            "Summary",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // Bold text style with larger font size
          ),
          Divider(), // Divider line
          Text(description), // Display the description
          SizedBox(height: 16), // Add vertical space
          Center(
            child: ElevatedButton(
              onPressed: onPressed, // Call the onPressed callback when the button is pressed
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, // Text color
                backgroundColor: Colors.pink, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0), // Rounded corners for the button
                ),
              ),
              child: Text('Submit a Review'), // Button text
            ),
          ),
        ],
      ),
    );
  }
}
