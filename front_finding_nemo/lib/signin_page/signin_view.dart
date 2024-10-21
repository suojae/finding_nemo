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

          // Blurred backdrop
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.8, sigmaY: 2.8),
            child: Container(
              color: Colors.white.withOpacity(0.05),
            ),
          ),

          Positioned.fill(
            child: IgnorePointer(
              ignoring: true, // Disable touch events for everything outside FrostedCard
              child: Container(),
            ),
          ),

          Center(
            child: FrostedCard(), // Touch events inside FrostedCard are allowed
          ),
        ],
      ),
    );
  }
}
