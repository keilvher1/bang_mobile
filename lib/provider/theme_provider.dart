import 'package:flutter/material.dart';

import '../model/theme.dart';
import '../utils/api_server.dart';

class ThemeProvider with ChangeNotifier {
  List<ThemeModel> _themeList = [];
  bool _isLoading = false;

  List<ThemeModel> get themeList => _themeList;
  bool get isLoading => _isLoading;

  Future<void> fetchTheme() async {
    _isLoading = true;
    notifyListeners();
    try {
      List<dynamic> response = await ApiService().fetchThemeLists();
      _themeList = response.map((json) => ThemeModel.fromJson(json)).toList();
    } catch (e) {
      print("Error fetching theme list: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchFilteredThemes(Map<String, dynamic> filters) async {
    _isLoading = true;
    notifyListeners();
    try {
      List<dynamic> response = await ApiService().fetchFilteredThemes(filters);
      _themeList = response.map((json) => ThemeModel.fromJson(json)).toList();
    } catch (e) {
      print("Error fetching filtered themes: $e");
    }
    _isLoading = false;
    notifyListeners();
  }
}
