import 'package:flutter/material.dart';

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

  void _toggleHorror() {
    setState(() {
      _isHorrorSelected = !_isHorrorSelected;
    });
  }

  void _toggleActivity() {
    setState(() {
      _isActivitySelected = !_isActivitySelected;
    });
  }

  void _showRegionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return RegionBottomSheet();
      },
    );
  }

  void showDifficultyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DifficultyBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 5),
          GestureDetector(
              onTap: () => _showRegionBottomSheet(context),
              child: _buildDropdownButton('지역')),
          const SizedBox(width: 5),
          GestureDetector(
              onTap: () => showDifficultyBottomSheet(context),
              child: _buildDropdownButton('난이도')),
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
          const SizedBox(width: 14),
          _buildCircleIconButton('assets/button/filter.png'),
        ],
      ),
    );
  }

  Widget _buildDropdownButton(String label) {
    return Container(
      height: widget.height,
      padding: EdgeInsets.symmetric(
          horizontal: widget.horizontalPadding, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Text(
            '지역',
            style: TextStyle(
              color: widget.fontColor,
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
            ),
          ),
          const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
            size: 16,
          ),
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

  Widget _buildCircleIconButton(String iconPath) {
    return Container(
      width: 27,
      height: 27,
      // decoration: BoxDecoration(
      //   color: Colors.grey[800],
      //   shape: BoxShape.circle,
      // ),
      child: IconButton(
        icon: Image.asset(
          iconPath,
          fit: BoxFit.contain,
        ),
        iconSize: widget.iconSize,
        onPressed: () {},
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
    '서울': ['강남', '건대'],
    '경기/인천': ['건대'],
    '대전/충청': ['홍대'],
    '대구/경북': ['노원'],
    '부산/울산': ['성수'],
    '경남': ['신촌'],
    '광주/전라': ['잠실'],
    '강원': ['강남'],
    '제주': ['대학로'],
  };

  @override
  Widget build(BuildContext context) {
    final currentSub = subRegions[mainRegions[selectedMainIndex]] ?? [];
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text('지역',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
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
          GestureDetector(
            onTap:
                selectedSubRegion != null ? () => Navigator.pop(context) : null,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              color: selectedSubRegion != null
                  ? Color(0xffD90206)
                  : Color(0xff515151),
              child: Text(
                '선택 완료',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
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
    final double sliderWidth = MediaQuery.of(context).size.width - 80;

    return Container(
      padding: EdgeInsets.all(16),
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
            children: [
              Text("난이도",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),

          Divider(color: Color(0xff363636)),

          /// 난이도 설명 텍스트
          ...difficultyDescriptions.entries.map((entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
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
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 16),
                        ),
                        child: RangeSlider(
                          values: RangeValues(_startDifficulty, _endDifficulty),
                          min: 1,
                          max: 5,
                          divisions: 4,
                          labels: RangeLabels(
                            _startDifficulty.round().toString(),
                            _endDifficulty.round().toString(),
                          ),
                          onChanged: (values) {
                            setState(() {
                              _startDifficulty = values.start.roundToDouble();
                              _endDifficulty = values.end.roundToDouble();
                              _difficultySelected = true;
                            });
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
          SizedBox(height: 50),

          /// 완료 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _difficultySelected ? Color(0xffD90206) : Color(0xff515151),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed:
                  _difficultySelected ? () => Navigator.pop(context) : null,
              child: Text("선택 완료",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
