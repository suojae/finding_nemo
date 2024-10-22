import 'package:flutter/material.dart';
import 'dart:ui';
import 'flow_field.dart';
import 'signup_card.dart';

class SignUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          FlowFieldScreen(),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.8, sigmaY: 2.8),
            child: Container(
              color: Colors.white.withOpacity(0.05),
            ),
          ),

          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: Container(),
            ),
          ),

          Center(
            child: SignUpCard(),
          ),
        ],
      ),
    );
  }
}
