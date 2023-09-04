import 'package:camera/camera.dart';
import 'package:dart_tensor_flow_app/components/box_widget.dart';
import 'package:dart_tensor_flow_app/components/stats_widget.dart';
import 'package:dart_tensor_flow_app/screens/object_detect_screen/object_detect_screen.controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ObjectDetectScreen extends StatefulWidget {
  const ObjectDetectScreen({super.key});

  @override
  State<ObjectDetectScreen> createState() => _ObjectDetectScreenState();
}

class _ObjectDetectScreenState extends State<ObjectDetectScreen>
    with WidgetsBindingObserver {
  late ObjectDectectScreenController controller =
      ObjectDectectScreenController(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller.init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.destroy();
    super.dispose();
  }

  Widget _boundingBoxes() {
    if (controller.results == null) {
      return const SizedBox.shrink();
    }
    return Stack(
        children:
            controller.results!.map((box) => BoxWidget(result: box)).toList());
  }

  Widget _statsWidget() => (controller.stats != null)
      ? Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white.withAlpha(150),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: controller.stats!.entries
                    .map((e) => StatsWidget(e.key, e.value))
                    .toList(),
              ),
            ),
          ),
        )
      : const SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => controller,
      child: Consumer<ObjectDectectScreenController>(
        builder: (context, con, child) {
          return Scaffold(
            body: SafeArea(
              child: con.cameraController == null
                  ? Center(child: CircularProgressIndicator())
                  : Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: CameraPreview(con.cameraController),
                        ),
                        _statsWidget(),
                        AspectRatio(
                          aspectRatio: 1,
                          child: _boundingBoxes(),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
