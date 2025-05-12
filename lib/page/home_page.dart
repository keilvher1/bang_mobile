import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrd/components/style.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/filter_row_widget.dart';
import '../model/theme.dart';
import '../provider/bottomsheet_provider.dart';
import '../provider/detail_provider.dart';
import '../provider/filter_provider.dart';
import '../provider/filter_theme_provider.dart';
import '../provider/review_provider.dart';
import '../provider/saved_theme_provider.dart';
import '../provider/search_theme_provider.dart';
import '../provider/theme_provider.dart';

class DateGridPage extends StatefulWidget {
  const DateGridPage({super.key});

  @override
  _DateGridPageState createState() => _DateGridPageState();
}

class _DateGridPageState extends State<DateGridPage> {
  late DateTime _currentDate;
  late DateTime _selectedDate;
  int clicked = 0;
  late ScrollController _scrollController;
  late ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _selectedDate = DateTime.now();
    clicked = 0;
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _themeProvider.loadInitialThemes();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.loadInitialThemes(date: _selectedDate);
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          // 맨 아래 근처에 오면 추가 로드
          _themeProvider.loadMoreThemes();
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
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

  void showCustomBottomSheet(
    BuildContext context,
    ThemeModel theme,
  ) async {
    //
    debugPrint('BottomSheet: ${theme.proportion}');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => BottomSheetProvider()),
              // ChangeNotifierProvider(
              //     create: (_) =>
              //         ReviewProvider()..fetchReviews(theme.id)), //⭐ 리뷰 불러오기
              // ChangeNotifierProvider(
              //     create: (_) => ThemeDetailProvider()
              //       ..fetchThemeDetail(theme.id)), //⭐ 테마 상세정보 불러오기
            ],
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
                                        ? const Color(0xffD90206)
                                        : Colors.white,
                                    fontSize: 20,
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
                                            ? const Color(0xffD90206)
                                            : Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Transform.translate(
                                      offset: const Offset(0, -9),
                                      child: Text(
                                        '+${theme.reviewCount.toString()}',
                                        style: TextStyle(
                                            color:
                                                provider.selectedTabIndex == 1
                                                    ? const Color(0xffD90206)
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
                            ? _buildDetailContent(theme)
                            : _buildReviewContent(theme),
                      ),
                      provider.selectedTabIndex == 1
                          ? const SizedBox()
                          : const SizedBox(),
                      const SizedBox(height: 30),
                      _buildActionButtons(theme)
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailContent(ThemeModel theme) {
    final themeDetailProvider =
        Provider.of<ThemeDetailProvider>(context, listen: true);
    final themeDetail = themeDetailProvider.themeDetail;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      theme.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    theme.branch ?? 'none',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  )
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  theme.location,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.watch_later_outlined,
                  color: Colors.white, size: 19),
              const SizedBox(width: 4),
              Text(
                '${theme.playtime}분',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ]),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRatingItem(
                    label: '난이도',
                    value: theme.level.toStringAsFixed(0),
                    imagePath: 'assets/icon/puzzle_red.png',
                    imageSize: 23,
                    color: const Color(0xffD90206)),
                const SizedBox(width: 14),
                _buildRatingItem(
                  label: '장치비율',
                  value: themeDetail?.proportion ?? '0',
                  fontSize: 17,
                  color: const Color(0xffD90206),
                ),
                const SizedBox(width: 14),
                _buildRatingItem(
                    label: '공포도',
                    imagePath: theme.horror == 0
                        ? 'assets/icon/ghost.png'
                        : 'assets/icon/ghost_in.png',
                    imageSize: 23),
                const SizedBox(width: 14),
                _buildRatingItem(
                    label: '활동성',
                    imagePath: theme.activity == 0
                        ? 'assets/icon/shoe_in.png'
                        : 'assets/icon/shoe.png',
                    imageSize: 23),
              ],
            ),
            const SizedBox(height: 25),
            // Divider(
            //   color: Color(0xff363636),
            // ),
            Text(
              theme.description ?? '설명 없음',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Text(
            //   //'안녕하세요, 어른이 여러분. 오래만에 우리 어른이 여러분들을 위해서 새로운 주제를 들고 왔는데, 뭘까~요? 짜잔! 바로바로 키이스케이프사에서 야심 차게 출시한 시즌 2 "머니머니 부.동.산!" 울고 싶을 만큼 혹독한 세상에서도 이왕이면 내 건물 안에서 우는 게 나으니까! 본격 머니머니 룸과 자본주의의 꽃, 부동산의 콜라보. 지금 바로 주문하세요!',
            //   theme.url,
            //   style: TextStyle(color: Color(0xff929292), fontSize: 13),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewContent(ThemeModel theme) {
    final reviewProvider = Provider.of<ReviewProvider>(context, listen: true);
    final reviews = reviewProvider.reviews; // ✨ 받아온 리뷰 목록

    if (reviewProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (reviews.isEmpty) {
      return const Center(
        child: Text(
          '아직 등록된 리뷰가 없습니다.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 유저 정보 표시
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/level/level${review.userTier}.png',
                            width: 25,
                            height: 25,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review.nickName,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xffC9C9C9),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '방탈출 기록 표시 가능 (ex. 3개월 전)', // 여기 원하면 날짜 추가 가능
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
                  IconButton(
                    icon: const Icon(Icons.more_vert,
                        color: Colors.white, size: 20),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 13),

              // 평점, 난이도, 공포도, 활동성
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRatingItem(
                    label: '평점',
                    value: review.stars.toStringAsFixed(0),
                    fontSize: 14,
                    color: const Color(0xffD90206),
                  ),
                  const SizedBox(width: 14),
                  _buildRatingItem(
                    label: '난이도',
                    value: review.level.toString(),
                    imagePath: 'assets/icon/puzzle_red.png',
                    imageSize: 23,
                    color: const Color(0xffD90206),
                  ),
                  const SizedBox(width: 14),
                  _buildRatingItem(
                    label: '공포도',
                    imagePath: review.horror == 0
                        ? 'assets/icon/ghost.png'
                        : 'assets/icon/ghost_in.png',
                    imageSize: 23,
                  ),
                  const SizedBox(width: 14),
                  _buildRatingItem(
                    label: '활동성',
                    imagePath: review.activity == 0
                        ? 'assets/icon/shoe_in.png'
                        : 'assets/icon/shoe.png',
                    imageSize: 23,
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // 태그 리스트 (있으면)
              if (review.tagNames.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: review.tagNames.map((tag) {
                    return Chip(
                      label: Text(tag,
                          style: const TextStyle(color: Colors.white)),
                      backgroundColor: const Color(0xff2D0000),
                      side: const BorderSide(color: Color(0xffD90206)),
                    );
                  }).toList(),
                ),
              if (review.tagNames.isNotEmpty) const SizedBox(height: 15),
              // 리뷰 텍스트
              Text(
                review.text,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 12),
              const Divider(color: Color(0xff363636)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(ThemeModel theme) {
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
            onPressed: () {
              _launchUrl(Uri.parse(theme.url ?? 'http://example.com'));
            },
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

  String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  String fixBrokenText(String brokenText) {
    List<int> bytes = brokenText.codeUnits; // 유니코드 코드 유닛 리스트로 변환
    return utf8.decode(bytes); // UTF-8로 디코딩
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final filterThemeProvider = Provider.of<FilterThemeProvider>(context);
    final searchThemeProvider = Provider.of<SearchThemeProvider>(context);
    // final availableTimeProvider = Provider.of<AvailableTimeProvider>(context);
    debugPrint("isSearching: ${searchThemeProvider.isSearching}");
    debugPrint("isFiltered: ${filterThemeProvider.isFiltered}");
    debugPrint("isDateSelected: ${searchThemeProvider.dateSelected}");
    final themesToShow = searchThemeProvider.isSearching
        ? searchThemeProvider.searchResults
        // ? (searchThemeProvider.dateSelected
        //     ? (searchThemeProvider.searchResults)
        //     : (filterThemeProvider.isFiltered
        //         ? filterThemeProvider.filteredThemes
        //         : themeProvider.themes))
        : (filterThemeProvider.isFiltered
            ? filterThemeProvider.filteredThemes
            : themeProvider.themes);
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
                            final themeProvider = Provider.of<ThemeProvider>(
                                context,
                                listen: false);
                            themeProvider.loadInitialThemes(
                                date: _selectedDate);
                            // Provider.of<SearchThemeProvider>(context,
                            //         listen: false)
                            //     .setDate(_selectedDate);
                            Provider.of<SearchThemeProvider>(context,
                                    listen: false)
                                .searchThemes(
                                    date: date,
                                    filterProvider: FilterProvider());
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
            const FilterRowWidget(
              height: 29.0,
              horizontalPadding: 10.0,
              iconSize: 12.0,
              fontSize: 13.0,
            ),
          ],
        ),
        toolbarHeight: 130,
      ),
      body: Consumer<ThemeProvider>(builder: (context, provider, child) {
        if (themesToShow.isEmpty &&
            Provider.of<SearchThemeProvider>(context).isSearching) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                '결과가 없습니다.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          );
        }

        if (provider.isLoading) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColors.red6,
          ));
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: themesToShow.length,
          itemBuilder: (context, index) {
            final theme = themesToShow[index];
            final List<String> availableTimes = theme.availableTimes ?? [];
            if (index < themesToShow.length) {
              return GestureDetector(
                onTap: () {
                  final detailProvider =
                      Provider.of<ThemeDetailProvider>(context, listen: false);
                  final reviewProvider =
                      Provider.of<ReviewProvider>(context, listen: false);
                  reviewProvider.fetchReviews(theme.id); // ★ 리뷰 불러오기
                  detailProvider.fetchThemeDetail(theme.id); // ★ 테마 상세정보 불러오기
                  showCustomBottomSheet(
                    context,
                    theme,
                  ); // ★ 그 다음 BottomSheet 열기
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
                                      theme.image,
                                      width: 144,
                                      height: 161,
                                      fit: BoxFit.fill,
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
                                            Colors.black
                                                .withOpacity(0.5), // 반투명
                                            Colors.black
                                                .withOpacity(0.8), // 진한 검정
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
                                          color: Color(0xffD90206), // 별 아이콘 색상
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          theme.rating.toStringAsFixed(1), // 평점
                                          style: const TextStyle(
                                            color: Color(0xffD90206),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Transform.translate(
                                          offset:
                                              const Offset(0, 1.5), // 위로 1px 이동
                                          child: Text(
                                            '(${theme.reviewCount.toString()})', // 리뷰 수
                                            style: const TextStyle(
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
                                    offset: const Offset(0, -4), // 위로 5px 이동
                                    child: Text(
                                      theme.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    theme.branch,
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 11),
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
                                        theme.location,
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
                                      '${theme.playtime}분',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                  ]),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${formatCurrency(theme.price)}원',
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
                                          value: theme.level.toStringAsFixed(0),
                                          imagePath:
                                              'assets/icon/puzzle_red.png',
                                          imageSize: 21,
                                          color: const Color(0xffD90206)),
                                      const SizedBox(width: 13),
                                      _buildRatingItem(
                                        label: '공포도',
                                        imageSize: 21,
                                        imagePath: theme.horror == 0
                                            ? 'assets/icon/ghost_in.png'
                                            : 'assets/icon/ghost.png',
                                      ),
                                      const SizedBox(width: 12),
                                      _buildRatingItem(
                                        label: '활동성',
                                        imagePath: theme.activity == 0
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
                            IconButton(
                              alignment: const Alignment(-1.0, -1.65),
                              padding: const EdgeInsets.all(0),
                              icon: Icon(
                                context
                                        .watch<SavedThemeProvider>()
                                        .isSaved(theme.id)
                                    ? Icons.bookmark // 저장된 경우
                                    : Icons.bookmark_border, // 저장 안 된 경우
                                color: context
                                        .watch<SavedThemeProvider>()
                                        .isSaved(theme.id)
                                    ? const Color(0xffD90206) // 빨간색
                                    : Colors.white, // 기본색
                                size: 24,
                              ),
                              onPressed: () async {
                                final savedThemeProvider =
                                    context.read<SavedThemeProvider>();

                                // ⭐ 여기 한 줄이면 끝난다!
                                await savedThemeProvider
                                    .toggleSaveTheme(theme.id);
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 13),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: availableTimes
                                .map((time) => Container(
                                      margin: const EdgeInsets.only(right: 15),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xff2D0000),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: const Color(0xffD90206)),
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
            } else {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        );
      }),
    );
  }
}
