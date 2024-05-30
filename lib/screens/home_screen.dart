import 'package:book_review/screens/review_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var db = FirebaseFirestore.instance;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    TopScoresScreen(),
    AllBooksScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Top Scores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'All Books',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class TopScoresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: 'Top Source Material Scores'),
          BookList(scoreType: 'sourceMaterialScore'),
          SectionTitle(title: 'Top Adaptation Scores'),
          BookList(scoreType: 'adaptationScore'),
          SectionTitle(title: 'Top Likeness Scores'),
          BookList(scoreType: 'likenessScore'),
        ],
      ),
    );
  }
}

class AllBooksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('book').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var books = snapshot.data?.docs ?? [];
        return ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            var book = books[index];
            return ListTile(
              title: Text(book['title']),
              subtitle: Text(book['author']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewScreen(userId: book.id),
                  ),
                );
              },
            );
          },
        );
      },
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
  final String scoreType;

  BookList({required this.scoreType});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: StreamBuilder<QuerySnapshot>(
        stream: db.collection('book').orderBy(scoreType, descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var books = snapshot.data?.docs ?? [];
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              var book = books[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.network(
                      'https://via.placeholder.com/150',
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 8),
                    Text(book['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(book['author']),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
