import 'package:news_app/features/news/data/models/news.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;



abstract class NewsRemoteDataSource {
  Future<List<NewsArticle>> fetchNews({required int page, required int pageSize});
}



class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final String _baseUrl = 'https://newsapi.org/v2/everything';
  final String _apiKey = '80bd6d362d7d4cb59b5d53c00bdccd82'; 

  @override
  Future<List<NewsArticle>> fetchNews({required int page, required int pageSize}) async {

    final Uri url = Uri.parse(
        '$_baseUrl?q=technology&from=2024-11-11&language=en&sortBy=publishedAt&apiKey=$_apiKey&page=$page&pageSize=$pageSize');

      print('$_baseUrl?q=technology&from=2024-11-11&language=en&sortBy=publishedAt&apiKey=$_apiKey&page=$page&pageSize=$pageSize');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articlesJson = data['articles'];

        return articlesJson.map((articleJson) => NewsArticle.fromJson(articleJson)).toList();
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load news: $error');
    }
  }
}