import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

/// --- theme_cubit.dart ---
/// ThemeCubit handles switching between light and dark theme modes.
/// Persists the user's choice using Hive so the theme remains after app restarts.
/// Emits [ThemeMode] for the app UI to respond instantly.
class ThemeCubit extends Cubit<ThemeMode> {
  /// Name of the Hive box storing app settings.
  static const String settingsBox = 'settings';

  /// Key for storing user's theme preference in Hive.
  static const String keyIsDark = 'isDark';

  /// Creates ThemeCubit and loads theme preference on startup.
  ThemeCubit() : super(ThemeMode.system) {
    _load();
  }

  /// Loads saved theme preference from Hive and emits the correct ThemeMode.
  void _load() {
    try {
      final box = Hive.box(settingsBox);
      final isDark = box.get(keyIsDark, defaultValue: false) as bool;
      emit(isDark ? ThemeMode.dark : ThemeMode.light);
    } catch (e) {
      emit(ThemeMode.system);
    }
  }

  /// Toggles theme mode and updates preference in Hive.
  /// Emits new [ThemeMode] immediately so the UI updates, then saves to Hive.
  void toggle() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(next);
    try {
      Hive.box(settingsBox).put(keyIsDark, next == ThemeMode.dark);
    } catch (e) {
      debugPrint('ThemeCubit: Failed to save theme preference: $e');
    }
  }
}
