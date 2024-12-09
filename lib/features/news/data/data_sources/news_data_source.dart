import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/features/news/data/models/news.dart';


abstract class NewsRemoteDataSource {

  Future<List<NewsArticle>> fetchNews();

}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {

  final String _baseUrl = 'https://newsapi.org/v2/everything';
  final String _apiKey = '42568c9987104876aa48ace1261cf10a'; 

  @override
  Future<List<NewsArticle>> fetchNews() async {

    final Uri url = Uri.parse(
        '$_baseUrl?q=tesla&from=2024-11-09&sortBy=publishedAt&apiKey=$_apiKey');

    try {
      final response = await http.get(url);


      if (response.statusCode == 200) {

        final Map<String, dynamic> data = json.decode(response.body);

        
        final List<dynamic> articlesJson = data['articles'];


        print(articlesJson
            .map((articleJson) => NewsArticle.fromJson(articleJson))
            .toList());

        
        return articlesJson
            .map((articleJson) => NewsArticle.fromJson(articleJson))
            .toList();

      } else {

        throw Exception('Failed to load news: ${response.statusCode}');

      }
    } catch (error) {

      throw Exception('Failed to load news: $error');
      
    }
  }
}