import 'package:flutter/material.dart';
import 'dart:math';

class BallHScreen extends StatefulWidget {
  @override
  _BallHScreenState createState() => _BallHScreenState();
}

class _BallHScreenState extends State<BallHScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double y = 150;
  double dy = 5;
  final double ballSize = 50;
  final double wallPadding = 10;
  final double minY = 100; // The ball should not reach the top
  final List<Color> colors = [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple];
  int colorIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 30))
      ..addListener(() {
        setState(() {
          y += dy;
          if (y + ballSize >= MediaQuery.of(context).size.height - wallPadding || y <= minY) {
            dy = -dy;
            colorIndex = (colorIndex + 1) % colors.length;
          }
        });
      })
      ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Positioned(
              left: constraints.maxWidth / 2 - ballSize / 2,
              top: y,
              child: Container(
                width: ballSize,
                height: ballSize,
                decoration: BoxDecoration(
                  color: colors[colorIndex],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
