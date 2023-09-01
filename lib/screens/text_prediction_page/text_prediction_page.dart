import 'package:dart_tensor_flow_app/screens/text_prediction_page/text_prediction_page.controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextPredictionPage extends StatefulWidget {
  const TextPredictionPage({super.key});

  @override
  State<TextPredictionPage> createState() => _TextPredictionPageState();
}

class _TextPredictionPageState extends State<TextPredictionPage> {
  late TextPredictionPageController controller;

  @override
  void initState() {
    controller = TextPredictionPageController(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => controller,
      child: Consumer<TextPredictionPageController>(
        builder: (context, con, child) {
          return Scaffold(
            appBar: AppBar(title: Text("Text Prediction")),
            body: Column(
              children: [
                Flexible(
                    child: ListView.builder(
                  itemCount: con.predictResults.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      child: con.predictResults[index].text.isNotEmpty
                          ? Card(
                              color: con.predictResults[index].positive >
                                      con.predictResults[index].negative
                                  ? Colors.green
                                  : Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 32),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Input : ${con.predictResults[index].text}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    Text(
                                      "Positive : ${con.predictResults[index].positive}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    Text(
                                      "Negative : ${con.predictResults[index].negative}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    );
                  },
                )),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  height: 50,
                  // color: Colors.blue,
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: con.wordCtrl,
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      GestureDetector(
                        child: Icon(Icons.send),
                        onTap: () {
                          con.predict();
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
