import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {
  int? horror; // 0 또는 1
  int? activity; // 0 또는 1
  String? region; // 지역명
  double? levelMin;
  double? levelMax;

  void setHorror(int? value) {
    horror = value;
    notifyListeners();
  }

  void setActivity(int? value) {
    activity = value;
    notifyListeners();
  }

  void setRegion(String? value) {
    region = value;
    notifyListeners();
  }

  void setLevel(double? min, double? max) {
    levelMin = min;
    levelMax = max;
    notifyListeners();
  }

  void clearAll() {
    horror = null;
    activity = null;
    region = null;
    levelMin = null;
    levelMax = null;
    notifyListeners();
  }
}
