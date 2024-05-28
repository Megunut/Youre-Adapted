import 'package:cloud_firestore/cloud_firestore.dart';

// method to be called when generating listview based on genre(filter) and name(search)
class QueryBuilder {
  String searchQuery = '';
  List<String> selectedGenres = [];

  QueryBuilder({this.searchQuery = '', this.selectedGenres = const []});

  Query buildQuery() {
    Query query = FirebaseFirestore.instance.collection('book');

    if (searchQuery.isNotEmpty) {
      query = query
          .where('name', isGreaterThanOrEqualTo: searchQuery)
          .where('name', isLessThanOrEqualTo: '$searchQuery\uf8ff');
    }

    if (selectedGenres.isNotEmpty) {
      query = query.where('genre', whereIn: selectedGenres);
    }

    return query;
  }
}


// UI builder example
/*
class BooksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('book').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          var books = snapshot.data!.docs
              .map((doc) => Book.fromFirestore(doc))
              .toList();

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(books[index].name),
                subtitle: Text(books[index].genre),
              );
            },
          );
        },
      ),
    );
  }
}

class Book {
  final String name;
  final String genre;

  Book({required this.name, required this.genre});

  factory Book.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Book(
      name: data['name'] ?? '',
      genre: data['genre'] ?? '',
    );
  }
}
*/