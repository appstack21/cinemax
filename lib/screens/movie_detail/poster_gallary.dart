import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cinemax/data/image/images.dart';
import 'package:cinemax/util/constant.dart';
import 'package:cinemax/util/url_constant.dart';
import 'package:cinemax/util/utility_helper.dart';
import 'package:flutter/material.dart';

class PosterGallery extends StatelessWidget {
  final List<Poster> posters;

  const PosterGallery({Key? key, required this.posters}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gallery',
          style: titleStyle,
        ),
      ),
      body: Center(
        child: Container(
          // width: MediaQuery.of(context).size.width,
          // height:MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10),
          // decoration: BoxDecoration(border: Border.all(width: 1.0), borderRadius: BorderRadius.all(Radius.circular(10))),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            child: CarouselSlider(
              options: CarouselOptions(
                scrollDirection: Axis.horizontal,
                aspectRatio: 9 / 16,
                viewportFraction: 1.0,
                initialPage: 0,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                pauseAutoPlayOnTouch: true,
                enlargeCenterPage: true,
                autoPlay: true,
              ),

              // height:MediaQuery.of(context).size.height ,

              items: pageViewList(posters, context),
              //pageViewList(trendingList, context)
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget> pageViewList(List<Poster> posters, BuildContext context) {
  var list = posters.map((poster) {
    return buildPageViewContent(context, poster.filePath ?? '');
  }).toList();
  return list;
}

Widget buildPageViewContent(BuildContext context, String filePath) {
  return Container(
    child: getNeworkImages('${kPosterImageBaseUrl}w780$filePath'),
  );
}

Widget getNeworkImages(String imagePath) {
  print(imagePath);
  return CachedNetworkImage(
    imageUrl: imagePath,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    ),
    placeholder: (context, url) => loadingIndicator(),
    errorWidget: (context, url, error) => Image.asset(
      'assets/images/placeholder.jpg',
      fit: BoxFit.cover,
    ),
  );
}
