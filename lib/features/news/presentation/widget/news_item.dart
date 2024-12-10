import 'package:flutter/material.dart';
import 'package:news_app/features/news/data/models/news.dart';

class NewsItemWidget extends StatefulWidget {
  final NewsArticle newsArticle;

  const NewsItemWidget({super.key, required this.newsArticle});

  @override
  _NewsItemWidgetState createState() => _NewsItemWidgetState();
}

class _NewsItemWidgetState extends State<NewsItemWidget> {
  bool _isExpanded = false;
  bool _showReadMore = false;
  final GlobalKey _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Check if the text overflows and set the state to show "Read more"
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTextOverflow();
    });
  }

  void _checkTextOverflow() {
    final RenderBox renderBox = _textKey.currentContext?.findRenderObject() as RenderBox;
    if (renderBox != null) {
      final size = renderBox.size;
      final textHeight = size.height;
      final textLineHeight = 18.0; // This is the approximate line height of the text
      final maxLines = 4;
      final maxHeight = textLineHeight * maxLines;

      if (textHeight > maxHeight) {
        setState(() {
          _showReadMore = true; // Show the Read more button if the text is longer
        });
      }
    }
  }

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
        leading: widget.newsArticle.urlToImage.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.newsArticle.urlToImage,
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
          widget.newsArticle.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.newsArticle.description ?? 'No description available.',
              key: _textKey,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              maxLines: _isExpanded ? null : 4,
              overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (_showReadMore)
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
        ),
        onTap: () {
          // You can add navigation or action on tap here
        },
      ),
    );
  }
}
