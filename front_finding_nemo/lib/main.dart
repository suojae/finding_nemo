import 'package:flutter/material.dart';
import 'main_view.dart'; // Import the MainView

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      home: MainView(),
    );
  }
}
