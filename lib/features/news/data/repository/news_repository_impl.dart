

import 'package:fpdart/src/either.dart';
import 'package:news_app/core/error/failure.dart';
import 'package:news_app/features/news/data/data_sources/news_data_source.dart';
import 'package:news_app/features/news/data/models/news.dart';
import 'package:news_app/features/news/domain/repository/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository{

  final NewsRemoteDataSource newsRemoteDataSource;


  NewsRepositoryImpl(this.newsRemoteDataSource);


  @override
  Future<Either<Failure, List<NewsArticle>>> getAllNews(int page,int pageSize,String query) async{
      try{
        final news = await newsRemoteDataSource.fetchNews(page:page,pageSize: pageSize,query: query);
        return Right(news);
      }
      catch(e)
      {
        return Left(Failure(e.toString()));
      }

  }


  

}