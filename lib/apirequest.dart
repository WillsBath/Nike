
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  // GET request
  Future<List<dynamic>> getPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // POST request
  Future<Map<String, dynamic>> createPost(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(response.body);
  }

  // PUT request
  Future<Map<String, dynamic>> updatePost(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/posts/$id'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(response.body);
  }

  // DELETE request
  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete post');
    }
  }
}


/*main*/
import 'package:flutter/material.dart';
import 'api_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final api = ApiService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('API Request Example')),
        body: FutureBuilder(
          future: api.getPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            final posts = snapshot.data as List<dynamic>;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(posts[index]['title']),
              ),
            );
          },
        ),
      ),
    );
  }
}


/*
api_service.dart
http: ^0.13.6 
*/
