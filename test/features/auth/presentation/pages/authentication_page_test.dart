import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/features/auth/presentation/bloc/auth.state.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_app/features/auth/presentation/pages/authentication_page.dart';
import 'package:task_app/features/task/presentation/pages/tast_screen.dart';


class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();

    // Provide an initial state for the mock AuthBloc
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
  });

  tearDown(() {
    mockAuthBloc.close();
  });

  Widget createTestableWidget(Widget child) {
    return BlocProvider<AuthBloc>(
      create: (_) => mockAuthBloc,
      child: MaterialApp(
        home: child,
      ),
    );
  }


  testWidgets('AuthScreen displays app bar and buttons', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(const AuthenticationPage()));

    // Verify the app bar title
    expect(find.text("Authentication"), findsOneWidget);

    // Verify the presence of buttons
    expect(find.text("Create"), findsOneWidget);
    expect(find.text("Login"), findsOneWidget);
  });

  
  test("testing if create user is present", ()async{

  });



  //     testWidgets('Create button is tappable and emits event', (WidgetTester tester) async {
  //   await tester.pumpWidget(createTestableWidget(const AuthenticationPage()));

  //   // Tap on the "Add User" button
  //   await tester.tap(find.text("Create"));
  //   await tester.pump();

  //   // Verify that the "Add User" button is still present
  //   expect(find.byType(TaskScreen), findsOneWidget);
  // });
  


}