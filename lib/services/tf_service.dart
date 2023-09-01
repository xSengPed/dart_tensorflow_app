import 'dart:developer';

import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

class TfService {
  static void initialize() async {
    try {
      final tfl.Interpreter interpreter =
          await tfl.Interpreter.fromAsset("assets/text_classification.tflite");
      log("OK!");
    } catch (e) {
      log(e.toString());
    }
  }
}
