import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/features/news/data/models/news.dart';
import 'package:news_app/features/news/domain/usecases/get_all_news.dart';
import 'package:news_app/features/news/presentation/bloc/news_bloc.dart';
import 'package:news_app/core/error/failure.dart';
import 'package:news_app/features/news/presentation/bloc/news_event.dart';
import 'package:news_app/features/news/presentation/bloc/news_state.dart';

class MockGetAllNews extends Mock implements GetAllNews {}

void main() {
  late MockGetAllNews mockGetAllNews;

  setUp(() {
    mockGetAllNews = MockGetAllNews();
  });

  group('NewsBloc', () {
    const tPage = 1;
    const tPageSize = 10;
    const tQuery = "flutter";

    final List<NewsArticle> tNewsList = [
      NewsArticle(title: 'Title 1', description: 'Description 1', urlToImage: 'https://example.com', publishedAt: '2024-12-18'),
      NewsArticle(title: 'Title 2', description: 'Description 2', urlToImage: 'https://example.com', publishedAt: '2024-12-18'),
    ];

    final Failure tFailure = Failure('Server error');

    test('initial state should be NewsInitial', () {
      // Arrange
      final newsBloc = NewsBloc(getAllNews: mockGetAllNews);
      
      // Act
      expect(newsBloc.state, equals(NewsInitial()));
    });

    blocTest<NewsBloc, NewsState>(
      'emits [NewsLoading, NewsLoaded] when FetchAllNewsEvent is added and the API call succeeds',
      build: () {
        when(() => mockGetAllNews(tPage, tPageSize, tQuery))
            .thenAnswer((_) async => Right(tNewsList));
        return NewsBloc(getAllNews: mockGetAllNews);
      },
      act: (bloc) => bloc.add(FetchAllNewsEvent(page: tPage, pageSize: tPageSize, query: tQuery)),
      expect: () => [
        // NewsLoading(),
        NewsLoaded(tNewsList, tPage, tPageSize, tQuery),
      ],
      verify: (_) {
        verify(() => mockGetAllNews(tPage, tPageSize, tQuery)).called(1);
      },
    );

    blocTest<NewsBloc, NewsState>(
      'emits [NewsLoading, NewsError] when FetchAllNewsEvent is added and the API call fails',
      build: () {
        when(() => mockGetAllNews(tPage, tPageSize, tQuery))
            .thenAnswer((_) async => Left(tFailure));
        return NewsBloc(getAllNews: mockGetAllNews);
      },
      act: (bloc) => bloc.add(FetchAllNewsEvent(page: tPage, pageSize: tPageSize, query: tQuery)),
      expect: () => [
        NewsLoading(),
        NewsError(tFailure.message),
      ],
      verify: (_) {
        verify(() => mockGetAllNews(tPage, tPageSize, tQuery)).called(1);
      },
    );

    blocTest<NewsBloc, NewsState>(
      'emits [NewsLoading, NewsLoaded] when FetchAllNewsEvent is added for the second page and the API call succeeds',
      build: () {
        when(() => mockGetAllNews(tPage + 1, tPageSize, tQuery))
            .thenAnswer((_) async => Right(tNewsList));
        return NewsBloc(getAllNews: mockGetAllNews);
      },
      act: (bloc) => bloc.add(FetchAllNewsEvent(page: tPage + 1, pageSize: tPageSize, query: tQuery)),
      expect: () => [
        NewsLoading(),
        NewsLoaded(tNewsList, tPage + 1, tPageSize, tQuery),
      ],
      verify: (_) {
        verify(() => mockGetAllNews(tPage + 1, tPageSize, tQuery)).called(1);
      },
    );

    blocTest<NewsBloc, NewsState>(
      'emits [NewsLoading, NewsError] when FetchAllNewsEvent is added for the second page and the API call fails',
      build: () {
        when(() => mockGetAllNews(tPage + 1, tPageSize, tQuery))
            .thenAnswer((_) async => Left(tFailure));
        return NewsBloc(getAllNews: mockGetAllNews);
      },
      act: (bloc) => bloc.add(FetchAllNewsEvent(page: tPage + 1, pageSize: tPageSize, query: tQuery)),
      expect: () => [
        NewsLoading(),
        NewsError(tFailure.message),
      ],
      verify: (_) {
        verify(() => mockGetAllNews(tPage + 1, tPageSize, tQuery)).called(1);
      },
    );
  });
}
