import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/filter_provider.dart';
import '../provider/filter_theme_provider.dart';
import '../provider/theme_provider.dart';

class FilterRowWidget extends StatefulWidget {
  final double height;
  final double horizontalPadding;
  final double iconSize;
  final double fontSize;
  final Color fontColor;
  final FontWeight fontWeight;

  const FilterRowWidget({
    Key? key,
    this.height = 29.0,
    this.horizontalPadding = 12.0,
    this.iconSize = 24.0,
    this.fontSize = 13.0,
    this.fontColor = Colors.white,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  @override
  _FilterRowWidgetState createState() => _FilterRowWidgetState();
}

class _FilterRowWidgetState extends State<FilterRowWidget> {
  bool _isHorrorSelected = false;
  bool _isActivitySelected = false;

  String? _selectedRegion;
  String? _selectedDifficulty;
  void _toggleHorror() async {
    setState(() {
      _isHorrorSelected = !_isHorrorSelected;
    });

    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    filterProvider.setHorror(_isHorrorSelected ? 1 : 0); // 🔥 여기 추가
    final filterThemeProvider =
        Provider.of<FilterThemeProvider>(context, listen: false);
    await filterThemeProvider.fetchFilteredThemes(filterProvider);
  }

  void _toggleActivity() async {
    setState(() {
      _isActivitySelected = !_isActivitySelected;
    });

    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    filterProvider.setActivity(_isActivitySelected ? 1 : 0); // 🔥 여기 추가
    final filterThemeProvider =
        Provider.of<FilterThemeProvider>(context, listen: false);
    await filterThemeProvider.fetchFilteredThemes(filterProvider);
  }

  void _showRegionBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => RegionBottomSheet(),
    );

    if (result != null) {
      setState(() {
        _selectedRegion = result;
      });
    }
  }

