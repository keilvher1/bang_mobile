import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TagSelectionProvider extends ChangeNotifier {
  final Set<String> _selectedTags = {};
  final List<int> _tagIds = [];

  Set<String> get selectedTags => _selectedTags;
  List<int> get tagIds => _tagIds;

  void toggleTag(String tag, int tagId) {
    debugPrint("Toggling tag: $tag");
    debugPrint("Current selected tags: $_selectedTags");
    if (_selectedTags.contains(tag)) {
      _selectedTags.remove(tag);
      _tagIds.remove(tagId);
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
      _tagIds.add(tagId);
    }
    notifyListeners();
  }

  void clearTags() {
    debugPrint("Clearing selected tags");
    _selectedTags.clear();
    notifyListeners();
  }
}
