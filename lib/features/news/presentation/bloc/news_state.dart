import 'package:news_app/features/news/data/models/news.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsArticle> newsList;

  NewsLoaded(this.newsList);
}

class NewsError extends NewsState {
  final String message;

  NewsError(this.message);
}
