import 'package:book_review/widgets/book_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'submit_review_screen.dart';
import 'package:intl/intl.dart';

var db = FirebaseFirestore.instance;

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key, required this.userId});

  final String userId;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  Key _refreshKey = UniqueKey();

  void refreshFeed() {
    setState(() {
      debugPrint('ping');
      _refreshKey = UniqueKey();
    });
  }

  Future<DocumentSnapshot> getInfo() async {
    return FirebaseFirestore.instance.collection("book").doc(widget.userId).get();
  }

  int parseValue(dynamic value) {
    if (value is String) {
      return int.tryParse(value) ?? 0;
    } else if (value is int) {
      return value;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit a Review'), // App bar title
      ),
      body: Stack(
        children: [
          // Main content of the screen
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80.0), // Add padding to avoid being overlapped by the button
            child: FutureBuilder(
              future: getInfo(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    var data = snapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the similarity rating widget
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                "Similarity",
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 32),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.star, color: Colors.orange),
                                  Text("${parseValue(data['averageSimilarityScore'])} (${parseValue(data['numberOfRatings'])} reviews)"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Section for book details and ratings
                        SectionHeader(title: "Book"),
                        BookCard(
                          title: data['bookTitle'],
                          subtitle: data['author'],
                          imageUrl: data['bookImageURL'],
                          description: data['summary'],
                          averageSourceMaterialScore: parseValue(data['averageSourceMaterialScore']),
                          numberOfRatings: parseValue(data['numberOfRatings']),
                          averageAdaptationScore: parseValue(data['averageAdaptationScore']),
                          averageSimilarityScore: parseValue(data['averageSimilarityScore']),
                          onPressed: () {},
                        ),
                        // Source Material Rating Widget
                        SourceMaterialRating(
                          averageSourceMaterialScore: parseValue(data['averageSourceMaterialScore']),
                          numberOfRatings: parseValue(data['numberOfRatings']),
                        ),
                        // Section for adaptation details and ratings
                        SectionHeader(title: "Movie"),
                        BookCard(
                          title: data['adaptationTitle'].toString(),
                          subtitle: data['author'],
                          imageUrl: data['adaptationImageURL'],
                          description: data['summary'],
                          averageSourceMaterialScore: parseValue(data['averageSourceMaterialScore']),
                          numberOfRatings: parseValue(data['numberOfRatings']),
                          averageAdaptationScore: parseValue(data['averageAdaptationScore']),
                          averageSimilarityScore: parseValue(data['averageSimilarityScore']),
                          onPressed: () {},
                        ),
                        // Adaptation Rating Widget
                        AdaptationRating(
                          averageAdaptationScore: parseValue(data['averageAdaptationScore']),
                          numberOfRatings: parseValue(data['numberOfRatings']),
                        ),
                        // Section for user reviews
                        SectionHeader(title: "User Reviews"),
                        _buildReviewList(snapshot.data!.id),
                      ],
                    );
                  } else {
                    return Center(child: Text("No data available"));
                  }
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          // Positioned button at the bottom of the screen
          Positioned(
            bottom: 16.0,
            left: 50.0, // Adjusted horizontal padding to make the button smaller
            right: 50.0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubmitReviewScreen(bookID: widget.userId),
                  ),
                ).then((value) {
                  refreshFeed(); // Refresh the feed when returning from the SubmitReviewScreen
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.pink, // text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              child: Text('Submit a Review'),
            ),
          ),
        ],
      ),
    );
  }

  // Function to build the review list
  Widget _buildReviewList(String bookID) {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('rating').where('bookID', isEqualTo: bookID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var reviews = snapshot.data?.docs ?? [];
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            var review = reviews[index];
            var timestamp = review['timestamp'] as Timestamp;
            var date = timestamp.toDate();
            var formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(date);

            return FutureBuilder<DocumentSnapshot>(
              future: db.collection('users').doc(review['userID']).get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.done) {
                  if (userSnapshot.hasData) {
                    var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 3,
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData['name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Source Material Score: ${review['sourceMaterialScore']}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Icon(Icons.star, color: Colors.orange, size: 16),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Adaptation Score: ${review['adaptationScore']}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Icon(Icons.star, color: Colors.orange, size: 16),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Likeness Score: ${review['similarityScore']}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Icon(Icons.star, color: Colors.orange, size: 16),
                                ],
                              ),
                              Text(
                                'Submitted on: $formattedDate',
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(review['comment']),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(child: Text("User data not available"));
                  }
                }
                return Center(child: CircularProgressIndicator());
              },
            );
          },
        );
      },
    );
  }
}

// SectionHeader widget
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Header text style
      ),
    );
  }
}

// SourceMaterialRating widget
class SourceMaterialRating extends StatelessWidget {
  final int averageSourceMaterialScore;
  final int numberOfRatings;

  const SourceMaterialRating({
    Key? key,
    required this.averageSourceMaterialScore,
    required this.numberOfRatings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Source Material Rating",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.orange),
              Text("$averageSourceMaterialScore ($numberOfRatings reviews)"),
            ],
          ),
        ],
      ),
    );
  }
}

// AdaptationRating widget
class AdaptationRating extends StatelessWidget {
  final int averageAdaptationScore;
  final int numberOfRatings;

  const AdaptationRating({
    Key? key,
    required this.averageAdaptationScore,
    required this.numberOfRatings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Adaptation Rating",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.orange),
              Text("$averageAdaptationScore ($numberOfRatings reviews)"),
            ],
          ),
        ],
      ),
    );
  }
}
