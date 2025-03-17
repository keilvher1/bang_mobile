import 'package:flutter/material.dart';
import 'package:scrd/page/after_login.dart';
import 'package:scrd/page/nav_page.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

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
    final uri = Uri.parse(widget.redirectUri);
    try {
      final response = await http.get(
        Uri.parse(
            // "http://172.17.209.59:8000/scrd/auth/kakao-login?code=$authCode"),
            "http://172.17.144.55:8000/scrd/auth/kakao-login?code=$authCode"),
        headers: {
          // "Origin": "http://172.17.209.59:8000", // 서버 헤더 구성
          "Origin": "http://172.17.144.55:8000", // 서버 헤더 구성
        },
      );

      if (response.statusCode == 200) {
        debugPrint("Server Response: ${response.body}");
        // Navigator.pop(context, authCode); // WebView 닫고 authCode 반환
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => NavPage()), // 이동할 화면
          (Route<dynamic> route) => false, // 이전 모든 경로 제거
        );
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
