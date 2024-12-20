import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/features/news/domain/usecases/get_all_news.dart';
import 'package:news_app/features/news/presentation/bloc/news_bloc.dart';
import 'package:news_app/features/news/presentation/bloc/news_event.dart';
import 'package:news_app/service_locator.dart';
import 'package:news_app/features/news/presentation/pages/NewsList.dart';

void main() {
  setUpAll(() async {
    // Load .env and setup service locator
    await dotenv.load(fileName: ".env");
    setupLocator();
  });

 testWidgets('toggle theme and check icon change', (WidgetTester tester) async {
  bool isDarkMode = false;

  // Helper function to build the app with the given theme
  Widget createApp({required bool isDarkMode}) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: BlocProvider<NewsBloc>(       
        create: (_) => NewsBloc(getAllNews: locator<GetAllNews>())..add(FetchAllNewsEvent()),
        child: NewsList(),
      ),
    );
  }

  // Build the app with light mode initially
  await tester.pumpWidget(createApp(isDarkMode: isDarkMode));

  // Check that the app starts in light mode
  expect(find.byWidgetPredicate(
    (widget) => widget is MaterialApp && widget.theme == ThemeData.light(),
  ), findsOneWidget);

  // Ensure the light mode icon (sun) is present
  expect(find.byIcon(Icons.wb_sunny), findsOneWidget);

  // Tap the theme toggle button to switch to dark mode
  await tester.tap(find.byIcon(Icons.wb_sunny)); 
  await tester.pumpAndSettle(); 

  // After toggle, the theme should switch to dark mode
  expect(find.byIcon(Icons.nightlight_round), findsOneWidget);

  // expect(find.byWidgetPredicate(
  //   (widget) => widget is MaterialApp && widget.theme == ThemeData.dark(),
  // ), findsOneWidget);

  // Ensure the dark mode icon (moon) is present

  // Tap the theme toggle button to switch back to light mode
  await tester.tap(find.byIcon(Icons.nightlight_round));  // Tap the dark mode (moon) icon to toggle
  await tester.pumpAndSettle();

  // After toggle back, the theme should switch to light mode
  // expect(find.byWidgetPredicate(
  //   (widget) => widget is MaterialApp && widget.theme == ThemeData.light(),
  // ), findsOneWidget);

  // Ensure the light mode icon (sun) is back
  expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
});
}