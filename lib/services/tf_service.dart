import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

class TfService {
  static late tfl.Interpreter _interpreter;
  static late Map<String, int> _dict;

  final int _sentenceLen = 256;
  final String start = '<START>';
  final String pad = '<PAD>';
  final String unk = '<UNKNOWN>';

  static void initialize() async {
    log("Initialize Service");
    try {
      _loadModel();
      _loadDict();
    } catch (e) {
      log(e.toString());
    }
  }

  static void _loadModel() async {
    log("Load Model");
    final options = tfl.InterpreterOptions();
    if (true == Platform.isAndroid) {
      options.addDelegate(tfl.XNNPackDelegate());
    }

    if (true == Platform.isIOS) {
      options.addDelegate(tfl.GpuDelegate());
    }
    try {
      _interpreter = await tfl.Interpreter.fromAsset(
          "assets/text_classification.tflite",
          options: options);
      log("Interpreter loading success!");
    } catch (e) {
      log(e.toString());
    }
  }

  static void _loadDict() async {
    log("Load Dict");
    final String vocab = await rootBundle.loadString("assets/vocab.txt");
    Map<String, int> dict = {};
    final vocabList = vocab.split('\n');
    for (var i = 0; i < vocabList.length; i++) {
      var entry = vocabList[i].trim().split(' ');
      if (entry.length == 2) {
        dict[entry[0]] = int.parse(entry[1]);
      } else if (entry.length == 1) {
        entry.insert(0, 'bad_char');
      }
    }
    _dict = dict;
    print('Dictionary loaded successfully');
  }

  List<double> classify(String rawText) {
    // tokenizeInputText returns List<List<double>>
    // of shape [1, 256].
    List<List<double>> input = tokenizeInputText(rawText);

    // output of shape [1,2].
    var output = List<double>.filled(2, 0).reshape([1, 2]);

    // The run method will run inference and
    // store the resulting values in output.
    _interpreter.run(input, output);

    return [output[0][0], output[0][1]];
  }

  List<List<double>> tokenizeInputText(String text) {
    // Whitespace tokenization
    final toks = text.split(' ');

    // Create a list of length==_sentenceLen filled with the value <pad>
    var vec = List<double>.filled(_sentenceLen, _dict[pad]!.toDouble());

    var index = 0;
    if (_dict.containsKey(start)) {
      vec[index++] = _dict[start]!.toDouble();
    }

    // For each word in sentence find corresponding index in dict
    for (var tok in toks) {
      if (index > _sentenceLen) {
        break;
      }
      vec[index++] = _dict.containsKey(tok)
          ? _dict[tok]!.toDouble()
          : _dict[unk]!.toDouble();
    }

    // returning List<List<double>> as our interpreter input tensor expects the shape, [1,256]
    return [vec];
  }
}
