// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';


class BookAdaptationInfoTab extends StatefulWidget {
  const BookAdaptationInfoTab({super.key});


  @override
  State<BookAdaptationInfoTab> createState() => _BookAdaptationInfoTabState();
}

class _BookAdaptationInfoTabState extends State<BookAdaptationInfoTab> with TickerProviderStateMixin {

  // constructor
  @override
  Widget build(BuildContext context) {
    TabController _tabController = 
    TabController(length: 2, vsync: this);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(50),
        child: Container(
          child: Column(
          children: [
            // Text("Hello World!"),
            
            Container(
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text:"Book"),
                  Tab(text:"Adaptation"),
                ]),
            ),
            Container(
              width: double.maxFinite,
              height: 300,
              child: TabBarView(
                controller: _tabController,
                children: [
                  Text("Hi"),
                  Text("Hello"),
                ]
              ),
            ),
            
          ],
        ),
      )
    )
  );
    
  }
}