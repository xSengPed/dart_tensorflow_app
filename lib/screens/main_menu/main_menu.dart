import 'package:dart_tensor_flow_app/models/screen_params.dart';
import 'package:dart_tensor_flow_app/screens/image_classification_screen/image_classification_screen.dart';
import 'package:dart_tensor_flow_app/screens/object_detect_screen/object_detect_screen.dart';
import 'package:dart_tensor_flow_app/screens/text_prediction_page/text_prediction_page.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    ScreenParams.screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text("Main Menu")),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Flexible(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return TextPredictionPage();
                          },
                        ));
                      },
                      child: Text('Text Prediction')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ImageClassificationScreen();
                          },
                        ));
                      },
                      child: Text('Image Classification')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ObjectDetectScreen();
                          },
                        ));
                      },
                      child: Text('Object Detector')),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
