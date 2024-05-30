import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String name;
  final String genre;

  Item({required this.name, required this.genre});

  factory Item.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Item(
      name: data['name'] ??
          '', // name of the item (will try later to make search for initials or incomplete name string)
      genre: data['genre'] ?? '', // horror, triller, action, etc.
    );
  }
}

class FilterSearchPage extends StatefulWidget {
  const FilterSearchPage({super.key});

  @override
  _FilterSearchPageState createState() => _FilterSearchPageState();
}

class _FilterSearchPageState extends State<FilterSearchPage> {
  String searchQuery = '';
  List<String> selectedGenres = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter & Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search by name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              children: [
                FilterChip(
                  label: const Text('Fantasy'),
                  selected: selectedGenres.contains('fantasy'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedGenres.add('fantasy');
                      } else {
                        selectedGenres.remove('fantasy');
                      }
                    });
                  },
                ),
                FilterChip(
                  label: const Text('Romance'),
                  selected: selectedGenres.contains('romance'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedGenres.add('romance');
                      } else {
                        selectedGenres.remove('romance');
                      }
                    });
                  },
                ),
                // Add more genres as needed
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _buildQuery().snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                var items = snapshot.data!.docs
                    .map((doc) => Item.fromFirestore(doc))
                    .toList();
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(items[index].name),
                      subtitle: Text(items[index].genre),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Query _buildQuery() {
    Query query = FirebaseFirestore.instance.collection('book');

    if (searchQuery.isNotEmpty) {
      query = query
          .where('bookTitle', isGreaterThanOrEqualTo: searchQuery)
          .where('bookTitle', isLessThanOrEqualTo: '$searchQuery\uf8ff');
    }

    if (selectedGenres.isNotEmpty) {
      query = query.where('genre', whereIn: selectedGenres);
    }

    return query;
  }
}
