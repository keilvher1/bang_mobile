import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:scrd/auth/secure_storage.dart';
import 'package:scrd/page/after_login.dart';
import 'package:scrd/page/nav_page.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../utils/endpoint.dart';

class KakaoLoginWebView extends StatefulWidget {
  final String clientId;
  final String redirectUri;

  KakaoLoginWebView({
    required this.clientId,
    required this.redirectUri,
  });

  @override
  _KakaoLoginWebViewState createState() => _KakaoLoginWebViewState();
}

class _KakaoLoginWebViewState extends State<KakaoLoginWebView> {
  late final WebViewController _controller;
  SecureStorage storage = SecureStorage();
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            debugPrint("Navigating to: ${request.url}");
            if (request.url.startsWith(widget.redirectUri)) {
              Uri uri = Uri.parse(request.url);
              if (uri.queryParameters['code'] != null) {
                String authCode = uri.queryParameters['code']!;
                debugPrint("Authorization Code: $authCode");

                // 서버에 Authorization Code 전달
                _sendCodeToServer(authCode);
              } else if (uri.queryParameters['error'] != null) {
                String error = uri.queryParameters['error']!;
                debugPrint("Error: $error");
                Navigator.pop(context, "Error: $error");
              }
              return NavigationDecision.prevent; // 리다이렉션 중단
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            debugPrint("Page started loading: $url");
          },
          onPageFinished: (String url) async {
            debugPrint("Page finished loading: $url");
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          "https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=${widget.clientId}&redirect_uri=${widget.redirectUri}",
        ),
      );
  }

  // 서버로 Authorization Code 전달
  void _sendCodeToServer(String authCode) async {
    try {
      final response = await http.get(
        Uri.parse(
            "${ApiConstants.loginUrl}:8080/scrd/auth/kakao-login?code=$authCode"),
        headers: {
          "Origin": "${ApiConstants.loginUrl}:8000",
        },
      );

      if (response.statusCode == 200) {
        debugPrint("Server Response: ${response.body}");
        debugPrint("Server Headers: ${response.headers}");

        // 헤더에서 토큰 꺼내기
        final refreshToken = response.headers['x-refresh-token'];
        final authorizationHeader = response.headers['authorization'];

        if (refreshToken != null && authorizationHeader != null) {
          // access-token에서 "Bearer " 제거
          final accessToken = authorizationHeader.startsWith("Bearer ")
              ? authorizationHeader.substring(7) // "Bearer " 제외한 토큰만 저장
              : authorizationHeader;

          // 저장
          await storage.saveToken("x-refresh-token", refreshToken);
          await storage.saveToken("x-access-token", accessToken);

          // 저장된 토큰 읽어서 로그 출력
          final savedRefreshToken = await storage.readToken("x-refresh-token");
          final savedAccessToken = await storage.readToken("x-access-token");

          debugPrint("Saved x-refresh-token: $savedRefreshToken");
          debugPrint("Saved x-access-token: $savedAccessToken");

          // 이동
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => NavPage()),
            (Route<dynamic> route) => false,
          );
        } else {
          debugPrint("Token missing in response headers.");
          Navigator.pop(context, "Error: Token missing");
        }
      } else {
        debugPrint("Server Error: ${response.statusCode} ${response.body}");
        Navigator.pop(context, "Error: ${response.body}");
      }
    } catch (error) {
      debugPrint("HTTP Error: $error");
      Navigator.pop(context, "Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller),
    );
  }
}
