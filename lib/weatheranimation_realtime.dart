import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Real-time Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _city = 'London';
  String _temperature = '';
  String _weatherDescription = '';
  String _feelsLike = '';
  bool _loading = false;
  String _selectedWeather = 'sunny';

  final String apiKey = 'bd5e378503939ddaee76f12ad7a97608';

  // Mapping weather conditions to Lottie JSON assets
  final Map<String, String> weatherAnimations = {
    'sunny': 'assets/sunny.json',
    'cloudy': 'assets/cloudy.json',
    'rainy': 'assets/rainy.json',
    'snowy': 'assets/snowy.json',
  };

  Future<void> _getWeather() async {
    setState(() {
      _loading = true;
    });

    final String url = 'https://api.openweathermap.org/data/2.5/weather?q=$_city&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final condition = data['weather'][0]['main'].toString().toLowerCase();

        // Map API condition to animation type
        String animationType = 'sunny'; // default
        if (condition.contains('cloud')) {
          animationType = 'cloudy';
        } else if (condition.contains('rain') || condition.contains('drizzle') || condition.contains('thunderstorm')) {
          animationType = 'rainy';
        } else if (condition.contains('snow')) {
          animationType = 'snowy';
        }

        setState(() {
          _temperature = '${data['main']['temp']} °C';
          _weatherDescription = data['weather'][0]['description'];
          _feelsLike = 'Feels like: ${data['main']['feels_like']} °C';
          _selectedWeather = animationType;
        });
      } else {
        setState(() {
          _temperature = 'Error fetching data';
          _selectedWeather = 'sunny';
        });
      }
    } catch (e) {
      setState(() {
        _temperature = 'Error fetching data';
        _selectedWeather = 'sunny';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather & Animation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Lottie.asset(
              weatherAnimations[_selectedWeather]!,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                _city = value;
              },
              decoration: InputDecoration(labelText: 'Enter city name'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _getWeather,
              child: Text('Get Weather'),
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('City: $_city', style: TextStyle(fontSize: 16)),
                      Text('Temperature: $_temperature', style: TextStyle(fontSize: 16)),
                      Text('Weather: $_weatherDescription', style: TextStyle(fontSize: 16)),
                      Text(_feelsLike, style: TextStyle(fontSize: 16)),
                    ],
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
  http: ^0.15.0


If you're targeting Android, add internet permission in:

android/app/src/main/AndroidManifest.xml:

<uses-permission android:name="android.permission.INTERNET"/>


Go to https://openweathermap.org → Click “Sign In” → “Create an Account” → Verify your email 
→ Log in at https://home.openweathermap.org → Go to “API keys” → Click “+ Create key” 
→ Name it (e.g., weatherAppKey) → Click “Generate” → Copy the API key 
→ Paste it in your code replacing YOUR_API_KEY.



/*

https://lottiefiles.com/animation/sunny-7888843
https://lottiefiles.com/animation/cloudy-5327123
https://lottiefiles.com/animation/rainy-weather-8779552
https://lottiefiles.com/free-animation/snowy-night-el5v1Q3DIr


1. pubspec.yaml (add these lines under flutter:):
yaml
Copy
Edit
flutter:
  assets:
    - assets/sunny.json
    - assets/cloudy.json
    - assets/rainy.json
    - assets/snowy.json


flutter pub add lottie
or
dependencies:
  lottie: ^2.6.0


Download .json animations and place them in the assets/ folder in your project root:
/assets
  ├── sunny.json
  ├── cloudy.json
  ├── rainy.json
  └── snowy.json

 */
 */