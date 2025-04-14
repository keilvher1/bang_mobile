import 'package:flutter/material.dart';
import 'package:scrd/utils/api_server.dart';
import '../model/saved_theme_model.dart';

class SavedThemeProvider with ChangeNotifier {
  List<SavedThemeModel> _savedThemes = [];
  bool _isLoading = false;

  List<SavedThemeModel> get savedThemes => _savedThemes;
  bool get isLoading => _isLoading;

  Future<void> fetchSavedThemes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _savedThemes = await ApiService().fetchSavedThemes();
    } catch (e) {
      _savedThemes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
