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
    if (state is NewsLoading && event.page == 1) {
      emit(NewsLoading());
    }

    print("fetching...  ${event.page} ${event.pageSize}");



    try {
      final Either<Failure, List<NewsArticle>> result = await getAllNews(event.page, event.pageSize);

      
      result.fold(
        (failure) {
          emit(NewsError(failure.message));
        },
        (newsList) {
          if (state is NewsLoaded) {
            
            final currentState = state as NewsLoaded;
            if(currentState.page != event.page)
            {
            print("emmiting..... ${event.page} ${event.pageSize}");
            emit(NewsLoaded([...currentState.newsList, ...newsList], event.page, event.pageSize));

            }
          } else {
           
            emit(NewsLoaded(newsList, event.page, event.pageSize));
          }
        },
      );
    } catch (e) {
      emit(NewsError('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
