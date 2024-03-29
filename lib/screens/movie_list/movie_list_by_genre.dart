import 'package:cinemax/common_widgets/custom_transition.dart';
import 'package:cinemax/common_widgets/movie_list_card_cell.dart';
import 'package:cinemax/data/genres.dart';
import 'package:cinemax/data/movie/movie.dart';
import 'package:cinemax/screens/home/base_home_screen.dart';
import 'package:cinemax/screens/movie_detail/movie_detail_screen.dart';
import 'package:cinemax/services/movie/movie_services.dart';
import 'package:cinemax/util/constant.dart';
import 'package:cinemax/util/utility_helper.dart';
import 'package:flutter/material.dart';

class GenreMovieListScreen extends StatefulWidget {
  final Genre? genre;
  final bool isFromDetail;

  const GenreMovieListScreen({Key? key, this.genre, required this.isFromDetail})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GenreMovieListScreenState();
  }
}

class GenreMovieListScreenState extends State<GenreMovieListScreen> {
  List<Movie>? movieList;
  late int currentPage;
  int totalPage = 0;
  @override
  void initState() {
    currentPage = 1;
    if (widget.genre != null && widget.genre?.id != null) {
      _getMovieList(widget.genre!.id!, currentPage);
    }
    super.initState();
  }

  _getMovieList(int genreId, int pageNo) async {
    await MovieServices().getMovieListByGenre(genreId, pageNo).then((movies) {
      setState(() {
        currentPage = currentPage + 1;
        if (movieList != null) {
          List<Movie> newList = List.from(movieList ?? [])
            ..addAll(movies.results ?? []);
          movieList = newList;
        } else {
          totalPage = movies.totalPages ?? 0;
          movieList = movies.results;
        }
      });
    }).catchError((onError) {
      setState(() {
        movieList = [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = '';
    if (widget.genre != null) {
      title = widget.genre?.name ?? '';
    }
    return widget.isFromDetail
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                title,
                style: titleStyle,
              ),
            ),
            body: _getBuidComponent(),
          )
        : BaseHomeScreen(
            appBar: AppBar(
              title: Text(
                title,
                style: titleStyle,
              ),
            ),
            body: _getBuidComponent(),
          );
  }

  void _cardDidTap(Movie movie, int index, BuildContext context) {
    Navigator.push(context, ScaleRoute(page: MovieDetailScreen(movie: movie)));
  }

  Widget _getBuidComponent() {
    Widget component = Container();
    if (movieList == null) {
      component = loadingIndicator();
    } else if (movieList?.length == 0) {
      component = Center(
        child: Text('No Data Available'),
      );
    } else {
      print('Movie Lenght ${movieList?.length ?? 0}');
      int rowCount = 0;
      if ((movieList?.length ?? 0) % 2 == 0) {
        rowCount = (movieList?.length ?? 0) ~/ 2;
      } else {
        rowCount = (movieList?.length ?? 0) ~/ 2 + 1;
      }
      component = Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: rowCount,
          itemBuilder: (context, index) {
            if (index == rowCount - 1 && currentPage < totalPage) {
              if (widget.genre != null && widget.genre?.id != null) {
                _getMovieList(widget.genre!.id!, currentPage);
                return loadingIndicator();
              } else {
                return CardListCell.buildCardCell(
                    index, context, movieList ?? [], _cardDidTap);
              }
            } else {
              return CardListCell.buildCardCell(
                  index, context, movieList ?? [], _cardDidTap);
            }
          },
        ),
      );
    }
    return component;
  }
}
