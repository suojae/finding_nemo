import 'dart:math';
import 'package:flutter/material.dart';

final class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlowFieldScreen(),
    );
  }
}

class FlowFieldApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlowFieldScreen(),
    );
  }
}

class FlowFieldScreen extends StatefulWidget {
  @override
  _FlowFieldScreenState createState() => _FlowFieldScreenState();
}

class _FlowFieldScreenState extends State<FlowFieldScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> particles = [];
  final int particleCount = 2000;
  double scl = 20;
  int cols = 0, rows = 0;
  List<Offset> flowfield = [];
  bool paused = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: Duration(seconds: 60))
      ..addListener(() {
        if (!paused) {
          setState(() {});
        }
      })
      ..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;

      cols = (screenSize.width / scl).floor();
      rows = (screenSize.height / scl).floor();

      particles = List.generate(particleCount, (_) => Particle(screenSize));

      flowfield = List.generate(cols * rows, (_) => Offset.zero);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8EBFF), // Background color
      body: GestureDetector(
        onTap: () {
          setState(() {
            paused = !paused;
          });
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: OceanFlowPainter(particles, flowfield, cols, rows, scl),
        ),
      ),
    );
  }
}

class OceanFlowPainter extends CustomPainter {
  final List<Particle> particles;
  final List<Offset> flowfield;
  final int cols;
  final int rows;
  final double scl;

  OceanFlowPainter(this.particles, this.flowfield, this.cols, this.rows, this.scl);

  @override
  void paint(Canvas canvas, Size size) {
    if (cols == 0 || rows == 0) return;

    Offset constantDirection = Offset(0.5, 0.2); // Particle direction control

    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        int index = x + y * cols;
        flowfield[index] = constantDirection;
      }
    }

    for (var particle in particles) {
      particle.follow(flowfield, cols, rows, scl);
      particle.update();
      particle.edges(size);
      particle.show(canvas);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

final class Particle {
  Offset pos;
  Offset vel;
  Offset acc;
  double maxSpeed;
  Color color;

  Particle(Size screenSize)
      : pos = Offset(Random().nextDouble() * screenSize.width, Random().nextDouble() * screenSize.height),
        vel = Offset.zero,
        acc = Offset.zero,
        maxSpeed = Random().nextDouble() * 1.5,
        // Speed control
        color = _randomOceanColor();

  static Color _randomOceanColor() {
    double hue = Random().nextDouble() * 60 + 180;
    return HSVColor.fromAHSV(0.9, hue, 0.8, 1.0).toColor();
  }

  void follow(List<Offset> flowfield, int cols, int rows, double scl) {
    int x = (pos.dx / scl).floor();
    int y = (pos.dy / scl).floor();

    if (x >= cols) x = cols - 1;
    if (y >= rows) y = rows - 1;
    if (x < 0) x = 0;
    if (y < 0) y = 0;

    int index = x + y * cols;

    if (index < 0 || index >= flowfield.length) return;

    Offset force = flowfield[index];
    applyForce(force);
  }

  void applyForce(Offset force) {
    acc = acc.translate(force.dx, force.dy);
  }

  void update() {
    vel = vel.translate(acc.dx, acc.dy);
    vel = Offset(
      vel.dx.clamp(-maxSpeed, maxSpeed),
      vel.dy.clamp(-maxSpeed, maxSpeed),
    );
    pos = pos.translate(vel.dx, vel.dy);
    acc = Offset.zero;
  }

  void edges(Size size) {
    if (pos.dx > size.width) pos = Offset(0, pos.dy);
    if (pos.dx < 0) pos = Offset(size.width, pos.dy);
    if (pos.dy > size.height) pos = Offset(pos.dx, 0);
    if (pos.dy < 0) pos = Offset(pos.dx, size.height);
  }

  void show(Canvas canvas) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;

    canvas.drawCircle(pos, 3, paint);
  }
}
