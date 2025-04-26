import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(AnimatedBallApp());
}

class AnimatedBallApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bouncing Ball',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BouncingBallScreen(),
    );
  }
}

class BouncingBallScreen extends StatefulWidget {
  @override
  _BouncingBallScreenState createState() => _BouncingBallScreenState();
}

class _BouncingBallScreenState extends State<BouncingBallScreen> {
  double x = 100;
  double y = 100;
  double dx = 2;
  double dy = 2;
  double speed = 1.0;
  Timer? timer;
  bool isAnimating = false;
  Color ballColor = Colors.red;

  void _startAnimation() {
    timer = Timer.periodic(Duration(milliseconds: (16 ~/ speed)), (timer) {
      setState(() {
        x += dx;
        y += dy;

        final size = MediaQuery.of(context).size;
        final ballSize = 50.0;

        if (x <= 0 || x + ballSize >= size.width) {
          dx = -dx;
        }
        if (y <= 0 || y + ballSize >= size.height - 200) {
          dy = -dy;
        }
      });
    });
  }

  void _stopAnimation() {
    timer?.cancel();
  }

  void _toggleAnimation() {
    setState(() {
      isAnimating = !isAnimating;
      if (isAnimating) {
        _startAnimation();
      } else {
        _stopAnimation();
      }
    });
  }

  void _updateSpeed(double value) {
    setState(() {
      speed = value;
      if (isAnimating) {
        _stopAnimation();
        _startAnimation();
      }
    });
  }

  void _changeColor(String color) {
    setState(() {
      switch (color) {
        case 'Red':
          ballColor = Colors.red;
          break;
        case 'Blue':
          ballColor = Colors.blue;
          break;
        case 'Green':
          ballColor = Colors.green;
          break;
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Free Bouncing Ball')),
      body: Stack(
        children: [
          Positioned(
            left: x,
            top: y,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: ballColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Slider(
                  value: speed,
                  min: 0.5,
                  max: 3.0,
                  divisions: 5,
                  label: speed.toStringAsFixed(1),
                  onChanged: _updateSpeed,
                ),
                DropdownButton<String>(
                  value: ballColor == Colors.red
                      ? 'Red'
                      : ballColor == Colors.blue
                          ? 'Blue'
                          : 'Green',
                  onChanged: (value) => _changeColor(value!),
                  items: ['Red', 'Blue', 'Green'].map((String color) {
                    return DropdownMenuItem<String>(
                      value: color,
                      child: Text(color),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: _toggleAnimation,
                  child: Text(isAnimating ? 'Stop' : 'Start'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          )
        ],
      ),
    );
  }
}
