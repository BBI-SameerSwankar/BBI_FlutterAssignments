import 'package:flutter/material.dart';
import 'package:news_app/core/theme/theme.dart';

class NewsDescriptionWidget extends StatefulWidget {
  final String description;
  final bool isDarkMode;

  const NewsDescriptionWidget({
    super.key,
    required this.description,
    required this.isDarkMode,
  });

  @override
  _NewsDescriptionWidgetState createState() => _NewsDescriptionWidgetState();
}

class _NewsDescriptionWidgetState extends State<NewsDescriptionWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
  
        Text(
          widget.description.isNotEmpty ? widget.description : 'No description available.',
          style: TextStyle(
            fontSize: 14,
            color: widget.isDarkMode
                ? Themes.darkTheme.subFont
                : Themes.lightTheme.subFont,
          ),
          maxLines: _isExpanded ? null : 4, 
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis, 
        ),
        
       
        if (widget.description.length > 100) 
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded; 
              });
            },
            child: Text(
              _isExpanded ? 'Show less' : 'Read more', 
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
