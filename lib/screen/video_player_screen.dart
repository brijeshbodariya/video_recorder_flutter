import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String? path;

  const VideoPlayerScreen({Key? key, this.path}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? playerController;
  VoidCallback? listener;
  String? path;

  @override
  void initState() {
    super.initState();
    path = widget.path;
    listener = () {};
    initializeVideo();
    playerController!.play();
  }

  void initializeVideo() {
    playerController = VideoPlayerController.file(File(path!))
      ..addListener(listener!)
      ..setVolume(1.0)
      ..initialize()
      ..play();
  }

  @override
  void deactivate() {
    if (playerController != null) {
      playerController!.setVolume(0.0);
      playerController!.removeListener(listener!);
    }
    super.deactivate();
  }

  @override
  void dispose() {
    if (playerController != null) playerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Player')),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 9 / 16,
            child: Container(
              child: (playerController != null
                  ? VideoPlayer(playerController!)
                  : Container()),
            ),
          ),
        ],
      ),
    );
  }
}
