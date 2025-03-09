import 'package:flutter/material.dart';
import 'package:newapp/pages/Decimal.dart';
import 'package:newapp/pages/Hexa.dart';

class OctalScreen extends StatefulWidget {
  const OctalScreen({super.key});

  @override
  State<OctalScreen> createState() => _OctalScreenState();
}

class _OctalScreenState extends State<OctalScreen> {
  var counter = 0;

  void incrementOctal() {
    setState(() {
      counter = (counter + 1) % 8;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Octal Counter")),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: const Color.fromARGB(96, 61, 224, 142),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Number
            Text(counter.toString()),
            SizedBox(height: 25),
            // Increment button
            ElevatedButton(
              onPressed: incrementOctal,
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => DecimalCounter()));
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
