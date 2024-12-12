import 'package:flutter/material.dart';
import 'package:news_app/core/theme/theme.dart';
import 'package:news_app/features/news/data/models/news.dart';
import 'package:news_app/features/news/presentation/widget/news/news_description.dart';
import 'package:news_app/features/news/presentation/widget/news/news_title.dart';

class NewsItemWidget extends StatelessWidget {
  final NewsArticle newsArticle;
  final bool isDarkMode;

  const NewsItemWidget({super.key, required this.newsArticle, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: isDarkMode ? Themes.darkTheme.card : Themes.lightTheme.card,
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
        title: NewsTitleWidget(
          title: newsArticle.title,
          isDarkMode: isDarkMode,
        ),
        subtitle: NewsDescriptionWidget(
          description: newsArticle.description ?? '',
          isDarkMode: isDarkMode,
        ),
        onTap: () {
          // Handle tap event here
        },
      ),
    );
  }
}
