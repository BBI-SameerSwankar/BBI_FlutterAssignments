


import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/features/news/data/data_sources/news_data_source.dart';
import 'package:news_app/features/news/data/models/news.dart';
import 'package:news_app/features/news/data/repository/news_repository_impl.dart';

class MockNewsRemoteDataSource extends Mock implements NewsRemoteDataSource{

}

void main()
{

    const String query = 'flutter';
    const String language = 'en';
    const String sortBy = 'publishedAt';
    const int page = 1;
    const int pageSize = 10;

  late NewsRepositoryImpl news_repository_impl;
  late NewsRemoteDataSource news_remote_data_source;


  setUp((){
    news_remote_data_source = MockNewsRemoteDataSource();
    news_repository_impl = NewsRepositoryImpl(news_remote_data_source);
  });


  test("testing the repository impl", ()async{
    

      final mockNewsList = [
      NewsArticle(
        title: 'Article 1',
        description: 'Description 1',
        urlToImage: 'http://image1.com',
        publishedAt: '2024-12-19',
      ),
      NewsArticle(
        title: 'Article 2',
        description: 'Description 2',
        urlToImage: 'http://image2.com',
        publishedAt: '2024-12-20',
      ),
    ];




        when(() => news_remote_data_source.fetchNews(
        query: query,    
        page: page,
        pageSize: pageSize,
      )).thenAnswer((_) async => mockNewsList);
    

    final result = await news_repository_impl.getAllNews(page, pageSize, query);


    result.fold(
      (l)=>{   fail("failed to get the news") },
      (r)=>{    
          expect(r, mockNewsList)

        }
    );



  });


}