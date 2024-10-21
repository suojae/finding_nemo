import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: WaveAnimation(),
    ),
  ));
}

class WaveAnimation extends StatefulWidget {
  @override
  _WaveAnimationState createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<WaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<ui.Image> frames = [];
  int frameLen = 60;
  int frameIndex = 0;
  bool isFramesGenerated = false;

  final int width = 300;
  final int height = 300;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: frameLen * 16),
    )..addListener(() {
      setState(() {
        frameIndex = (_controller.value * frameLen).floor() % frameLen;
      });
    });

    _generateFrames();
  }

  Future<void> _generateFrames() async {
    final random = Random(70);
    final initPoints = List.generate(36, (_) {
      return Offset(random.nextDouble() * width, random.nextDouble() * height);
    });

    List<ui.Image> tempFrames = [];

    try {
      for (int f = 0; f < frameLen; f++) {
        final points = initPoints.map((point) {
          final angle = f * 360 / frameLen + 6 * point.dx;
          final pX = 50 * sin(_degToRad(angle)) + point.dx;
          final pY = 50 * cos(_degToRad(angle)) + point.dy;
          return Offset(pX, pY);
        }).toList();

        final pixels = Uint8List(width * height * 4);

        for (int x = 0; x < width; x++) {
          for (int y = 0; y < height; y++) {
            final distances = points.map((p) {
              final dx = x - p.dx;
              final dy = y - p.dy;
              return dx * dx + dy * dy;
            }).toList();

            distances.sort();
            final noise = sqrt(distances[0]);
            final index = (x + y * width) * 4;

            final r = _waveColor(noise, 40, 32, 2.2);
            final g = _waveColor(noise, 30, 55, 3.34);
            final b = _waveColor(noise, 30, 68, 3.55);

            pixels[index] = _clampColor(r);
            pixels[index + 1] = _clampColor(g);
            pixels[index + 2] = _clampColor(b);
            pixels[index + 3] = 255;
          }
        }

        ui.Image img = await _createImageFromPixels(pixels, width, height);
        tempFrames.add(img);

        if (f % 5 == 0) {
          await Future.delayed(Duration(milliseconds: 1));
        }

        print('Generating frame data: ${f + 1}/$frameLen');
      }

      setState(() {
        frames = tempFrames;
        isFramesGenerated = true;
      });

      _controller.repeat();
    } catch (e) {
      print('Error generating frames: $e');
      setState(() {
        frames = [];
        isFramesGenerated = false;
      });
    }
  }

  double _degToRad(double deg) {
    return deg * pi / 180;
  }

  int _clampColor(double value) {
    return value.clamp(0, 255).toInt();
  }

  double _waveColor(double x, double a, double b, double e) {
    if (x < 0) return b;
    return pow(x / a, e) + b;
  }

  Future<ui.Image> _createImageFromPixels(
      Uint8List pixels, int width, int height) async {
    final completer = Completer<ui.Image>();

    ui.decodeImageFromPixels(
      pixels,
      width,
      height,
      ui.PixelFormat.rgba8888,
          (ui.Image img) {
        completer.complete(img);
      },
    );

    return completer.future;
  }

  @override
  void dispose() {
    _controller.dispose();
    frames.forEach((image) {
      image.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isFramesGenerated
        ? CustomPaint(
      painter: WavePainter(frames, frameIndex),
      size: Size.infinite,
    )
        : Center(
      child: CircularProgressIndicator(),
    );
  }
}

class WavePainter extends CustomPainter {
  final List<ui.Image> frames;
  final int frameIndex;

  WavePainter(this.frames, this.frameIndex);

  @override
  void paint(Canvas canvas, Size size) {
    if (frames.isEmpty) return;

    final image = frames[frameIndex];
    final paint = Paint();

    final srcRect =
    Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dstRect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(image, srcRect, dstRect, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => true;
}
