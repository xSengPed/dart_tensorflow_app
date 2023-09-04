// import 'package:dart_tensor_flow_app/models/screen_params.dart';
import 'package:dart_tensor_flow_app/models/screen_params.dart';
import 'package:dart_tensor_flow_app/screens/main_menu/main_menu.dart';
import 'package:dart_tensor_flow_app/services/tf_service.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  TfService.initialize();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainMenu(),
    );
  }
}
