import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _currentInput = "";
  double _num1 = 0;
  double _num2 = 0;
  String _operation = "";

  void _buttonPressed(String text) {
    setState(() {
      if (text == "C") {
        _output = "0";
        _currentInput = "";
        _num1 = 0;
        _num2 = 0;
        _operation = "";
      } else if (text == "+" || text == "-" || text == "×" || text == "÷") {
        if (_currentInput.isNotEmpty) {
          _num1 = double.parse(_currentInput);
          _operation = text;
          _currentInput = "";
        }
      } else if (text == "=") {
        if (_currentInput.isNotEmpty) {
          _num2 = double.parse(_currentInput);
          if (_operation == "+") {
            _output = (_num1 + _num2).toString();
          } else if (_operation == "-") {
            _output = (_num1 - _num2).toString();
          } else if (_operation == "×") {
            _output = (_num1 * _num2).toString();
          } else if (_operation == "÷") {
            _output = (_num2 != 0) ? (_num1 / _num2).toString() : "Error";
          }
          _currentInput = _output;
          _num1 = 0;
          _num2 = 0;
          _operation = "";
        }
      } else {
        _currentInput += text;
        _output = _currentInput;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Calculator", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            alignment: Alignment.centerRight,
            child: Text(
              _output,
              style: TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _buildButton("C", Colors.redAccent),
                  _buildButton("÷", Colors.orange),
                  _buildButton("×", Colors.orange),
                  _buildButton("⌫", Colors.grey),
                  _buildButton("7"),
                  _buildButton("8"),
                  _buildButton("9"),
                  _buildButton("-", Colors.orange),
                  _buildButton("4"),
                  _buildButton("5"),
                  _buildButton("6"),
                  _buildButton("+", Colors.orange),
                  _buildButton("1"),
                  _buildButton("2"),
                  _buildButton("3"),
                  _buildButton("=", Colors.green),
                  _buildButton("0", Colors.white, isWide: true),
                  _buildButton(".", Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, [Color? color, bool isWide = false]) {
    return GestureDetector(
      onTap: () => _buttonPressed(text),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color ?? Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
          gradient: (color == null)
              ? LinearGradient(
                  colors: [Colors.grey[800]!, Colors.grey[700]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        width: isWide ? 160 : 70,
        height: 70,
        child: Text(
          text,
          style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}


