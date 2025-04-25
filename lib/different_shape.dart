import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(DrawShapeApp());

class DrawShapeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DrawShapePage(),
    );
  }
}

class DrawShapePage extends StatefulWidget {
  @override
  _DrawShapePageState createState() => _DrawShapePageState();
}

class _DrawShapePageState extends State<DrawShapePage> {
  Offset? startPoint;
  Offset? currentPoint;
  ShapeType _selectedShape = ShapeType.circle; // Default shape

  // For storing drawn shapes
  List<Shape> shapes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Draw Shapes'),
        actions: [
          PopupMenuButton<ShapeType>(
            onSelected: (ShapeType result) {
              setState(() {
                _selectedShape = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<ShapeType>>[
              const PopupMenuItem<ShapeType>(
                value: ShapeType.circle,
                child: Text('Circle'),
              ),
              const PopupMenuItem<ShapeType>(
                value: ShapeType.square,
                child: Text('Square'),
              ),
              const PopupMenuItem<ShapeType>(
                value: ShapeType.rectangle,
                child: Text('Rectangle'),
              ),
              const PopupMenuItem<ShapeType>(
                value: ShapeType.triangle,
                child: Text('Triangle'),
              ),
            ],
          ),
        ],
      ),
      body: GestureDetector(
        onPanStart: (details) {
          setState(() {
            startPoint = details.localPosition;
            currentPoint = startPoint;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            currentPoint = details.localPosition;
          });
        },
        onPanEnd: (_) {
          if (startPoint != null && currentPoint != null) {
            setState(() {
              shapes.add(Shape(
                type: _selectedShape,
                startPoint: startPoint!,
                endPoint: currentPoint!,
              ));
              startPoint = null;
              currentPoint = null;
            });
          }
        },
        child: CustomPaint(
          painter: ShapePainter(shapes),
          child: Container(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => shapes.clear()),
        child: Icon(Icons.clear),
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  final List<Shape> shapes;

  ShapePainter(this.shapes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (final shape in shapes) {
      switch (shape.type) {
        case ShapeType.circle:
          final radius = (shape.endPoint - shape.startPoint).distance;
          canvas.drawCircle(shape.startPoint, radius, paint);
          break;
        case ShapeType.square:
          double sideLength = (shape.endPoint - shape.startPoint).distance;
          Rect squareRect = Rect.fromPoints(shape.startPoint, Offset(shape.startPoint.dx + sideLength, shape.startPoint.dy + sideLength));
          canvas.drawRect(squareRect, paint);
          break;
        case ShapeType.rectangle:
          double width = (shape.endPoint.dx - shape.startPoint.dx).abs();
          double height = (shape.endPoint.dy - shape.startPoint.dy).abs();
          Rect rect = Rect.fromLTWH(shape.startPoint.dx, shape.startPoint.dy, width, height);
          canvas.drawRect(rect, paint);
          break;
        case ShapeType.triangle:
          final path = Path();
          path.moveTo(shape.startPoint.dx, shape.startPoint.dy);
          path.lineTo(shape.endPoint.dx, shape.startPoint.dy);
          path.lineTo(shape.startPoint.dx, shape.endPoint.dy);
          path.close();
          canvas.drawPath(path, paint);
          break;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

enum ShapeType { circle, square, rectangle, triangle }

class Shape {
  final ShapeType type;
  final Offset startPoint;
  final Offset endPoint;

  Shape({required this.type, required this.startPoint, required this.endPoint});
}
