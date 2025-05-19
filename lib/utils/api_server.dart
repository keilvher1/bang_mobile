import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../auth/secure_storage.dart';
import '../model/detail.dart';
import '../model/party.dart';
import '../model/partyDetail.dart';
import '../model/party_join_notification.dart';
import '../model/region_theme_count.dart';
import '../model/review.dart';
import '../model/saved_theme_model.dart';
import '../model/theme.dart';
import '../provider/notification_provider.dart';
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

      debugPrint("Theme ID: $themeId"); // 디버깅용

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
        final List<dynamic> reviews = jsonDecode(decodedBody);

        // id 기준 내림차순 정렬
        reviews.sort((a, b) => (b['id'] as int).compareTo(a['id'] as int));

        return reviews;
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

      if (queryParameters.isEmpty ||
          ((region == "전체" || region == null) &&
              ((horror == 0 || horror == null) &&
                  (activity == 0 || activity == null) &&
                  (levelMin == 1 || levelMin == null) &&
                  (levelMax == 5 || levelMax == null)))) {
        debugPrint("No filters applied 2");
        uri = Uri.parse(
          '${ApiConstants.baseUrl}/scrd/api/theme/paged?page=0&size=20&platform=mobile&date=$formattedDate',
        );
      } else {
        debugPrint("ApiConstants.baseHost: ${ApiConstants.baseHost}");
        uri = Uri.https(
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

      Uri uri = Uri.parse(ApiConstants.myReviewList("my")); // ✅ userId 넣어서 호출
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
        // final List<dynamic> jsonList = jsonDecode(decodedBody);
        // return jsonList.map((json) => Review.fromJson(json)).toList();
        //final decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> decodedJson = jsonDecode(decodedBody);

// id 기준 내림차순 정렬 후, Review 객체로 매핑
        decodedJson.sort((a, b) => (b['id'] as int).compareTo(a['id'] as int));
        final List<Review> reviewList = decodedJson
            .map((json) => Review.fromJson(json as Map<String, dynamic>))
            .toList();

        return reviewList;
      } else {
        throw Exception("Failed to load my reviews: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching my reviews: $e");
      throw Exception("Failed to fetch my reviews");
    }
  }

  Future<List<SavedThemeModel>> fetchSavedThemes({required String date}) async {
    try {
      final accessToken = await secureStorage.readToken("x-access-token");
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("No access token found.");
      }

      Uri uri = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.mySavedList}?date=$date');
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

  StreamSubscription<String>? _sseSubscription;

  Future<void> subscribeToSSE(BuildContext context, String token) async {
    final uri =
        Uri.parse('${ApiConstants.baseUrl}/scrd/api/subscribe?token=$token');

    debugPrint("🔔 SSE 구독 URL: $uri");

    final client = http.Client();
    final request = http.Request("GET", uri);

    try {
      final response = await client.send(request);
      if (response.statusCode == 200) {
        debugPrint("✅ SSE 연결 성공");

        _sseSubscription = response.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen((line) async {
          if (line.trim().isNotEmpty) {
            debugPrint("📥 SSE 수신: $line");
            await Provider.of<NotificationProvider>(context, listen: false)
                .loadNotifications();

            // "참여 신청" 포함된 경우 상태 반영
            if (line.contains('참여 신청')) {
              Provider.of<NotificationProvider>(context, listen: false)
                  .setHasPending(true);
            }
          }
        });
      } else {
        debugPrint("❌ SSE 연결 실패: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❗ SSE 오류: $e");
    }
  }

  //일행 신청하기
  Future<bool> joinParty(int postId) async {
    final accessToken = await secureStorage.readToken("x-access-token");
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception("No access token found.");
    }

    final uri =
        Uri.parse('${ApiConstants.baseUrl}/scrd/api/party/$postId/join');

    final response = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    return response.statusCode == 200;
  }

  // 일행 신청 취소하기
  Future<bool> cancelJoinParty(int postId) async {
    final accessToken = await secureStorage.readToken("x-access-token");
    final uri =
        Uri.parse('${ApiConstants.baseUrl}/scrd/api/party/$postId/join');

    final response = await http.delete(uri, headers: {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    return response.statusCode == 200;
  }

  Future<bool> toggleJoinParty(int postId) async {
    final accessToken = await secureStorage.readToken("x-access-token");
    final uri =
        Uri.parse('${ApiConstants.baseUrl}/scrd/api/party/$postId/join');

    final response = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return true; // 새로 신청 성공
    } else if (response.statusCode == 400) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body['message'] == '이미 신청한 일행입니다.') {
        debugPrint("이미 신청한 일행입니다.");
        cancelJoinParty(postId);
        return false; // 이미 신청 → 취소로 간주
      }
    }
    throw Exception('신청/취소 요청 실패');
  }

  Future<List<PartyJoinNotification>> fetchJoinNotifications() async {
    final accessToken = await secureStorage.readToken("x-access-token");
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception("No access token found.");
    }

    final uri =
        Uri.parse('${ApiConstants.baseUrl}/scrd/api/party/join/notification');

    final response = await http.get(uri, headers: {
      "Authorization": "Bearer $accessToken",
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> jsonList = decoded['data'];
      return jsonList
          .map((json) => PartyJoinNotification.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch notifications');
    }
  }

  Future<bool> updateJoinStatus(int joinId, String status) async {
    final token = await secureStorage.readToken("x-access-token");
    final uri =
        Uri.parse('${ApiConstants.baseUrl}/scrd/api/party/join/$joinId/status');

    final response = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"status": status}),
    );

    return response.statusCode == 200;
  }

  // 지역별 테마 개수 가져오기
  // Future<List<RegionThemeCount>> fetchRegionThemeCounts() async {
  //   final accessToken = await secureStorage.readToken("x-access-token");
  //   if (accessToken == null || accessToken.isEmpty) {
  //     throw Exception("No access token found.");
  //   }
  //
  //   final uri =
  //       Uri.parse('${ApiConstants.baseUrl}/scrd/api/theme/location-counts');
  //   final response = await http.get(uri, headers: {
  //     "Authorization": "Bearer $accessToken",
  //     'Content-Type': 'application/json; charset=UTF-8',
  //     'Accept': 'application/json',
  //   });
  //   debugPrint("ResponseCode: ${response.statusCode}");
  //   if (response.statusCode == 200) {
  //     final decoded = jsonDecode(utf8.decode(response.bodyBytes));
  //     final List<dynamic> list = decoded['counts'];
  //     return list.map((e) => RegionThemeCount.fromJson(e)).toList();
  //   } else {
  //     throw Exception('Failed to fetch region counts');
  //   }
  // }
  Future<RegionCountResponse> fetchRegionCounts() async {
    final accessToken = await secureStorage.readToken("x-access-token");

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception("No access token found.");
    }

    final uri =
        Uri.parse('${ApiConstants.baseUrl}/scrd/api/theme/location-counts');

    final response = await http.get(uri, headers: {
      "Authorization": "Bearer $accessToken",
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return RegionCountResponse.fromJson(decoded);
    } else {
      throw Exception('지역 카운트 불러오기 실패: ${response.statusCode}');
    }
  }

  Future<List<ThemeModel>> searchFilteredThemes({
    required String keyword,
    required DateTime date,
    int? horror,
    int? activity,
    String? location,
    double? levelMin,
    double? levelMax,
  }) async {
    try {
      debugPrint("🔍 Search Filtered Themes");
      final token = await secureStorage.readToken("x-access-token");
      if (token == null || token.isEmpty) {
        throw Exception("No access token found");
      }

      final String formattedDate = DateFormat('yyyy-MM-dd').format(date);

      final queryParams = {
        'keyword': keyword,
        'date': formattedDate,
        if (horror != null) 'horror': horror.toString(),
        if (activity != null) 'activity': activity.toString(),
        if (location != null && location != '전체') 'location': location,
        if (levelMin != null) 'levelMin': levelMin.toString(),
        if (levelMax != null) 'levelMax': levelMax.toString(),
      };
      debugPrint("🔍 Search Filtered Themes Query Params: $queryParams");
      final uri = Uri.https(
        ApiConstants.baseHost,
        '/scrd/api/theme/search/filtered',
        queryParams,
      );
      debugPrint("🔍 Search API Request URL: $uri");

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Origin": ApiConstants.baseUrl,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => ThemeModel.fromJson(e)).toList();
      } else {
        debugPrint("❌ Search failed: ${response.statusCode}");
        throw Exception("Search failed");
      }
    } catch (e) {
      debugPrint("❗ Search error: $e");
      rethrow;
    }
  }

  Future<int> fetchReviewCount() async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/scrd/api/review/count');
      final accessToken = await secureStorage.readToken("x-access-token");

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final int reviewCount = json['data'];
        return reviewCount;
      } else {
        throw Exception("리뷰 개수 가져오기 실패: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❗ 리뷰 개수 요청 중 오류 발생: $e");
      rethrow;
    }
  }

  Future<bool> validateToken(String token) async {
    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/auth/validate"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteReview(int reviewId) async {
    final accessToken = await secureStorage.readToken("x-access-token");
    final url = Uri.parse('${ApiConstants.baseUrl}/scrd/api/review/$reviewId');
    debugPrint("Delete Review URL: $url");
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('리뷰 삭제 실패: ${response.statusCode}, ${response.body}');
      return false;
    }
  }

  Future<bool> deleteUser(int userId) async {
    final accessToken = await secureStorage.readToken("x-access-token");
    final url = Uri.parse('${ApiConstants.baseUrl}/scrd/api/user/delete');
    debugPrint("Delete User URL: $url");
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('회원 탈퇴 실패: ${response.statusCode}, ${response.body}');
      return false;
    }
  }

  Future<List<Party>> fetchPartiesByDate(String date) async {
    final accessToken = await secureStorage.readToken("x-access-token");

    final url = Uri.parse(
        '${ApiConstants.baseUrl}/scrd/api/party/paged?deadline=$date');
    debugPrint("Fetch Parties by Date URL: $url");
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
    debugPrint("ResponseCode: ${response.statusCode}");
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      debugPrint("Party ResponseBody: $decodedBody");

      final Map<String, dynamic> body = jsonDecode(decodedBody);
      final List<dynamic> partyList = body['data'];
      debugPrint("Party List: $partyList");
      return partyList.map((json) => Party.fromJson(json)).toList();
    } else {
      throw Exception('파티 날짜 검색 실패: ${response.statusCode}');
    }
  }
}
