import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../components/filter_row_widget.dart';
import '../provider/bottomsheet_provider.dart';

class DateGridPage extends StatefulWidget {
  const DateGridPage({Key? key}) : super(key: key);

  @override
  _DateGridPageState createState() => _DateGridPageState();
}

class _DateGridPageState extends State<DateGridPage> {
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                color: color,
                width: 16,
                height: 16,
              ),
              if (value != null)
                Text(
                  value,
                  style: TextStyle(color: color, fontSize: 11),
                ),
            ],
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
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

  Widget filterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 8),
          Container(
            height: 29,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(30),
            ),
            child: DropdownButton<String>(
              value: '지역',
              items: <String>['지역', '옵션1', '옵션2']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child:
                      Text(value, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (String? newValue) {},
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 29,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(30),
            ),
            child: DropdownButton<String>(
              value: '난이도',
              items: <String>['난이도', '쉬움', '보통', '어려움']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child:
                      Text(value, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (String? newValue) {},
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 29,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextButton.icon(
              onPressed: () {},
              icon: Image.asset(
                'assets/button/knife.png', // 원하는 이미지 경로
                width: 24, // 크기 조절
                height: 24,
              ),
              label: const Text('공포도 X',
                  style: TextStyle(color: Colors.white, fontSize: 13)),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 29,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextButton.icon(
              onPressed: () {},
              icon: Image.asset(
                'assets/button/sneaker.png', // 원하는 이미지 경로
                width: 24,
                height: 24,
              ),
              label: const Text('활동성 X', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(width: 33),
          Container(
            width: 27,
            height: 27,
            decoration: BoxDecoration(
              color: Colors.grey[800], // 둥근 버튼 배경색
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Image.asset(
                'assets/icon/radio.png', // 이미지 경로
                color: Colors.white, // 이미지 색상 (필요 시 적용)
              ),
              iconSize: 24, // 아이콘 크기
              onPressed: () {},
            ),
          )
        ],
      ),
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
                                      ? Colors.red
                                      : Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () => provider.setTabIndex(1),
                              child: Text(
                                '리뷰 12+',
                                style: TextStyle(
                                  color: provider.selectedTabIndex == 1
                                      ? Colors.red
                                      : Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
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
                        ? Center(
                            child: Text(
                            '전체 리뷰',
                            style: TextStyle(color: Colors.red),
                          ))
                        : SizedBox(),
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
                Text(
                  '머니머니 부동산',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
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
                  style: TextStyle(color: Colors.black, fontSize: 10),
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
            const SizedBox(height: 22),
            const SizedBox(height: 8),
            const Text(
              '테마 설명',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '안녕하세요, 어른이 여러분. 오래만에 우리 어른이 여러분들을 위해서 새로운 주제를 들고 왔는데, 뭘까~요? 짜잔! 바로바로 키이스케이프사에서 야심 차게 출시한 시즌 2 "머니머니 부.동.산!" 울고 싶을 만큼 혹독한 세상에서도 이왕이면 내 건물 안에서 우는 게 나으니까! 본격 머니머니 룸과 자본주의의 꽃, 부동산의 콜라보. 지금 바로 주문하세요!',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewContent() {
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
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 20,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'saint0325(tier)',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '3개월 전',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '머니머니 패키지보다 훨씬더 어렵고 인원이 늘어나서인지 모르겠지만 문제 난이도 자체는 머머패가 조금 더 어려웠던 것 같다. 머머패랑 비교했을때 만족도는 거의 비슷하다.',
                style: TextStyle(color: Colors.white70),
              ),
              const Divider(color: Color(0xff363636)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
          ),
          child: const Text('리뷰작성'),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
          ),
          child: const Text('예약하기', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

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
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          margin: const EdgeInsets.only(left: 1),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.red : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                            border: isToday
                                ? Border.all(color: Colors.red, width: 1)
                                : Border.all(color: Colors.transparent),
                          ),
                          child: Column(
                            children: [
                              Text(
                                DateFormat('d').format(date),
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 9),
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
            SizedBox(height: 21),
            FilterRowWidget(
              height: 29.0,
              horizontalPadding: 10.0,
              iconSize: 12.0,
              fontSize: 13.0,
            ),
            SizedBox(height: 10),
          ],
        ),
        toolbarHeight: 150,
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => showCustomBottomSheet(context),
            child: Card(
              color: Colors.black,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
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
                          color: Color(0xffD9D9D9),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '머니머니부동산',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
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
                                        color: Colors.black, fontSize: 10),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.watch_later_outlined,
                                    color: Colors.white, size: 19),
                                SizedBox(width: 4),
                                Text(
                                  '80분',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
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
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildRatingItem(
                                      label: '난이도',
                                      value: '5',
                                      imagePath: 'assets/button/puzzle.png',
                                      color: Colors.red),
                                  SizedBox(width: 11),
                                  _buildRatingItem(
                                    label: '공포도',
                                    imagePath:
                                        'assets/button/knife_rounded.png',
                                  ),
                                  SizedBox(width: 10),
                                  _buildRatingItem(
                                      label: '활동성',
                                      imagePath:
                                          'assets/button/shoes_rounded.png'),
                                  SizedBox(width: 9),
                                  _buildRatingItem(label: '평점', value: '4.0'),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: IconButton(
                            alignment: Alignment(-1.0, -2.5),
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(
                              Icons.bookmark_border,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
                                      horizontal: 7, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Color(0xff2D0000),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.red),
                                  ),
                                  child: Text(
                                    time,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 8),
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
