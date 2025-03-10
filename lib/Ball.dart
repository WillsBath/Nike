import 'package:flutter/material.dart';
import 'dart:math';

class BallScreen extends StatefulWidget {
  @override
  _BallScreenState createState() => _BallScreenState();
}

class _BallScreenState extends State<BallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double x = 50;
  double dx = 5;
  final double ballSize = 50;
  final double wallPadding = 10;
  final List<Color> colors = [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple];
  int colorIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 30))
      ..addListener(() {
        setState(() {
          x += dx;
          if (x + ballSize >= MediaQuery.of(context).size.width - wallPadding || x <= wallPadding) {
            dx = -dx;
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
              left: x,
              top: constraints.maxHeight / 2 - ballSize / 2,
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
