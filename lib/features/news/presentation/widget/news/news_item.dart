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
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: isDarkMode ? Themes.darkTheme.card : Themes.lightTheme.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            NewsTitleWidget(
              title: newsArticle.title,
              imageUrl: newsArticle.urlToImage,
            ),
            
 
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  NewsDescriptionWidget(
                    description: newsArticle.description ?? '',
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
