import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:news_app/features/news/presentation/bloc/news_bloc.dart';
import 'package:news_app/features/news/data/models/news.dart';
import 'package:news_app/core/error/failure.dart';
import 'package:news_app/features/news/domain/usecases/get_all_news.dart';
import 'package:news_app/features/news/presentation/bloc/news_event.dart';
import 'package:news_app/features/news/presentation/bloc/news_state.dart';

class MockGetAllNews extends Mock implements GetAllNews {}

void main() {
  late MockGetAllNews mockGetAllNews;
  late NewsBloc newsBloc;

  setUp(() {
    mockGetAllNews = MockGetAllNews();
    newsBloc = NewsBloc(getAllNews: mockGetAllNews);
  });

 test('initial state should be NewsInitial', () {
  expect(newsBloc.state, isA<NewsInitial>());
});

  group('FetchAllNewsEvent', () {
    const pageSize = 10;
    const page = 1;
    const query = 'flutter';

    final newsList = [
      NewsArticle(
        title: 'Flutter 3 Released',
        description: 'The latest version of Flutter has been released.',
        urlToImage: 'https://example.com/flutter.jpg',
        publishedAt: '2021-01-01',
      ),
      NewsArticle(
        title: 'Dart 2.13 Released',
        description: 'Dart 2.13 is now available with new features.',
        urlToImage: 'https://example.com/dart.jpg',
        publishedAt: '2021-01-02',
      ),
    ];

    test('emits [NewsLoading, NewsLoaded] when the data is successfully fetched', () async {
     // Arrange
      when(() => mockGetAllNews(page, pageSize, query)).thenAnswer(
        (_) async => Right(newsList),
      ); 

      // Assert
      final expectedStates = [
   
        NewsLoaded(newsList, page, pageSize, query),
      ];

      await expectLater(
        newsBloc.stream,
        emitsInOrder(expectedStates),
      );

      // Act
      newsBloc.add(FetchAllNewsEvent(page: page, pageSize: pageSize, query: query));
    });

    test('emits [NewsLoading, NewsError] when there is a failure', () async {
      // Arrange
      final failure = Failure('Server error');
      when(() => mockGetAllNews(page, pageSize, query)).thenAnswer(
        (_) async => Left(failure),
      );

      // Assert
      final expectedStates = [
        NewsLoading(),
        NewsError('Server error'),
      ];

      await expectLater(
        newsBloc.stream,
        emitsInOrder(expectedStates),
      );

      // Act
      newsBloc.add(FetchAllNewsEvent(page: page, pageSize: pageSize, query: query));
    });

    test('emits [NewsError] when an unexpected error occurs', () async {
      // Arrange
      when(() => mockGetAllNews(page, pageSize, query)).thenThrow(Exception('Unexpected error'));

      // Assert
      final expectedStates = [
        NewsLoading(),
        NewsError('An unexpected error occurred: Exception: Unexpected error'),
      ];

      await expectLater(
        newsBloc.stream,
        emitsInOrder(expectedStates),
      );

      // Act
      newsBloc.add(FetchAllNewsEvent(page: page, pageSize: pageSize, query: query));
    });

    test('does not fetch new data if the query is the same and the state is NewsLoaded', () async {
      // Arrange
      final currentState = NewsLoaded(newsList, page, pageSize, query);
      newsBloc.emit(currentState);

      // Act
      newsBloc.add(FetchAllNewsEvent(page: page, pageSize: pageSize, query: query));

      // Assert
      verifyNever(() => mockGetAllNews(page, pageSize, query));
    });
  });

  tearDown(() {
    newsBloc.close();
  });
}
