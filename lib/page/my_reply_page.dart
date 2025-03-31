import 'package:flutter/material.dart';

import '../components/buttons.dart';

class MyReviewPage extends StatefulWidget {
  const MyReviewPage({Key? key}) : super(key: key);

  @override
  _MyReviewPageState createState() => _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPage> {
  @override
  Widget build(BuildContext context) {
    List<String> tags = ["#감성적인", "#귀여운", "#신비한", "#스타일있는", "#미스테리한"];
    void _addTag(String tag) {
      setState(() {
        tags.add(tag);
      });
    }

    void _removeTag(String tag) {
      setState(() {
        tags.remove(tag);
      });
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          '내가 쓴 리뷰',
          style: TextStyle(
            color: Color(0xffD90206),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white, // 배경색 설정
                              radius: 20, // 아바타 크기 설정
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/needle.png',
                                  width: 25, // 원하는 크기로 조정
                                  height: 25,
                                  fit: BoxFit.contain, // 원 안에 이미지 맞추기
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize:
                                  MainAxisSize.max, // Row가 전체 너비를 차지하도록 설정
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '60분 35초 / 75분',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xffC9C9C9),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2), // 간격 추가
                                    Row(
                                      children: [
                                        Text(
                                          '성공 / 힌트 3개 ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xffC9C9C9),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '• 3개월 전', // 중간 점(•) 추가
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Color(0xffC9C9C9),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(height: 13),
                Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRatingItem(
                              label: '평점',
                              value: '4.0',
                              fontSize: 14,
                              color: Color(0xffD90206),
                            ),
                            SizedBox(width: 14),
                            _buildRatingItem(
                                label: '난이도',
                                value: '5',
                                imagePath: 'assets/icon/puzzle_red.png',
                                imageSize: 23,
                                color: Color(0xffD90206)),
                            SizedBox(width: 14),
                            _buildRatingItem(
                                label: '공포도',
                                imagePath: 'assets/icon/ghost.png',
                                imageSize: 23),
                            SizedBox(width: 14),
                            _buildRatingItem(
                                label: '활동성',
                                imagePath: 'assets/icon/shoe_in.png',
                                imageSize: 23),
                          ],
                        ),
                        const SizedBox(height: 15),
                        hashtag(tags, _addTag, _removeTag),
                        const SizedBox(height: 15),
                        const Text(
                          '머니머니 패키지보다 훨씬더 어렵고 인원이 늘어나서인지 모르겠지만 문제 난이도 자체는 머머패가 조금 더 어려웠던 것 같다. 머머패랑 비교했을때 만족도는 거의 비슷하다.',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 12,
                ),
                const Divider(color: Color(0xff363636)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRatingItem({
    required String label,
    String? imagePath, // 이미지 경로를 위한 필드 추가
    Color? color,
    String? value,
    String? subText,
    double? imageSize,
    double? fontSize,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        if (imagePath != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(),
              Image.asset(
                alignment: Alignment.center,
                imagePath,
                color: color,
                width: imageSize,
                height: imageSize,
              ),
              value != null
                  ? Text(
                      value,
                      style: TextStyle(
                          color: color,
                          fontSize: fontSize ?? 11,
                          fontWeight: FontWeight.w700),
                    )
                  : SizedBox(),
            ],
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize ?? 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subText != null)
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(
                    subText,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildReviewCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                'assets/sample_review.png', // Replace with your actual asset
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '머니머니부동산',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '키이스케이프 | 스테이션점',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _ratingItem('assets/icon/star.png', '4.0'),
                      _ratingItem('assets/icon/puzzle_red.png', '5'),
                      _ratingItem('assets/icon/ghost.png', null),
                      _ratingItem('assets/icon/shoe.png', null),
                    ],
                  )
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: Colors.white),
            )
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: const [
            _Hashtag('#감성적인'),
            _Hashtag('#귀여운'),
            _Hashtag('#신비한'),
            _Hashtag('#스릴있는'),
            _Hashtag('#미스터리한'),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          '머니머니 패키지보다 훨씬더 어렵고 인원이 늘어나서인지 모르겠지만 문제 난이도 자체는 머머패가 조금 더 어려웠던 것 같다. 머머패랑 비교했을 때 만족도는 거의 비슷하다.',
          style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
        ),
        const SizedBox(height: 24),
        const Divider(color: Color(0xff363636), thickness: 1),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _ratingItem(String iconPath, String? text) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        children: [
          Image.asset(iconPath, width: 18, height: 18, color: Colors.white),
          if (text != null) ...[
            const SizedBox(width: 4),
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            )
          ]
        ],
      ),
    );
  }
}

class _Hashtag extends StatelessWidget {
  final String tag;
  const _Hashtag(this.tag);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xff515151),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          color: Color(0xffD8D8D8),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
