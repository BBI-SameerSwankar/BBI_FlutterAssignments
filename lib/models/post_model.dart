class Post {
  int id;
  String title;
  String body;

 
  Post({
    required this.id,
    required this.title,
    required this.body,
  });

   factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      title: map['title'],
      body: map['body'],
    );
  }

 
}
