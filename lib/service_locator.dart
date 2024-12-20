import 'package:get_it/get_it.dart';

import 'package:news_app/features/news/data/repository/news_repository_impl.dart';
import 'package:news_app/features/news/domain/repository/news_repository.dart';
import 'package:news_app/features/news/data/data_sources/news_data_source.dart';
import 'package:news_app/features/news/domain/usecases/get_all_news.dart';
import 'package:news_app/features/news/presentation/bloc/news_bloc.dart';
import 'package:http/http.dart' as http;
// Initialize GetIt
final locator = GetIt.instance;

void setupLocator() {


  // Register DataSource
  locator.registerLazySingleton<NewsRemoteDataSource>(() => NewsRemoteDataSourceImpl(http.Client()));

  // Register Repository
  locator.registerLazySingleton<NewsRepository>(() => NewsRepositoryImpl(locator()));

  // Register UseCase
  locator.registerLazySingleton(() => GetAllNews(locator()));

  // Register BLoC
  locator.registerFactory(() => NewsBloc(getAllNews: locator()));
}
