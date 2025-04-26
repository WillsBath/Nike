import 'package:flutter/material.dart';

void main() => runApp(UnitConverterApp());

class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UnitConverter(),
    );
  }
}

class UnitConverter extends StatefulWidget {
  @override
  _UnitConverterState createState() => _UnitConverterState();
}

class _UnitConverterState extends State<UnitConverter> {
  final TextEditingController _controller = TextEditingController();

  String _category = 'Length';
  String _fromUnit = 'Meters';
  String _toUnit = 'Kilometers';
  double _inputValue = 0;
  String _result = '';

  final Map<String, Map<String, double>> _conversionRates = {
    'Length': {
      'Meters': 1.0,
      'Kilometers': 0.001,
      'Miles': 0.000621371,
      'Centimeters': 100.0,
      'Feet': 3.28084,
    },
    'Weight': {
      'Grams': 1.0,
      'Kilograms': 0.001,
      'Pounds': 0.00220462,
      'Ounces': 0.035274,
      'Milligrams': 1000.0,
    },
  };

  List<String> get _unitList => _conversionRates[_category]!.keys.toList();

  void _convert() {
    double? input = double.tryParse(_controller.text);
    if (input == null) {
      setState(() => _result = 'Please enter a valid number');
      return;
    }

    double fromRate = _conversionRates[_category]![_fromUnit]!;
    double toRate = _conversionRates[_category]![_toUnit]!;

    double baseValue = input / fromRate;
    double convertedValue = baseValue * toRate;

    setState(() {
      _inputValue = input;
      _result = '${convertedValue.toStringAsFixed(4)} $_toUnit';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Unit Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _category,
              items: ['Length', 'Weight']
                  .map((cat) => DropdownMenuItem(
                value: cat,
                child: Text(cat),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _category = value!;
                  _fromUnit = _unitList[0];
                  _toUnit = _unitList[1];
                  _result = '';
                  _controller.clear();
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter value',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _convert(),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _fromUnit,
                    items: _unitList
                        .map((unit) => DropdownMenuItem(
                      value: unit,
                      child: Text(unit),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _fromUnit = value!;
                        _convert();
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.swap_horiz),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _toUnit,
                    items: _unitList
                        .map((unit) => DropdownMenuItem(
                      value: unit,
                      child: Text(unit),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _toUnit = value!;
                        _convert();
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'Result: $_result',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}