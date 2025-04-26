import 'package:flutter/material.dart';

void main() {
  runApp(PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Portfolio',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: PortfolioMainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PortfolioMainPage extends StatefulWidget {
  @override
  State<PortfolioMainPage> createState() => _PortfolioMainPageState();
}

class _PortfolioMainPageState extends State<PortfolioMainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    AboutPage(),
    ProjectsPage(),
    ContactPage(),
  ];

  void _onTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'About'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.contact_mail), label: 'Contact'),
        ],
      ),
    );
  }
}

// -------------------- About Page --------------------
class AboutPage extends StatelessWidget {
  final String name = "John Doe";
  final String title = "Flutter Developer";
  final String bio = "Passionate developer with experience in building beautiful and functional mobile applications using Flutter.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About Me")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(radius: 60, backgroundImage: AssetImage('assets/profile.jpg')), // Add your image here
            SizedBox(height: 20),
            Text(name, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(fontSize: 18, color: Colors.grey[700])),
            SizedBox(height: 20),
            Text(bio, style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// -------------------- Projects Page --------------------
class ProjectsPage extends StatelessWidget {
  final List<String> projects = [
    "Crop Disease Detection App",
    "E-commerce Flutter UI",
    "Portfolio Website",
    "Chat App with Firebase",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Projects")),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: projects.length,
        itemBuilder: (context, index) => Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text(projects[index], style: TextStyle(fontSize: 18)),
          ),
        ),
      ),
    );
  }
}

// -------------------- Contact Page --------------------
class ContactPage extends StatelessWidget {
  final String email = "john.doe@example.com";
  final String phone = "+91 9876543210";
  final String linkedIn = "linkedin.com/in/johndoe";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContactTile(icon: Icons.email, label: "Email", value: email),
            ContactTile(icon: Icons.phone, label: "Phone", value: phone),
            ContactTile(icon: Icons.link, label: "LinkedIn", value: linkedIn),
          ],
        ),
      ),
    );
  }
}

class ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  ContactTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.indigo),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(value),
            ],
          ),
        ],
      ),
    );
  }
}