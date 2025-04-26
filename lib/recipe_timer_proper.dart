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

  List<Timer?> timers = [];

  void _addRecipe() {
    if (nameController.text.isNotEmpty &&
        ingredientsController.text.isNotEmpty &&
        directionsController.text.isNotEmpty &&
        timeController.text.isNotEmpty) {
      setState(() {
        int cookingTime = int.tryParse(timeController.text) ?? 0;
        recipes.add({
          'name': nameController.text,
          'ingredients': ingredientsController.text,
          'directions': directionsController.text,
          'cookingTime': cookingTime,
          'timerRunning': false,
          'currentTime': cookingTime * 60,
        });
        timers.add(null);
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
        content: SingleChildScrollView(
          child: Column(
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
                decoration:
                InputDecoration(labelText: 'Cooking Time (minutes)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                int cookingTime = int.tryParse(timeController.text) ?? 0;
                recipes[index] = {
                  'name': nameController.text,
                  'ingredients': ingredientsController.text,
                  'directions': directionsController.text,
                  'cookingTime': cookingTime,
                  'timerRunning': false,
                  'currentTime': cookingTime * 60,
                };
                timers[index]?.cancel();
                timers[index] = null;
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
    if (recipes[index]['timerRunning']) return;

    setState(() {
      recipes[index]['timerRunning'] = true;
    });

    timers[index]?.cancel(); // cancel any existing timer

    timers[index] = Timer.periodic(Duration(seconds: 1), (timer) {
      if (recipes[index]['currentTime'] > 0) {
        setState(() {
          recipes[index]['currentTime']--;
        });
      } else {
        timer.cancel();
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
  void dispose() {
    for (var timer in timers) {
      timer?.cancel();
    }
    super.dispose();
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
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipes[index]['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text('Ingredients: ${recipes[index]['ingredients']}'),
                          SizedBox(height: 4),
                          Text('Directions: ${recipes[index]['directions']}'),
                          SizedBox(height: 4),
                          Text(
                            'Time Left: ${_formatTime(recipes[index]['currentTime'])}',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                icon: Icon(Icons.timer),
                                label: Text('Start Timer'),
                                onPressed: recipes[index]['timerRunning']
                                    ? null
                                    : () => _startTimer(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editRecipe(index),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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