import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrd/model/upload_party.dart';
import 'package:scrd/page/search_theme.dart';
import '../components/buttons.dart';
import '../model/review_upload.dart';
import '../provider/select_theme_provider.dart';
import '../provider/upload_provider.dart';

class UploadPage extends StatefulWidget {
  final bool isReviewMode;

  const UploadPage({
    super.key,
    required this.isReviewMode,
  });

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool isRecruitment = true;
  bool isRated = false;
  double rating = 0;
  List<String> selectedTags = [];
  bool isScary = false;
  bool isActive = false;
  bool isEscaped = false;
  int hintCount = 3;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int puzzleLevel = 0;
  bool isDatePicked = false; //캘린더 날짜 선택 여부
  bool isTapped = false;
  Color red = const Color(0xFFD90206);
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  late SelectThemeProvider _selectThemeProvider;

  final Map<String, int> tagToIdMap = {
    "#감성적인": 1,
    "#귀여운": 2,
    "#신비한": 3,
    "#스타일있는": 4,
    "#미스테리한": 5,
    "#복고무드": 6,
    "#아날로그감성": 7,
    "#타임슬립체험": 8,
    "#몽글몽글무드": 9,
    "#러블리테마": 10,
    "#귀여움주의": 11,
    "#달콤살벌": 12,
    "#심쿵주의보": 13,
    "#오싹한무드": 14,
    "#긴장감폭발": 15,
    "#소름돋는감성": 16,
    "#조용한공포": 17,
    "#숨멎주의": 18,
    "#긴장백배": 19,
    "#심리공포감성": 20,
    "#섬세한연출": 21,
    "#감성디테일": 22,
    "#눈치게임시작": 23,
    "#감정선폭발": 24,
    "#잔잔한몰입감": 25,
    "#디테일맛집": 26,
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectThemeProvider =
        Provider.of<SelectThemeProvider>(context, listen: false);
    isRecruitment = _selectThemeProvider.selectedMode == UploadMode.recruitment;
  }

  @override
  void dispose() {
    _selectThemeProvider.clearSelectedTheme(); // ✅ 안전하게 사용
    super.dispose();
  }

  bool isFormCompleteForReview() {
    debugPrint("puzzelLevel: $puzzleLevel");
    debugPrint("isRated: $isRated");
    debugPrint("description: ${descriptionController.text}");
    debugPrint("selectedTags: $selectedTags");
    return isRated &&
        // descriptionController.text.isNotEmpty &&
        // selectedTags.isNotEmpty &&
        puzzleLevel > 0;
  }

  bool isFormCompleteForRecruitment() {
    return titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        selectedDate != null &&
        selectedTime != null;
  }

