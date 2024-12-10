


import 'package:fpdart/fpdart.dart';
import 'package:news_app/core/error/failure.dart';
import 'package:news_app/features/news/data/models/news.dart';

abstract interface class NewsRepository {

  Future<Either<Failure,List<NewsArticle> >> getAllNews(int page,int pageSize);
  


}