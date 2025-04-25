import 'package:flutter/material.dart';

void main() {
  runApp(LibraryApp());
}

class LibraryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LibraryPage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final List<Map<String, dynamic>> _books = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  // Function to show Add or Edit Book Dialog
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
                if (_titleController.text.isEmpty ||
                    _authorController.text.isEmpty ||
                    _yearController.text.isEmpty) {
                  return;
                }

                if (bookId == null) {
                  // Add new book
                  setState(() {
                    _books.add({
                      'id': DateTime.now().toString(),
                      'title': _titleController.text,
                      'author': _authorController.text,
                      'year': int.parse(_yearController.text),
                    });
                  });
                } else {
                  // Edit existing book
                  setState(() {
                    final bookIndex = _books.indexWhere(
                      (book) => book['id'] == bookId,
                    );
                    if (bookIndex != -1) {
                      _books[bookIndex] = {
                        'id': bookId,
                        'title': _titleController.text,
                        'author': _authorController.text,
                        'year': int.parse(_yearController.text),
                      };
                    }
                  });
                }

                _titleController.clear();
                _authorController.clear();
                _yearController.clear();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Function to delete a book
  void _deleteBook(String id) {
    setState(() {
      _books.removeWhere((book) => book['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library Management'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
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
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(
                        _books[index]['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        '${_books[index]['author']} (${_books[index]['year']})',
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
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
                            icon: Icon(Icons.delete, color: Colors.red),
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
              style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 15.0),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('Add New Book'),
            ),
          ],
        ),
      ),
    );
  }
}
