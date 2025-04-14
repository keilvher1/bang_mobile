import 'package:flutter/material.dart';
import '../model/review.dart';
import '../utils/api_server.dart';

class MyReviewProvider with ChangeNotifier {
  List<Review> _myReviews = [];
  bool _isLoading = false;

  List<Review> get myReviews => _myReviews;
  bool get isLoading => _isLoading;

  Future<void> fetchMyReviews(String userId) async {
    // ✅ userId 받게 수정
    _isLoading = true;
    notifyListeners();

    try {
      _myReviews = await ApiService().fetchMyReviewLists(userId);
    } catch (e) {
      debugPrint('Error fetching my reviews: $e');
      _myReviews = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
