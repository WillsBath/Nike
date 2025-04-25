import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

void main() {
  runApp(HotelSearchApp());
}

class HotelSearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HotelSearchScreen(),
    );
  }
}

class HotelSearchScreen extends StatefulWidget {
  @override
  _HotelSearchScreenState createState() => _HotelSearchScreenState();
}

class _HotelSearchScreenState extends State<HotelSearchScreen> {
  late GoogleMapController mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = position;
    });
    _updateMapLocation();
  }

  void _updateMapLocation() {
    if (_currentPosition != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        ),
      );
    }
  }

  void _searchHotels(String query) {
    // Mock implementation for hotel search
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('hotel1'),
          position: LatLng(
            _currentPosition!.latitude + 0.01,
            _currentPosition!.longitude + 0.01,
          ),
          infoWindow: InfoWindow(title: 'Hotel Paradise', snippet: '4.5 stars'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('hotel2'),
          position: LatLng(
            _currentPosition!.latitude - 0.01,
            _currentPosition!.longitude - 0.01,
          ),
          infoWindow: InfoWindow(title: 'Luxury Inn', snippet: '4.7 stars'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hotel Finder')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Enter location',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _searchHotels(searchController.text),
                ),
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) => mapController = controller,
              initialCameraPosition: CameraPosition(
                target: LatLng(37.7749, -122.4194),
                zoom: 12,
              ),
              markers: _markers,
              myLocationEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
/*
# ================================
# 1. pubspec.yaml dependencies
# ================================
# Add these under dependencies:
dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.5.0       # For Google Maps
  geolocator: ^10.1.0               # For current location
  google_places_flutter: ^2.0.5     # For autocomplete input

# Run this after saving:
flutter pub get

<!-- ===========================================
     2. android/app/src/main/AndroidManifest.xml
     =========================================== -->

<!-- Outside <application> tag -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />

<!-- Inside <application> tag -->
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_API_KEY_HERE" />
// =================================
// 3. android/app/build.gradle
// =================================

android {
  defaultConfig {
    applicationId "com.example.yourapp"
    minSdkVersion 21     // Required for geolocator & maps
    targetSdkVersion 33
    // ...
  }
}

# ====================================
# 4. Google Cloud Platform (GCP) setup
# ====================================

1. Go to https://console.cloud.google.com/
2. Create/select a project.
3. Go to "APIs & Services" > "Credentials".
4. Create an API Key.
5. Copy it and paste into AndroidManifest.xml (step 2 above).
6. Enable these APIs:
   - Maps SDK for Android
   - Places API
   - Geolocation API

*/ 