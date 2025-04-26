import 'package:flutter/material.dart';

void main() => runApp(PetCareApp());

class PetCareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Caretaking System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: PetHomePage(),
    );
  }
}

class Pet {
  final String name;
  final String type;
  final int age;
  final List<String> tasks;

  Pet({required this.name, required this.type, required this.age, required this.tasks});
}

class PetHomePage extends StatefulWidget {
  @override
  _PetHomePageState createState() => _PetHomePageState();
}

class _PetHomePageState extends State<PetHomePage> {
  final List<Pet> pets = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController taskController = TextEditingController();

  void _addPet() {
    String name = nameController.text.trim();
    String type = typeController.text.trim();
    String ageText = ageController.text.trim();

    if (name.isNotEmpty && type.isNotEmpty && ageText.isNotEmpty) {
      try {
        int age = int.parse(ageText); // only accepts numbers like "1", "2", not "1 year"
        setState(() {
          pets.add(Pet(name: name, type: type, age: age, tasks: []));
          nameController.clear();
          typeController.clear();
          ageController.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter a valid number for age")),
        );
      }
    }
  }


  void _addTask(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Care Task for ${pets[index].name}"),
        content: TextField(
          controller: taskController,
          decoration: InputDecoration(labelText: 'Task (e.g. Feed at 6 PM)'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (taskController.text.isNotEmpty) {
                setState(() {
                  pets[index].tasks.add(taskController.text);
                  taskController.clear();
                });
                Navigator.pop(context);
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showTasks(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Tasks for ${pets[index].name}"),
        content: Container(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: pets[index].tasks
                .map((task) => ListTile(
              title: Text(task),
              leading: Icon(Icons.pets),
            ))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pet Caretaking System"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Add New Pet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Pet Name")),
            TextField(controller: typeController, decoration: InputDecoration(labelText: "Pet Type (Dog, Cat...)")),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: "Age"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _addPet, child: Text("Add Pet")),
            Divider(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.pets),
                      title: Text("${pets[index].name} (${pets[index].type})"),
                      subtitle: Text("Age: ${pets[index].age}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add_task),
                            onPressed: () => _addTask(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.list),
                            onPressed: () => _showTasks(index),
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