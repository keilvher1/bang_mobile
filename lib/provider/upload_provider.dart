import 'package:flutter/material.dart';
import 'package:scrd/utils/endpoint.dart';
import '../model/review_upload.dart';
import '../model/upload_party.dart';
import '../utils/api_server.dart';

class UploadProvider with ChangeNotifier {
  bool isLoading = false;
  String? message;

  Future<bool> uploadParty(int themeId, PartyUpload data) async {
    isLoading = true;
    notifyListeners();
    debugPrint("Uploading party data: $data");
    debugPrint("Theme ID: $themeId");
    try {
      final response = await ApiService().postJson(
        url: "${ApiConstants.baseUrl}/scrd/api/party/$themeId", // 동적 themeId
        body: data.toJson(),
      );
      debugPrint("Response: $response");
      message = response['message'];
      return response['code'] == 200;
    } catch (e) {
      message = "업로드 실패: $e";
      return false;
    } finally {
      debugPrint("Upload completed");
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> uploadReview(int themeId, ReviewUpload data) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await ApiService().postJson(
        url: "${ApiConstants.baseUrl}/scrd/api/review/$themeId", // 동적 themeId
        body: data.toJson(),
      );
      debugPrint("Response: $response");
      message = response['message'];
      return response['code'] == 200;
    } catch (e) {
      debugPrint("Error uploading review: $e");
      message = "업로드 실패: $e";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
