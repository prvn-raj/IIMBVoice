import 'package:flutter/material.dart';
import 'radio_page.dart'; // Import the RadioPage from radiopage.dart

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Radio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RadioPage(), // Use the RadioPage from radiopage.dart
    );
  }
}
