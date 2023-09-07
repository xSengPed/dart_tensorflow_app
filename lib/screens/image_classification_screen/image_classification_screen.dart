import 'dart:io';
import 'package:dart_tensor_flow_app/screens/image_classification_screen/image_classification_screen.controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageClassificationScreen extends StatefulWidget {
  const ImageClassificationScreen({super.key});

  @override
  State<ImageClassificationScreen> createState() =>
      _ImageClassificationScreen();
}

class _ImageClassificationScreen extends State<ImageClassificationScreen> {
  late ImageClassificationScreenController controller =
      ImageClassificationScreenController(context);

  @override
  void initState() {
    controller.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImageClassificationScreenController>(
      create: (context) => controller,
      child: Consumer<ImageClassificationScreenController>(
          builder: (context, con, child) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        con.cleanResult();
                        final result = await con.imagePicker.pickImage(
                          source: ImageSource.camera,
                        );

                        con.imagePath = result?.path;
                        setState(() {});
                        con.processImage();
                      },
                      icon: const Icon(
                        Icons.camera,
                        size: 48,
                      ),
                      label: const Text("Take a photo"),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        con.cleanResult();
                        final result = await con.imagePicker.pickImage(
                          source: ImageSource.gallery,
                        );

                        con.imagePath = result?.path;

                        con.processImage();
                      },
                      icon: const Icon(
                        Icons.photo,
                        size: 48,
                      ),
                      label: const Text("Pick from gallery"),
                    ),
                  ],
                ),
                const Divider(color: Colors.black),
                Expanded(
                    child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (con.imagePath != null) Image.file(File(con.imagePath!)),
                    if (con.image == null)
                      const Text(
                          "Take a photo or choose one from the gallery to "
                          "inference."),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(),
                        if (con.image != null) ...[
                          if (con.imageClassificationHelper?.inputTensor !=
                              null)
                            Text(
                              'Input: (shape: ${con.imageClassificationHelper?.inputTensor.shape} type: '
                              '${con.imageClassificationHelper?.inputTensor.type})',
                            ),
                          if (con.imageClassificationHelper?.outputTensor !=
                              null)
                            Text(
                              'Output: (shape: ${con.imageClassificationHelper?.outputTensor.shape} '
                              'type: ${con.imageClassificationHelper?.outputTensor.type})',
                            ),
                          const SizedBox(height: 8),
                          Text('Num channels: ${con.image?.numChannels}'),
                          Text(
                              'Bits per channel: ${con.image?.bitsPerChannel}'),
                          Text('Height: ${con.image?.height}'),
                          Text('Width: ${con.image?.width}'),
                        ],
                        const Spacer(),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              if (con.classification != null)
                                ...(con.classification!.entries.toList()
                                      ..sort(
                                        (a, b) => a.value.compareTo(b.value),
                                      ))
                                    .reversed
                                    .take(3)
                                    .map(
                                      (e) => Container(
                                        padding: const EdgeInsets.all(8),
                                        color: Colors.white,
                                        child: Row(
                                          children: [
                                            Text(e.key),
                                            const Spacer(),
                                            Text(e.value.toStringAsFixed(2))
                                          ],
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
              ],
            ),
          ),
        );
      }),
    );
  }
}
