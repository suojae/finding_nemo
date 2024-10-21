import 'package:flutter/material.dart';
import 'dart:ui';
import 'flow_field.dart';
import 'frosted_card.dart';

final class MainView extends StatelessWidget {
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
          Center(
            child: FrostedCard(),
          ),
        ],
      ),
    );
  }
}
