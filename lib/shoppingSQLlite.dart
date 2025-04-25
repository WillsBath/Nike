import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() {
  runApp(ShoppingApp());
}

class ShoppingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App with SQLite',
      theme: ThemeData(primarySwatch: Colors.green),
      home: ProductListPage(),
    );
  }
}

class Product {
  final int? id;
  final String name;
  final double price;

  Product({this.id, required this.name, required this.price});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'price': price};
  }
}

class CartItem {
  final int id;
  final String name;
  final double price;

  CartItem({required this.id, required this.name, required this.price});
}

class DBHelper {
  static Database? _db;

  static Future<Database> initDb() async {
    if (_db != null) return _db!;
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'shopping.db');

    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price REAL)');
      await db.execute(
          'CREATE TABLE cart(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price REAL)');
    });
    return _db!;
  }

  static Future<int> insertProduct(Product product) async {
    final db = await initDb();
    return await db.insert('products', product.toMap());
  }

  static Future<List<Product>> getProducts() async {
    final db = await initDb();
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length,
        (i) => Product(id: maps[i]['id'], name: maps[i]['name'], price: maps[i]['price']));
  }

  static Future<void> deleteProduct(int id) async {
    final db = await initDb();
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> updateProduct(Product product) async {
    final db = await initDb();
    await db.update('products', product.toMap(), where: 'id = ?', whereArgs: [product.id]);
  }

  static Future<void> addToCart(Product product) async {
    final db = await initDb();
    await db.insert('cart', {'name': product.name, 'price': product.price});
  }

  static Future<List<CartItem>> getCartItems() async {
    final db = await initDb();
    final List<Map<String, dynamic>> maps = await db.query('cart');
    return List.generate(
        maps.length,
        (i) =>
            CartItem(id: maps[i]['id'], name: maps[i]['name'], price: maps[i]['price']));
  }

  static Future<void> removeFromCart(int id) async {
    final db = await initDb();
    await db.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> clearCart() async {
    final db = await initDb();
    await db.delete('cart');
  }
}

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> products = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  void loadProducts() async {
    final list = await DBHelper.getProducts();
    setState(() => products = list);
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void addProduct() async {
    String name = nameController.text;
    double? price = double.tryParse(priceController.text);
    if (name.isNotEmpty && price != null) {
      await DBHelper.insertProduct(Product(name: name, price: price));
      nameController.clear();
      priceController.clear();
      loadProducts();
    }
  }

  void editProduct(Product product) async {
    nameController.text = product.name;
    priceController.text = product.price.toString();

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Edit Product'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
                  TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Price')),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      final name = nameController.text;
                      final price = double.tryParse(priceController.text);
                      if (name.isNotEmpty && price != null) {
                        await DBHelper.updateProduct(Product(id: product.id, name: name, price: price));
                        Navigator.pop(context);
                        nameController.clear();
                        priceController.clear();
                        loadProducts();
                      }
                    },
                    child: Text('Update'))
              ],
            ));
  }

  void goToCart() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product List"),
        actions: [IconButton(icon: Icon(Icons.shopping_cart), onPressed: goToCart)],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Product Name')),
              TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Price')),
              ElevatedButton(onPressed: addProduct, child: Text('Add Product')),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, i) {
                final product = products[i];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => editProduct(product)),
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await DBHelper.deleteProduct(product.id!);
                            loadProducts();
                          }),
                      IconButton(
                          icon: Icon(Icons.add_shopping_cart),
                          onPressed: () async {
                            await DBHelper.addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("${product.name} added to cart")));
                          }),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];

  void loadCart() async {
    final items = await DBHelper.getCartItems();
    setState(() => cartItems = items);
  }

  double get totalAmount =>
      cartItems.fold(0, (sum, item) => sum + item.price);

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Cart")),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (_, i) {
                  final item = cartItems[i];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () async {
                          await DBHelper.removeFromCart(item.id);
                          loadCart();
                        }),
                  );
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Total: \$${totalAmount.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              child: Text("Clear Cart"),
              onPressed: () async {
                await DBHelper.clearCart();
                loadCart();
              },
            )
          ],
        ));
  }
}
/*

dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.2
  path_provider: ^2.1.2
  path: ^1.8.3


android/app/build.gradle
defaultConfig {
    applicationId "com.example.shoppingapp"
    minSdkVersion 21 // check for minSdkVersion
    targetSdkVersion 33
    ...
}

*/