import 'package:cinemax/data/movie/credits.dart';
import 'package:cinemax/services/movie/movie_services.dart';
import 'package:cinemax/util/constant.dart';
import 'package:cinemax/util/url_constant.dart';
import 'package:cinemax/util/utility_helper.dart';
import 'package:flutter/material.dart';

class CastCrewList extends StatefulWidget {
  final Credits credits;

  const CastCrewList(this.credits);

  @override
  State<StatefulWidget> createState() {
    return CastCrewListState();
  }
}

class CastCrewListState extends State<CastCrewList> {
  late Widget baseComponent;

  @override
  void initState() {
    if (widget.credits.cast == null) {
      baseComponent = noRecordContainer();
      // _getCredits(widget.movieId);
    } else {
      baseComponent = buildBaseComponet();
    }
    super.initState();
  }

  Widget noRecordContainer() {
    return Center(
      child: Text('No Record found', style: titleStyle),
    );
  }

  Widget buildBaseComponet() {
    return Container(
        child: ListView.builder(
      itemCount: (widget.credits.cast?.length ?? 0) +
          (widget.credits.crew?.length ?? 0),
      itemBuilder: (context, index) {
        if (index < (widget.credits.cast?.length ?? 0)) {
          return buildCastCard(context, widget.credits.cast?[index]);
        } else {
          return buildCrewCard(context,
              widget.credits.crew?[index - (widget.credits.cast?.length ?? 0)]);
        }
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: baseComponent);
  }
}

Widget buildCastCard(BuildContext context, Cast? cast) {
  String character = cast?.character ?? '';
  character = character.split('\/').first;
  String imageUrl = '${kPosterImageBaseUrl}w500/${cast?.profilePath}';
  String name = cast?.name ?? '';
  return getCard(imageUrl, name, character);
}

Widget buildCrewCard(BuildContext context, Crew? crew) {
  String character = crew?.job ?? '';
  character = character.split('\/').first;
  String imageUrl = '${kPosterImageBaseUrl}w500/${crew?.profilePath}';
  String name = crew?.name ?? '';
  return getCard(imageUrl, name, character);
}

Widget getCard(String imageUrl, String name, String character) {
  return Container(
    height: 120,
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.black26,
      shape: BoxShape.rectangle,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
            radius: 50,
            backgroundColor: appTheme.primaryColor,
            backgroundImage: NetworkImage(
              imageUrl,
            )),
        SizedBox(
          width: 16,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              child: Text(
                '$name',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 200,
              child: Text(
                'Role: $character',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.normal,
                ),
                maxLines: 2,
              ),
            ),
          ],
        )
      ],
    ),
  );
}
