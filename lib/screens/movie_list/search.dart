import 'package:cinemax/common_widgets/movie_list_card_cell.dart';
import 'package:cinemax/data/movie/movie.dart';
import 'package:cinemax/screens/movie_detail/movie_detail_screen.dart';
import 'package:cinemax/services/movie/movie_services.dart';
import 'package:cinemax/util/utility_helper.dart';
import 'package:flutter/material.dart';

class SearchMovie extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchMovieState();
  }
}

class SearchMovieState extends State<SearchMovie> {
  List<Movie>? searchResult;
  int? currentPage;
  int? totalPage;
  String? searchText;

  _getMovieList(int pageNo) async {
    await MovieServices()
        .fetchSearchListFromText(searchText ?? '', pageNo)
        .then((movies) {
      setState(() {
        if (pageNo > 1) {
          List<Movie> newList = List.from(searchResult ?? [])
            ..addAll(movies.results ?? []);
          searchResult = newList;
        } else {
          totalPage = movies.totalPages;
          searchResult = movies.results;
        }
        //getSortedListWithType(list.results, sortType);
      });
    }).catchError((onError) {});
  }

  @override
  void initState() {
    currentPage = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new TextField(
          // controller: _filter,
          decoration: new InputDecoration(hintText: 'Search movies'),
          onChanged: (String value) {
            setState(() {
              searchText = value;
              currentPage = 1;
              _getMovieList(currentPage ?? 0);
            });
          },
        ),
      ),
      body: searchResult == null
          ? Center(
              child: Text('Your Search Result'),
            )
          : _getBuidComponent(),
    );
  }

  void _cardDidTap(Movie movie, int index, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return MovieDetailScreen(
        movie: movie,
      );
    }));
  }

  Widget _getBuidComponent() {
    Widget component = Container();

    if (searchResult == null) {
      component = loadingIndicator();
    } else if (searchResult?.length == 0) {
      component = Center(
        child: Text('No Data Available'),
      );
    } else {
      int rowCount = 0;
      if ((searchResult?.length ?? 0) % 2 == 0) {
        rowCount = (searchResult?.length ?? 0) ~/ 2;
      } else {
        rowCount = (searchResult?.length ?? 0) ~/ 2 + 1;
      }
      component = Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: rowCount,
          itemBuilder: (context, index) {
            if (index == rowCount - 1 &&
                ((currentPage ?? 0) < (totalPage ?? 0))) {
              currentPage = (currentPage ?? 0) + 1;
              _getMovieList(currentPage ?? 0);
              return loadingIndicator();
            } else {
              return CardListCell.buildCardCell(
                  index, context, searchResult ?? [], _cardDidTap);
            }
          },
        ),
      );
    }
    return component;
  }
}
