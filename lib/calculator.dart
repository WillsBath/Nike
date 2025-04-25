import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
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
    return ElevatedButton(
      onPressed: () => _onButtonPressed(text),
      child: Text(text, style: TextStyle(fontSize: 24)),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(22),
        shape: CircleBorder(),
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
      appBar: AppBar(title: Text('Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Text(_input, style: TextStyle(fontSize: 32)),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(_result, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
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
