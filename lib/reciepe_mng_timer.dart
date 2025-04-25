import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(RecipeApp());
}

class RecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Manager',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: RecipeScreen(),
    );
  }
}

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final List<Map<String, dynamic>> recipes = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController directionsController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  Timer? _timer;
  int _currentTime = 0;

  void _addRecipe() {
    if (nameController.text.isNotEmpty &&
        ingredientsController.text.isNotEmpty &&
        directionsController.text.isNotEmpty &&
        timeController.text.isNotEmpty) {
      setState(() {
        recipes.add({
          'name': nameController.text,
          'ingredients': ingredientsController.text,
          'directions': directionsController.text,
          'cookingTime': int.tryParse(timeController.text) ?? 0,
          'timerRunning': false,
          'currentTime': 0,
        });
        nameController.clear();
        ingredientsController.clear();
        directionsController.clear();
        timeController.clear();
      });
    }
  }

  void _editRecipe(int index) {
    nameController.text = recipes[index]['name'];
    ingredientsController.text = recipes[index]['ingredients'];
    directionsController.text = recipes[index]['directions'];
    timeController.text = recipes[index]['cookingTime'].toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Recipe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Recipe Name'),
            ),
            TextField(
              controller: ingredientsController,
              decoration: InputDecoration(labelText: 'Ingredients'),
            ),
            TextField(
              controller: directionsController,
              decoration: InputDecoration(labelText: 'Directions'),
            ),
            TextField(
              controller: timeController,
              decoration: InputDecoration(labelText: 'Cooking Time (minutes)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                recipes[index] = {
                  'name': nameController.text,
                  'ingredients': ingredientsController.text,
                  'directions': directionsController.text,
                  'cookingTime': int.tryParse(timeController.text) ?? 0,
                  'timerRunning': false,
                  'currentTime': 0,
                };
              });
              nameController.clear();
              ingredientsController.clear();
              directionsController.clear();
              timeController.clear();
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _startTimer(int index) {
    setState(() {
      recipes[index]['timerRunning'] = true;
      _currentTime = recipes[index]['cookingTime'] * 60;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentTime > 0) {
        setState(() {
          _currentTime--;
          recipes[index]['currentTime'] = _currentTime;
        });
      } else {
        _timer?.cancel();
        setState(() {
          recipes[index]['timerRunning'] = false;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe Manager')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Recipe Name'),
            ),
            TextField(
              controller: ingredientsController,
              decoration: InputDecoration(labelText: 'Ingredients'),
            ),
            TextField(
              controller: directionsController,
              decoration: InputDecoration(labelText: 'Directions'),
            ),
            TextField(
              controller: timeController,
              decoration: InputDecoration(labelText: 'Cooking Time (minutes)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addRecipe,
              child: Text('Add Recipe'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(recipes[index]['name']),
                    subtitle: Text('Ingredients: ${recipes[index]['ingredients']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editRecipe(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.timer),
                          onPressed: recipes[index]['timerRunning']
                              ? null
                              : () => _startTimer(index),
                        ),
                      ],
                    ),
                    onTap: () {
                      if (!recipes[index]['timerRunning']) {
                        _startTimer(index);
                      }
                    },
                    leading: recipes[index]['timerRunning']
                        ? Icon(Icons.timer, color: Colors.green)
                        : Icon(Icons.timer, color: Colors.grey),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
