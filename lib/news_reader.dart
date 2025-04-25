import 'package:flutter/material.dart';

void main() {
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsListScreen(),
    );
  }
}

class NewsListScreen extends StatefulWidget {
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final List<Map<String, String>> news = [
    {
      'title': 'Flutter 3.0 Released',
      'description': 'Flutter 3.0 comes with exciting new features and improvements.',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'title': 'AI Advances in 2025',
      'description': 'Artificial Intelligence is transforming industries worldwide.',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'title': 'SpaceX Mars Mission',
      'description': 'SpaceX announces plans to send humans to Mars by 2030.',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'title': 'Climate Change Effects',
      'description': 'Scientists warn about the increasing impacts of climate change.',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'title': 'Tech Giants Merge',
      'description': 'Major tech companies are joining forces to push the boundaries of innovation.',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'title': 'Electric Cars: The Future of Transportation',
      'description': 'Electric vehicles continue to rise in popularity with environmental benefits.',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'title': 'Breakthrough in Quantum Computing',
      'description': 'New advancements in quantum computing could revolutionize industries.',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'title': 'Global Water Crisis',
      'description': 'The world faces an increasing water scarcity challenge due to overuse and climate change.',
      'image': 'https://via.placeholder.com/150'
    },
  ];

  List<Map<String, String>> displayedNews = [];

  @override
  void initState() {
    super.initState();
    displayedNews = List.from(news);
  }

  void filterNews(String query) {
    final filteredNews = news.where((newsItem) {
      final titleLower = newsItem['title']!.toLowerCase();
      final descriptionLower = newsItem['description']!.toLowerCase();
      final queryLower = query.toLowerCase();
      return titleLower.contains(queryLower) || descriptionLower.contains(queryLower);
    }).toList();

    setState(() {
      displayedNews = filteredNews;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Headlines'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                showSearch(context: context, delegate: NewsSearchDelegate(news, filterNews));
              },
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: displayedNews.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            child: ListTile(
              leading: Image.network(
                displayedNews[index]['image']!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(
                displayedNews[index]['title']!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(displayedNews[index]['description']!),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailScreen(
                      displayedNews[index]['title']!,
                      displayedNews[index]['description']!,
                      displayedNews[index]['image']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class NewsSearchDelegate extends SearchDelegate {
  final List<Map<String, String>> allNews;
  final Function(String) onSearchChanged;

  NewsSearchDelegate(this.allNews, this.onSearchChanged);

  @override
  String? get searchFieldLabel => 'Search News';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearchChanged(query);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearchChanged(query);
    return ListView.builder(
      itemCount: allNews.length,
      itemBuilder: (context, index) {
        if (allNews[index]['title']!.toLowerCase().contains(query.toLowerCase()) ||
            allNews[index]['description']!.toLowerCase().contains(query.toLowerCase())) {
          return ListTile(
            title: Text(allNews[index]['title']!),
            subtitle: Text(allNews[index]['description']!),
          );
        }
        return Container();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}

class NewsDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  NewsDetailScreen(this.title, this.description, this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(image, width: double.infinity, height: 250, fit: BoxFit.cover),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
