import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TodoListScreen(),
    );
  }
}

class Todo {
  String title;
  bool isCompleted;
  String? id;

  Todo({required this.title, this.isCompleted = false, this.id});

  // Convert Todo to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  // Convert Map to Todo
  factory Todo.fromMap(Map<String, dynamic> map, String id) {
    return Todo(
      title: map['title'],
      isCompleted: map['isCompleted'],
      id: id,
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todos = [];

  final databaseRef = FirebaseDatabase.instance.reference().child('todos');

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  // Load todos from Firebase
  void _loadTodos() {
    databaseRef.onChildAdded.listen((event) {
      final todo = Todo.fromMap(event.snapshot.value as Map<String, dynamic>, event.snapshot.key!);
      setState(() {
        todos.add(todo);
      });
    });

    databaseRef.onChildChanged.listen((event) {
      final updatedTodo = Todo.fromMap(event.snapshot.value as Map<String, dynamic>, event.snapshot.key!);
      setState(() {
        int index = todos.indexWhere((todo) => todo.id == updatedTodo.id);
        if (index != -1) {
          todos[index] = updatedTodo;
        }
      });
    });

    databaseRef.onChildRemoved.listen((event) {
      setState(() {
        todos.removeWhere((todo) => todo.id == event.snapshot.key);
      });
    });
  }

  // Add or edit a task
  void _addOrEditTask({Todo? todo, int? index}) async {
    final result = await showDialog<Todo>(
      context: context,
      builder: (context) => TaskDialog(todo: todo),
    );
    if (result != null) {
      if (todo == null) {
        _addTodo(result);
      } else {
        _updateTodo(result);
      }
    }
  }

  // Add a new todo
  void _addTodo(Todo todo) {
    final ref = databaseRef.push();
    ref.set(todo.toMap()).then((_) {
      setState(() {
        todos.add(todo.copyWith(id: ref.key));
      });
    });
  }

  // Update an existing todo
  void _updateTodo(Todo todo) {
    final ref = databaseRef.child(todo.id!);
    ref.update(todo.toMap()).then((_) {
      setState(() {
        int index = todos.indexWhere((t) => t.id == todo.id);
        if (index != -1) {
          todos[index] = todo;
        }
      });
    });
  }

  // Delete a todo
  void _deleteTask(String id) {
    final ref = databaseRef.child(id);
    ref.remove().then((_) {
      setState(() {
        todos.removeWhere((todo) => todo.id == id);
      });
    });
  }

  // Toggle task completion
  void _toggleTaskCompletion(int index) {
    setState(() {
      todos[index].isCompleted = !todos[index].isCompleted;
      _updateTodo(todos[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo List')),
      body: todos.isEmpty
          ? Center(child: Text('No tasks available'))
          : ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration:
                            todo.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    leading: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (_) => _toggleTaskCompletion(index),
                    ),
                    onTap: () => _addOrEditTask(todo: todo, index: index),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteTask(todo.id!),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addOrEditTask(),
      ),
    );
  }
}

class TaskDialog extends StatefulWidget {
  final Todo? todo;
  TaskDialog({this.todo});

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = Todo(title: _titleController.text, isCompleted: widget.todo?.isCompleted ?? false);
      Navigator.pop(context, newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.todo == null ? 'Add Task' : 'Edit Task'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _titleController,
          decoration: InputDecoration(labelText: 'Task Title'),
          validator: (value) => value!.isEmpty ? 'Please enter a task' : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveTask,
          child: Text('Save'),
        ),
      ],
    );
  }
}

/*
1. **Create a Firebase Project:**
   - Go to the [Firebase Console](https://console.firebase.google.com/).
   - Click on **"Add project"** and follow the steps to create a new Firebase project.

2. **Add Your Flutter App to Firebase:**
   - In the Firebase Console, select your project.
   - Click on the **Android icon** to add your Android app.
   - Register your app by providing your **Android package name**.
   
   android/app/build.gradle
   defaultConfig {
    applicationId "com.example.yourappname"  // <-- This is your package name
    ...
}

   - Download the `google-services.json` file.
   - Place the `google-services.json` file into your `android/app/` directory.

3. **Add Firebase SDKs in Flutter:**
   - Open your `pubspec.yaml` file and add the following dependencies:
     ```yaml
     dependencies:
       firebase_core: ^1.10.6
       firebase_database: ^9.0.6
       flutter:
         sdk: flutter
     ```
   - Run `flutter pub get` to install the dependencies.

4. **Initialize Firebase in Flutter:**
   - Open `main.dart` and initialize Firebase at the start of your app:
     ```dart
     import 'package:firebase_core/firebase_core.dart';
     import 'package:flutter/material.dart';

     void main() async {
       WidgetsFlutterBinding.ensureInitialized();
       await Firebase.initializeApp();
       runApp(MyApp());
     }
     ```

5. **Enable Firebase Realtime Database:**
   - In the Firebase Console, go to **Database** > **Realtime Database**.
   - Click on **Create Database** and set the location.
   - Set the **database rules** for development (e.g., allowing access to authenticated users):
     ```json
     {
       "rules": {
         ".read": "auth != null",
         ".write": "auth != null"
       }
     }
     ```

6. **Add Firebase Services to Android:**
   - Open `android/app/build.gradle` and add the `google-services` plugin:
     ```gradle
     apply plugin: 'com.google.gms.google-services'
     ```
   - Open `android/build.gradle` and ensure this classpath is in the `dependencies` section:
     ```gradle
     dependencies {
       classpath 'com.google.gms:google-services:4.3.15'
     }
     ```


*/