import 'package:flutter/material.dart';
import 'package:scrd/utils/api_server.dart';

import '../model/party_join_notification.dart';

class NotificationProvider with ChangeNotifier {
  List<PartyJoinNotification> _notifications = [];
  List<PartyJoinNotification> get notifications => _notifications;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _hasPendingNotification = false;

  bool get hasPendingNotification => _hasPendingNotification;

  void setHasPending(bool value) {
    if (_hasPendingNotification != value) {
      _hasPendingNotification = value;
      notifyListeners(); // NavigationBar를 업데이트
    }
  }

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();
    try {
      _notifications = await ApiService().fetchJoinNotifications();
    } catch (e) {
      debugPrint("Notification fetch error: \$e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> initialize(BuildContext context, String token) async {
    debugPrint("Initializing NotificationProvider with token: $token");
    await ApiService().subscribeToSSE(context, token);
  }

  Future<void> respondToJoinRequest(int joinId, String status) async {
    try {
      final success = await ApiService().updateJoinStatus(joinId, status);
      if (success) {
        notifications.removeWhere((n) => n.joinId == joinId);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Join status update error: $e");
    }
  }
}
