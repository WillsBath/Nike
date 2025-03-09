import 'package:flutter/material.dart';
import 'package:newapp/pages/Hexa.dart';
import 'package:newapp/pages/Octal.dart';

class HexadecimalScreen extends StatefulWidget {
  const HexadecimalScreen({super.key});

  @override
  State<HexadecimalScreen> createState() => _HexadecimalScreenState();
}

class _HexadecimalScreenState extends State<HexadecimalScreen> {
  var counter = 0;
  String dispString = "0";

  void incrementHexadecimal() {
    setState(() {
      counter = (counter + 1) % 16;
      switch (counter) {
        case 10:
          dispString = "A";
          break;
        case 11:
          dispString = "B";
          break;
        case 12:
          dispString = "C";
          break;
        case 13:
          dispString = "D";
          break;
        case 14:
          dispString = "E";
          break;
        case 15:
          dispString = "F";
          break;
        default:
          dispString = counter.toString();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Hexadecimal Counter")),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: const Color.fromARGB(96, 61, 224, 142),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Number
            Text(dispString),
            // Space
            SizedBox(height: 25),
            // Increment button
            ElevatedButton(
              onPressed: incrementHexadecimal,
              child: Text("Increment"),
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(height: 120),
            Icon(Icons.chat_bubble_outline_sharp),
            SizedBox(height: 120),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OctalScreen()));
              },
              child: Text("Octal Counter"),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DecimalScreen()));
              },
              child: Text("Decimal Counter"),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HexadecimalScreen()));
              },
              child: Text("Hexadecimal Counter"),
            ),
          ],
        ),
      ),
    );
  }
}
