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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit a Review'), // App bar title
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80.0), // Add padding to avoid being overlapped by the button
            child: FutureBuilder(
              future: getInfo(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: "Book"),
                      BookCard(
                        title: snapshot.data!['bookTitle'],
                        subtitle: snapshot.data!['author'],
                        imageUrl: snapshot.data!['bookImageURL'],
                        description: snapshot.data!['summary'],
                        onPressed: () {},
                      ),
                      SectionHeader(title: "Movie"),
                      BookCard(
                        title: snapshot.data!['adaptationTitle'].toString(),
                        subtitle: snapshot.data!['author'],
                        imageUrl: snapshot.data!['adaptationImageURL'],
                        description: snapshot.data!['summary'],
                        onPressed: () {},
                      ),
                      SectionHeader(title: "User Reviews"),
                      _buildReviewList(snapshot.data!.id),
                    ],
                  );
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return Text("No data");
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
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
                );
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
          },
        );
      },
    );
  }
}

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


// class BookCard extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final String imageUrl;
//   final String description;
//   final VoidCallback onPressed;

//   const BookCard({
//     Key? key,
//     required this.title,
//     required this.subtitle,
//     required this.imageUrl,
//     required this.description,
//     required this.onPressed,
//   }) : super(key: key);
//   const BookCard({
//     Key? key,
//     required this.title,
//     required this.subtitle,
//     required this.imageUrl,
//     required this.description,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ListTile(
//             contentPadding: EdgeInsets.zero,
//             title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text(subtitle),
//             trailing: Icon(Icons.favorite_border),
//           ),
//           SizedBox(height: 16),
//           Center(
//             child: Image.network(
//               imageUrl,
//               fit: BoxFit.cover,
//               width: MediaQuery.of(context).size.width * 0.6, // Adjust image width based on screen width
//             ),
//           ),
//           SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Column(
//                 children: [
//                   Text(
//                     "Similarity",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Row(
//                     children: [
//                       Icon(Icons.star, color: Colors.orange),
//                       Text("4.5 (44 reviews)"),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(width: 40),
//               Column(
//                 children: [
//                   Text(
//                     "Rating",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Row(
//                     children: [
//                       Icon(Icons.star, color: Colors.orange),
//                       Text("3.2 (23 reviews)"),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           Text(
//             "Summary",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           ),
//           Divider(),
//           Text(description),
//           SizedBox(height: 16),
//           Center(
//             child: ElevatedButton(
//               onPressed: onPressed,
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white, backgroundColor: Colors.pink, // text color
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(18.0),
//                 ),
//               ),
//               child: Text('Submit a Review'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ListTile(
//             contentPadding: EdgeInsets.zero,
//             title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text(subtitle),
//             trailing: Icon(Icons.favorite_border),
//           ),
//           SizedBox(height: 16),
//           Center(
//             child: Image.network(
//               imageUrl,
//               fit: BoxFit.cover,
//               width: MediaQuery.of(context).size.width * 0.6, // Adjust image width based on screen width
//             ),
//           ),
//           SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Column(
//                 children: [
//                   Text(
//                     "Similarity",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Row(
//                     children: [
//                       Icon(Icons.star, color: Colors.orange),
//                       Text("4.5 (44 reviews)"),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(width: 40),
//               Column(
//                 children: [
//                   Text(
//                     "Rating",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Row(
//                     children: [
//                       Icon(Icons.star, color: Colors.orange),
//                       Text("3.2 (23 reviews)"),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           Text(
//             "Summary",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           ),
//           Divider(),
//           Text(description),
//           SizedBox(height: 16),
//           Center(
//             child: ElevatedButton(
//               onPressed: onPressed,
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white, backgroundColor: Colors.pink, // text color
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(18.0),
//                 ),
//               ),
//               child: Text('Submit a Review'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
