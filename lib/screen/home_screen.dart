import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_recorder_flutter/constant/constant.dart';
import 'package:video_recorder_flutter/screen/video_player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  String? videosPath;
  double headerHeight = 320.0;
  final String _assetPlayImagePath = 'assets/images/ic_play.png';
  final String _assetImagePath = 'assets/images/ic_no_video.png';

  String? thumbPath;

  String? videoName;

  _HomeScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        videosPath != null ? _getVideoContainer() : _getImageFromAsset(),
        _getCameraFab(),
        _getLogo(),
      ],
    ));
  }

  Widget _getImageFromAsset() {
    return ClipPath(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Container(
            width: double.infinity,
            height: headerHeight,
            color: Colors.grey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  _assetImagePath,
                  fit: BoxFit.fill,
                  width: 48.0,
                  height: 32.0,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'No Video Available',
                    style: TextStyle(
                      color: Colors.grey[350],
                      //fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _getVideoContainer() {
    return Container(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Container(
        width: double.infinity,
        height: headerHeight,
        color: Colors.grey,
        child: Stack(
          children: <Widget>[
            thumbPath != null
                ? Opacity(
                    opacity: 0.5,
                    child: Image.file(
                      File(thumbPath!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: headerHeight,
                    ),
                  )
                : Container(),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              VideoPlayerScreen(path: videosPath!)));
                    },
                    child: Image.asset(
                      _assetPlayImagePath,
                      width: 72.0,
                      height: 72.0,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      videoName != null ? videoName! : "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildPathWidget()
          ],
        ),
      ),
    );
  }

  Widget _buildPathWidget() {
    return videosPath != null
        ? Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 100.0,
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
              color: const Color.fromRGBO(00, 00, 00, 0.7),
              child: Center(
                child: Text(
                  videosPath!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        : Container();
  }

  Widget _getCameraFab() {
    return Positioned(
      top: headerHeight - 30.0,
      right: 16.0,
      child: FloatingActionButton(
        onPressed: _recordVideo,
        child: const Icon(
          Icons.videocam,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _getLogo() {
    return Container(
      margin: const EdgeInsets.only(top: 200.0),
      alignment: Alignment.center,
      child: Center(
        child: Image.asset(
          'assets/images/ic_flutter_devs_logo.png',
          width: 160.0,
          height: 160.0,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Future _recordVideo() async {
    final videoPath = await Navigator.of(context).pushNamed(cameraScreen);
    setState(() {
      videosPath = videoPath as String?;
    });
  }
}
