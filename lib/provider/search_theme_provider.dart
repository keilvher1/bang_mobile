import 'package:flutter/material.dart';
import 'package:scrd/provider/filter_provider.dart';
import '../model/theme.dart';
import '../utils/api_server.dart';

class SearchThemeProvider extends ChangeNotifier {
  List<ThemeModel> _searchResults = [];
  bool _isLoading = false;
  String _error = '';
  String _keyword = '';
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  List<ThemeModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get error => _error;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  bool _dateSelected = false;
  bool get dateSelected => _dateSelected;

  void setIsSearching(bool isSearching) {
    _isSearching = isSearching;
    notifyListeners();
  }

  void cancelSearch() {
    _isSearching = false;
    notifyListeners();
  }

  void setKeyword(String keyword) {
    _keyword = keyword;
    _isSearching = true;
    notifyListeners();
  }

  void setSearchResults(List<ThemeModel> results) {
    debugPrint("Search results: $results");
    _searchResults = results;
    _isSearching = true;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    _dateSelected = true;
    debugPrint("set date: $_selectedDate");
    searchThemes(
      date: date,
      filterProvider: FilterProvider(),
    );
    notifyListeners();
  }

  Future<void> searchThemes(
      {required DateTime date, required FilterProvider filterProvider}) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final results = await ApiService().searchFilteredThemes(
        keyword: _keyword,
        date: date,
        horror: filterProvider.horror,
        activity: filterProvider.activity,
        location: filterProvider.region,
        levelMin: filterProvider.levelMin,
        levelMax: filterProvider.levelMax,
      );
      _searchResults = results;
    } catch (e) {
      _error = '검색 중 오류가 발생했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearResults() {
    _searchResults = [];
    notifyListeners();
  }
}
