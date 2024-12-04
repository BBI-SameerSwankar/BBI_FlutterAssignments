import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:search_app/models/post_model.dart';
import 'package:search_app/post_list.dart';
import 'package:search_app/utils/custom_search.dart';
import 'package:search_app/utils/theme.dart';  // Import theme.dart for theme management

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = [];
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    _loadTheme(); // Load the saved theme when the app starts
  }

  // Load theme from SharedPreferences
  void _loadTheme() async {
   isDarkMode = await Themes.loadTheme();
    setState(() {});
  }

  // Toggle the theme and save it to SharedPreferences
  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    Themes.saveTheme(isDarkMode); // Save the new theme choice
  }

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
      backgroundColor:  isDarkMode ? Themes.darkTheme.background : Themes.lightTheme.background,
      appBar: AppBar(
        title: const Text(
          'Posts',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: isDarkMode ? Themes.darkTheme.appBar : Themes.lightTheme.appBar,
        // backgroundColor: Colors.red ,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PostSearchDelegate(posts,isDarkMode),
              );
            },
          ),
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: Colors.white,
            ),
            onPressed: _toggleTheme, // Toggle the theme on button press
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
            return PostList(posts: snapshot.data! , isDarkMode:isDarkMode); 
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
