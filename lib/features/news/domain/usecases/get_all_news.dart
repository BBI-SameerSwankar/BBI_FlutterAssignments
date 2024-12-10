

import 'package:fpdart/fpdart.dart';
import 'package:news_app/core/error/failure.dart';
import 'package:news_app/features/news/data/models/news.dart';
import 'package:news_app/features/news/domain/repository/news_repository.dart';

class GetAllNews {
  final NewsRepository repository;
  GetAllNews(this.repository);

  Future<Either<Failure ,List<NewsArticle>>> call(int page,int pageSize)
  {
    return repository.getAllNews(page, pageSize);
  }

}