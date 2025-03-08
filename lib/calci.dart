import 'package:flutter/material.dart';
class CalculatorScreen extends StatefulWidget {

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String output = "0";
  double num1 = 0, num2 = 0;
  String operand = "";

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        output = "0";
        num1 = num2 = 0;
        operand = "";
      } else if (buttonText == "=") {
        try {
          num2 = double.parse(output);
          if (operand == "+") output = (num1 + num2).toString();
          if (operand == "-") output = (num1 - num2).toString();
          if (operand == "*") output = (num1 * num2).toString();
          if (operand == "/") {
            output = num2 != 0 ? (num1 / num2).toString() : "Error";
          }
        } catch (e) {
          output = "Error";
        }
        operand = "";
      } else if ("+-*/".contains(buttonText)) {
        num1 = double.tryParse(output) ?? 0;
        operand = buttonText;
        output = "";
      } else {
        output = output == "0" || output == "Error" ? buttonText : output + buttonText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculator"), backgroundColor: Colors.blue),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(25),
              child: Text(output, style: TextStyle(fontSize: 32, color: output == "Error" ? Colors.red : Colors.black)),
            ),
          ),
          for (var row in ["7 8 9 /", "4 5 6 *", "1 2 3 -", "C 0 = +"])
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.split(" ").map((text) {
                return SizedBox(
                  width: 75,
                  height: 75,
                  child: ElevatedButton(
                    onPressed: () => buttonPressed(text),
                    child: Text(text, style: TextStyle(fontSize: 25)),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
