import 'dart:io';

import 'package:dart_tensor_flow_app/utils/image_classification_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class ImageClassificationScreenController extends ChangeNotifier {
  late BuildContext context;
  ImageClassificationHelper? imageClassificationHelper;
  final imagePicker = ImagePicker();
  String? imagePath;
  img.Image? image;
  Map<String, double>? classification;

  ImageClassificationScreenController(this.context);

  void init() {
    imageClassificationHelper = ImageClassificationHelper();
    imageClassificationHelper!.initHelper();
  }

  @override
  void dispose() {
    imageClassificationHelper?.close();
    super.dispose();
  }

  void cleanResult() {
    imagePath = null;
    image = null;
    classification = null;
    notifyListeners();
  }

  Future<void> processImage() async {
    if (imagePath != null) {
      final imageData = File(imagePath!).readAsBytesSync();
      image = img.decodeImage(imageData);
      // notifyListeners();
      classification = await imageClassificationHelper?.inferenceImage(image!);
      notifyListeners();
    }
  }
}
