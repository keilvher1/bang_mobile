import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:scrd/auth/login.dart';
import 'package:scrd/page/nav_page.dart';
import 'package:scrd/provider/bottomsheet_provider.dart';
import 'package:scrd/provider/detail_provider.dart';
import 'package:scrd/provider/filter_provider.dart';
import 'package:scrd/provider/filter_theme_provider.dart';
import 'package:scrd/provider/jwt_provider.dart';
import 'package:scrd/provider/my_review_provider.dart';
import 'package:scrd/provider/navigation_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scrd/provider/notification_provider.dart';
import 'package:scrd/provider/party_comment_provider.dart';
import 'package:scrd/provider/party_detail_provider.dart';
import 'package:scrd/provider/party_join_provider.dart';
import 'package:scrd/provider/party_provider.dart';
import 'package:scrd/provider/region_count_provider.dart';
import 'package:scrd/provider/review_provider.dart';
import 'package:scrd/provider/saved_theme_provider.dart';
import 'package:scrd/provider/search_theme_provider.dart';
import 'package:scrd/provider/select_theme_provider.dart';
import 'package:scrd/provider/tag_selection_provider.dart';
import 'package:scrd/provider/theme_provider.dart';
import 'package:scrd/provider/upload_provider.dart';
import 'package:scrd/utils/auth_service.dart';

import 'auth/animation_page.dart';
import 'model/jwt_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: '8d8c6b5337bc43327f57c7c053b8573e',
    javaScriptAppKey: '2989773320c1b397c490149250377c',
  );
  initializeDateFormatting('ko_KR', null);
  //.env 파일 로드
  // await dotenv.load(fileName: "assets/env/.env");
  final authService = AuthService();
  final jwt = await authService.tryAutoLogin();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => BottomSheetProvider()),
        ChangeNotifierProvider(create: (context) => TagSelectionProvider()),
        ChangeNotifierProvider(
            create: (context) => ThemeProvider()..loadInitialThemes()),
        ChangeNotifierProvider(create: (context) => ReviewProvider()),
        ChangeNotifierProvider(create: (context) => FilterThemeProvider()),
        ChangeNotifierProvider(create: (context) => FilterProvider()),
        ChangeNotifierProvider(create: (context) => MyReviewProvider()),
        ChangeNotifierProvider(create: (context) => SavedThemeProvider()),
        ChangeNotifierProvider(create: (context) => ThemeDetailProvider()),
        ChangeNotifierProvider(create: (context) => SelectThemeProvider()),
        ChangeNotifierProvider(create: (context) => UploadProvider()),
        ChangeNotifierProvider(create: (context) => PartyProvider()),
        ChangeNotifierProvider(create: (context) => PartyDetailProvider()),
        ChangeNotifierProvider(create: (context) => PartyCommentProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => PartyJoinProvider()),
        ChangeNotifierProvider(create: (context) => RegionCountProvider()),
        ChangeNotifierProvider(create: (context) => SearchThemeProvider()),
        ChangeNotifierProvider(
            create: (_) => JwtProvider()..setJwtIfNotNull(jwt)),
      ],
      child: const MyApp(),
    ),
  );
}

extension JwtProviderExtension on JwtProvider {
  void setJwtIfNotNull(JwtToken? jwt) {
    if (jwt != null) setJwt(jwt);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffD90206)),
        useMaterial3: true,
      ),
      home: const SplashWrapper(),
    );
  }
}

class TotalLoginPage extends StatelessWidget {
  const TotalLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // 배경에 무한 스크롤 배경 이미지를 설정
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.contain,
            ),
          ),
          const LoginPage(),
        ],
      ),
    );
  }
}

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  _SplashWrapperState createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _showAnimation = true;

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = context.watch<JwtProvider>().isLoggedIn;

    if (_showAnimation) {
      return AnimationPage(
        onFinish: () {
          setState(() {
            _showAnimation = false;
          });
        },
      );
    } else {
      return isLoggedIn ? const NavPage() : const TotalLoginPage();
    }
  }
}
