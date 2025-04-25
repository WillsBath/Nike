import 'package:flutter/material.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: 18, color: Colors.black),
          bodyText2: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
      home: NotesScreen(),
    );
  }
}

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<Map<String, String>> notes = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  // Function to add a note
  void _addNote() {
    if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
      setState(() {
        notes.add({
          'title': titleController.text,
          'content': contentController.text,
        });
        titleController.clear();
        contentController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note added successfully!')),
      );
    }
  }

  // Function to edit a note
  void _editNote(int index) {
    titleController.text = notes[index]['title']!;
    contentController.text = notes[index]['content']!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Note', style: TextStyle(fontSize: 24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              maxLines: 5,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                notes[index] = {
                  'title': titleController.text,
                  'content': contentController.text,
                };
              });
              titleController.clear();
              contentController.clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Note updated successfully!')),
              );
            },
            child: Text('Save', style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes App'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              maxLines: 5,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addNote,
              style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 15.0),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('Add Note'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(
                        notes[index]['title']!,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        notes[index]['content']!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editNote(index),
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
