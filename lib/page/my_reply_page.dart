import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrd/page/home_page.dart';

import '../components/buttons.dart';
import '../model/review.dart';
import '../provider/jwt_provider.dart';
import '../provider/my_review_provider.dart';

class MyReviewPage extends StatefulWidget {
  const MyReviewPage({super.key});

  @override
  _MyReviewPageState createState() => _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPage> {
  final String userId = "3"; // ★ 여기에 로그인한 사용자의 userId 넣으면 돼!

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MyReviewProvider>(context, listen: false)
          .fetchMyReviews(userId);
    });
  }

  String getRelativeTime(String regDateString) {
    try {
      if (regDateString.isEmpty) return "";

      final regDate = DateTime.parse(regDateString); // ✅ ISO 8601 처리
      final now = DateTime.now();
      final diff = now.difference(regDate);

      if (diff.inSeconds < 60) {
        return " ·방금 전";
      } else if (diff.inMinutes < 60) {
        return " ·${diff.inMinutes}분 전";
      } else if (diff.inHours < 24) {
        return " ·${diff.inHours}시간 전";
      } else if (diff.inDays < 30) {
        return " ·${diff.inDays}일 전";
      } else if (diff.inDays < 365) {
        return " ·${(diff.inDays / 30).floor()}개월 전";
      } else {
        return " ·${(diff.inDays / 365).floor()}년 전";
      }
    } catch (e) {
      print("날짜 파싱 오류: $e");
      return "날짜 오류";
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<JwtProvider>().jwt?.userId;
    debugPrint("userId: $userId");
    List<String> tags = ["#감성적인", "#귀여운", "#신비한", "#스타일있는", "#미스테리한"];
    void addTag(String tag) {
      setState(() {
        tags.add(tag);
      });
    }

    void removeTag(String tag) {
      setState(() {
        tags.remove(tag);
      });
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            const Text(
              '내가 쓴 리뷰',
              style: TextStyle(
                color: Color(0xffD90206),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        centerTitle: false,
      ),
      body: Consumer<MyReviewProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.myReviews.isEmpty) {
            return const Center(
                child: Text('아직 작성한 리뷰가 없습니다.',
                    style: TextStyle(color: Colors.white70)));
          }
          return ListView.builder(
            itemCount: provider.myReviews.length,
            itemBuilder: (context, index) {
              final review = provider.myReviews[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
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
                                  radius: 45, // 아바타 크기 설정
                                  child: ClipOval(
                                    child: Image.network(
                                      review.themeImage,
                                      width: 144,
                                      height: 161,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize:
                                      MainAxisSize.max, // Row가 전체 너비를 차지하도록 설정
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              160,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 190,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      review.themeTitle,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      getRelativeTime(
                                                          review.regDate),
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        color:
                                                            Color(0xffC9C9C9),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              ReviewItem(
                                                review: review,
                                                userId: userId!,
                                                isSaved: true,
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 2), // 간격 추가
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              color: Color(0xFFB9B9B9),
                                              size: 14,
                                            ),
                                            Text(
                                              ' ${review.themeLocation} | ${review.themeBranch}',
                                              style: const TextStyle(
                                                color: Color(0xFFB9B9B9),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildRatingItem(
                                              label: '평점',
                                              value: review.stars.toString(),
                                              fontSize: 14,
                                              color: const Color(0xffD90206),
                                            ),
                                            const SizedBox(width: 14),
                                            _buildRatingItem(
                                                label: '난이도',
                                                value: review.level.toString(),
                                                imagePath:
                                                    'assets/icon/puzzle_red.png',
                                                imageSize: 23,
                                                color: const Color(0xffD90206)),
                                            const SizedBox(width: 14),
                                            _buildRatingItem(
                                                label: '공포도',
                                                imagePath: review.horror == 1
                                                    ? 'assets/icon/ghost.png'
                                                    : 'assets/icon/ghost_in.png',
                                                imageSize: 23),
                                            const SizedBox(width: 14),
                                            _buildRatingItem(
                                                label: '활동성',
                                                imagePath: review.activity == 1
                                                    ? 'assets/icon/shoe.png'
                                                    : 'assets/icon/shoe_in.png',
                                                imageSize: 23),
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
                      ],
                    ),
                    const SizedBox(height: 5),
                    Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            hashtag(review.tagNames, addTag, removeTag),
                            const SizedBox(height: 15),
                            Text(
                              review.text,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 12,
                    ),
                    const Divider(color: Color(0xff363636)),
                  ],
                ),
              );
            },
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
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        if (imagePath != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(),
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
                  : const SizedBox(),
            ],
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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

  Widget _buildReviewCard(Review review) {
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
        // Wrap(
        //   spacing: 8,
        //   runSpacing: 6,
        //   children:  tagNames.map((tag) => _Hashtag('#$tag')).toList(),
        // ),
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
