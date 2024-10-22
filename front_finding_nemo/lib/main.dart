import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signin_page/signin_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sessac Aquarium',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.neuchaTextTheme(),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      home: SignInView(),
    );
  }
}
