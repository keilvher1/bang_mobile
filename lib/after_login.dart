import 'package:flutter/material.dart';

class AfterLogin extends StatefulWidget {
  const AfterLogin({Key? key}) : super(key: key);

  @override
  State<AfterLogin> createState() => _AfterLoginState();
}

class _AfterLoginState extends State<AfterLogin> {
  // 탭 선택 상태
  TagOption selectedOption = TagOption.scarlet;
  String selectedCircle = "고객 센터"; // 선택된 버튼 초기값
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 큰 문구
                Text(
                  "THERE'S THE\nSCARLET THREAD OF MURDER\nRUNNING THROUGH THE\nCOLOURLESS SKEIN OF LIFE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),

                // segmented toggle: scarlet / HOLMES (59)
                _buildSegmentedToggle(),
                const SizedBox(height: 40),

                // 첫 번째 타원형 영역: GIF + REVIEW / RECORD / MY THEME
                _buildOvalMenuWithGif(
                  gifAsset: 'assets/video1.gif',
                  menuItems: ["REVIEW (52)", "RECORD", "MY THEME"],
                ),
                const SizedBox(height: 24),

                // 두 번째 타원형 영역: GIF + MY CREW / ABOUT CREW
                _buildOvalMenuWithGif(
                  gifAsset: 'assets/video2.gif',
                  menuItems: ["MY CREW", "ABOUT CREW"],
                ),
                const SizedBox(height: 40),

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
                        ["문의하기", "공지사항", "리뷰 일괄 입력"],
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
                        ["ABOUT USCRD", "NEWS", "방탈출예약제휴"],
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
                  selectedOption = TagOption.scarlet;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: (selectedOption == TagOption.scarlet)
                      ? Colors.white
                      : Colors.black,
                  borderRadius: BorderRadius.circular(40),
                ),
                alignment: Alignment.center,
                child: Text(
                  "scarlet",
                  style: TextStyle(
                    color: (selectedOption == TagOption.scarlet)
                        ? Colors.black
                        : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
                  color: (selectedOption == TagOption.holmes)
                      ? Colors.white
                      : Colors.black,
                  borderRadius: BorderRadius.circular(40),
                ),
                alignment: Alignment.center,
                child: Text(
                  "HOLMES (59)",
                  style: TextStyle(
                    color: (selectedOption == TagOption.holmes)
                        ? Colors.black
                        : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
    required List<String> menuItems,
  }) {
    return Container(
      width: double.infinity,
      height: 140, // 원하는 높이
      // ClipRRect로 감싸서 모서리를 둥글게 처리
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
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item,
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
    0,      0,      0,      1, 0, // Alpha
  ];

  /// 하단의 원형 메뉴(고객 센터 / 더보기)
  Widget _buildCircleMenu(String title, List<String> items, bool isSelected){
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            ...items.map(
                  (e) => Text(
                e,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white70 : Colors.black54,
                  fontSize: 12,
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