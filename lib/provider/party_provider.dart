import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/party.dart';
import '../utils/api_server.dart';

class PartyProvider with ChangeNotifier {
  List<Party> _parties = [];
  bool _isLoading = false;
  int _currentPage = 0;
  final int _pageSize = 10;
  bool _hasMore = true;

  List<Party> get parties => _parties;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchInitialParties(String? search) async {
    _parties = [];
    _currentPage = 0;
    _hasMore = true;
    await fetchMoreParties(search);
  }

  Future<void> fetchMoreParties(String? search) async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newParties = await ApiService().fetchPartyPagedList(
        page: _currentPage,
        size: _pageSize,
      );

      if (newParties.length < _pageSize) _hasMore = false;

      _parties.addAll(newParties);
      _currentPage++;
    } catch (e) {
      debugPrint('❌ Error fetching parties: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPartyByDeadline(DateTime selectedDate) async {
    final formatted = DateFormat('yyyy-MM-dd').format(selectedDate);
    try {
      debugPrint('Selected date: $formatted');
      final parties = await ApiService().fetchPartiesByDate(formatted);
      debugPrint('Fetched parties: $parties');
      _parties = parties;
      notifyListeners();
    } catch (e) {
      print('날짜 기반 파티 조회 실패: $e');
    }
  }
}
