import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeKey = 'is_dark_mode';
  final SharedPreferences prefs;

  ThemeCubit({required this.prefs}) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final isDark = prefs.getBool(_themeKey);
    if (isDark != null) {
      emit(isDark ? ThemeMode.dark : ThemeMode.light);
    }
  }

  void toggleTheme() {
    final isCurrentlyDark = state == ThemeMode.dark;
    final newMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;

    prefs.setBool(_themeKey, newMode == ThemeMode.dark);
    emit(newMode);
  }
}
