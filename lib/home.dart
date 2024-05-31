import 'package:book_review/test_lists.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import '../screens/profile_screen.dart' as profilescreen;

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
  void readData() async {
    await db.collection("people").get().then((event) {
    for (var doc in event.docs) {
      print("${doc.id} => ${doc.data()}");
    }

    return ListView(
    // This next line does the trick.
    scrollDirection: Axis.horizontal,
    children: <Widget>[
      Container(
        width: 160,
        color: Colors.red,
      ),
      Container(
        width: 160,
        color: Colors.blue,
      ),
      Container(
        width: 160,
        color: Colors.green,
      ),
      Container(
        width: 160,
        color: Colors.yellow,
      ),
      Container(
        width: 160,
        color: Colors.orange,
      ),
    ],
  );
});

}

class HomeScreen extends StatelessWidget {
  

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => profilescreen.ProfileScreen(),
                ),
              );
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/dash.png'),
            Text(
              'Welcome!',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: () async {
                // navigates to the profile screen after data is successfully posted
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context)=> const TestList()));
              },
              
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Go to Lists'),
            ),
            ElevatedButton(
              onPressed: () async {
                // navigates to the profile screen after data is successfully posted
                uploadData();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Submit Data'),
            ),
            ElevatedButton(
              onPressed: () async {
                // navigates to the profile screen after data is successfully posted
                readData();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Read Data'),
            ),
            const SignOutButton(),
          ],
        ),
      ),
    );
  }
}
