
class NewsArticle {

  final String title;
  final String description;
  final String urlToImage;
  final String publishedAt;

  NewsArticle({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
    );
  }
  
}