import 'package:flutter/material.dart';

class AnimationPage extends StatefulWidget {
  final VoidCallback onFinish;

  const AnimationPage({Key? key, required this.onFinish}) : super(key: key);

  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _textAnimationController;
  late AnimationController _outerTextController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _moveAnimationLeft;
  late Animation<double> _moveAnimationRight;

  @override
  void initState() {
    super.initState();

    // 텍스트 이동 애니메이션 컨트롤러
    _textAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // 왼쪽으로 이동하는 애니메이션
    _moveAnimationLeft = Tween<double>(begin: 200.0, end: -200.0).animate(
      CurvedAnimation(parent: _textAnimationController, curve: Curves.easeOut),
    );

    // 오른쪽으로 이동하는 애니메이션
    _moveAnimationRight = Tween<double>(begin: -200.0, end: 200.0).animate(
      CurvedAnimation(parent: _textAnimationController, curve: Curves.easeOut),
    );

    _textAnimationController.forward();

    // 페이드 아웃 애니메이션 컨트롤러
    _fadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    // 애니메이션이 종료되면 메인 페이지로 이동
    Future.delayed(const Duration(seconds: 3), () {
      _fadeController.forward().then((value) => widget.onFinish());
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD90206), // 빨간색 배경
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 가장 바깥 사각형
                  _buildRotatedBoxWithText2(
                    -10,
                    750,
                    "FOLLOW",
                    "SCARLET",
                    "THREADS",
                  ),
                  // 중간 사각형
                  _buildRotatedBoxWithText(
                    10,
                    300,
                    "FOLLOW",
                    "SCARLET",
                    "THREADS",
                  ),
                  // 가장 안쪽 사각형
                  _buildRotatedBoxWithText(
                    -10,
                    150,
                    "FOLLOW",
                    "SCARLET",
                    "THREADS",
                  ),
                ],
              ),
            ),
            // 흰색 텍스트 추가
            // 흰색 텍스트 추가 - 위쪽 좌상향으로 이동
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 300, // 더 위로 이동
              left: MediaQuery.of(context).size.width / 4 - 90, // 더 왼쪽으로 이동
              child: Transform.rotate(
                angle: -9.775 * 3.14159 / 180, // 각도 조정
                child: const Text(
                  "ESCAPE ROOM\nTEAM MATCHING",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // 흰색 텍스트 추가 - 아래쪽 우하향으로 이동
            Positioned(
              top: MediaQuery.of(context).size.height / 2 + 240, // 더 아래로 이동
              right: MediaQuery.of(context).size.width / 4 - 60, // 더 오른쪽으로 이동
              child: Transform.rotate(
                angle: -9.775 * 3.14159 / 180, // 각도 조정
                child: const Text(
                  "ESCAPE ROOM\nTEAM MATCHING",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRotatedBoxWithText(
      double angle,
      double size,
      String text1,
      String text2,
      String text3,
      ) {
    return Transform.rotate(
      angle: angle * 3.14159 / 180, // 기울기 각도
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 사각형 배경
          Container(
            width: size,
            height: size * 1.2,
            decoration: BoxDecoration(
              color: const Color(0xFFD90206),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // 그림자 색상 (진하게)
                  blurRadius: 30, // 그림자 퍼짐 정도
                  spreadRadius: 5, // 그림자 확산 정도
                  offset: const Offset(0, 15), // 그림자 위치
                ),
              ],
            ),
          ),
          // 사각형 내부 텍스트
          ClipRect(
            child: Container(
              width: size,
              height: size * 1.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAnimatedText(text1, _moveAnimationLeft),
                  const SizedBox(height: 20), // 텍스트 간 간격 조정
                  _buildAnimatedText(text2, _moveAnimationRight),
                  const SizedBox(height: 20), // 텍스트 간 간격 조정
                  _buildAnimatedText(text3, _moveAnimationLeft),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRotatedBoxWithText2(
      double angle,
      double size,
      String text1,
      String text2,
      String text3,
      ) {
    return Transform.rotate(
      angle: angle * 3.14159 / 180, // 기울기 각도
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 사각형 배경
          Container(
            width: size,
            height: size * 1.2,
            decoration: BoxDecoration(
              color: const Color(0xFFD90206),
              boxShadow: [
                // BoxShadow(
                //   color: Colors.black.withOpacity(0.3),
                //   blurRadius: 20,
                //   offset: const Offset(0, 10),
                // ),
              ],
            ),
          ),
          // 사각형 내부 텍스트
          ClipRect(
            child: Container(
              width: size,
              height: size * 1.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAnimatedText2(text1, _moveAnimationLeft),
                  const SizedBox(height: 60), // 텍스트 간 간격 조정
                  _buildAnimatedText2(text2, _moveAnimationRight),
                  const SizedBox(height: 60), // 텍스트 간 간격 조정
                  _buildAnimatedText2(text3, _moveAnimationLeft),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedText(String text, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(animation.value, 0), // 텍스트 이동
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
  Widget _buildAnimatedText2(String text, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(animation.value, 0), // 텍스트 이동
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 75,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}