import 'package:flutter/material.dart';

class InfiniteScrollingBackground extends StatefulWidget {
  final String imagePath;
  final double speed; // 애니메이션 속도 (초 단위)

  const InfiniteScrollingBackground({
    Key? key,
    required this.imagePath,
    this.speed = 20.0,
  }) : super(key: key);

  @override
  _InfiniteScrollingBackgroundState createState() =>
      _InfiniteScrollingBackgroundState();
}

class _InfiniteScrollingBackgroundState
    extends State<InfiniteScrollingBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  // 이미지의 너비를 저장할 변수
  double _imageWidth = 0;

  @override
  void initState() {
    super.initState();

    // AnimationController 초기화 (애니메이션의 지속 시간 설정)
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.speed.toInt()), // 속도 조절
    )..repeat(); // 무한 반복

    // 애니메이션 정의 (0부터 1까지의 값)
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 이미지의 너비를 화면 너비로 설정
        _imageWidth = constraints.maxWidth;

        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            // 애니메이션 값에 따라 이미지의 x 위치 계산
            double offset = _animation.value * _imageWidth;

            return Stack(
              children: [
                // 첫 번째 이미지
                Positioned(
                  left: -offset,
                  top: 0,
                  child: Image.asset(
                    widget.imagePath,
                    width: _imageWidth,
                    height: constraints.maxHeight,
                    fit: BoxFit.cover,
                  ),
                ),
                // 두 번째 이미지 (첫 번째 이미지가 끝난 후 이어지도록 위치 설정)
                Positioned(
                  left: _imageWidth - offset,
                  top: 0,
                  child: Image.asset(
                    widget.imagePath,
                    width: _imageWidth,
                    height: constraints.maxHeight,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}