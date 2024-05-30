import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class AllTitlesScreen extends StatefulWidget {
  const AllTitlesScreen({super.key});

  @override
  _AllTitlesScreenState createState() => _AllTitlesScreenState();
}

class _AllTitlesScreenState extends State<AllTitlesScreen> {
  List<String> data = [
    'Dune',
    'Duno',
  ];

  List<String> searchResults = ['Dun1e'];

  void onQueryChanged(String query) {
    setState(() {
      searchResults = data
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SearchBar(onQueryChanged: onQueryChanged),
        Expanded(
          child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchResults[index]),
                );
              }),
        )
      ],
    ));
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar(
      {super.key, required void Function(String query) onQueryChanged});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String query = '';

  void onQueryChanged(String newQuery) {
    setState(() {
      query = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.0),
      child: TextField(
        onChanged: onQueryChanged,
        decoration: InputDecoration(
          labelText: 'Search',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
