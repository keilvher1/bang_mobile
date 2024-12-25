import 'package:flutter/material.dart';

class StackBackgroundPage extends StatelessWidget {
  const StackBackgroundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar 추가 (선택 사항)
      appBar: AppBar(
        title: const Text('Stack 배경 이미지 예제'),
      ),
      body: Stack(
        children: [
          // 배경 이미지

          // 오버레이 (선택 사항: 어두운 반투명 레이어)
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          // 컨텐츠
          const Center(
            child: Text(
              'Stack을 이용한 배경 이미지',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}