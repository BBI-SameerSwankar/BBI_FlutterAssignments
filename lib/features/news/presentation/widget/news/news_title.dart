import 'package:flutter/material.dart';
import 'package:news_app/core/theme/theme.dart';

class NewsTitleWidget extends StatelessWidget {
  final String title;
  final bool isDarkMode;

  const NewsTitleWidget({super.key, required this.title, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: isDarkMode ? Themes.darkTheme.mainFont : Themes.lightTheme.mainFont,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
