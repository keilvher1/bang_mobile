import 'package:flutter/material.dart';
import '../model/review.dart';
import '../utils/api_server.dart';

class ReviewProvider with ChangeNotifier {
  List<Review> _reviews = [];
  List<Review> get reviews => _reviews;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchReviews(int themeId) async {
    _isLoading = true;
    notifyListeners();

    try {
      List<dynamic> response = await ApiService().fetchReviewLists(themeId);
      _reviews = response.map((json) => Review.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching review list: $e');
      _reviews = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearReviews() {
    _reviews = [];
    notifyListeners();
  }
}
