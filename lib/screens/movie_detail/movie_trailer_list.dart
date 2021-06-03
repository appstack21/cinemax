import 'dart:io';

import 'package:cinemax/data/video/video.dart';
import 'package:cinemax/services/movie/movie_services.dart';
import 'package:cinemax/util/constant.dart';
import 'package:cinemax/util/utility_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeDefaultWidget extends StatefulWidget {
  final int movieId;
  const YoutubeDefaultWidget(this.movieId);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<YoutubeDefaultWidget> {
  List<Video>? videoList;
  YoutubePlayerController? _controller;
  APIStatus? status;

  @override
  void initState() {
    status = APIStatus.InProcess;
    _getVideoList(widget.movieId);
    super.initState();
  }

  void listener() {}

  @override
  void deactivate() {
    if (_controller != null) {
      _controller?.pause();
    }

    super.deactivate();
  }

  Widget noRecordContainer() {
    return Center(
      child: Text('No Record found', style: titleStyle),
    );
  }

  _getVideoList(int movieId) async {
    await MovieServices().fetchVideoList(movieId).then((videos) {
      setState(() {
        status = APIStatus.Success;
        videoList = videos.results;
        _controller = YoutubePlayerController(
          initialVideoId: videoList?[0].key ?? '',
          flags: const YoutubePlayerFlags(
            mute: false,
            autoPlay: true,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: true,
          ),
        )..addListener(listener);
      });
    }).catchError((onError) {
      setState(() {
        status = APIStatus.Failed;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.arrow_back;
    if (Platform.isAndroid) {
      // Android-specific code
    } else if (Platform.isIOS) {
      icon = Icons.arrow_back_ios;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Video', style: titleStyle),
          leading: IconButton(
              onPressed: () {
                SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]).then((_) {
                  Navigator.pop(context);
                });
              },
              icon: Icon(icon)),
        ),
        body: status == APIStatus.InProcess
            ? loadingIndicator()
            : (status == APIStatus.Failed
                ? noRecordContainer()
                : Stack(
                    children: <Widget>[
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        child: _controller != null
                            ? YoutubePlayer(
                                controller: _controller!,
                                showVideoProgressIndicator: true,
                                progressColors: ProgressBarColors(
                                  playedColor: Colors.amber,
                                  handleColor: Colors.amberAccent,
                                ),
                                progressIndicatorColor: Colors.amber,
                                onReady: () {
                                  _controller?.addListener(listener);
                                },
                                onEnded: (data) {
                                  _controller?.play();
                                },
                              )
                            : Container(),
                      ),
                    ],
                  )));
  }

  @override
  void onCurrentSecond(double second) {
    print("onCurrentSecond second = $second");
    // _currentVideoSecond = second;
  }

  @override
  void onError(String error) {
    print("onError error = $error");
  }

  @override
  void onReady() {
    // _controller.pause();
    print("onReady");
  }

  @override
  void onStateChange(String state) {
    print("onStateChange state = $state");
  }

  @override
  void onVideoDuration(double duration) {
    print("onVideoDuration duration = $duration");
  }
}
