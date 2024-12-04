import 'package:flutter/material.dart';
import 'package:search_app/models/post_model.dart';
import 'package:search_app/utils/theme.dart';

class PostList extends StatefulWidget {
  final List<Post>? posts;
  final isDarkMode;
  PostList({this.posts,this.isDarkMode});

  @override
  State<PostList> createState() => _PostListState();
}
  

class _PostListState extends State<PostList> {


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: widget.posts!.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: widget.isDarkMode ?  Colors.grey[300] : Colors.white,  
              borderRadius: BorderRadius.circular(15), 
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.1), 
           
                  offset: Offset(2, 2),
                  blurRadius: 6,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                widget.posts![index].title,
                style: const TextStyle(
                  color: Colors.deepPurple, 
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                widget.posts![index].body,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7), 
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
