import 'package:dart_tensor_flow_app/models/text_prediction.model.dart';
import 'package:dart_tensor_flow_app/services/tf_service.dart';
import 'package:flutter/material.dart';

class TextPredictionPageController extends ChangeNotifier {
  BuildContext context;
  TextPredictionPageController(this.context);

  TextEditingController wordCtrl = TextEditingController();
  TextPredictModel predictResult = TextPredictModel(text: "");

  List<TextPredictModel> predictResults = [];

  void predict() {
    final List<double> response = TfService().classify(wordCtrl.text);
    predictResult = TextPredictModel(
        text: wordCtrl.text, negative: response[0], positive: response[1]);

    if (predictResults.length >= 3) {
      predictResults.clear();
    }
    predictResults.add(predictResult);
    notifyListeners();
  }

  void clearResults() {
    predictResults.clear();
    notifyListeners();
  }
}
