import 'package:flutter/material.dart';
import 'package:news_app/features/news/data/models/news.dart';

class NewsItemWidget extends StatelessWidget {
  final NewsArticle newsArticle;

  const NewsItemWidget({super.key, required this.newsArticle});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        leading: newsArticle.urlToImage.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  newsArticle.urlToImage,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://t4.ftcdn.net/jpg/02/09/53/11/360_F_209531103_vL5MaF5fWcdpVcXk5yREBk3KMcXE0X7m.jpg',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              )
            : const Icon(Icons.image, size: 80, color: Colors.grey),
        title: Text(
          newsArticle.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Flexible(
          child: Text(
            newsArticle.description ?? 'No description available.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ),
        // Removed the trailing widget here (the right arrow icon)
        onTap: () {
          // You can add navigation or action on tap here
        },
      ),
    );
  }
}
