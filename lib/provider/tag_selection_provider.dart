import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TagSelectionProvider extends ChangeNotifier {
  final Set<String> _selectedTags = {};

  Set<String> get selectedTags => _selectedTags;

  void toggleTag(String tag) {
    if (_selectedTags.contains(tag)) {
      _selectedTags.remove(tag);
    } else {
      if (_selectedTags.length >= 5) {
        Fluttertoast.showToast(
          msg: "태그는 최대 5개까지 선택할 수 있습니다.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 13,
        );
        return;
      }
      _selectedTags.add(tag);
    }
    notifyListeners();
  }

  void clearTags() {
    _selectedTags.clear();
    notifyListeners();
  }
}
