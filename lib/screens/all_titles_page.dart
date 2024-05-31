import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'review_screen.dart';

class AllTitlesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // Stream to listen to changes in the 'book' collection ordered by 'bookTitle'
      stream: FirebaseFirestore.instance
          .collection('book')
          .orderBy('bookTitle')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Show a loading indicator if the snapshot has no data
          return Center(child: CircularProgressIndicator());
        }

        var books = snapshot.data!.docs; // List of book documents
        return ListView.builder(
          itemCount: books.length, // Number of books to display
          itemBuilder: (context, index) {
            var book = books[index]; // Current book document
            return GestureDetector(
              // Navigate to the ReviewScreen when a book is tapped
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewScreen(userId: book.id),
                  ),
                );
              },
              child: Card(
                // Card widget to display book information
                child: Container(
                  padding: EdgeInsets.all(8.0), // Padding for the card content
                  child: Row(
                    children: [
                      // Display the book's image
                      Image.network(
                        book['bookImageURL'],
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 8), // Spacing between image and text
                      Expanded(
                        // Expanded widget to allow text to take remaining space
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display the book title
                            Text(
                              book['bookTitle'],
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis, // Handle long titles
                            ),
                            // Display the book author
                            Text(
                              book['author'],
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis, // Handle long author names
                            ),
                            // Display the source material rating
                            Text(
                              'Source Material: ${book['averageSourceMaterialScore']}',
                              style: TextStyle(fontSize: 12, color: Colors.black),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis, // Handle long text
                            ),
                            // Display the adaptation rating
                            Text(
                              'Adaptation: ${book['averageAdaptationScore']}',
                              style: TextStyle(fontSize: 12, color: Colors.black),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis, // Handle long text
                            ),
                            // Display the similarity rating
                            Text(
                              'Similarity: ${book['averageSimilarityScore']}',
                              style: TextStyle(fontSize: 12, color: Colors.black),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis, // Handle long text
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
