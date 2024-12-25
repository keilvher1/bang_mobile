// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrd/after_login.dart';
// import 'package:provider/provider.dart';
// import '../provider/application_provider.dart';
// import '../Auth/widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 위치 권한 요청 메서드
  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  // 카카오 로그인 메서드
  //Future<void> kakaoLogin(ApplicationProvider appProvider) async {
    Future<void> kakaoLogin() async {
    try {
      // 카카오톡으로 로그인
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      debugPrint('카카오톡으로 로그인 성공: ${token.accessToken}');

      // Access Token 저장
      // await appProvider.setAccessToken(token.accessToken);
      //
      // 카카오 사용자 정보 가져오기
      User user = await UserApi.instance.me();
      Map<String, dynamic> userInfo = {
        'id': user.id.toString(),
        'nickname': user.kakaoAccount?.profile?.nickname ?? 'Unknown',
        'email': user.kakaoAccount?.email ?? 'Unknown',
        'profileImageUrl': user.kakaoAccount?.profile?.profileImageUrl ?? '',
      };
      debugPrint('사용자 정보: $userInfo');
      // 사용자 정보 ApplicationProvider 및 Firestore에 저장
      // await appProvider.setUserInfo(userInfo);
      // await appProvider.saveUserInfoToFirestore();

      // 위치 권한 요청
      await requestLocationPermission();

      // 로그인 성공 후 WidgetTree로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AfterLogin()),
      );
    } catch (error) {
      debugPrint('카카오톡으로 로그인 실패: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final appProvider = Provider.of<ApplicationProvider>(context, listen: false);

    return  Semantics(
                button: true,
                label: '카카오 로그인',
                hint: '카카오 계정으로 로그인',
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await kakaoLogin();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Semantics(
                      // 이미지에 시맨틱 레이블 추가
                      label: '카카오 로그인 버튼 이미지',
                      child: Image.asset(
                        'assets/kakao_login/ko/kakao_login_large_wide.png', // 카카오 로그인 이미지
                        height: 48, // 원하는 크기로 조정 가능
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
              // const SizedBox(height: 30),
              //
              // // 회원가입 텍스트 버튼에 시맨틱 태그 추가
              // Semantics(
              //   button: true,
              //   label: '회원가입',
              //   hint: '새 계정 생성',
              //   child: Align(
              //     alignment: Alignment.center,
              //     child: TextButton(
              //       onPressed: () {
              //         // 회원가입 페이지로 이동
              //       },
              //       child: const Text(
              //         '계정이 없으신가요? 회원가입',
              //         style: TextStyle(color: Colors.blue, fontSize: 14),
              //       ),
              //     ),
              //   ),
              // ),
          //   ],
          // );

  }
}