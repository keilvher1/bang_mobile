import 'package:flutter/material.dart';

class TierPage extends StatefulWidget {
  const TierPage({super.key});

  @override
  _TierPageState createState() => _TierPageState();
}

class _TierPageState extends State<TierPage> {
  final PageController _pageController = PageController(viewportFraction: 0.7);
  int _currentPage = 0;

  List<Map<String, String>> pages = [
    {"title": "NEEDLE", "description": "Less Than 50"},
    {"title": "CLIP", "description": "Less Than 100"},
    {"title": "KEY", "description": "Less Than 150"},
    {"title": "IRIS", "description": "Less Than 200"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 60),
          Align(
            alignment: const Alignment(-0.25, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "WHAT\nTIE_R\nU?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 74,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                      fontFamily: 'NeueHaasDisplay',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                          color: Colors.white, width: 2), // 흰색 테두리 추가
                    ),
                  ),
                  child: const Text("HOLMES (259)",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'NeueHaasDisplay',
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index % pages.length;
                });
              },
              itemBuilder: (context, index) {
                final pageIndex = index % pages.length;
                final isActive = pageIndex == _currentPage;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(
                      horizontal: 10, vertical: isActive ? 0 : 20),
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xffD90206) : Colors.black,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          // 숫자 위치 (홀수: 아래, 짝수: 위)
                          Positioned(
                            top: pageIndex % 2 != 0 ? -100 : null,
                            bottom: pageIndex % 2 == 0 ? -100 : null,
                            left: -25,
                            child: Text(
                              "${pageIndex + 1}".padLeft(2, '0'),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                                fontSize: 250,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'NeueHaasDisplay',
                              ),
                            ),
                          ),
                          // 제목과 내용 위치 (홀수: 위, 짝수: 아래)
                          Positioned(
                            top: pageIndex % 2 == 0 ? 20 : null,
                            bottom: pageIndex % 2 != 0 ? 40 : null,
                            left: 20,
                            right: 20,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pages[pageIndex]["title"]!,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'NeueHaasDisplay',
                                  ),
                                ),
                                const SizedBox(height: 30),
                                const Text(
                                  "Number Of\nRooms Escaped",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'NeueHaasDisplay',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Text(
                                  pages[pageIndex]["description"]!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'NeueHaasDisplay',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 곡선 이미지 추가
                          Center(
                            child: pageIndex % 2 != 0
                                ? Image.asset(
                                    "assets/Vector 2.png",
                                    width: constraints.maxWidth, // 페이지 너비에 맞춤
                                  )
                                : Image.asset(
                                    "assets/Vector 1.png",
                                    width: constraints.maxWidth, // 페이지 너비에 맞춤
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
