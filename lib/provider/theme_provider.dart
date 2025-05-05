import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/theme.dart';
import '../utils/api_server.dart';

// theme_provider.dart
class ThemeProvider with ChangeNotifier {
  DateTime _selectedDate = DateTime.now(); // 기본값 오늘
  DateTime get selectedDate => _selectedDate;
  set selectedDate(DateTime newDate) {
    _selectedDate = newDate;
    notifyListeners(); // 필요한 경우
  }

  final List<dynamic> _themes = [];
  int _currentPage = 0;
  final int _pageSize = 104;
  bool _isLoading = false;
  bool _hasMore = true;

  List<dynamic> get themes => _themes;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> loadInitialThemes({DateTime? date}) async {
    _themes.clear();
    _currentPage = 0;
    _hasMore = true;
    _selectedDate = date ?? DateTime.now();
    debugPrint("Selected date: $_selectedDate");
    await loadMoreThemes();
  }

  Future<void> loadMoreThemes() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final newThemeJsonList = await ApiService().fetchThemePaged(
        page: _currentPage,
        size: _pageSize,
        date: formattedDate,
      );

      final newThemes =
          newThemeJsonList.map((json) => ThemeModel.fromJson(json)).toList();
      _themes.addAll(newThemes);
      _currentPage++;
    } catch (e) {
      debugPrint("Error loading more themes: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class PaginationParams {
  final int? take;
  final String? customCursor;

  const PaginationParams({
    this.take,
    this.customCursor,
  });

  Map<String, dynamic> toJson() => {
        'take': take,
        'cursor': customCursor,
      };
}
