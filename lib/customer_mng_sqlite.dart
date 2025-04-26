import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() {
  runApp(const CustomerApp());
}

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer Manager',
      home: const CustomerListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Customer {
  final int? id;
  final String name;
  final String email;

  Customer({this.id, required this.name, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      email: map['email'],
    );
  }
}

class CustomerDatabase {
  static final CustomerDatabase instance = CustomerDatabase._init();
  static Database? _database;

  CustomerDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('customers.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    if (kIsWeb) {
      throw UnsupportedError("Database not supported on web.");
    }
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');
  }

  Future<List<Customer>> getCustomers() async {
    final db = await instance.database;
    final result = await db.query('customers');
    return result.map((map) => Customer.fromMap(map)).toList();
  }

  Future<int> insertCustomer(Customer customer) async {
    final db = await instance.database;
    return await db.insert('customers', customer.toMap());
  }

  Future<int> updateCustomer(Customer customer) async {
    final db = await instance.database;
    return await db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<int> deleteCustomer(int id) async {
    final db = await instance.database;
    return await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }
}

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  List<Customer> customers = [];
  bool isWeb = kIsWeb;

  @override
  void initState() {
    super.initState();
    if (!isWeb) {
      _loadCustomers();
    }
  }

  Future<void> _loadCustomers() async {
    final data = await CustomerDatabase.instance.getCustomers();
    setState(() {
      customers = data;
    });
  }

  void _openForm({Customer? customer}) {
    final nameController = TextEditingController(text: customer?.name);
    final emailController = TextEditingController(text: customer?.email);

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(customer == null ? 'Add Customer' : 'Edit Customer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final email = emailController.text.trim();
              if (name.isNotEmpty && email.isNotEmpty && !isWeb) {
                if (customer == null) {
                  await CustomerDatabase.instance.insertCustomer(
                    Customer(name: name, email: email),
                  );
                } else {
                  await CustomerDatabase.instance.updateCustomer(
                    Customer(id: customer.id, name: name, email: email),
                  );
                }
                _loadCustomers();
                Navigator.pop(context);
              } else if (isWeb) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Feature not available on Web")),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteCustomer(int id) async {
    if (isWeb) return;
    await CustomerDatabase.instance.deleteCustomer(id);
    _loadCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Manager')),
      body: isWeb
          ? const Center(child: Text('Database functionality not supported on Web.'))
          : customers.isEmpty
              ? const Center(child: Text('No customers found.'))
              : ListView.builder(
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(customer.name),
                        subtitle: Text(customer.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _openForm(customer: customer),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteCustomer(customer.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}


// dependencies:
//   flutter:
//     sdk: flutter
//   sqflite: ^2.3.0
//   path: ^1.9.0
//   path_provider: ^2.1.2