  void _showDifficultyBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DifficultyBottomSheet(),
    );

    if (result != null) {
      setState(() {
        _selectedDifficulty = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 5),
                GestureDetector(
                    onTap: () {
                      _showRegionBottomSheet(context);
                    },
                    child: _buildDropdownButton('전국', _selectedRegion, 0)),
                const SizedBox(width: 5),
                GestureDetector(
                    onTap: () => _showDifficultyBottomSheet(context),
                    child: _buildDropdownButton('난이도', _selectedDifficulty, 1)),
                const SizedBox(width: 5),
                _buildIconTextButton(
                  '공포도',
                  'assets/icon/ghost_no.png',
                  _isHorrorSelected,
                  _toggleHorror,
                ),
                const SizedBox(width: 5),
                _buildIconTextButton(
                  '활동성',
                  'assets/icon/shoe_no.png',
                  _isActivitySelected,
                  _toggleActivity,
                ),
                const SizedBox(width: 10),
                // Icon(
                //   Icons.menu,
                //   size: 30,
                //   color: Colors.white,
                // ),
                GestureDetector(
                    onTap: () async {
                      final filterProvider =
                          Provider.of<FilterProvider>(context, listen: false);
                      final filterThemeProvider =
                          Provider.of<FilterThemeProvider>(context,
                              listen: false);
                      debugPrint(
                          'FilterProvider: ${filterProvider.horror}, ${filterProvider.activity}, ${filterProvider.region}, ${filterProvider.levelMin}, ${filterProvider.levelMax}');
                      await filterThemeProvider
                          .fetchFilteredThemes(filterProvider);
                      debugPrint(
                          'Filtered themes: ${filterThemeProvider.filteredThemes}');
                    },
                    child: _buildCircleIconButton('assets/button/filter.png'))
              ],
            ),
          ),
        ),
        // _buildCircleIconButton('assets/button/filter.png'),
      ],
    );
  }

  Widget _buildDropdownButton(
      String defaultLabel, String? selectedValue, int num) {
    debugPrint('selected :  $selectedValue');
    final isSelected = selectedValue != null &&
        selectedValue != '전체' &&
        selectedValue != '난이도';
    return Container(
      height: widget.height,
      padding: EdgeInsets.only(left: 7, right: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        border: Border.all(color: isSelected ? Colors.black : Colors.white),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          num == 1
              ? Image.asset(
                  'assets/icon/puzzle_red.png',
                  width: 16,
                  color: isSelected ? Colors.black : Colors.white,
                )
              : SizedBox.shrink(),
          const SizedBox(width: 3),
          Text(
            selectedValue ?? defaultLabel,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
            ),
          ),
          num == 0
              ? Icon(Icons.arrow_drop_down,
                  color: isSelected ? Colors.black : Colors.white, size: 16)
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildIconTextButton(
    String text,
    String iconPath,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: widget.height,
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                iconPath,
                width: widget.iconSize,
                height: widget.iconSize,
                color: isSelected ? Colors.black : Colors.white,
              ),
              const SizedBox(width: 7),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.black : widget.fontColor,
                  fontSize: widget.fontSize,
                  fontWeight: widget.fontWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleIconButton(String iconPath, {VoidCallback? onTap}) {
    return SizedBox(
      width: 27,
      height: 27,
      child: IconButton(
        icon: Image.asset(
          iconPath,
          fit: BoxFit.contain,
        ),
        iconSize: widget.iconSize,
        onPressed: onTap, // 👉 onTap을 여기로 넘겨줌
        padding: EdgeInsets.zero,
      ),
    );
  }
}

// 3. RegionBottomSheet 위젯
class RegionBottomSheet extends StatefulWidget {
  @override
  _RegionBottomSheetState createState() => _RegionBottomSheetState();
}

class _RegionBottomSheetState extends State<RegionBottomSheet> {
  int selectedMainIndex = 0;
  String? selectedSubRegion;

  final List<String> mainRegions = [
    '전국',
    '서울',
    '경기/인천',
    '대전/충청',
    '대구/경북',
    '부산/울산',
    '경남',
    '광주/전라',
    '강원',
    '제주',
  ];

  final Map<String, List<String>> subRegions = {
    '전국': ['전체'],
    '서울': ['전체', '강남', '건대', '노원', '성수', '신촌', '잠실', '홍대', '성수', '노원'],
    '경기/인천': ['전체', '수원', '안산', '건대'],
    '대구': ['전체'],
    '대전': ['전체'],
    '부산': ['전체'],
    '전북': ['전체'],
    '충북': ['전체'],
    '충남': ['전체']
  };

  @override
  Widget build(BuildContext context) {
    final currentSub = subRegions[mainRegions[selectedMainIndex]] ?? [];
    debugPrint('$selectedMainIndex');
    return Container(
      height: MediaQuery.of(context).size.height * 0.63,
      // height: MediaQuery.of(context).size.width - 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),

          /// 제목 및 닫기 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 12,
                  ),
                  Text("지역",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              IconButton(
                padding: EdgeInsets.only(bottom: 20, right: 25),
                icon: Icon(Icons.close, color: Colors.white),
                alignment: Alignment(-1, 1),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          Expanded(
            child: Row(
              children: [
                // Main region list
                Expanded(
                  child: ListView.builder(
                    itemCount: mainRegions.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedMainIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => selectedMainIndex = index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.black,
                            border: Border(
                              bottom: BorderSide(
                                width: 0.50,
                                color: const Color(0xFF363636),
                              ),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(
                              mainRegions[index],
                              style: TextStyle(
                                color: isSelected
                                    ? Color(0xffD90206)
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Sub region list
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: currentSub.length,
                    itemBuilder: (context, index) {
                      final sub = currentSub[index];
                      final isSelected = sub == selectedSubRegion;
                      return GestureDetector(
                        onTap: () => setState(() => selectedSubRegion = sub),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                isSelected ? Color(0xffD90206) : Colors.black,
                            border: Border(
                              bottom: BorderSide(
                                width: 0.50,
                                color: const Color(0xFF363636),
                              ),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                sub,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text('12', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // ✅ 지역 선택 완료 버튼
          // ✅ 지역 선택 완료 버튼
          GestureDetector(
            onTap: selectedSubRegion != null
                ? () async {
                    final region = selectedMainIndex > 0
                        ? (selectedSubRegion != '전체'
                            ? '$selectedSubRegion'
                            : '${mainRegions[selectedMainIndex]} $selectedSubRegion')
                        : '전체';

                    final filterProvider =
                        Provider.of<FilterProvider>(context, listen: false);
                    filterProvider.setRegion(region == '전체' ? null : region);
                    final filterThemeProvider =
                        Provider.of<FilterThemeProvider>(context,
                            listen: false);
                    await filterThemeProvider
                        .fetchFilteredThemes(filterProvider);
                    Navigator.pop(context, region); // 닫기만 해도 됨 (적용은 오른쪽 버튼에서)
                  }
                : null,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              color: selectedSubRegion != null
                  ? Color(0xffD90206)
                  : Color(0xff515151),
              child: Text('선택 완료',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class DifficultyBottomSheet extends StatefulWidget {
  @override
  _DifficultyBottomSheetState createState() => _DifficultyBottomSheetState();
}

class _DifficultyBottomSheetState extends State<DifficultyBottomSheet> {
  double _startDifficulty = 1;
  double _endDifficulty = 5;
  bool _difficultySelected = false;

  final Map<int, String> difficultyDescriptions = {
    1: '10방 미만에게 추천하는 난이도',
    2: '10방 이상 50방 미만에게 추천하는 난이도',
    3: '50방 이상 100방 미만에게 추천하는 난이도',
    4: '100방 이상 200방 미만에게 추천하는 난이도',
    5: '200방 이상에게 추천하는 난이도',
  };

  @override
  Widget build(BuildContext context) {
    // final double sliderWidth = MediaQuery.of(context).size.width - 80;

    return Container(
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 제목 및 닫기 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 12,
                  ),
                  Text("난이도",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              IconButton(
                padding: EdgeInsets.only(bottom: 20, right: 25),
                icon: Icon(Icons.close, color: Colors.white),
                alignment: Alignment(-1, 1),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),

          Divider(color: Color(0xff363636)),
          SizedBox(
            height: 25,
          ),

          /// 난이도 설명 텍스트
          ...difficultyDescriptions.entries.map((entry) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    Image.asset(
                      'assets/icon/puzzle_red.png',
                      width: 20,
                      color: Color(0xffD90206),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "${entry.key}  :  ${entry.value}",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    )
                  ],
                ),
              )),

          SizedBox(height: 30),

          /// 퍼즐 + 슬라이더 (Stack)
          SizedBox(
            height: 100, // ← Stack 높이 충분히 확보
            child: LayoutBuilder(
              builder: (context, constraints) {
                final sliderWidth = constraints.maxWidth - 40; // 20 padding * 2

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    /// RangeSlider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbColor: Colors.white, // 🔥 커서(thumb) 색상
                          // overlayColor: Colors.white.withOpacity(0.2),
                          // thumbShape: RoundSliderThumbShape(
                          //   // enabledThumbRadius: 8,
                          //   elevation: 2,
                          // ),
                          trackHeight: 4,
                          activeTrackColor: Color(0xffD90206),
                          inactiveTrackColor: Colors.white30,
                          // overlayShape:
                          //     RoundSliderOverlayShape(overlayRadius: 16),
                        ),
                        child: RangeSlider(
                          values: RangeValues(_startDifficulty, _endDifficulty),
                          min: 1,
                          max: 5,
                          divisions: 4,
                          // labels: RangeLabels(
                          //   _startDifficulty.round().toString(),
                          //   _endDifficulty.round().toString(),
                          // ),
                          onChanged: (values) {
                            setState(() {
                              _startDifficulty = values.start.roundToDouble();
                              _endDifficulty = values.end.roundToDouble();
                              _difficultySelected = true;
                            });
                            debugPrint('selected : $_difficultySelected');
                          },
                        ),
                      ),
                    ),

                    /// 시작 퍼즐 아이콘 + 숫자
                    Positioned(
                      left: 30 + (_startDifficulty - 1) / 4 * sliderWidth - 10,
                      bottom: 60,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icon/puzzle_red.png',
                            width: 24,
                            color: Color(0xffD90206),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "${_startDifficulty.round()}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                    /// 끝 퍼즐 아이콘 + 숫자
                    Positioned(
                      left: 0 + (_endDifficulty - 1) / 4 * sliderWidth - 10,
                      bottom: 60,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icon/puzzle_red.png',
                            width: 24,
                            color: Color(0xffD90206),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "${_endDifficulty.round()}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 30),

          /// 완료 버튼
          // Container(
          //   width: double.infinity,
          //   padding: EdgeInsets.symmetric(vertical: 16),
          //   alignment: Alignment.center,
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor:
          //           _difficultySelected ? Color(0xffD90206) : Color(0xff515151),
          //     ),
          //     onPressed:
          //         _difficultySelected ? () => Navigator.pop(context) : null,
          //     child: Text("선택 완료",
          //         style: TextStyle(
          //             color: Colors.white, fontWeight: FontWeight.bold)),
          //   ),
          // ),
          // ✅ 난이도 선택 완료 버튼
          // ✅ 난이도 선택 완료 버튼
          GestureDetector(
            onTap: _difficultySelected
                ? () async {
                    final minLevel = _startDifficulty;
                    final maxLevel = _endDifficulty;

                    final filterProvider =
                        Provider.of<FilterProvider>(context, listen: false);

                    if (minLevel == 1 && maxLevel == 5) {
                      filterProvider.setLevel(null, null);
                      Navigator.pop(context, '난이도'); // 🎯 난이도 초기화
                    } else {
                      final filterThemeProvider =
                          Provider.of<FilterThemeProvider>(context,
                              listen: false);
                      await filterThemeProvider
                          .fetchFilteredThemes(filterProvider);
                      filterProvider.setLevel(minLevel, maxLevel);
                      Navigator.pop(context,
                          '${minLevel.round()} ~ ${maxLevel.round()}'); // 🎯 난이도 범위 넘긴다
                    }
                  }
                : null,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              color:
                  _difficultySelected ? Color(0xffD90206) : Color(0xff515151),
              child: Text('선택 완료',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
