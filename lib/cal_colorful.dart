import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colorful Calculator',
      theme: ThemeData(fontFamily: 'Arial'),
      home: CalculatorHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _input = '';
  String _result = '';

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _input = '';
        _result = '';
      } else if (value == '=') {
        try {
          _result = _calculate(_input).toString();
        } catch (e) {
          _result = 'Error';
        }
      } else {
        _input += value;
      }
    });
  }

  double _calculate(String input) {
    List<String> parts;
    if (input.contains('+')) {
      parts = input.split('+');
      return double.parse(parts[0]) + double.parse(parts[1]);
    } else if (input.contains('-')) {
      parts = input.split('-');
      return double.parse(parts[0]) - double.parse(parts[1]);
    } else if (input.contains('*')) {
      parts = input.split('*');
      return double.parse(parts[0]) * double.parse(parts[1]);
    } else if (input.contains('/')) {
      parts = input.split('/');
      return double.parse(parts[0]) / double.parse(parts[1]);
    }
    throw FormatException('Invalid input');
  }

  Widget _buildButton(String text) {
    final isOperator = ['+', '-', '*', '/', '='].contains(text);
    final isClear = text == 'C';

    Color bgColor;
    if (isClear) {
      bgColor = Colors.redAccent;
    } else if (isOperator) {
      bgColor = Colors.orangeAccent;
    } else {
      bgColor = Colors.deepPurple[200]!;
    }

    return ElevatedButton(
      onPressed: () => _onButtonPressed(text),
      child: Text(text, style: TextStyle(fontSize: 24, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: EdgeInsets.all(22),
        shape: CircleBorder(),
        shadowColor: Colors.black45,
        elevation: 6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonList = [
      ['7', '8', '9', '/'],
      ['4', '5', '6', '*'],
      ['1', '2', '3', '-'],
      ['C', '0', '=', '+'],
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Colorful Calculator'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple[50]!, Colors.deepPurple[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _input,
                style: TextStyle(fontSize: 32, color: Colors.black87),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _result,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            SizedBox(height: 20),
            ...buttonList.map((row) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map(_buildButton).toList(),
            )),
          ],
        ),
      ),
    );
  }
}
