import 'package:flutter/material.dart';
import '../screens/review_screen.dart';
import '../widgets/book_card.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('You\'re Adapted'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title: 'Top Source Material Scores'),
            BookList(), // Replace with actual data fetching and display logic
            SectionTitle(title: 'Top Adaptation Scores'),
            BookList(), // Replace with actual data fetching and display logic
            SectionTitle(title: 'Top Likeness Scores'),
            BookList(), // Replace with actual data fetching and display logic
            SectionTitle(title: 'All Books'),
            BookList(), // Replace with actual data fetching and display logic
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }
}

class BookList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration
    List<String> books = ["Book 1", "Book 2", "Book 3"];

    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          return BookCard(
            title: books[index],
            subtitle: 'Author',
            imageUrl: 'https://via.placeholder.com/150',
            description: 'A great book.',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
