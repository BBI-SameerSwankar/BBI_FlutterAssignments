import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:search_app/models/post_model.dart';
import 'package:search_app/post_list.dart';
import 'package:search_app/utils/custom_search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = [];

  Future<List<Post>> fetchData() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      List<Post> postList = jsonList.map((json) => Post.fromMap(json)).toList();
      return postList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Posts',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.deepPurple, 
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PostSearchDelegate(posts),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: fetchData(),
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); 
          } else if (snapshot.hasError) {
            return Center(child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.red, fontSize: 18),
            )); 
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text(
                'No posts found',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ));
            }
            posts = snapshot.data!;
            return PostList(posts: snapshot.data!); 
          } else {
            return const Center(child: Text(
              'No data available', 
              style: TextStyle(color: Colors.grey, fontSize: 18),
            )); 
          }
        },
      ),
    );
  }
}
