import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String name;
  final String genre;
  final String type;

  Item({required this.name, required this.genre, required this.type});

  factory Item.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Item(
      name: data['name'] ??
          '', // name of the item (will try later to make search for initials or incomplete name string)
      genre: data['genre'] ?? '', // horror, triller, action, etc.
      type: data['type'] ?? '', // can be book or movieAdaptation
    );
  }
}

class FilterSearchPage extends StatefulWidget {
  @override
  _FilterSearchPageState createState() => _FilterSearchPageState();
}

class _FilterSearchPageState extends State<FilterSearchPage> {
  String searchQuery = '';
  List<String> selectedGenres = [];
  String selectedType = 'All';

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
                  selected: selectedGenres.contains('Fantasy'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedGenres.add('Fantasy');
                      } else {
                        selectedGenres.remove('Fantasy');
                      }
                    });
                  },
                ),
                FilterChip(
                  label: const Text('Romance'),
                  selected: selectedGenres.contains('Romance'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedGenres.add('Romance');
                      } else {
                        selectedGenres.remove('Romance');
                      }
                    });
                  },
                ),
                // Add more genres as needed
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedType,
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
              items: ['All', 'Book', 'Movie Adaptation'].map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _buildQuery().snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                var items = snapshot.data!.docs
                    .map((doc) => Item.fromFirestore(doc))
                    .toList();
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(items[index].name),
                      subtitle:
                          Text('${items[index].genre} - ${items[index].type}'),
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
    Query query = FirebaseFirestore.instance.collection('items');

    if (searchQuery.isNotEmpty) {
      query = query
          .where('name', isGreaterThanOrEqualTo: searchQuery)
          .where('name', isLessThanOrEqualTo: searchQuery + '\uf8ff');
    }

    if (selectedGenres.isNotEmpty) {
      query = query.where('genre', whereIn: selectedGenres);
    }

    if (selectedType != 'All') {
      query = query.where('type', isEqualTo: selectedType);
    }

    return query;
  }
}
