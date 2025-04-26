import 'package:flutter/material.dart';

void main() => runApp(ShoppingApp());

class ShoppingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Shopping App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    CategoryPage(
      category: 'Home Decor',
      products: [
        Product(name: 'Wooden Lamp', price: '\$35', image: Icons.lightbulb),
        Product(name: 'Wall Art', price: '\$50', image: Icons.photo),
      ],
    ),
    CategoryPage(
      category: 'Electronics',
      products: [
        Product(name: 'Smartphone', price: '\$699', image: Icons.smartphone),
        Product(name: 'Laptop', price: '\$999', image: Icons.laptop_mac),
      ],
    ),
    CategoryPage(
      category: 'Clothing',
      products: [
        Product(name: 'T-shirt', price: '\$25', image: Icons.checkroom),
        Product(name: 'Jeans', price: '\$40', image: Icons.local_mall),
      ],
    ),
  ];

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Shopping'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.teal,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home Decor'),
          BottomNavigationBarItem(icon: Icon(Icons.electrical_services), label: 'Electronics'),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Clothing'),
        ],
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String category;
  final List<Product> products;

  const CategoryPage({required this.category, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: products
          .map(
            (product) => Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Icon(product.image, size: 40),
            title: Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(product.price),
            trailing: Icon(Icons.add_shopping_cart),
          ),
        ),
      )
          .toList(),
    );
  }
}

class Product {
  final String name;
  final String price;
  final IconData image;

  Product({required this.name, required this.price, required this.image});
}