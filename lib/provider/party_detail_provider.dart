import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../auth/secure_storage.dart';
import '../model/partyDetail.dart';
import '../utils/api_server.dart';
import '../utils/endpoint.dart';
import 'package:http/http.dart' as http;

class PartyDetailProvider extends ChangeNotifier {
  PartyDetail? party;
  bool isLoading = false;
  String? error;

  Future<void> loadParty(int postId) async {
    isLoading = true;
    notifyListeners();

    try {
      party = await ApiService().fetchPartyDetail(postId);
      error = null;
    } catch (e) {
      error = e.toString();
      party = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPartyDetail(int partyId) async {
    isLoading = true;
    notifyListeners();
    final SecureStorage secureStorage = SecureStorage();
    try {
      final accessToken = await secureStorage.readToken("x-access-token");
      final uri = Uri.parse('${ApiConstants.baseUrl}/scrd/api/party/$partyId');
      final response = await http.get(uri, headers: {
        "Authorization": "Bearer $accessToken",
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> json = jsonDecode(decoded);
        final data = json['data'];
        party = PartyDetail.fromJson(data);
      } else {
        throw Exception("Failed to fetch party detail");
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
