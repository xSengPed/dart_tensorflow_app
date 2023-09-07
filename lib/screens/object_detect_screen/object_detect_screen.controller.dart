import 'dart:async';
import 'package:camera/camera.dart';
import 'package:dart_tensor_flow_app/models/recognition.dart';
import 'package:dart_tensor_flow_app/models/screen_params.dart';
import 'package:dart_tensor_flow_app/services/detector_service.dart';
import 'package:flutter/material.dart';

class ObjectDectectScreenController extends ChangeNotifier {
  late BuildContext context;
  ObjectDectectScreenController(this.context);
  late List<CameraDescription> cameras;
  CameraController? _cameraController;
  get cameraController => _cameraController;
  Detector? _detector;
  StreamSubscription? _subscription;
  List<Recognition>? results;
  Map<String, String>? stats;

  init() {
    _initStateAsync();
  }

  void _initStateAsync() async {
    _initializeCamera();
    Detector.start().then((instance) {
      _detector = instance;
      _subscription = instance.resultsStream.stream.listen((values) {
        results = values['recognitions'];
        stats = values['stats'];
        notifyListeners();
      });
    });
  }

  void _initializeCamera() async {
    try {
      cameras = await availableCameras();

      if (cameras.length == 0) {
        throw Exception("Camera not found");
      }
      _cameraController = CameraController(
        cameras[0],
        ResolutionPreset.medium,
        enableAudio: false,
      )..initialize().then((_) async {
          await cameraController.startImageStream(onLatestImageAvailable);
          // notifyListeners();
          ScreenParams.previewSize = cameraController.value.previewSize!;
        });

      notifyListeners();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('${e.toString()}'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("Close"))
            ],
          );
        },
      );
    }
  }

  void onLatestImageAvailable(CameraImage cameraImage) async {
    _detector?.processFrame(cameraImage);
  }

  void destroy() {
    _cameraController?.dispose();
    _detector?.stop();
    _subscription?.cancel();
  }
}
