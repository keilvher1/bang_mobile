import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrd/components/buttons.dart';
import 'package:scrd/page/my_reply_page.dart';

import '../components/filter_row_widget.dart';
import '../provider/bottomsheet_provider.dart';

class MySavedPage extends StatefulWidget {
  const MySavedPage({Key? key}) : super(key: key);

  @override
  _MySavedPageState createState() => _MySavedPageState();
}

class _MySavedPageState extends State<MySavedPage> {
  late DateTime _currentDate;
  late DateTime _selectedDate;
  int clicked = 0;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _selectedDate = DateTime.now();
    clicked = 0;
  }

  List<DateTime> _generateDateRange() {
    return List.generate(
      7,
      (index) => _currentDate.add(Duration(days: index)),
    );
  }

  void _goToPreviousWeek() {
    setState(() {
      _currentDate = _currentDate.subtract(const Duration(days: 7));
      clicked--;
    });
  }

  void _goToNextWeek() {
    setState(() {
      _currentDate = _currentDate.add(const Duration(days: 7));
      clicked++;
    });
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

  void showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ChangeNotifierProvider(
          create: (_) => BottomSheetProvider(),
          child: Consumer<BottomSheetProvider>(
            builder: (context, provider, _) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => provider.setTabIndex(0),
                              child: Text(
                                '상세 정보',
                                style: TextStyle(
                                  color: provider.selectedTabIndex == 0
                                      ? Color(0xffD90206)
                                      : Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () => provider.setTabIndex(1),
                              child: Row(
                                children: [
                                  Text(
                                    '리뷰',
                                    style: TextStyle(
                                      color: provider.selectedTabIndex == 1
                                          ? Color(0xffD90206)
                                          : Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: const Offset(0, -9),
                                    child: Text(
                                      '12+',
                                      style: TextStyle(
                                          color: provider.selectedTabIndex == 1
                                              ? Color(0xffD90206)
                                              : Colors.white,
                                          fontSize: 11),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xff363636)),
                    Expanded(
                      child: provider.selectedTabIndex == 0
                          ? _buildDetailContent()
                          : _buildReviewContent(),
                    ),
                    provider.selectedTabIndex == 1
                        ? SizedBox()
                        // Center(
                        //         child: Text(
                        //         '전체 리뷰',
                        //         style: TextStyle(color: Color(0xffD90206)),
                        //       ))
                        : SizedBox(),
                    const SizedBox(height: 30),
                    _buildActionButtons()
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDetailContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '머니머니 부동산',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '키이스케이프 | 스테이션점',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                )
              ],
            ),
            SizedBox(height: 8),
            Row(children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  '강남',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.watch_later_outlined,
                  color: Colors.white, size: 19),
              const SizedBox(width: 4),
              const Text(
                '80분',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ]),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRatingItem(
                    label: '난이도',
                    value: '5',
                    imagePath: 'assets/icon/puzzle_red.png',
                    imageSize: 23,
                    color: Color(0xffD90206)),
                SizedBox(width: 14),
                _buildRatingItem(
                  label: '장치비율',
                  value: '7:3',
                  fontSize: 17,
                  color: Color(0xffD90206),
                ),
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
            const SizedBox(height: 25),
            // Divider(
            //   color: Color(0xff363636),
            // ),
            const Text(
              '테마 설명',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '안녕하세요, 어른이 여러분. 오래만에 우리 어른이 여러분들을 위해서 새로운 주제를 들고 왔는데, 뭘까~요? 짜잔! 바로바로 키이스케이프사에서 야심 차게 출시한 시즌 2 "머니머니 부.동.산!" 울고 싶을 만큼 혹독한 세상에서도 이왕이면 내 건물 안에서 우는 게 나으니까! 본격 머니머니 룸과 자본주의의 꽃, 부동산의 콜라보. 지금 바로 주문하세요!',
              style: TextStyle(color: Color(0xff929292), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewContent() {
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

    return ListView.builder(
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
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
            ),
            child: const Text('공유하기'),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
            ),
            child:
                const Text('예약하기', style: TextStyle(color: Color(0xffD90206))),
          ),
        ],
      ),
    );
  }

  bool isBookmarkClicked = false;

  @override
  Widget build(BuildContext context) {
    final dates = _generateDateRange();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // IconButton(
                //     icon: Icon(
                //       Icons.arrow_back_ios,
                //       color: Colors.white,
                //       size: 20,
                //     ),
                //     onPressed: () {
                //       if (clicked > 0) {
                //         _goToPreviousWeek();
                //       }
                //     }
                //     // _goToPreviousWeek,
                //     ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...dates.map((date) {
                      final isToday = DateFormat('yyyy-MM-dd').format(date) ==
                          DateFormat('yyyy-MM-dd').format(DateTime.now());
                      final isSelected =
                          DateFormat('yyyy-MM-dd').format(date) ==
                              DateFormat('yyyy-MM-dd').format(_selectedDate);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                        child: Container(
                          width: 47,
                          height: 55,
                          margin: const EdgeInsets.only(left: 1),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(0xffD90206)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                            border: isToday
                                ? Border.all(color: Color(0xffD90206), width: 1)
                                : Border.all(color: Colors.transparent),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('d').format(date),
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 7),
                              Text(
                                DateFormat('E', 'ko_KR').format(date),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                // IconButton(
                //   icon: Icon(
                //     Icons.arrow_forward_ios,
                //     color: Colors.white,
                //     size: 20,
                //   ),
                //   onPressed: () {
                //     _goToNextWeek();
                //   },
                // ),
              ],
            ),
            SizedBox(height: 15),
            // FilterRowWidget(
            //   height: 29.0,
            //   horizontalPadding: 10.0,
            //   iconSize: 12.0,
            //   fontSize: 13.0,
            // ),
          ],
        ),
        toolbarHeight: 130,
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return GestureDetector(
            // onTap: () => showCustomBottomSheet(context),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MyReviewPage()),
              );
            },
            child: Card(
              color: Colors.black,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 144,
                          height: 161,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              // 네트워크 이미지
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://handonglikelionpegbackend.s3.ap-northeast-2.amazonaws.com/scrd/%E1%84%80%E1%85%B3%E1%84%85%E1%85%B5%E1%86%B7%E1%84%8C%E1%85%A1+%E1%84%8B%E1%85%A5%E1%86%B8%E1%84%89%E1%85%B3%E1%86%AB%E3%84%B4+%E1%84%89%E1%85%A1%E1%86%BC%E1%84%8C%E1%85%A1.jpeg',
                                  width: 144,
                                  height: 161,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              // 하단 그라데이션 효과
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 161 * 0.2, // 높이의 5분의 1
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withOpacity(0), // 투명
                                        Colors.black.withOpacity(0.5), // 반투명
                                        Colors.black.withOpacity(0.8), // 진한 검정
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // 좌측 하단 평점 추가
                              Positioned(
                                bottom: 4,
                                left: 6,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Color(0xffD90206), // 별 아이콘 색상
                                      size: 14,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "4.0", // 평점
                                      style: TextStyle(
                                        color: Color(0xffD90206),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Transform.translate(
                                      offset: Offset(0, 1.5), // 위로 1px 이동
                                      child: Text(
                                        "(12)", // 리뷰 수
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Transform.translate(
                                offset: Offset(0, -4), // 위로 5px 이동
                                child: Text(
                                  '머니머니부동산',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '키이스케이프 | 스테이션점',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 11),
                                softWrap: true,
                              ),
                              SizedBox(height: 13),
                              Row(children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    '강남',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.watch_later_outlined,
                                    color: Colors.white, size: 18),
                                SizedBox(width: 4),
                                Text(
                                  '80분',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              ]),
                              SizedBox(height: 10),
                              Text(
                                '30,000원',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  _buildRatingItem(
                                      label: '난이도',
                                      value: '5',
                                      imagePath: 'assets/icon/puzzle_red.png',
                                      imageSize: 21,
                                      color: Color(0xffD90206)),
                                  SizedBox(width: 13),
                                  _buildRatingItem(
                                    label: '공포도',
                                    imageSize: 21,
                                    imagePath: 'assets/icon/ghost.png',
                                  ),
                                  SizedBox(width: 12),
                                  _buildRatingItem(
                                    label: '활동성',
                                    imagePath: 'assets/icon/shoe.png',
                                    imageSize: 21,
                                  ),
                                  SizedBox(width: 9),
                                ],
                              )
                            ],
                          ),
                        ),
                        IconButton(
                          alignment: const Alignment(-1.0, -1.65),
                          padding: const EdgeInsets.all(0),
                          icon: Icon(
                            isBookmarkClicked
                                ? Icons.bookmark_border
                                : Icons.bookmark,
                            color: isBookmarkClicked
                                ? Colors.white
                                : Color(0xffD90206),
                            size: 24,
                          ),
                          onPressed: () {
                            setState(() {
                              isBookmarkClicked = !isBookmarkClicked;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          '11 : 00',
                          '12 : 10',
                          '13 : 20',
                          '14 : 30',
                          '18 : 00',
                          '19 : 20',
                          '20 : 30'
                        ]
                            .map((time) => Container(
                                  margin: const EdgeInsets.only(right: 15),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Color(0xff2D0000),
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Color(0xffD90206)),
                                  ),
                                  child: Text(
                                    time,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 5),
                    Divider(color: Color(0xff363636)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
