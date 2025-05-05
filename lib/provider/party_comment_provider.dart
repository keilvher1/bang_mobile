import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scrd/utils/endpoint.dart';

import '../auth/secure_storage.dart';
import '../model/party_comment.dart';
import 'package:http/http.dart' as http;

import '../utils/api_server.dart';

class PartyCommentProvider with ChangeNotifier {
  List<PartyComment> _comments = [];
  bool _isLoading = false;
  final SecureStorage secureStorage = SecureStorage();
  List<PartyComment> get comments => _comments;
  bool get isLoading => _isLoading;

  Future<void> fetchComments(int partyId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final accessToken = await secureStorage.readToken("x-access-token");

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("No access token found.");
      }
      final uri =
          Uri.parse('${ApiConstants.baseUrl}/scrd/api/party/comment/$partyId');
      final response = await http.get(uri, headers: {
        "Authorization": "Bearer $accessToken",
        // 'Accept': 'application/json',
      });
      debugPrint("URL: $uri");

      if (response.statusCode == 200) {
        debugPrint("Response: ${response.body}");
        final decoded = jsonDecode(utf8.decode(response.bodyBytes)) as List;
        _comments = decoded.map((e) => PartyComment.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      debugPrint('Error: $e');
      _comments = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> postComment({
    required int postId,
    int? parentId,
    required String content,
  }) async {
    try {
      final SecureStorage secureStorage = SecureStorage();
      final accessToken = await secureStorage.readToken("x-access-token");
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/scrd/api/party/comment'),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "postId": postId,
          "parentId": parentId,
          "content": content,
        }),
      );

      if (response.statusCode == 200) {
        await fetchComments(postId); // 댓글 새로고침
        return true;
      } else {
        debugPrint("Failed to post comment: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Exception posting comment: $e");
      return false;
    }
  }

  Future<void> deleteComment(int commentId) async {
    try {
      final success = await ApiService().deleteComment(commentId);
      if (success) {
        _comments.removeWhere((c) => c.id == commentId);
        notifyListeners();
      } else {
        throw Exception("댓글 삭제 실패");
      }
    } catch (e) {
      debugPrint("댓글 삭제 에러: $e");
    }
  }
}
