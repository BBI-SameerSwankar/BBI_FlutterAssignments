import 'package:news_app/features/news/data/models/news.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsArticle> newsList;
  final int page;
  final int pageSize;
  final String query;


  NewsLoaded(this.newsList, this.page , this.pageSize,this.query);
}

class NewsError extends NewsState {
  final String message;

  NewsError(this.message);
}
