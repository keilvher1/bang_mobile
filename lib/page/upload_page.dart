import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scrd/page/search_theme.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';

import '../components/buttons.dart';

class GroupReviewPage extends StatefulWidget {
  @override
  _GroupReviewPageState createState() => _GroupReviewPageState();
}

class _GroupReviewPageState extends State<GroupReviewPage> {
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
  Color red = Color(0xFFD90206);

  void _toggleTag(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        selectedTags.add(tag);
      }
    });
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

  @override
  Widget build(BuildContext context) {
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
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () => setState(() => isRecruitment = true),
                child: Text(
                  "일행 모집",
                  style: TextStyle(
                    color: isRecruitment ? Color(0xFFD90206) : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 13),
              GestureDetector(
                onTap: () => setState(() => isRecruitment = false),
                child: Text(
                  "리뷰",
                  style: TextStyle(
                    color: !isRecruitment ? Color(0xFFD90206) : Colors.white,
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
                  }
                : null,
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey;
                }
                return red;
              }),
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(vertical: 17),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
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

    final Set<String> selectedTags = {};

    void handleTagToggle(String tag) {
      setState(() {
        if (selectedTags.contains(tag)) {
          selectedTags.remove(tag);
        } else {
          if (selectedTags.length < 5) {
            debugPrint("Selected Tags: $tag");
            selectedTags.add(tag);
          } else {
            Fluttertoast.showToast(
              msg: "태그는 최대 5개까지 선택할 수 있습니다.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.black87,
              textColor: Colors.white,
              fontSize: 13,
            );
          }
        }
      });
    }

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

    int min = 0;
    int sec = 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 30),
        SelectThemeButton(
            onTap: () {
              setState(() {
                isTapped = !isTapped;
              });
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const SearchThemePage()),
              // );
            },
            isTapped: isTapped),
        SizedBox(height: 24),
        sectionTitle2('테마의 평점을 남겨주세요 !'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Color(0xFFD90206),
                size: 30,
              ),
              onPressed: () => setState(() {
                rating = index + 1.0;
                isRated = true;
              }),
            );
          }),
        ),
        SizedBox(height: 23),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: const Color(0xFF121212)),
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
        SizedBox(height: 12),
        Container(
          width: 342,
          height: 209,
          padding: EdgeInsets.only(top: 5, left: 5),
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
                color: const Color(0xFFB9B9B9),
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
        SizedBox(height: 12),
        Container(
          color: const Color(0xFF121212),
          padding:
              const EdgeInsets.only(left: 30, top: 12, right: 30, bottom: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 14),
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
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
                            style: TextStyle(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
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
        SizedBox(height: 30),
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
                : Color(0xFF121212), // 배경색 (원 안)
            border: Border.all(
                width: 2,
                color: isSelected == true ? Colors.white : Color(0xFF777676)),
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
                color: isSelected == false ? Color(0xff777676) : Colors.black,
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
                isChecked == true ? const Color(0xFFD90206) : Color(0xFF777676),
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
      padding: EdgeInsets.zero,
      color: const Color(0xFF121212),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                        color: isAm ? Color(0xffB80205) : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        border: Border.all(color: Color(0xffB80205)),
                      ),
                      child: const Text("AM",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
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
                        color: !isAm ? Color(0xffB80205) : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        border: Border.all(color: Color(0xffB80205)),
                      ),
                      child: const Text("PM",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 102.0,
            ), // top: 4 → 간격 좁게
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 88),
                  child: Text("Hour",
                      style: TextStyle(
                        color: Colors.white,
                        height: -0.8,
                      )),
                ),
                Text("Min",
                    style: TextStyle(
                      color: Colors.white,
                      height: -0.8,
                    )),
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

  Widget _timeInputBox({
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return Container(
      width: 120,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Color(0xff2D0000),
        border: Border.all(color: Color(0xffB80205), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          maxLength: 2,
          style: const TextStyle(
            fontSize: 45,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            height: 1.16,
          ),
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: "", // 글자수 없애기
          ),
        ),
      ),
    );
  }

  Widget _buildRecruitmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 30),
        SelectThemeButton(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchThemePage()),
            );
          },
          isTapped: isTapped,
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
        SizedBox(height: 10),
        sectionTitle('시간을 선택해주세요 !'),
        _buildTimePicker(),
        SizedBox(height: 10),
        sectionTitle('일행을 소개해주세요 !'),
        // 제목 입력 필드
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 342,
              padding: EdgeInsets.only(top: 5, left: 5),
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
                    color: const Color(0xFFB9B9B9),
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
            SizedBox(height: 12),
            Container(
              width: 342,
              height: 209,
              padding: EdgeInsets.only(top: 5, left: 5),
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
                    color: const Color(0xFFB9B9B9),
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
            SizedBox(height: 30),
          ],
        ),

// 내용 입력 필드
      ],
    );
  }
}
