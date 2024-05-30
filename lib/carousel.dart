import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Carousel extends StatelessWidget {
  const Carousel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var carouselOptions = CarouselOptions(
      height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
      aspectRatio: 16 / 9,
      viewportFraction: 0.9,
      initialPage: 0,
      enableInfiniteScroll: true,
      reverse: false,
      autoPlay: true,
      autoPlayInterval: const Duration(seconds: 3),
      autoPlayAnimationDuration: const Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      enlargeCenterPage: true,
      scrollDirection: Axis.horizontal,
    );
    return SizedBox(
      width: size.width,
      height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
      child: CarouselSlider.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          return GestureDetector(
              child: Column(
            children: [
              Image.network(
                  'https://i0.wp.com/www.sciencenews.org/wp-content/uploads/2024/02/022924_ts_dune_feat.jpg?fit=1030%2C580&ssl=1'),
              const SizedBox(
                height: 20,
              ),
              Text("Dune", style: TextStyle(fontWeight: FontWeight.w600))
            ],
          ));
        },
        options: carouselOptions,
      ),
    );
  }
}
