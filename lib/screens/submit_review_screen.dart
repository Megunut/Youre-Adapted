import 'package:flutter/material.dart';

class SubmitReviewScreen extends StatelessWidget {
  final String reviewType;

  SubmitReviewScreen({required this.reviewType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit a Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Submit your review for the $reviewType',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 20),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write your review here',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Submit review logic
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
