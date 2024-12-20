


import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/core/error/failure.dart';
import 'package:news_app/features/news/data/models/news.dart';
import 'package:news_app/features/news/domain/repository/news_repository.dart';
import 'package:news_app/features/news/domain/usecases/get_all_news.dart';

class MockNewsRepository extends Mock implements NewsRepository{

}

void main()
{


  int page = 1;
  int pageSize  = 20;
  String query = "";

  late GetAllNews usecase;
  late NewsRepository repository;


  setUp((){
    repository = MockNewsRepository();
    usecase = GetAllNews(repository);
  });

  test("should call the NewsRepository.getAllNews", 
  () async {


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


    when( ()=> repository.getAllNews(page, pageSize, query) ).thenAnswer((_)async => Right(mockNewsList)  );

    // main
    final result = await usecase.call(page, pageSize, query);


    expect(result.isRight() , true);
    
    result.fold((l)=>{ fail("you failed ") }, (r){  expect(r, mockNewsList);  }   );

    // left
    when( ()=> repository.getAllNews(page, pageSize, query) ).thenAnswer((_)async => Left(Failure("failed"))  );

    // main
    final result_failed = await usecase.call(page, pageSize, query);


    expect(result_failed.isLeft() , true);
    
    result_failed.fold((l)=>{ expect(l.message, "failed") }, (r){  fail("right");  }   );




    




  }
  
  );
}