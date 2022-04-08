import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CameraHomeScreen extends StatefulWidget {
  final List<CameraDescription>? cameras;

  const CameraHomeScreen({Key? key, this.cameras}) : super(key: key);

  @override
  State<CameraHomeScreen> createState() => _CameraHomeScreenState();
}

class _CameraHomeScreenState extends State<CameraHomeScreen> {
  String? imagePath;
  bool _toggleCamera = false;
  bool _startRecording = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CameraController? controller;

  final String _assetVideoRecorder = 'assets/images/ic_video_shutter.png';
  final String _assetStopVideoRecorder = 'assets/images/ic_stop_video.png';

  String? videoPath;
  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;

  @override
  void initState() {
    try {
      onCameraSelected(widget.cameras![0]);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cameras!.isEmpty) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          'No Camera Found!',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      );
    }

    if (!controller!.value.isInitialized) {
      return Container();
    }

    return AspectRatio(
      key: _scaffoldKey,
      aspectRatio: controller!.value.aspectRatio,
      child: Stack(
        children: <Widget>[
          CameraPreview(controller!),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 120.0,
              padding: const EdgeInsets.all(20.0),
              color: const Color.fromRGBO(00, 00, 00, 0.7),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50.0)),
                        onTap: () {
                          !_startRecording
                              ? onVideoRecordButtonPressed()
                              : onStopButtonPressed();
                          setState(() {
                            _startRecording = !_startRecording;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            !_startRecording
                                ? _assetVideoRecorder
                                : _assetStopVideoRecorder,
                            width: 72.0,
                            height: 72.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  !_startRecording ? _getToggleCamera() : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getToggleCamera() {
    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
          onTap: () {
            !_toggleCamera
                ? onCameraSelected(widget.cameras![1])
                : onCameraSelected(widget.cameras![0]);
            setState(() {
              _toggleCamera = !_toggleCamera;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(
              'assets/images/ic_switch_camera_3.png',
              color: Colors.grey[200],
              width: 42.0,
              height: 42.0,
            ),
          ),
        ),
      ),
    );
  }

  void onCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) await controller!.dispose();
    controller = CameraController(cameraDescription, ResolutionPreset.medium);

    controller!.addListener(() {
      if (mounted) setState(() {});
      if (controller!.value.hasError) {
        showSnackBar('Camera Error: ${controller!.value.errorDescription}');
      }
    });

    try {
      await controller!.initialize();
    } on CameraException catch (e) {
      _showException(e);
    }

    if (mounted) setState(() {});
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void setCameraResult() {
    if (kDebugMode) {
      print("Recording Done! --> $videoPath");
    }
    Navigator.pop(context, videoPath);
  }

  void onVideoRecordButtonPressed() {
    if (kDebugMode) {
      print('onVideoRecordButtonPressed()');
    }
    startVideoRecording().then((value) {
      if (mounted) setState(() {});
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((XFile? file) {
      if (mounted) setState(() {});
      if (file != null) {
        showSnackBar('Video recorded to ${file.path}');
        videoPath = file.path;
        setCameraResult();
      }
    });
    // stopVideoRecording().then((_) {
    //   if (mounted) setState(() {});
    //   showSnackBar('Video recorded to: $videoPath');
    // });
  }

  Future<void> startVideoRecording() async {
    if (!controller!.value.isInitialized) {
      showSnackBar('Error: select a camera first.');
      return;
    }

    // final Directory extDir = await getApplicationDocumentsDirectory();
    // final String dirPath = '${extDir.path}/Videos';
    // await Directory(dirPath).create(recursive: true);
    // final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller!.value.isRecordingVideo) {
      return;
    }

    try {
      await controller!.startVideoRecording();
    } on CameraException catch (e) {
      _showException(e);
      return;
    }
  }

  Future<XFile?> stopVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      return null;
    }

    try {
      return controller!.stopVideoRecording();
    } on CameraException catch (e) {
      _showException(e);
      return null;
    }

    // setCameraResult();
  }

  void _showException(CameraException e) {
    logError(e.code, e.description!);
    showSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showSnackBar(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  void logError(String code, String message) =>
      log('Error: $code\nMessage: $message');
}
