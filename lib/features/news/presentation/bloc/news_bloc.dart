import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:news_app/core/error/failure.dart';
import 'package:news_app/features/news/data/models/news.dart';
import 'package:news_app/features/news/domain/usecases/get_all_news.dart';
import 'package:news_app/features/news/presentation/bloc/news_event.dart';
import 'package:news_app/features/news/presentation/bloc/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetAllNews getAllNews;

  NewsBloc({required this.getAllNews}) : super(NewsInitial()) {
    on<FetchAllNewsEvent>(_onFetchAllNews);
  }

  Future<void> _onFetchAllNews(FetchAllNewsEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoading());

    try {
      final Either<Failure, List<NewsArticle>> result = await getAllNews();

      result.fold(
        (failure) {
          emit(NewsError(failure.message));  // Handle the failure message
        },
        (newsList) {
          emit(NewsLoaded(newsList));  // Emit the list of news
        },
      );
    } catch (e) {
      
      emit(NewsError('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
