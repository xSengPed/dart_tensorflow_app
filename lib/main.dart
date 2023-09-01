import 'package:dart_tensor_flow_app/screens/splash_screen/splash_screen.dart';
import 'package:dart_tensor_flow_app/services/tf_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      home: SplahScreen(),
    );
  }
}
