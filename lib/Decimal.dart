import 'package:flutter/material.dart';
import 'package:newapp/pages/Hexa.dart';
import 'package:newapp/pages/Octal.dart';

class DecimalScreen extends StatefulWidget {
  const DecimalScreen({super.key});

  @override
  State<DecimalScreen> createState() => _DecimalScreenState();
}

class _DecimalScreenState extends State<DecimalScreen> {
  var counter = 0;

  void incrementDecimal() {
    setState(() {
      counter = (counter + 1) % 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Decimal Counter")),
        backgroundColor: const Color.fromARGB(255, 46, 173, 88),
      ),
      backgroundColor: const Color.fromARGB(95, 30, 255, 0),
      body: Center(
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 136, 201, 226),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Number
              Text(
                counter.toString(),
                style: TextStyle(fontSize: 15, color: Colors.purple),
              ),
              // Space
              SizedBox(height: 25),
              // Increment button
              ElevatedButton(
                onPressed: incrementDecimal,
                child: Text("Increment"),
              )
            ],
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.orange,
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => HexCounter()));
              },
              child: Text("Hexadecimal Counter"),
            ),
          ],
        ),
      ),
    );
  }
}
