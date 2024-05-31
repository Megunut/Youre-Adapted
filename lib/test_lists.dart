import 'package:book_review/book_adaptation_info.dart';
import 'package:book_review/screens/review_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:book_review/firestore.dart';

var db = FirebaseFirestore.instance;

void uploadData() async {
  // Create a new user with a first and last name
  final user = <String, dynamic>{
    "title": "Les Misérables",
    "author": "Victor Hugo",
    "sourceMaterialScore": 0,
    "summary": "In 19th-century France, Jean Valjean, who for decades has been hunted by the ruthless policeman Javert after breaking parole, agrees to care for a factory worker's daughter. The decision changes their lives forever."
  };

  // Add a new document with a generated ID
    db.collection("book").add(user).then((DocumentReference doc) =>
      print('DocumentSnapshot added with ID: ${doc.id}'));
}

class TestList extends StatefulWidget {
  const TestList({super.key});


  @override
  State<TestList> createState() => _TestListState();
}

class _TestListState extends State<TestList> {
  Key _refreshKey = UniqueKey();

  void refreshFeed() {
    setState(() {
      debugPrint('ping');
      _refreshKey = UniqueKey();
    });
  }

  // constructor
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
        Column(children: [
          const SizedBox(height: 250),
          const Text('Highest Rated Source Materials'),
          StreamBuilder<QuerySnapshot>(
          stream: db.collection('book').snapshots(),
          builder: (context, snapshot){
            List<Widget> bookWidgets = [];
            if(snapshot.hasData)
            {
              final books = snapshot.data?.docs.reversed.toList();
              for (var book in books!){
                final bookWidget = SizedBox(
                  width: 250,
                  child: 
                    Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          // navigates to the profile screen after data is successfully posted
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context)=> ReviewScreen(userId: book.id,)));
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              width: 200,
                              height: 300,
                              child: Image.network('https://picsum.photos/250?image=9')
                            ),
                            Text(book['bookTitle']),
                          ]
                        ),
                      )
                    ],
                  )
                );
                bookWidgets.add(bookWidget);
              }
            }

            return Expanded(child:
              ListView(
                scrollDirection: Axis.horizontal,
                children: bookWidgets,
              )
            );
          },
        )
        ],)
        
  );
  }

  
}