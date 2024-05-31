import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'review_screen.dart';

class HighestRatingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: "Highest Source Material Rating"),
          _buildRatingRow(context, 'averageSourceMaterialScore', 'Source Material'),
          SectionHeader(title: "Highest Adaptation Rating"),
          _buildRatingRow(context, 'averageAdaptationScore', 'Adaptation'),
          SectionHeader(title: "Highest Similarity Rating"),
          _buildRatingRow(context, 'averageSimilarityScore', 'Similarity'),
        ],
      ),
    );
  }

  Widget _buildRatingRow(BuildContext context, String ratingField, String ratingType) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('book')
          .orderBy(ratingField, descending: true)
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var books = snapshot.data!.docs;
        return Container(
          height: 250, // Increased height to accommodate additional info
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              var book = books[index];
              var ratingValue = parseValue(book[ratingField]);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewScreen(userId: book.id),
                    ),
                  );
                },
                child: Card(
                  child: Container(
                    width: 200, // Set a fixed width for the card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          book['bookImageURL'],
                          height: 100,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            book['bookTitle'],
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            book['author'],
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '$ratingType Rating: $ratingValue',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  int parseValue(dynamic value) {
    if (value is String) {
      return int.tryParse(value) ?? 0;
    } else if (value is int) {
      return value;
    } else {
      return 0;
    }
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Header text style
      ),
    );
  }
}
