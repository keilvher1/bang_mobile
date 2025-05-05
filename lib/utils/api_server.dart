import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../auth/secure_storage.dart';
import '../model/detail.dart';
import '../model/party.dart';
import '../model/partyDetail.dart';
import '../model/review.dart';
import '../model/saved_theme_model.dart';
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

  // api_server.dart
  Future<List<dynamic>> fetchThemePaged({
    required int page,
    required int size,
    String? platform = 'mobile',
    String? date,
  }) async {
    final accessToken = await secureStorage.readToken("x-access-token");

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}/scrd/api/theme/paged?page=$page&size=20&platform=$platform${date != null ? '&date=$date' : ''}',
    );
    debugPrint("Request URL: $uri");

    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json",
        "Origin": ApiConstants.baseUrl,
      },
    );

    if (response.statusCode == 200) {
      debugPrint("Response: ${response.body}");
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load paged themes");
    }
  }

  Future<ThemeDetail> fetchThemeDetail(int id) async {
    final accessToken = await secureStorage.readToken("x-access-token");

    final url = "${ApiConstants.themeDetail}/$id";
    debugPrint("Request URL: $url"); // 요청 URL 확인
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json; charset=UTF-8",
        "Origin": ApiConstants.baseUrl,
      },
    );
    debugPrint("ResponseCode: ${response.statusCode}");
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)); // <- 한글 깨짐 방지
      debugPrint("ResponseBody: $data");
      return ThemeDetail.fromJson(data);
    } else {
      throw Exception('Failed to load theme detail');
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
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to fetch filtered themes");
      }
    } catch (e) {
      throw Exception("Failed to fetch filtered themes: $e");
    }
  }

  Future<List<dynamic>> fetchFilteredThemeLists({
    int? horror,
    int? activity,
    String? region,
    double? levelMin,
    double? levelMax,
    DateTime? selectedDate,
  }) async {
    try {
      final accessToken = await secureStorage.readToken("x-access-token");

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("No access token found.");
      }

      // Query parameters
      Map<String, String> queryParameters = {};
      if (horror != null) queryParameters['horror'] = horror.toString();
      if (activity != null) queryParameters['activity'] = activity.toString();
      if (region != null && region != "전체") {
        queryParameters['location'] = region;
      }
      if (levelMin != null) queryParameters['levelMin'] = levelMin.toString();
      if (levelMax != null) queryParameters['levelMax'] = levelMax.toString();

      // URI 구성
      final String formattedDate =
          DateFormat('yyyy-MM-dd').format(selectedDate ?? DateTime.now());
      Uri uri;

      if (queryParameters.isEmpty) {
        uri = Uri.parse(
          '${ApiConstants.baseUrl}/scrd/api/theme/paged?page=0&size=20&platform=mobile&date=$formattedDate',
        );
      } else {
        uri = Uri.http(
          ApiConstants.baseHost,
          '/scrd/api/theme/filter',
          queryParameters,
        );
      }

      debugPrint("Filtered Request URL: $uri");

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Accept": "application/json",
          "Origin": ApiConstants.baseUrl,
        },
      );

      debugPrint("Filtered Response Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        try {
          debugPrint("Response: ${response.body}");
          return jsonDecode(response.body);
        } catch (e) {
          debugPrint("❗ JSON decoding error: $e");
          throw Exception("JSON decoding failed");
        }
      } else {
        throw Exception("Failed to fetch themes: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Exception during filter fetch: $e");
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
      debugPrint("ResponseCode: ${response.statusCode}");

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        debugPrint("ResponseBody: $decodedBody");
        final List<dynamic> jsonList = jsonDecode(decodedBody);
        return jsonList.map((json) {
          if (json is Map<String, dynamic>) {
            return SavedThemeModel.fromJson(json);
          } else if (json is SavedThemeModel) {
            return json;
          } else {
            throw Exception("Unexpected type: ${json.runtimeType}");
          }
        }).toList();
      } else {
        throw Exception("Failed to load saved themes: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching saved themes: $e");
      throw Exception("Failed to fetch saved themes");
    }
  }

  Future<bool> saveTheme(int themeId) async {
    try {
      final token = await secureStorage.readToken("x-access-token"); // 토큰 가져오기
      if (token == null || token.isEmpty) {
        throw Exception("No access token found.");
      }
      final response = await http.post(
        Uri.parse(
          '${ApiConstants.baseUrl}/scrd/api/save/$themeId',
        ),
        headers: {
          "Authorization": "Bearer $token", // ✅ 헤더에 꼭 Bearer 토큰 넣기
          "Accept": "application/json",
          "Origin": ApiConstants.baseUrl,
        },
      );
      debugPrint('Authorization Header: Bearer $token');
      debugPrint("'uri: ${ApiConstants.baseUrl}/scrd/api/save/$themeId'");
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('Failed to save theme: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Exception saving theme: $e');
      return false;
    }
  }

  Future<List<String>> fetchAvailableTimes(int themeId, String date) async {
    try {
      final accessToken = await secureStorage.readToken("x-access-token");
      final uri = Uri.parse(
          'http://localhost:8080/scrd/api/theme/$themeId/available-times?date=$date');

      final response = await http.get(uri, headers: {
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        final times = List<String>.from(json['availableTime']);
        return times;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching available times: $e');
      return [];
    }
  }

  Future<List<dynamic>> searchThemes(String keyword) async {
    try {
      final accessToken = await secureStorage.readToken("x-access-token");

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("No access token found.");
      }

      final uri = Uri.parse(
          '${ApiConstants.baseUrl}/scrd/api/theme/search?keyword=$keyword');
      debugPrint("Search Request URL: $uri");

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Accept": "application/json",
          "Origin": ApiConstants.baseUrl,
        },
      );

      debugPrint("Search ResponseCode: ${response.statusCode}");

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        debugPrint("Search ResponseBody: $decodedBody");
        return jsonDecode(response.body); // List<dynamic> 반환
      } else {
        throw Exception("Failed to search themes: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Exception searching themes: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> postJson({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final accessToken = await secureStorage.readToken("x-access-token");

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception("No access token found.");
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to post: ${response.body}');
    }
  }

  Future<List<Party>> fetchPartyPagedList({int page = 0, int size = 10}) async {
    try {
      final accessToken = await secureStorage.readToken("x-access-token");

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("No access token found.");
      }

      final uri = Uri.parse(
          '${ApiConstants.baseUrl}/scrd/api/party/paged?page=$page&size=$size');
      debugPrint("Party Request URL: $uri");

      final response = await http.get(uri, headers: {
        "Authorization": "Bearer $accessToken",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      });

      debugPrint("Party ResponseCode: ${response.statusCode}");

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        debugPrint("Party ResponseBody: $decodedBody");

        final Map<String, dynamic> body = jsonDecode(decodedBody);
        final List<dynamic> partyList = body['data'];

        return partyList.map((json) => Party.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch party list: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Exception fetching party list: $e");
      return [];
    }
  }

  Future<PartyDetail> fetchPartyDetail(int postId) async {
    final accessToken = await secureStorage.readToken("x-access-token");

    final uri = Uri.parse("${ApiConstants.baseUrl}/scrd/api/party/$postId");
    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json",
        "Origin": ApiConstants.baseUrl,
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return PartyDetail.fromJson(decoded['data']);
    } else {
      throw Exception("Failed to fetch party detail");
    }
  }

  Future<bool> deleteComment(int commentId) async {
    final accessToken = await secureStorage.readToken("x-access-token");
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception("No access token found.");
    }

    final uri =
        Uri.parse('${ApiConstants.baseUrl}/scrd/api/party/comment/$commentId');

    debugPrint("Delete Comment URL: $uri");
    final response = await http.delete(
      uri,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json",
      },
    );
    debugPrint("Delete Comment ResponseCode: ${response.statusCode}");

    return response.statusCode == 200;
  }
}
