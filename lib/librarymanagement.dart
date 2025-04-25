import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LibraryPage());
  }
}

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final _databaseReference = FirebaseDatabase.instance.reference().child(
    'books',
  );
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  List<Map<dynamic, dynamic>> _books = [];

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  // Fetch books from Firebase Realtime Database
  Future<void> _fetchBooks() async {
    _databaseReference.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        setState(() {
          _books = [];
          Map<dynamic, dynamic> values = snapshot.value;
          values.forEach((key, value) {
            _books.add({
              'id': key,
              'title': value['title'],
              'author': value['author'],
              'year': value['year'],
            });
          });
        });
      }
    });
  }

  // Add or Edit a book
  Future<void> _addOrEditBook({String? id}) async {
    if (_titleController.text.isEmpty ||
        _authorController.text.isEmpty ||
        _yearController.text.isEmpty) {
      return;
    }

    if (id == null) {
      // Add new book
      _databaseReference
          .push()
          .set({
            'title': _titleController.text,
            'author': _authorController.text,
            'year': int.parse(_yearController.text),
          })
          .then((_) {
            _titleController.clear();
            _authorController.clear();
            _yearController.clear();
            _fetchBooks();
          });
    } else {
      // Edit existing book
      _databaseReference
          .child(id)
          .update({
            'title': _titleController.text,
            'author': _authorController.text,
            'year': int.parse(_yearController.text),
          })
          .then((_) {
            _titleController.clear();
            _authorController.clear();
            _yearController.clear();
            _fetchBooks();
          });
    }
  }

  // Show Add/Edit Book Dialog
  void _showAddEditDialog({
    String? bookId,
    String? title,
    String? author,
    int? year,
  }) {
    if (bookId != null) {
      _titleController.text = title ?? '';
      _authorController.text = author ?? '';
      _yearController.text = year?.toString() ?? '';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(bookId == null ? 'Add Book' : 'Edit Book'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _titleController,
                decoration: InputDecoration(hintText: 'Title'),
              ),
              TextField(
                controller: _authorController,
                decoration: InputDecoration(hintText: 'Author'),
              ),
              TextField(
                controller: _yearController,
                decoration: InputDecoration(hintText: 'Year'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(bookId == null ? 'Add' : 'Update'),
              onPressed: () {
                _addOrEditBook(id: bookId);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Delete a book
  void _deleteBook(String id) {
    _databaseReference.child(id).remove().then((_) {
      _fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Library Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _books.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(_books[index]['title']),
                      subtitle: Text(
                        '${_books[index]['author']} (${_books[index]['year']})',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _showAddEditDialog(
                                bookId: _books[index]['id'],
                                title: _books[index]['title'],
                                author: _books[index]['author'],
                                year: _books[index]['year'],
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteBook(_books[index]['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _showAddEditDialog(),
              child: Text('Add New Book'),
            ),
          ],
        ),
      ),
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