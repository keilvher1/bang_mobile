import 'package:flutter/material.dart';
import '../model/theme.dart';

enum UploadMode { recruitment, review }

class SelectThemeProvider with ChangeNotifier {
  ThemeModel? _selectedTheme;
  UploadMode _selectedMode = UploadMode.recruitment;

  ThemeModel? get selectedTheme => _selectedTheme;
  UploadMode get selectedMode => _selectedMode;

  void selectTheme(ThemeModel theme) {
    _selectedTheme = theme;
    notifyListeners();
  }

  void setMode(UploadMode mode) {
    _selectedMode = mode;
    notifyListeners();
  }

  void clearSelectedTheme() {
    _selectedTheme = null;
    notifyListeners();
  }
}
