import 'package:flutter/material.dart';
import 'package:scrd/provider/theme_provider.dart';
import '../model/theme.dart';
import '../utils/api_server.dart';
import 'filter_provider.dart';

class FilterThemeProvider with ChangeNotifier {
  List<dynamic> _filteredThemes = [];
  List<dynamic> get filteredThemes => _filteredThemes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchFilteredThemes(FilterProvider filterProvider) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final List<dynamic> jsonList = await ApiService().fetchFilteredThemeLists(
        horror: filterProvider.horror,
        activity: filterProvider.activity,
        region: filterProvider.region,
        levelMin: filterProvider.levelMin,
        levelMax: filterProvider.levelMax,
        selectedDate: ThemeProvider().selectedDate,
      );

      _filteredThemes =
          jsonList.map((json) => ThemeModel.fromJson(json)).toList();
      debugPrint("✅ Filtered themes loaded: ${_filteredThemes.length}개");
    } catch (e) {
      debugPrint('❌ Error fetching filtered themes: $e');
      _filteredThemes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearFilteredThemes() {
    _filteredThemes = [];
    notifyListeners();
  }
}
