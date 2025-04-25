import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(AQIApp());
}

class AQIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        textTheme: TextTheme(bodyLarge: TextStyle(fontFamily: 'Montserrat')),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: TextTheme(bodyLarge: TextStyle(fontFamily: 'Montserrat')),
      ),
      themeMode: ThemeMode.system,
      home: AQIScreen(),
    );
  }
}

class AQIScreen extends StatefulWidget {
  @override
  _AQIScreenState createState() => _AQIScreenState();
}

class _AQIScreenState extends State<AQIScreen> {
  int? aqi;
  String status = "Fetching data...";
  Color statusColor = Colors.grey;

  Future<void> fetchAQI() async {
    final response = await http.get(Uri.parse("https://api.waqi.info/feed/here/?token=YOUR_API_KEY"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        aqi = data['data']['aqi'];
        _updateStatus();
      });
    } else {
      setState(() {
        status = "Error fetching data";
      });
    }
  }

  void _updateStatus() {
    if (aqi == null) return;
    if (aqi! <= 50) {
      status = "Good";
      statusColor = Colors.green;
    } else if (aqi! <= 100) {
      status = "Moderate";
      statusColor = Colors.yellow;
    } else if (aqi! <= 150) {
      status = "Unhealthy for Sensitive Groups";
      statusColor = Colors.orange;
    } else if (aqi! <= 200) {
      status = "Unhealthy";
      statusColor = Colors.red;
    } else {
      status = "Hazardous";
      statusColor = Colors.purple;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAQI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Air Quality Index (AQI)")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              aqi != null ? "AQI: $aqi" : "Loading...",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              status,
              style: TextStyle(fontSize: 20, color: statusColor),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchAQI,
              child: Text("Refresh"),
            ),
          ],
        ),
      ),
    );
  }
}

/*

dependencies:
  flutter:
    sdk: flutter
  http: ^0.14.0  # Make sure to add the latest version of the http package



Go to https://waqi.info/.

Sign up for a new account or log in if you already have one.

Navigate to the API section (look for "Get Your API Key" or check under "Developers").

Request your API key, and it will be generated for you.

Copy the generated API key.

Replace YOUR_API_KEY in your code with the API key (e.g., https://api.waqi.info/feed/here/?token=YOUR_ACTUAL_API_KEY).

Be aware of usage limits and restrictions for the free API key (requests per day or minute).
 */