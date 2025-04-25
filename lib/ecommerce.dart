import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E-Commerce App"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search for products...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                // Placeholder for search functionality
              },
            ),
            SizedBox(height: 20),
            // Navigation to Buyer and Seller Pages
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BuyerPage()),
                  ),
              child: Text("Shop Now (Buyer)"),
            ),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SellerPage()),
                  ),
              child: Text("Sell Your Products (Seller)"),
            ),
          ],
        ),
      ),
    );
  }
}

class BuyerPage extends StatefulWidget {
  @override
  _BuyerPageState createState() => _BuyerPageState();
}

class _BuyerPageState extends State<BuyerPage> {
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Laptop',
      'price': 999.99,
      'description': 'High performance laptop.',
    },
    {
      'name': 'Smartphone',
      'price': 599.99,
      'description': 'Latest smartphone with great features.',
    },
    {
      'name': 'Headphones',
      'price': 199.99,
      'description': 'Noise-cancelling headphones.',
    },
  ];

  final List<Map<String, dynamic>> cart = [];

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      cart.add(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product List")),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          var product = products[index];
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$${product['price']}",
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                  SizedBox(height: 8),
                  Text(product['description']),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _addToCart(product),
                    child: Text("Add to Cart"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SellerPage extends StatefulWidget {
  @override
  _SellerPageState createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  final productNameController = TextEditingController();
  final productPriceController = TextEditingController();
  final productDescriptionController = TextEditingController();

  List<Map<String, dynamic>> sellerProducts = [];

  void _addProduct() {
    String name = productNameController.text;
    double price = double.tryParse(productPriceController.text) ?? 0.0;
    String description = productDescriptionController.text;

    if (name.isNotEmpty && price > 0 && description.isNotEmpty) {
      setState(() {
        sellerProducts.add({
          'name': name,
          'price': price,
          'description': description,
        });
      });

      // Clear text fields
      productNameController.clear();
      productPriceController.clear();
      productDescriptionController.clear();

      // Show product added confirmation
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Product Added"),
              content: Text("Product '$name' added successfully."),
              actions: [
                TextButton(
                  child: Text("Close"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Product")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: productPriceController,
              decoration: InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: productDescriptionController,
              decoration: InputDecoration(labelText: 'Product Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _addProduct, child: Text("Add Product")),
            SizedBox(height: 20),
            Text("Seller's Products", style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: sellerProducts.length,
                itemBuilder: (context, index) {
                  var product = sellerProducts[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "\$${product['price']}",
                            style: TextStyle(fontSize: 16, color: Colors.green),
                          ),
                          SizedBox(height: 8),
                          Text(product['description']),
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

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cart = [
    {'name': 'Laptop', 'price': 999.99},
    {'name': 'Smartphone', 'price': 599.99},
  ];

  @override
  Widget build(BuildContext context) {
    double total = cart.fold(0.0, (sum, item) => sum + item['price']);

    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  var item = cart[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item['name']),
                          Text("\$${item['price']}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Total: \$${total.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder for checkout functionality
              },
              child: Text("Proceed to Checkout"),
            ),
          ],
        ),
      ),
    );
  }
}
