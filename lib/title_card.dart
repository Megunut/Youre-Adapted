import 'package:flutter/material.dart';

class TitleCard extends StatelessWidget {
  final String listTitle;
  const TitleCard({
    super.key,
    required this.listTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsetsDirectional.only(start: 4.0),
            child: Text(listTitle,
                style: const TextStyle(fontWeight: FontWeight.w600))),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Image.network(
                        'https://cdn.kobo.com/book-images/2bd0e164-5c02-4e40-a43a-17d2fd5451b7/1200/1200/False/dune-2.jpg',
                      )),
                );
              }),
        )
      ],
    );
  }
}
