import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:scrd/auth/login.dart';
import 'package:scrd/provider/available_time_provider.dart';
import 'package:scrd/provider/bottomsheet_provider.dart';
import 'package:scrd/provider/detail_provider.dart';
import 'package:scrd/provider/filter_provider.dart';
import 'package:scrd/provider/filter_theme_provider.dart';
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

import 'auth/animation_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: '8d8c6b5337bc43327f57c7c053b8573e',
    javaScriptAppKey: '2989773320c1b397c490149250377c',
  );
  initializeDateFormatting('ko_KR', null);
  //.env 파일 로드
  // await dotenv.load(fileName: "assets/env/.env");
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
        ChangeNotifierProvider(create: (context) => AvailableTimeProvider()),
        ChangeNotifierProvider(create: (context) => SelectThemeProvider()),
        ChangeNotifierProvider(create: (context) => UploadProvider()),
        ChangeNotifierProvider(create: (context) => PartyProvider()),
        ChangeNotifierProvider(create: (context) => PartyDetailProvider()),
        ChangeNotifierProvider(create: (context) => PartyCommentProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => PartyJoinProvider()),
        ChangeNotifierProvider(create: (context) => RegionCountProvider()),
        ChangeNotifierProvider(create: (context) => SearchThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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
          // InfiniteScrollingBackground(
          //   imagePath: 'assets/login_background.png', // 배경 이미지 경로
          //   speed: 20.0, // 애니메이션 속도 (초 단위)
          // ),
          // 로그인 폼을 배경 위에 배치
          const LoginPage(),
          //const NavPage()
          // TierPage(),
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
    if (_showAnimation) {
      return AnimationPage(
        onFinish: () {
          setState(() {
            _showAnimation = false;
          });
        },
      );
    } else {
      return const TotalLoginPage();
    }
  }
}
