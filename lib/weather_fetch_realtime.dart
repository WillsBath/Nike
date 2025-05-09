import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  final String apiKey = 'bd5e378503939ddaee76f12ad7a97608';

  Future<void> _getWeather() async {
    setState(() {
      _loading = true;
    });

    final String url = 'https://api.openweathermap.org/data/2.5/weather?q=$_city&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _temperature = '${data['main']['temp']} °C';
          _weatherDescription = data['weather'][0]['description'];
          _feelsLike = 'Feels like: ${data['main']['feels_like']} °C';
        });
      } else {
        setState(() {
          _temperature = 'Error fetching data';
        });
      }
    } catch (e) {
      setState(() {
        _temperature = 'Error fetching data';
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
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                setState(() {
                  _city = value;
                });
              },
              decoration: InputDecoration(labelText: 'Enter city name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getWeather,
              child: Text('Get Weather'),
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : Column(
              children: [
                Text('City: $_city'),
                Text('Temperature: $_temperature'),
                Text('Weather: $_weatherDescription'),
                Text(_feelsLike),
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


Steps to get a free weather API key:
Go to: https://home.openweathermap.org/users/sign_up

Sign up for a free account (just needs email and password).

Once logged in, go to “API Keys” tab or visit https://home.openweathermap.org/api_keys.

You’ll see a default key like 123abc456def... — that’s your personal weather API key.

Use that in your app or website.


 */
