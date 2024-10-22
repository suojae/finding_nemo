import 'package:flutter/material.dart';
import 'dart:ui';
import 'flow_field.dart';
import 'signin_card.dart';
import 'signup_view.dart';

class SignInView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: SignInCard(
              onSignUpTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpView()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
