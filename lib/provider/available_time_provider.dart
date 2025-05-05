import 'package:flutter/material.dart';
import '../utils/api_server.dart';

class AvailableTimeProvider with ChangeNotifier {
  final Map<int, List<String>> _themeAvailableTimes = {};

  List<String> getAvailableTimes(int themeId) {
    return _themeAvailableTimes[themeId] ?? [];
  }

  Future<void> fetchAvailableTimes(int themeId, String date) async {
    final times = await ApiService().fetchAvailableTimes(themeId, date);
    _themeAvailableTimes[themeId] = times;
    notifyListeners();
  }
}
