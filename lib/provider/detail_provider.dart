import 'package:flutter/material.dart';
import '../model/detail.dart';
import '../utils/api_server.dart';

class ThemeDetailProvider with ChangeNotifier {
  ThemeDetail? _themeDetail;
  ThemeDetail? get themeDetail => _themeDetail;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchThemeDetail(int themeId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _themeDetail = await ApiService().fetchThemeDetail(themeId);
    } catch (e) {
      debugPrint("ThemeDetail 불러오기 실패: $e");
      _themeDetail = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _themeDetail = null;
    notifyListeners();
  }
}
