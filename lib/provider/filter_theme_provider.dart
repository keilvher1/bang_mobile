import 'package:flutter/material.dart';
import '../model/theme.dart';
import '../utils/api_server.dart';
import 'filter_provider.dart';

class FilterThemeProvider with ChangeNotifier {
  List<ThemeModel> _filteredThemes = [];
  List<ThemeModel> get filteredThemes => _filteredThemes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchFilteredThemes(FilterProvider filterProvider) async {
    _isLoading = true;
    notifyListeners();
    try {
      _filteredThemes = await ApiService().fetchFilteredThemeLists(
        horror: filterProvider.horror,
        activity: filterProvider.activity,
        region: filterProvider.region,
        levelMin: filterProvider.levelMin,
        levelMax: filterProvider.levelMax,
      );
    } catch (e) {
      print('Error fetching filtered themes: $e');
      _filteredThemes = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  void clearFilteredThemes() {
    _filteredThemes = [];
    notifyListeners();
  }
}
