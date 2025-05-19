import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrd/page/my_reply_page.dart';

import '../provider/saved_theme_provider.dart';

class MySavedPage extends StatefulWidget {
  const MySavedPage({super.key});

  @override
  _MySavedPageState createState() => _MySavedPageState();
}

class _MySavedPageState extends State<MySavedPage> {
  late DateTime _currentDate;
  late DateTime _selectedDate;
  int clicked = 0;
  late Future<void> _fetchSavedThemesFuture;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _selectedDate = DateTime.now();
    clicked = 0;
    final savedProvider =
        Provider.of<SavedThemeProvider>(context, listen: false);
    _fetchSavedThemesFuture = savedProvider.fetchAndSetSavedThemes();
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

  bool isBookmarkClicked = false;
  String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final savedProvider =
        Provider.of<SavedThemeProvider>(context, listen: false);

    final savedThemeProvider = Provider.of<SavedThemeProvider>(context);
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
                            //DateFormat('yyyy-MM-dd').format(_selectedDate);
                            final savedProvider =
                                Provider.of<SavedThemeProvider>(context,
                                    listen: false);
                            savedProvider.fetchAndSetSavedThemes(
                                date: _selectedDate);
                          });
                        },
                        child: Container(
                          width: 47,
                          height: 55,
                          margin: const EdgeInsets.only(left: 1),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xffD90206)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                            border: isToday
                                ? Border.all(
                                    color: const Color(0xffD90206), width: 1)
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
                              const SizedBox(height: 7),
                              Text(
                                DateFormat('E', 'ko_KR').format(date),
                                style: const TextStyle(
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
            const SizedBox(height: 15),
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
      body: FutureBuilder(
          future: _fetchSavedThemesFuture, // ⭐ 수정된 부분
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final savedThemes = savedProvider.savedThemes;

              return ListView.builder(
                itemCount: savedThemes.length,
                itemBuilder: (context, index) {
                  final themeId = savedThemes[index];
                  if (savedThemes.isEmpty) {
                    return const Center(
                      child: Text(
                        '저장된 테마가 없습니다.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    return GestureDetector(
                      // onTap: () => showCustomBottomSheet(context),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MyReviewPage()),
                        );
                      },
                      child: Card(
                        color: Colors.black,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                              // 'https://handonglikelionpegbackend.s3.ap-northeast-2.amazonaws.com/scrd/%E1%84%80%E1%85%B3%E1%84%85%E1%85%B5%E1%86%B7%E1%84%8C%E1%85%A1+%E1%84%8B%E1%85%A5%E1%86%B8%E1%84%89%E1%85%B3%E1%86%AB%E3%84%B4+%E1%84%89%E1%85%A1%E1%86%BC%E1%84%8C%E1%85%A1.jpeg',
                                              imageUrl:
                                                  savedThemes[index].image,
                                              width: 144,
                                              height: 161,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error)),
                                        ),

                                        // 하단 그라데이션 효과
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            height: 161 * 0.2, // 높이의 5분의 1
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                              ),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.black
                                                      .withOpacity(0), // 투명
                                                  Colors.black
                                                      .withOpacity(0.5), // 반투명
                                                  Colors.black.withOpacity(
                                                      0.8), // 진한 검정
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                color: Color(
                                                    0xffD90206), // 별 아이콘 색상
                                                size: 14,
                                              ),
                                              const SizedBox(width: 4),
                                              const Text(
                                                '??', // 평점
                                                style: TextStyle(
                                                  color: Color(0xffD90206),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Transform.translate(
                                                offset: const Offset(
                                                    0, 1.5), // 위로 1px 이동
                                                child: const Text(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Transform.translate(
                                          offset:
                                              const Offset(0, -4), // 위로 5px 이동
                                          child: Row(
                                            children: [
                                              Text(
                                                savedThemes[index].title,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "${savedThemes[index].brand} | ${savedThemes[index].branch}",
                                          style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 11),
                                          softWrap: true,
                                        ),
                                        const SizedBox(height: 13),
                                        Row(children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 2),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Text(
                                              savedThemes[index].brand,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.watch_later_outlined,
                                              color: Colors.white, size: 18),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${savedThemes[index].playtime}분',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ),
                                        ]),
                                        const SizedBox(height: 10),
                                        Text(
                                          '${formatCurrency(savedThemes[index].price)}원',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            _buildRatingItem(
                                                label: '난이도',
                                                value: savedThemes[index]
                                                    .level
                                                    .toStringAsFixed(0),
                                                imagePath:
                                                    'assets/icon/puzzle_red.png',
                                                imageSize: 21,
                                                color: const Color(0xffD90206)),
                                            const SizedBox(width: 13),
                                            _buildRatingItem(
                                              label: '공포도',
                                              imageSize: 21,
                                              imagePath: savedThemes[index]
                                                          .horror ==
                                                      0
                                                  ? 'assets/icon/ghost_in.png'
                                                  : 'assets/icon/ghost.png',
                                            ),
                                            const SizedBox(width: 12),
                                            _buildRatingItem(
                                              label: '활동성',
                                              imagePath: savedThemes[index]
                                                          .activity ==
                                                      0
                                                  ? 'assets/icon/shoe_in.png'
                                                  : 'assets/icon/shoe.png',
                                              imageSize: 21,
                                            ),
                                            const SizedBox(width: 9),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: IconButton(
                                      alignment: const Alignment(-1.0, -1.65),
                                      padding: const EdgeInsets.all(0),
                                      icon: Icon(
                                        context
                                                .watch<SavedThemeProvider>()
                                                .isSaved(savedThemes[index].id)
                                            ? Icons.bookmark // 저장된 경우
                                            : Icons
                                                .bookmark_border, // 저장 안 된 경우
                                        color: context
                                                .watch<SavedThemeProvider>()
                                                .isSaved(savedThemes[index].id)
                                            ? const Color(0xffD90206) // 빨간색
                                            : Colors.white, // 기본색
                                        size: 24,
                                      ),
                                      onPressed: () async {
                                        final savedThemeProvider =
                                            context.read<SavedThemeProvider>();

                                        // ⭐ 여기 한 줄이면 끝난다!
                                        await savedThemeProvider
                                            .toggleSaveTheme(
                                                savedThemes[index].id);
                                      },
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 13),
                              if (savedThemes[index].availableTimes != null &&
                                  savedThemes[index].availableTimes!.isNotEmpty)
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: savedThemes[index]
                                        .availableTimes!
                                        .map((time) => Container(
                                              margin: const EdgeInsets.only(
                                                  right: 15),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: const Color(0xff2D0000),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: const Color(
                                                        0xffD90206)),
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
                              const SizedBox(height: 5),
                              const Divider(color: Color(0xff363636)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              );
            }
          }),
    );
  }
}
