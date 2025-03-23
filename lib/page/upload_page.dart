import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  bool isDatePicked = false; //캘린더 날짜 선택 여부

  void _toggleTag(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        selectedTags.add(tag);
      }
    });
  }

  bool isFormComplete() {
    return isRated &&
        titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            GestureDetector(
              onTap: () => setState(() => isRecruitment = true),
              child: Text(
                "일행 모집",
                style: TextStyle(
                  color: isRecruitment ? Colors.red : Colors.white,
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
                  color: !isRecruitment ? Colors.red : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isRecruitment) _buildReviewSection(),
            if (isRecruitment) _buildRecruitmentSection(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isFormComplete() ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isFormComplete() ? Colors.red : Colors.grey,
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              child: Center(
                child: Text(
                  "등록하기",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewSection() {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 352,
            height: 73,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 66,
                  height: 73,
                  child: Image.network(
                      fit: BoxFit.fill,
                      'https://handonglikelionpegbackend.s3.ap-northeast-2.amazonaws.com/scrd/%E1%84%80%E1%85%B3%E1%84%85%E1%85%B5%E1%86%B7%E1%84%8C%E1%85%A1+%E1%84%8B%E1%85%A5%E1%86%B8%E1%84%89%E1%85%B3%E1%86%AB%E3%84%B4+%E1%84%89%E1%85%A1%E1%86%BC%E1%84%8C%E1%85%A1.jpeg'),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 18.0),
                  width: 286,
                  decoration: BoxDecoration(color: const Color(0xFF121212)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '머니머니부동산',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 13),
                      Row(
                        children: [
                          Icon(
                            Icons.pin_drop,
                            size: 12,
                            color: const Color(0xFFB9B9B9),
                          ),
                          SizedBox(width: 3),
                          Text(
                            '키이스케이프 | 스테이션점',
                            style: TextStyle(
                              color: const Color(0xFFB9B9B9),
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            )),
        SizedBox(height: 23),
        sectionTitle2('테마의 평점을 매겨주세요!'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.red,
              ),
              onPressed: () => setState(() {
                rating = index + 1.0;
                isRated = true;
              }),
            );
          }),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: const Color(0xFF121212)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              sectionTitleOption('분위기에 맞는 해시태그를 남겨주세요!'),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    hashtag(tags, _addTag, _removeTag),
                    SizedBox(height: 10),
                    hashtag(tags, _addTag, _removeTag),
                    SizedBox(height: 10),
                    hashtag(tags, _addTag, _removeTag),
                    SizedBox(height: 50),
                  ],
                ),
              )
            ],
          ),
        ),
        sectionTitleOption('생생한 후기를 적어주세요!'),
        Container(
          width: 342,
          height: 209,
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
                  "리뷰글을 작성해보세요.(선택사항)\n\n\n솔직한 경험을 공유하되, 다른 이용자와 업체를 배려하는\n리뷰를 작성해주세요!",
              hintStyle: TextStyle(
                color: const Color(0xFFB9B9B9),
                fontSize: 11,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.transparent,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            ),
          ),
        ),
        sectionTitleOption('더욱 자세한 후기를 알고 싶어요!'),
        Container(
          width: 390,
          height: 223,
          decoration: BoxDecoration(color: const Color(0xFF121212)),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '공포도',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
              Row(),
              Row(),
              Row(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker() {
    int hour = selectedTime?.hourOfPeriod ?? 11;
    int minute = selectedTime?.minute ?? 0;
    bool isAm = selectedTime?.period == DayPeriod.am || selectedTime == null;

    TextEditingController hourController =
        TextEditingController(text: hour.toString().padLeft(2, '0'));
    TextEditingController minuteController =
        TextEditingController(text: minute.toString().padLeft(2, '0'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: const Text(
            "Enter time",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hour Input
            _timeInputBox(
              controller: hourController,
              onChanged: (val) {
                int? newHour = int.tryParse(val);
                if (newHour != null && newHour >= 1 && newHour <= 12) {
                  setState(() {
                    selectedTime = TimeOfDay(
                      hour: isAm ? newHour % 12 : (newHour % 12) + 12,
                      minute: selectedTime?.minute ?? 0,
                    );
                  });
                }
              },
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(":",
                  style: TextStyle(
                      fontSize: 57,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
            ),

            // Minute Input
            _timeInputBox(
              controller: minuteController,
              onChanged: (val) {
                int? newMin = int.tryParse(val);
                if (newMin != null && newMin >= 0 && newMin <= 59) {
                  setState(() {
                    selectedTime = TimeOfDay(
                      hour: selectedTime?.hour ?? 11,
                      minute: newMin,
                    );
                  });
                }
              },
            ),

            const SizedBox(width: 16),

            // AM/PM Toggle
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTime = TimeOfDay(
                        hour: (selectedTime?.hour ?? 11) % 12,
                        minute: selectedTime?.minute ?? 0,
                      );
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                      color: isAm ? Color(0xffB80205) : Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      border:
                          isAm ? Border.all(color: Color(0xffB80205)) : null,
                    ),
                    child: const Text("AM",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      int h = selectedTime?.hour ?? 11;
                      selectedTime = TimeOfDay(
                        hour: h % 12 + 12,
                        minute: selectedTime?.minute ?? 0,
                      );
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                      color: !isAm ? Color(0xffB80205) : Colors.transparent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      border: Border.all(color: Color(0xffB80205)),
                    ),
                    child: const Text("PM",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.only(right: 120),
                child: Text("Hour", style: TextStyle(color: Colors.white)),
              ),
              Text("Minute", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectThemeButton(onTap: () {}),
        sectionTitle(isDatePicked == false ? '날짜를 선택해주세요!' : '시간을 선택해주세요!'),
        isDatePicked == false
            ? CustomPersistentDatePicker(
                initialDate: DateTime.now(),
                onDateSelected: (newDate) {
                  debugPrint(
                      "선택된 날짜: ${DateFormat('MM/dd/yyyy').format(newDate)}");
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      selectedDate = newDate;
                      isDatePicked = true;
                    });
                  });
                },
              )
            : _buildTimePicker(),
        SizedBox(height: 10),
        sectionTitle('일행을 소개해주세요!'),
        // 제목 입력 필드
        Container(
          decoration: ShapeDecoration(
            color: const Color(0xFF121212),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
                fontSize: 11,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.transparent,
              // 배경색 없음
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            ),
          ),
        ),
        const SizedBox(height: 10),

// 내용 입력 필드
        Container(
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
                  "내용을 입력해주세요.\n\n일행 소개글을 상세히 작성하면 나와 잘맞을 사람들의 모임 참여 신청이\n더욱 편리해져요 !\n\nex) OOO 테마에 예약을 미리 해놓았습니다 📅\n2~3인 정도 같이 하실 분 구해요 🫵🏻\n\n노쇼 방지하기 위해서 예약금은 2만원 씩 받으려고 합니다 !',",
              hintStyle: TextStyle(
                color: const Color(0xFFB9B9B9),
                fontSize: 11,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.transparent,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            ),
          ),
        ),
      ],
    );
  }
}
