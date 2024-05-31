import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String description;
  final int averageSourceMaterialScore;
  final int numberOfRatings;
  final int averageAdaptationScore;
  final int averageSimilarityScore;
  final VoidCallback onPressed;

  const BookCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.description,
    required this.averageSourceMaterialScore,
    required this.numberOfRatings,
    required this.averageAdaptationScore,
    required this.averageSimilarityScore,
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

class SourceMaterialRating extends StatelessWidget {
  final int averageSourceMaterialScore;
  final int numberOfRatings;

  const SourceMaterialRating({
    Key? key,
    required this.averageSourceMaterialScore,
    required this.numberOfRatings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Source Material Rating",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.orange),
              Text("$averageSourceMaterialScore ($numberOfRatings reviews)"),
            ],
          ),
        ],
      ),
    );
  }
}

class AdaptationRating extends StatelessWidget {
  final int averageAdaptationScore;
  final int numberOfRatings;

  const AdaptationRating({
    Key? key,
    required this.averageAdaptationScore,
    required this.numberOfRatings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Adaptation Rating",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.orange),
              Text("$averageAdaptationScore ($numberOfRatings reviews)"),
            ],
          ),
        ],
      ),
    );
  }
}
