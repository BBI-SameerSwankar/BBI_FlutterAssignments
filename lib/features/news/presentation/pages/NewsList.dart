import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/config/api_config.dart';
import 'package:news_app/core/theme/theme.dart';
import 'package:news_app/features/news/presentation/bloc/news_bloc.dart';
import 'package:news_app/features/news/presentation/bloc/news_event.dart';
import 'package:news_app/features/news/presentation/bloc/news_state.dart';
import 'package:news_app/features/news/presentation/widget/news/news_item.dart';
import 'package:news_app/service_locator.dart';

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  bool isDarkMode = true;
  int page = 1;
  int pageSize = 10;
  String searchParam="";
  late ScrollController _scrollController;
  bool _isScrolledToTop = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  void setSearchParam(String s){
    searchParam = s;
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

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }

    if (_scrollController.position.pixels > 200) {
      setState(() {
        _isScrolledToTop = true;
      });
    } else {
      setState(() {
        _isScrolledToTop = false;
      });
    }
  }

  void _loadMoreData() {
    if (page == APIConstants.NEWS_PAGE_LIMIT) {
      return;
    }
    page++;
    if(searchParam == "")
    {
    context.read<NewsBloc>().add(FetchAllNewsEvent(page: page, pageSize: pageSize));
    }
    else{

    context.read<NewsBloc>().add(FetchAllNewsEvent(page: page, pageSize: pageSize, query: searchParam));
    }
  }

  Future<void> _onRefresh(BuildContext context) async {
    setState(() {
      page = 1;
    });
    locator<NewsBloc>().add(FetchAllNewsEvent(page: page, pageSize: pageSize, query: _searchController.text));
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onSearchChanged(String query) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        page = 1; 
      });
      if(query == "")
      {
      context.read<NewsBloc>().add(FetchAllNewsEvent(page: page, pageSize: pageSize));
      }
      else{
      context.read<NewsBloc>().add(FetchAllNewsEvent(page: page, pageSize: pageSize,query: query));

      }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Themes.darkTheme.background : Themes.lightTheme.background,
      appBar: AppBar(
        title: const Text('News List', style: TextStyle(color: Colors.white)),
        backgroundColor: isDarkMode ? Themes.darkTheme.appBar : Themes.lightTheme.appBar,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: Colors.white,
            ),
            onPressed: _toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NewsSearchDelegate(_onSearchChanged, setSearchParam),
              );
            },
          ),
        ],
      ),
      body: 
      BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading && page == 1) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsError) {
            return Center(
              child: Text('Error: ${state.message}', style: TextStyle(color: Colors.red)),
            );
          } else if (state is NewsLoaded) {
            return RefreshIndicator(
              onRefresh: () => _onRefresh(context),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: (state.page == APIConstants.NEWS_PAGE_LIMIT  && state.newsList.length > 0 )
                    ? state.newsList.length
                    : state.newsList.length + 1,
                itemBuilder: (context, index) {
                  if (index == state.newsList.length) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    final newsArticle = state.newsList[index];
                    return NewsItemWidget(newsArticle: newsArticle, isDarkMode: isDarkMode);
                  }
                },
              ),
            );
          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
      
      floatingActionButton: _isScrolledToTop
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward),
            )
          : null,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}

class NewsSearchDelegate extends SearchDelegate {
  final Function(String) onSearchChanged;
  final Function(String) setSearchParam;

  NewsSearchDelegate(this.onSearchChanged, this.setSearchParam);

  @override
  String? get searchFieldLabel => 'Search News...';

  @override
  TextInputAction get textInputAction => TextInputAction.search;

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back), 
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();  
  }

 @override
Widget buildResults(BuildContext context) {
 
  WidgetsBinding.instance.addPostFrameCallback((_) {
    onSearchChanged(query); 
    setSearchParam(query);
    Navigator.pop(context);   
  });


  return Center(child: CircularProgressIndicator());
}

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; 
        },
      ),
    ];
  }
}
