import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../auth/secure_storage.dart';
import '../model/review.dart';
import '../model/saved_theme_model.dart';
import '../model/theme.dart';
import 'endpoint.dart';

class ApiService {
  final SecureStorage secureStorage = SecureStorage();

  Future<List<dynamic>> fetchThemeLists() async {
    try {
      final accessToken = await secureStorage.readToken("x-access-token");

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("No access token found.");
      }

      final response = await http.get(
        Uri.parse(ApiConstants.mainList),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Accept": "application/json; charset=UTF-8",
          "Origin": ApiConstants.baseUrl,
        },
      );

      debugPrint("ResponseCode (Theme): ${response.statusCode}");
      debugPrint("ResponseHeaders (Theme): ${response.headers}");

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        return jsonDecode(decodedBody);
      } else {
        debugPrint(
            "Error loading theme list: ${response.statusCode} ${response.body}");
        throw Exception("Failed to load theme list");
      }
    } catch (e) {
      debugPrint("Error fetching theme list: $e");
      throw Exception("Failed to fetch theme list");
    }
  }

  Future<List<dynamic>> fetchReviewLists(int themeId) async {
    try {
      final accessToken = await secureStorage.readToken("x-access-token");

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("No access token found.");
      }

      final response = await http.get(
        Uri.parse("${ApiConstants.reviewList}/theme/$themeId"), // ★ 여기를 수정
        headers: {
          "Authorization": "Bearer $accessToken",
          "Accept": "application/json; charset=UTF-8",
          "Origin": ApiConstants.baseUrl,
        },
      );

      debugPrint("ResponseCode (Review): ${response.statusCode}");
      debugPrint("ResponseBody (Review): ${response.body}");

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        return jsonDecode(decodedBody);
      } else {
        throw Exception("Failed to load reviews");
      }
    } catch (e) {
      debugPrint("Error fetching review list: $e");
      throw Exception("Failed to fetch review list");
    }
  }

  Future<List<dynamic>> fetchFilteredThemes(
      Map<String, dynamic> filters) async {
    try {
      final accessToken = await secureStorage.readToken("x-access-token");

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("No access token found.");
      }

      // 필터 파라미터 붙이기
      final queryParams =
          filters.entries.map((e) => '${e.key}=${e.value}').join('&');

      final response = await http.get(
        Uri.parse("${ApiConstants.filteredThemeList}?$queryParams"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Accept": "application/json; charset=UTF-8",
          "Origin": ApiConstants.baseUrl,
        },
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        return jsonDecode(decodedBody);
      } else {
        throw Exception("Failed to fetch filtered themes");
      }
    } catch (e) {
      throw Exception("Failed to fetch filtered themes: $e");
    }
  }

  Future<List<ThemeModel>> fetchFilteredThemeLists({
    int? horror,
    int? activity,
    String? region,
    double? levelMin,
    double? levelMax,
  }) async {
    try {
      final accessToken = await secureStorage.readToken("x-access-token");
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("No access token found.");
      }

      Map<String, String> queryParameters = {};
      if (horror != null) queryParameters['horror'] = horror.toString();
      if (activity != null) queryParameters['activity'] = activity.toString();
      if (region != null && region != "전체")
        queryParameters['location'] = region; // 🔥 수정
      if (levelMin != null)
        queryParameters['levelMin'] = levelMin.toString(); // 🔥 수정
      if (levelMax != null)
        queryParameters['levelMax'] = levelMax.toString(); // 🔥 수정

      Uri uri = Uri.http(
          ApiConstants.baseHost, '/scrd/api/theme/filter', queryParameters);

      debugPrint("Request URL: $uri"); // 요청 URL 확인
      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Accept": "application/json; charset=UTF-8",
          "Origin": ApiConstants.baseUrl,
        },
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> jsonList = jsonDecode(decodedBody);
        return jsonList.map((json) => ThemeModel.fromJson(json)).toList();
      } else {
        throw Exception(
            "Failed to load filtered themes: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching filtered themes: $e");
      throw Exception("Failed to fetch filtered themes");
    }
  }

  // 내 리뷰 리스트 가져오기
  Future<List<Review>> fetchMyReviewLists(String userId) async {
    // ✅ userId를 받도록 수정
    try {
      final accessToken = await secureStorage.readToken("x-access-token");
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("No access token found.");
      }

      Uri uri = Uri.parse(ApiConstants.myReviewList(userId)); // ✅ userId 넣어서 호출

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Accept": "application/json; charset=UTF-8",
          "Origin": ApiConstants.baseUrl,
        },
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> jsonList = jsonDecode(decodedBody);
        return jsonList.map((json) => Review.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load my reviews: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching my reviews: $e");
      throw Exception("Failed to fetch my reviews");
    }
  }

  Future<List<SavedThemeModel>> fetchSavedThemes() async {
    try {
      final accessToken = await secureStorage.readToken("x-access-token");
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("No access token found.");
      }

      Uri uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.mySavedList}');
      debugPrint("Request URL: $uri"); // 요청 URL 확인

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Accept": "application/json; charset=UTF-8",
          "Origin": ApiConstants.baseUrl,
        },
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> jsonList = jsonDecode(decodedBody);
        return jsonList.map((json) => SavedThemeModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load saved themes: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching saved themes: $e");
      throw Exception("Failed to fetch saved themes");
    }
  }
}
