import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Animation',
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
  String _selectedWeather = 'sunny';

  // Mapping each weather condition to its Lottie JSON asset path
  Map<String, String> weatherAnimations = {
    'sunny': 'assets/sunny.json',
    'cloudy': 'assets/cloudy.json',
    'rainy': 'assets/rainy.json',
    'snowy': 'assets/snowy.json',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather Animation')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset(
              weatherAnimations[_selectedWeather]!,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 10,
            children: weatherAnimations.keys.map((weather) {
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedWeather = weather;
                  });
                },
                child: Text(weather.toUpperCase()),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}


/*

https://lottiefiles.com/animation/sunny-7888843
https://lottiefiles.com/animation/cloudy-5327123
https://lottiefiles.com/animation/rainy-weather-8779552
https://lottiefiles.com/free-animation/snowy-night-el5v1Q3DIr

1. pubspec.yaml (add these lines under flutter:):

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