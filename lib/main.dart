import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_recorder_flutter/constant/constant.dart';
import 'package:video_recorder_flutter/screen/camera_home_screen.dart';
import 'package:video_recorder_flutter/screen/home_screen.dart';
import 'package:video_recorder_flutter/screen/splash_screen.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    log('${e.code} ${e.description}');
  }

  runApp(
    MaterialApp(
      title: "Video Recorder App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      routes: <String, WidgetBuilder>{
        homeScreen: (BuildContext context) => const HomeScreen(),
        cameraScreen: (BuildContext context) =>
            CameraHomeScreen(cameras: cameras!),
      },
    ),
  );
}