  Future<void> _submitForm() async {
    final selectedTheme = _selectThemeProvider.selectedTheme;
    if (selectedTheme == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('테마를 선택해주세요.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final provider = Provider.of<UploadProvider>(context, listen: false);
    final currentMode =
        Provider.of<SelectThemeProvider>(context, listen: false).selectedMode;

    bool success = false;

    if (currentMode == UploadMode.review) {
      final review = ReviewUpload(
        text: descriptionController.text.trim(),
        level: puzzleLevel,
        stars: rating.toInt(),
        horror: isScary ? 1 : 0,
        activity: isActive ? 1 : 0,
        themeId: selectedTheme.id,
        tagIds: selectedTags
            .map((tag) => tagToIdMap[tag] ?? 0)
            .where((id) => id != 0)
            .toList(),
        isSuccessful: isEscaped,
        hintUsageCount: hintCount,
      );
      success = await provider.uploadReview(selectedTheme.id, review);
    } else {
      final deadline = DateTime(
        selectedDate?.year ?? DateTime.now().year,
        selectedDate?.month ?? DateTime.now().month,
        selectedDate?.day ?? DateTime.now().day,
        selectedTime?.hour ?? 18,
        selectedTime?.minute ?? 0,
      );

      final party = PartyUpload(
        title: titleController.text.trim(),
        content: descriptionController.text.trim(),
        currentParticipants: 1,
        maxParticipants: 4,
        deadline: deadline.toIso8601String(),
      );
      success = await provider.uploadParty(selectedTheme.id, party);
    }

    setState(() => _isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('업로드 성공!')),
      );
      Navigator.of(context).pop();
    } else {
      debugPrint("Upload failed");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('업로드 실패. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectThemeProvider = Provider.of<SelectThemeProvider>(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Provider.of<SelectThemeProvider>(context, listen: false)
                        .clearSelectedTheme();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              GestureDetector(
                onTap: () {
                  setState(() => isRecruitment = true);
                  selectThemeProvider.setMode(UploadMode.recruitment); // ⭐
                  Provider.of<SelectThemeProvider>(context, listen: false)
                      .clearSelectedTheme();
                },
                child: Text(
                  "일행 모집",
                  style: TextStyle(
                    color: isRecruitment ? const Color(0xFFD90206) : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              GestureDetector(
                onTap: () {
                  setState(() => isRecruitment = false);
                  selectThemeProvider.setMode(UploadMode.review); // ⭐
                  Provider.of<SelectThemeProvider>(context, listen: false)
                      .clearSelectedTheme();
                },
                child: Text(
                  "리뷰",
                  style: TextStyle(
                    color: !isRecruitment ? const Color(0xFFD90206) : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isRecruitment) _buildReviewSection(),
              if (isRecruitment) _buildRecruitmentSection(),
            ],
          ),
        ),
        bottomNavigationBar: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (isRecruitment && isFormCompleteForRecruitment()) ||
                    (!isRecruitment && isFormCompleteForReview())
                ? () {
                    // 등록 로직
                    _submitForm();
                  }
                : null,
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.grey;
                }
                return red;
              }),
              padding: WidgetStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(vertical: 17),
              ),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                ),
              ),
            ),
            child: const Text(
              "등록하기",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewSection() {
    List<String> tags = ["#감성적인", "#귀여운", "#신비한", "#스타일있는", "#미스테리한"];
    List<List<String>> tagGroups = [
      ["#감성적인", "#귀여운", "#신비한", "#스타일있는", "#미스테리한"],
      ["#복고무드", "#아날로그감성", "#타임슬립체험", "#몽글몽글무드", "#러블리테마"],
      ["#귀여움주의", "#달콤살벌", "#심쿵주의보", "#오싹한무드", "#긴장감폭발"],
      ["#소름돋는감성", "#조용한공포", "#숨멎주의", "#긴장백배", "#심리공포감성"],
      ["#섬세한연출", "#감성디테일", "#눈치게임시작", "#감정선폭발", "#잔잔한몰입감"],
      ["#디테일맛집"]
    ];

    int min = 0;
    int sec = 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        SelectThemeButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SearchThemePage(),
              ),
            );

            if (result != null) {
              Provider.of<SelectThemeProvider>(context, listen: false)
                  .selectTheme(result);
            }
          },
          isTapped: isTapped, // 필요하다면 여전히 전달
        ),
        const SizedBox(height: 24),
        sectionTitle2('테마의 평점을 남겨주세요 !'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: const Color(0xFFD90206),
                size: 30,
              ),
              onPressed: () => setState(() {
                rating = index + 1.0;
                isRated = true;
              }),
            );
          }),
        ),
        const SizedBox(height: 23),
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: Color(0xFF121212)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              sectionTitleOption('분위기에 맞는 해시태그를 남겨주세요 !'),
              Padding(
                padding: const EdgeInsets.only(left: 13.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    SelectableHashtagRow(tags: tagGroups[0]),
                    const SizedBox(height: 15),
                    SelectableHashtagRow(tags: tagGroups[1]),
                    const SizedBox(height: 15),
                    SelectableHashtagRow(tags: tagGroups[2]),
                    const SizedBox(height: 15),
                    SelectableHashtagRow(tags: tagGroups[3]),
                    const SizedBox(height: 40),
                  ],
                ),
              )
            ],
          ),
        ),
        sectionTitleOption('생생한 후기를 적어주세요 !'),
        const SizedBox(height: 12),
        Container(
          width: 342,
          height: 209,
          padding: const EdgeInsets.only(top: 5, left: 5),
          decoration: ShapeDecoration(
            color: const Color(0xFF121212),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          child: TextField(
            controller: descriptionController,
            style: const TextStyle(
              color: Color(0xFFB9B9B9),
              fontSize: 14,
            ),
            maxLines: 8,
            // 충분한 높이를 위해 maxLines 지정
            minLines: 6,
            // 최소 줄 수 지정 (힌트 보이게끔)
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              hintText:
                  "리뷰글을 작성해보세요.(선택사항)\n\n솔직한 경험을 공유하되, 다른 이용자와 업체를 배려하는\n리뷰를 작성해주세요 !",
              hintStyle: TextStyle(
                color: Color(0xFFB9B9B9),
                fontSize: 13,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.transparent,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            ),
          ),
        ),
        sectionTitleOption('더욱 자세한 후기를 알고 싶어요 !'),
        const SizedBox(height: 12),
        Container(
          color: const Color(0xFF121212),
          padding:
              const EdgeInsets.only(left: 30, top: 12, right: 30, bottom: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isScary = !isScary;
                      });
                    },
                    child: _iconWithLabel(
                      '공포도',
                      'assets/icon/ghost_no.png',
                      isScary,
                    ),
                  ),
                  const SizedBox(width: 24),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isActive = !isActive;
                      });
                    },
                    child: _iconWithLabel(
                      '활동성',
                      'assets/icon/shoe_no.png',
                      isActive,
                    ),
                  ),
                  const SizedBox(width: 24),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isEscaped = !isEscaped;
                        debugPrint("isEscaped: $isEscaped");
                      });
                    },
                    child: _checkWithLabel(
                      '탈출 여부',
                      isEscaped,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('탈출 시간',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14)),
                  const SizedBox(width: 25),
                  _timeInputField(
                      onChanged: (v) =>
                          setState(() => min = int.tryParse(v) ?? 0)),
                  const SizedBox(width: 8),
                  const Text(
                    'Min',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  _timeInputField(
                      onChanged: (v) =>
                          setState(() => sec = int.tryParse(v) ?? 0)),
                  const SizedBox(width: 8),
                  const Text('Sec', style: TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('힌트 사용 횟수',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14)),
                  const SizedBox(width: 16),
                  Container(
                    height: 22, // 전체 높이 지정
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch, // 높이 꽉 채우도록
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (hintCount > 0) hintCount--;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 36,
                          color: Colors.white,
                          child: Text(
                            '$hintCount',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              hintCount++;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Text('체감 난이도',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14)),
                  const SizedBox(width: 13),
                  Row(
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            puzzleLevel = index + 1;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Image.asset(
                            'assets/icon/puzzle_red.png',
                            color: index < puzzleLevel ? red : Colors.grey,
                            width: 28,
                            height: 28,
                          ),
                        ),
                      );
                    }),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _iconWithLabel(String label, String iconPath, bool? isSelected) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 15),
        Container(
          width: 27,
          height: 27,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected == true
                ? Colors.white
                : const Color(0xFF121212), // 배경색 (원 안)
            border: Border.all(
                width: 2,
                color: isSelected == true ? Colors.white : const Color(0xFF777676)),
          ),
          child: Center(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                isSelected == false ? Colors.transparent : Colors.white,
                BlendMode.saturation,
              ),
              child: Image.asset(
                iconPath,
                width: 15,
                height: 15,
                color: isSelected == false ? const Color(0xff777676) : Colors.black,
                colorBlendMode: BlendMode.srcIn,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _checkWithLabel(String label, bool isChecked) {
    return Row(
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700)),
        const SizedBox(width: 15),
        Icon(Icons.check_circle,
            color:
                isChecked == true ? const Color(0xFFD90206) : const Color(0xFF777676),
            size: 26),
      ],
    );
  }

  Widget _timeInputField({required Function(String) onChanged}) {
    return SizedBox(
      width: 38,
      child: TextField(
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black, fontSize: 13),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.only(left: 4, right: 4, top: 4),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    bool isAm = selectedTime?.period == DayPeriod.am || selectedTime == null;
    int selectedHour = selectedTime?.hourOfPeriod ?? 11;
    int selectedMinute = selectedTime?.minute ?? 0;

    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      color: const Color(0xFF121212),
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 55,
              ),
              Text(
                '※ 스크롤을 올리거나 내려서 시간을 조정하세요.',
                style: TextStyle(
                  color: Color(0xFFB9B9B9),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // ✅ 세로 정렬 중앙
            children: [
              // Hour Picker
              _scrollPicker(
                value: selectedHour,
                max: 12,
                onChanged: (val) {
                  setState(() {
                    selectedTime = TimeOfDay(
                      hour: isAm ? val % 12 : (val % 12) + 12,
                      minute: selectedTime?.minute ?? 0,
                    );
                  });
                },
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  ":",
                  style: TextStyle(
                    fontSize: 57,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Minute Picker (5분 단위)
              _scrollPicker(
                value: selectedMinute ~/ 5,
                max: 11,
                step: 5,
                onChanged: (val) {
                  setState(() {
                    selectedTime = TimeOfDay(
                      hour: selectedTime?.hour ?? 11,
                      minute: val * 5,
                    );
                  });
                },
              ),

              const SizedBox(width: 32),

              // AM/PM Toggle (세로 정렬 중심)
              Column(
                mainAxisAlignment: MainAxisAlignment.center, // ✅ 가운데 정렬
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        int hour = selectedTime?.hour ?? 11;
                        selectedTime = TimeOfDay(
                          hour: hour % 12,
                          minute: selectedTime?.minute ?? 0,
                        );
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 10),
                      decoration: BoxDecoration(
                        color: isAm ? const Color(0xffB80205) : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        border: Border.all(color: const Color(0xffB80205)),
                      ),
                      child: const Text("AM",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        int hour = selectedTime?.hour ?? 11;
                        selectedTime = TimeOfDay(
                          hour: (hour % 12) + 12,
                          minute: selectedTime?.minute ?? 0,
                        );
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 10),
                      decoration: BoxDecoration(
                        color: !isAm ? const Color(0xffB80205) : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        border: Border.all(color: const Color(0xffB80205)),
                      ),
                      child: const Text("PM",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 105.0,
            ), // top: 4 → 간격 좁게
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 97),
                  child: Text("Hour",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          height: 0.4,
                          fontWeight: FontWeight.w300)),
                ),
                Text("Min",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        height: 0.4,
                        fontWeight: FontWeight.w300)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _scrollPicker({
    required int value,
    required int max,
    required Function(int) onChanged,
    int step = 1, // 🔥 기본은 1, minute는 5 사용
  }) {
    return Container(
      width: 80,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xff2D0000),
        border: Border.all(color: const Color(0xffB80205), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListWheelScrollView.useDelegate(
        itemExtent: 80,
        perspective: 0.003,
        diameterRatio: 2.0,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          onChanged(index);
        },
        controller: FixedExtentScrollController(initialItem: value),
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index > max || index < 0) return null;
            final displayVal = (index * step).toString().padLeft(2, '0');
            return Center(
              child: Text(
                displayVal,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRecruitmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        SelectThemeButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SearchThemePage(),
              ),
            );

            if (result != null) {
              Provider.of<SelectThemeProvider>(context, listen: false)
                  .selectTheme(result);
            }
          },
          isTapped: isTapped, // 필요하다면 여전히 전달
        ),
        sectionTitle('날짜를 선택해주세요 !'),
        CustomPersistentDatePicker(
          initialDate: DateTime.now(),
          onDateSelected: (newDate) {
            debugPrint("선택된 날짜: ${DateFormat('MM/dd/yyyy').format(newDate)}");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                selectedDate = newDate;
              });
            });
          },
        ),
        const SizedBox(height: 10),
        sectionTitle('시간을 선택해주세요 !'),
        _buildTimePicker(),
        const SizedBox(height: 10),
        sectionTitle('일행을 소개해주세요 !'),
        // 제목 입력 필드
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 342,
              padding: const EdgeInsets.only(top: 5, left: 5),
              decoration: ShapeDecoration(
                color: const Color(0xFF121212),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              child: TextField(
                controller: titleController,
                style: const TextStyle(
                  color: Color(0xFFB9B9B9),
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  hintText: "제목을 입력해주세요.",
                  hintStyle: TextStyle(
                    color: Color(0xFFB9B9B9),
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 12),
            Container(
              width: 342,
              height: 209,
              padding: const EdgeInsets.only(top: 5, left: 5),
              decoration: ShapeDecoration(
                color: const Color(0xFF121212),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              child: TextField(
                controller: descriptionController,
                style: const TextStyle(
                  color: Color(0xFFB9B9B9),
                  fontSize: 14,
                ),
                maxLines: 8,
                // 충분한 높이를 위해 maxLines 지정
                minLines: 6,
                // 최소 줄 수 지정 (힌트 보이게끔)
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText:
                      "내용을 입력해주세요.\n\n일행 소개글을 상세히 작성하면 나와 잘맞을 사람들의 모임 참여 신청이\n더욱 편리해져요 !\n\nex) OOO 테마에 예약을 미리 해놓았습니다 📅\n2~3인 정도 같이 하실 분 구해요 🫵🏻\n\n노쇼 방지하기 위해서 예약금은 2만원 씩 받으려고 합니다 !',",
                  hintStyle: TextStyle(
                    color: Color(0xFFB9B9B9),
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ],
    );
  }
}
