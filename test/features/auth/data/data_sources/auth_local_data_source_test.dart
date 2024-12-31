import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/features/auth/data/data_sources/auth_local_data_source.dart';

// Import your AuthLocalDataSource classes

// Create a Mock for SharedPreferences using Mocktail
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthLocalDataSourceImpl authLocalDataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    // Initialize the mock and the class to be tested
    mockSharedPreferences = MockSharedPreferences();
    authLocalDataSource = AuthLocalDataSourceImpl(mockSharedPreferences);
  });

  group('AuthLocalDataSourceImpl', () {
    test('saveUserId should save userId to SharedPreferences', () async {
      // Arrange
      const userId = '12345';
      when(() => mockSharedPreferences.setString('user_id', userId))
          .thenAnswer((_) async => true);

      // Act
      await authLocalDataSource.saveUserId(userId);

      // Assert
      verify(() => mockSharedPreferences.setString('user_id', userId))
          .called(1);
    });

    test('getUserId should return the saved userId from SharedPreferences', () async {
      // Arrange
      const userId = '12345';
      when(() => mockSharedPreferences.getString('user_id'))
          .thenReturn(userId);

      // Act
      final result = await authLocalDataSource.getUserId();

      // Assert
      expect(result, userId);
      verify(() => mockSharedPreferences.getString('user_id')).called(1);
    });

    test('clearUserId should remove the userId from SharedPreferences', () async {
      // Arrange
      when(() => mockSharedPreferences.remove('user_id'))
          .thenAnswer((_) async => true);

      // Act
      await authLocalDataSource.clearUserId();

      // Assert
      verify(() => mockSharedPreferences.remove('user_id')).called(1);
    });
  });
}
