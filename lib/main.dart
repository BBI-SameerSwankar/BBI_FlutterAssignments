import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/theme/theme.dart';
import 'package:news_app/features/news/domain/usecases/get_all_news.dart';
import 'package:news_app/features/news/presentation/bloc/news_bloc.dart';
import 'package:news_app/features/news/presentation/bloc/news_event.dart';
import 'package:news_app/features/news/presentation/pages/NewsList.dart';
import 'package:news_app/service_locator.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  bool isDarkMode = await Themes.loadTheme();

  runApp(MainApp(isDarkMode: isDarkMode));
}


class MainApp extends StatelessWidget {
  // const MainApp({super.key});

   final bool isDarkMode;

  const MainApp({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: BlocProvider<NewsBloc>(
        create: (_) => NewsBloc(getAllNews: locator<GetAllNews>() )..add(FetchAllNewsEvent()) ,
        child: NewsList(), 
      ),
    );
  }
}
