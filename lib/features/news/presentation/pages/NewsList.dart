import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/theme/theme.dart';
import 'package:news_app/features/news/presentation/bloc/news_bloc.dart';
import 'package:news_app/features/news/presentation/bloc/news_event.dart';
import 'package:news_app/features/news/presentation/bloc/news_state.dart';
import 'package:news_app/features/news/presentation/widget/news_item.dart';

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  bool isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _loadTheme(); 
  }

  void _loadTheme() async {
    isDarkMode = await Themes.loadTheme();
    setState(() {});
  }


  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    Themes.saveTheme(isDarkMode);
  }

  Future<void> _onRefresh(BuildContext context) async {
    context.read<NewsBloc>().add(FetchAllNewsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Themes.darkTheme.background : Themes.lightTheme.background,
      appBar: AppBar(
        title: const Text('News List',style: TextStyle(color: Colors.white),),
        backgroundColor: isDarkMode ? Themes.darkTheme.appBar : Themes.lightTheme.appBar,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: Colors.white,
            ),
            onPressed: _toggleTheme, 
          ),
        ],
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsError) {
            return Center(
              child: Text('Error: ${state.message}', style: TextStyle(color: Colors.red)),
            );
          } else if (state is NewsLoaded) {
            return RefreshIndicator(
              onRefresh: () => _onRefresh(context),
              child: ListView.builder(
                itemCount: state.newsList.length,
                itemBuilder: (context, index) {
                  final newsArticle = state.newsList[index];
                  return NewsItemWidget(newsArticle: newsArticle);
                },
              ),
            );
          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}
