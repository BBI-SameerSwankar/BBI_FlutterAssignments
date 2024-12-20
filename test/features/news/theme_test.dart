import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/core/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
 // Import your theme config and theme logic file

// Create a mock class for SharedPreferences using mocktail
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {



  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    // Register the mock for the SharedPreferences instance.
    SharedPreferences.setMockInitialValues({'isDarkMode':false});
  });

  group('Themes', () {
    test('saveTheme() should save the theme preference correctly', () async {
      // Arrange
      when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);

      // Act
        await Themes.saveTheme(true); 
       final isDarkMode = await Themes.loadTheme();

      // Assert
      // Assert
      expect(isDarkMode, true);
      // verify(() => mockPrefs.setBool('isDarkMode', true)).called(1);
    });

    test('loadTheme() should return saved theme preference', () async {
      // Arrange
      when(() => mockPrefs.getBool(any())).thenReturn(false); // Return true for dark mode

    
      // Act
      final isDarkMode = await Themes.loadTheme();

      // Assert
      expect(isDarkMode, false);
      // verify(() => mockPrefs.getBool('isDarkMode')).called(1);
    });

    test('loadTheme() should return false when no preference is saved', () async {
      // Arrange
      when(() => mockPrefs.getBool(any())).thenReturn(null); // No value saved

      // Act
      final isDarkMode = await Themes.loadTheme();

      // Assert
      expect(isDarkMode, false); // Default should be false
      // verify(() => mockPrefs.getBool('isDarkMode')).called(1);
    });
  });

  group('ThemeConfig', () {
    test('lightTheme should have correct values', () {
      // Act
      final theme = Themes.lightTheme;

      // Assert
      expect(theme.appBar, Colors.deepPurple);
      expect(theme.background, Colors.purple[50]);
      expect(theme.card, Colors.white);
      expect(theme.mainFont, Colors.black87);
      expect(theme.subFont, Colors.black54);
    });

    test('darkTheme should have correct values', () {
      // Act
      final theme = Themes.darkTheme;

      // Assert
      expect(theme.appBar, Colors.black);
      expect(theme.background, Colors.grey[850]);
      expect(theme.card, Colors.black);
      expect(theme.mainFont, Colors.white);
      expect(theme.subFont, Colors.grey);
    });
  });
}
