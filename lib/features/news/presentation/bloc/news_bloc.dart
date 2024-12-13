import 'package:flutter/material.dart';
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
    print("fetching... ${event.page} ${event.pageSize} query: ${event.query} state as ${state}");

    
    if (state is NewsLoaded) {
      final currentState = state as NewsLoaded;
      if (currentState.query != event.query) {
   
        emit(NewsLoading());
        try {
          final Either<Failure, List<NewsArticle>> result = await getAllNews(1, event.pageSize, event.query);
          result.fold(
            (failure) {
              print("error end");
              emit(NewsError(failure.message));
            
              
            },
            (newsList) {
              print("this is response $newsList");
              emit(NewsLoaded(newsList, 1, event.pageSize, event.query)); 
            },
          );
        } catch (e) {
          emit(NewsError('An unexpected error occurred: ${e.toString()}'));
        }
        return;
      }
    }

  
    if (state is NewsLoading && event.page == 1) {
      emit(NewsLoading());
    }

 
    try {
      final Either<Failure, List<NewsArticle>> result = await getAllNews(event.page, event.pageSize, event.query);

      result.fold(
        (failure) {
          emit(NewsError(failure.message));
        },
        (newsList) {
          if (state is NewsLoaded) {
            final currentState = state as NewsLoaded;
            if (currentState.page != event.page) {
              print("emitting new page... ${event.page} ${event.pageSize}");
              emit(NewsLoaded([...currentState.newsList, ...newsList], event.page, event.pageSize, event.query));
            }
          } else {
            emit(NewsLoaded(newsList, event.page, event.pageSize, event.query));
          }
        },
      );
    } catch (e) {
      emit(NewsError('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
