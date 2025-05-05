import 'package:flutter/material.dart';

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

  Future<void> fetchInitialParties() async {
    _parties = [];
    _currentPage = 0;
    _hasMore = true;
    await fetchMoreParties();
  }

  Future<void> fetchMoreParties() async {
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
}
