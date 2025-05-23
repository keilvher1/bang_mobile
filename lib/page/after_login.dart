import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:scrd/page/my_saved_page.dart';
import 'package:scrd/page/tier_page.dart';
import 'package:scrd/utils/api_server.dart';

import '../main.dart';
import '../provider/jwt_provider.dart';
import 'my_reply_page.dart';

class AfterLogin extends StatefulWidget {
  const AfterLogin({super.key});

  @override
  State<AfterLogin> createState() => _AfterLoginState();
}

class _AfterLoginState extends State<AfterLogin> {
  // 탭 선택 상태
  TagOption selectedOption = TagOption.scarlet;
  String selectedCircle = "고객 센터"; // 선택된 버튼 초기값
  final _storage = const FlutterSecureStorage();
  int? reviewCount;

  Future<void> loadReviewCount() async {
    final count = await ApiService().fetchReviewCount(); // 위에서 만든 함수 사용
    setState(() {
      reviewCount = count;
    });
  }

  @override
  void initState() {
    super.initState();
    loadReviewCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 큰 문구
                GestureDetector(
                  onTap: () {
                    // Future<void> logout() async {
                    //   await _storage.delete(key: 'accessToken');
                    //   debugPrint('로그아웃 성공');
                    //
                    //   // 로그인 페이지로 이동
                    //   Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => LoginPage()),
                    //   );
                    // }
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => TierPage()),
                    // );
                  },
                  child: const Text(
                    "THERE'S THE\nSCARLET THREAD OF MURDER\nRUNNING THROUGH THE\nCOLOURLESS SKEIN OF LIFE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // segmented toggle: scarlet / HOLMES (59)
                _buildSegmentedToggle(),
                const SizedBox(height: 40),

                // 첫 번째 타원형 영역: GIF + REVIEW / RECORD / MY THEME
                _buildOvalMenuWithGif(
                  gifAsset: 'assets/video1.gif',
                  menuItems: [
                    {
                      "REVIEW ($reviewCount)": () {
                        debugPrint("REVIEW 클릭됨");
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MyReviewPage(),
                          ),
                        );
                      }
                    },
                    {
                      "MY THEME": () {
                        debugPrint("MY THEME 클릭됨");
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MySavedPage(),
                          ),
                        );
                      }
                    },
                  ],
                ),
                const SizedBox(height: 24),

                // 두 번째 타원형 영역: GIF + MY CREW / ABOUT CREW
                // _buildOvalMenuWithGif(
                //   gifAsset: 'assets/video2.gif',
                //   menuItems: ["MY CREW", "ABOUT CREW"],
                // ),
                // const SizedBox(height: 40),

                // 하단의 동그라미 2개 (고객 센터, 더보기)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 고객 센터 버튼
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCircle = "고객 센터";
                        });
                      },
                      child: _buildCircleMenu(
                        "고객 센터",
                        [MapEntry("문의하기", () {}), MapEntry("리뷰 일괄 입력", () {})],
                        selectedCircle == "고객 센터",
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 더보기 버튼
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCircle = "더보기";
                        });
                      },
                      child: _buildCircleMenu(
                        "더보기",
                        [
                          MapEntry("로그아웃", () {
                            context.read<JwtProvider>().clearJwt();
                            debugPrint('로그아웃 성공');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TotalLoginPage()),
                            );
                          }),
                          MapEntry("회원탈퇴", () {
                            // 회원탈퇴 로직 추가
                          }),
                        ],
                        selectedCircle == "더보기",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Segmented Toggle
  Widget _buildSegmentedToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          // scarlet 버튼
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TierPage()),
                  );
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(40),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "TIER",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          // HOLMES (59) 버튼
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedOption = TagOption.holmes;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                alignment: Alignment.center,
                child: Text(
                  "HOLMES ($reviewCount)",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// GIF가 배경으로 들어간 타원형 메뉴
  /// GIF가 배경으로 들어간 타원형 메뉴
  Widget _buildOvalMenuWithGif({
    required String gifAsset,
    required List<Map<String, VoidCallback>> menuItems,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 140, // 원하는 높이
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Stack(
          children: [
            // GIF 영역 (흑백 처리 추가)
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: const ColorFilter.matrix(_greyscaleMatrix),
                child: Image.asset(
                  gifAsset,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 위에 텍스트/아이콘 오버레이
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: menuItems.map((item) {
                  final String title = item.keys.first; // 메뉴명
                  final VoidCallback action = item.values.first; // 클릭 이벤트

                  return GestureDetector(
                    onTap: action, // 개별 동작 추가
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

// 흑백 처리에 필요한 Greyscale matrix
  static const List<double> _greyscaleMatrix = [
    0.2126, 0.7152, 0.0722, 0, 0, // Red
    0.2126, 0.7152, 0.0722, 0, 0, // Green
    0.2126, 0.7152, 0.0722, 0, 0, // Blue
    0, 0, 0, 1, 0, // Alpha
  ];

  /// 하단의 원형 메뉴(고객 센터 / 더보기)
  Widget _buildCircleMenu(
    String title,
    List<MapEntry<String, VoidCallback>> items,
    bool isSelected,
  ) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 21,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8),
            ...items.map(
              (entry) => GestureDetector(
                onTap: entry.value,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    entry.key,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum TagOption {
  scarlet,
  holmes,
}
