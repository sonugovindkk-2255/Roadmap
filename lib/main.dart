import 'package:flutter/material.dart';
import 'package:project_2/Progress.dart';
import 'package:project_2/pro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(),
    home: Roadmap(),);
  }
}
