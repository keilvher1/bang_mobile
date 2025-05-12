import 'package:flutter/material.dart';

import '../utils/api_server.dart';

class PartyJoinProvider extends ChangeNotifier {
  bool isJoining = false;
  bool joinSuccess = false;
  bool hasJoined = false;

  Future<void> joinParty(int postId) async {
    isJoining = true;
    notifyListeners();

    try {
      final result = await ApiService().joinParty(postId);
      joinSuccess = result;
    } catch (e) {
      debugPrint('Join error: $e');
      joinSuccess = false;
    }

    isJoining = false;
    notifyListeners();
  }

  Future<void> cancelJoinParty(int postId) async {
    isJoining = true;
    notifyListeners();
    try {
      final result = await ApiService().cancelJoinParty(postId);
      joinSuccess = result;
    } catch (_) {
      joinSuccess = false;
    }
    isJoining = false;
    notifyListeners();
  }

  Future<void> toggleJoin(int postId) async {
    isJoining = true;
    notifyListeners();

    try {
      final result = await ApiService().toggleJoinParty(postId);
      hasJoined = result;
    } catch (e) {
      debugPrint("Toggle join failed: $e");
    } finally {
      isJoining = false;
      notifyListeners();
    }
  }
}
