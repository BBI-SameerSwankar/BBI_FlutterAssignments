import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/features/news/data/data_sources/news_data_source.dart';
import 'package:news_app/features/news/data/models/news.dart';

// Mock the http client
class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NewsRemoteDataSourceImpl dataSource;
  late http.Client mockHttpClient;

  setUpAll(() {
    // Register a fallback value for Uri
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  const String baseUrl = 'https://newsapi.org/v2/everything';
  const String query = 'flutter';
  const String language = 'en';
  const String sortBy = 'publishedAt';
  const int page = 1;
  const int pageSize = 10;
  const String apiKey = 'testApiKey'; // Simulated API key

  setUp(() async {
    // Initialize dotenv to load environment variables
    await dotenv.load(); // Load the environment variables before using them

    // Manually set the environment variable for testing
    dotenv.env['API_KEY'] = apiKey;

    mockHttpClient = MockHttpClient();
    dataSource = NewsRemoteDataSourceImpl(mockHttpClient);
  });

  group('fetchNews', () {
    test('should return a list of NewsArticle when the response is successful',
        () async {
      // Arrange: Simulate a successful API response
      final mockResponse = {
        'status': 'ok',
        'totalResults': 2,
        'articles': [
          {
            'title': 'Flutter 3 Released',
            'description': 'The latest version of Flutter has been released.',
            'urlToImage': 'https://example.com/flutter.jpg',
            'publishedAt': '2021-01-01',
          },
          {
            'title': 'Dart 2.13 Released',
            'description': 'Dart 2.13 is now available with new features.',
            'urlToImage': 'https://example.com/dart.jpg',
            'publishedAt': '2021-01-02',
          }
        ]
      };

      // Mock the behavior of the http client to return a successful response
      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response(jsonEncode(mockResponse), 200),
      );

      // Act: Call fetchNews method with mock parameters
      final result = await dataSource.fetchNews(
        query: query,
        page: page,
        pageSize: pageSize,
      );

      // Assert: Check if the result matches expected data
      expect(result, isA<List<NewsArticle>>());
      expect(result.length, 2);
      expect(result[0].title, 'Flutter 3 Released');
      expect(result[1].title, 'Dart 2.13 Released');

     
      // Verify that http.get was called with the correct URL
      verify(() => mockHttpClient.get(
        Uri.parse(
          '$baseUrl?q=${  Uri.encodeQueryComponent(query) }&from=2024-11-20&language=$language&sortBy=$sortBy&apiKey=$apiKey&page=$page&pageSize=$pageSize',
        ),
      )).called(1);

   

    });

    test('should throw an exception when the status code is not 200', () async {
      // Arrange: Create a mock response with a non-200 status code
      final mockErrorResponse = {
        'status': 'error',
        'message': 'Invalid API key'
      };

      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response(jsonEncode(mockErrorResponse),
            401), // Simulating a 401 Unauthorized error
      );

      // Act & Assert: Ensure the exception is thrown
      expect(
        () async => await dataSource.fetchNews(
          query: query,
          page: page,
          pageSize: pageSize,
        ),
        throwsException,
      );

      // Verify that http.get was called once
      verify(() => mockHttpClient.get(any())).called(1);
    });

    test(
        'should throw an exception when an error occurs during the HTTP request',
        () async {
      // Arrange: Simulate a network error by making the http.get throw an exception
      when(() => mockHttpClient.get(any()))
          .thenThrow(Exception('Network error'));

      // Act & Assert: Ensure the exception is thrown
      expect(
        () async => await dataSource.fetchNews(
          query: query,
          page: page,
          pageSize: pageSize,
        ),
        throwsException,
      );

      // Verify that http.get was called once
      verify(() => mockHttpClient.get(any())).called(1);
    });
  });
}
