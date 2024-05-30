import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var db = FirebaseFirestore.instance;
class SubmitReviewScreen extends StatefulWidget {
  final String reviewType;
  final String bookID;

  SubmitReviewScreen({required this.reviewType, required this.bookID});

  @override
  _SubmitReviewScreenState createState() => _SubmitReviewScreenState();
}

class _SubmitReviewScreenState extends State<SubmitReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  int _selectedBookRating = 0;
  int _selectedAdaptatioRating = 0;
  int _selectedSimilarityRating = 0;
  String bookID = '';
  final TextEditingController _reviewController = TextEditingController();

  void _setBookID(String bookid) {
    setState(() {
      bookID = bookid;
    });
  }
  void _setBookRating(int rating) {
    setState(() {
      _selectedBookRating = rating;
    });
  }
  void _setAdaptationRating(int rating) {
    setState(() {
      _selectedAdaptatioRating = rating;
    });
  }
  void _setSimilarityRating(int rating) {
    setState(() {
      _selectedSimilarityRating = rating;
    });
  }

  void _submitReview() {
    if (_formKey.currentState?.validate() ?? false) {
      FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final uid = user?.uid;
      // Submit review logic
      print("Review: ${_reviewController.text}");
      print("Source Material Rating: $_selectedBookRating");
      print("Adaptation Rating: $_selectedAdaptatioRating");
      print("Rating: $_selectedSimilarityRating");

      // Create a new user with a first and last name
    final rating = <String, dynamic>{
      "userID": uid,
      "bookID": bookID,
      "comment": _reviewController.text,
      "sourceMaterialScore": _selectedBookRating,
      "adaptationScore": _selectedAdaptatioRating,
      "similarityScore": _selectedSimilarityRating,
      "timestamp": Timestamp.now(),
    };

  // Add a new document with a generated ID
  db.collection("rating").add(rating).then((DocumentReference doc) =>
      print('DocumentSnapshot added with ID: ${doc.id}'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit a Review'),
      ),
      resizeToAvoidBottomInset: true, // Ensures the screen resizes when the keyboard is shown
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Submit your review for the ${widget.reviewType}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _reviewController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Write your review here',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a review';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                'Rate the Source Material',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _selectedBookRating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                    ),
                    onPressed: () => _setBookRating(index + 1),
                  );
                }),
              ),
              SizedBox(height: 10),
              Text(
                'Rate the Adaptation',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _selectedAdaptatioRating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                    ),
                    onPressed: () => _setAdaptationRating(index + 1),
                  );
                }),
              ),
              SizedBox(height: 10),
              Text(
                'Rate the Similarity',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _selectedSimilarityRating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                    ),
                    onPressed: () => _setSimilarityRating(index + 1),
                  );
                }),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _setBookID(widget.bookID);
                  _submitReview;},
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
