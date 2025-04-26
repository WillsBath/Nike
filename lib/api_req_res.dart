import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final api = ApiService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Request Example',
      home: Scaffold(
        appBar: AppBar(title: const Text('API Request Example')),
        body: FutureBuilder(
          future: api.getPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final posts = snapshot.data as List<dynamic>;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text(post['body'] ?? ''),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final newPost = await api.createPost({
                                  "title": "New Post",
                                  "body": "This is a new post created from the app.",
                                  "userId": 1
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Created Post ID: ${newPost['id']}')),
                                );
                              },
                              child: const Text('Create'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final updatedPost = await api.updatePost(post['id'], {
                                  "title": "Updated Title",
                                  "body": "Updated body from the app.",
                                  "userId": post['userId']
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Updated Post ID: ${updatedPost['id']}')),
                                );
                              },
                              child: const Text('Update'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await api.deletePost(post['id']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Deleted Post ID: ${post['id']}')),
                                );
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text('Delete'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// API service class
class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<dynamic>> getPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Map<String, dynamic>> createPost(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updatePost(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/posts/$id'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(response.body);
  }

  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete post');
    }
  }
}
