import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/saved_theme_model.dart';
import '../utils/api_server.dart';

class SavedThemeProvider with ChangeNotifier {
  Set<int> _savedThemeIds = {}; // ⭐ 서버에서 받아온 저장된 theme id 집합
  bool _loading = false;
  List<SavedThemeModel> _savedThemes = [];
  List<SavedThemeModel> get savedThemes => _savedThemes;
  Set<int> get savedThemeIds => _savedThemeIds;
  bool get loading => _loading;

  /// ✅ 서버에 요청 없이 빠르게 확인
  bool isSaved(int themeId) {
    return _savedThemeIds.contains(themeId);
  }

  /// ✅ 처음에 저장된 테마 목록을 서버에서 가져와서 로컬에 저장
  Future<void> fetchAndSetSavedThemes({DateTime? date}) async {
    try {
      _loading = true;
      notifyListeners();
      var formatted = DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
      final savedThemes = await ApiService().fetchSavedThemes(date: formatted);
      _savedThemeIds = savedThemes.map((theme) => theme.id).toSet(); // id만 저장
      final fetchedThemes =
          await ApiService().fetchSavedThemes(date: formatted);
      _savedThemes = fetchedThemes;
    } catch (e) {
      debugPrint('Error fetching saved themes: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// ✅ 저장/삭제 토글
  Future<void> toggleSaveTheme(int themeId) async {
    bool success = await ApiService().saveTheme(themeId); // 서버에 저장/삭제 요청

    if (success) {
      if (_savedThemeIds.contains(themeId)) {
        _savedThemeIds.remove(themeId); // 이미 저장된 경우 -> 제거
      } else {
        _savedThemeIds.add(themeId); // 저장되지 않은 경우 -> 추가
      }
      notifyListeners();
    } else {
      debugPrint("Failed to toggle saved theme: $themeId");
    }
  }
}
