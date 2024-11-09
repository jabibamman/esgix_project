import 'package:flutter/material.dart';

import 'core/app_config.dart';
import 'layout/layouts.dart';

void main() async {
  await AppConfig.loadEnv();
  runApp(const EsgiXApp());
}

class EsgiXApp extends StatelessWidget {
  const EsgiXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
          displayMedium: TextStyle(
            fontSize: 24,
            color: Colors.orange,
          ),
        ),
      ),
      home: const Layouts(),
    );
  }
}
