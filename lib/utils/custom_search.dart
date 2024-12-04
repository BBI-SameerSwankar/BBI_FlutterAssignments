import 'package:flutter/material.dart';
import 'package:search_app/models/post_model.dart';
import 'package:search_app/post_list.dart';
import 'package:search_app/utils/theme.dart';



class PostSearchDelegate extends SearchDelegate {

  List<Post> posts = [];

  final bool isDarkMode;
   

  PostSearchDelegate(this.posts,this.isDarkMode);

  List<Post> filterDataFromSearch(String input) {
    if (input.isEmpty) {
     return List.from(posts);
    } else {
      return posts
          .where(
              (post) => post.title.toLowerCase().contains(input.toLowerCase()),
            )
          .toList();
    }

  }


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; 
          showSuggestions(context);
        },
      ),
    ];
  }


  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {



    final filteredPosts =  filterDataFromSearch(query);


    return PostList(posts:filteredPosts,isDarkMode: isDarkMode);
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final filteredPosts =  filterDataFromSearch(query);

    return PostList(posts:filteredPosts, isDarkMode: isDarkMode);

  }

  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primaryColor: isDarkMode ? Themes.darkTheme.appBar : Themes.lightTheme.appBar,
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkMode ? Themes.darkTheme.background : Themes.lightTheme.background,
      ),
    );
  }

 
  
}