import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget hashtag(List<String> tagStrList, Function(String) onTagAdded,
    Function(String) onTagRemoved) {
  final TextEditingController controller = TextEditingController();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 해시태그 입력 필드
      Row(
        children: [
          // Expanded(
          //   child: TextField(
          //     controller: controller,
          //     style: TextStyle(color: Colors.white),
          //     decoration: InputDecoration(
          //       hintText: "해시태그 입력...",
          //       hintStyle: TextStyle(color: Colors.white54),
          //       filled: true,
          //       fillColor: Color(0xFF333333), // 어두운 배경
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(20),
          //         borderSide: BorderSide.none,
          //       ),
          //       contentPadding:
          //           EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          //     ),
          //     onSubmitted: (value) {
          //       String tag = value.trim();
          //       if (tag.isNotEmpty && !tagStrList.contains("#$tag")) {
          //         onTagAdded("#$tag"); // 해시태그 추가 콜백 실행
          //         controller.clear(); // 입력창 비우기
          //       }
          //     },
          //   ),
          // ),
          // SizedBox(width: 8),
          // ElevatedButton(
          //   onPressed: () {
          //     String tag = controller.text.trim();
          //     if (tag.isNotEmpty && !tagStrList.contains("#$tag")) {
          //       onTagAdded("#$tag"); // 해시태그 추가 콜백 실행
          //       controller.clear(); // 입력창 비우기
          //     }
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Color(0xFFD90206),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(20),
          //     ),
          //   ),
          //   child: Text("추가", style: TextStyle(color: Colors.white)),
          // ),
        ],
      ),
      // 해시태그 리스트
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tagStrList
              .map(
                (tag) => Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF515151),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Text(
                        tag,
                        style: TextStyle(
                          color: Color(0xffD8D8D8),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () => onTagRemoved(tag), // 삭제 콜백 실행
                      //   child: Icon(Icons.close, size: 14, color: Colors.white),
                      // ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    ],
  );
}

class SelectThemeButton extends StatelessWidget {
  final VoidCallback onTap;

  const SelectThemeButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        decoration: BoxDecoration(
          color: Color(0xFF131313),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey, size: 22),
                const SizedBox(width: 8),
                const Text(
                  "이 곳을 눌러 테마를 선택해주세요.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.only(left: 28),
              child: Text(
                "(같은 테마더라도 지점이 다를 수 있습니다.)",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPersistentDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const CustomPersistentDatePicker({
    Key? key,
    required this.initialDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _CustomPersistentDatePickerState createState() =>
      _CustomPersistentDatePickerState();
}

class _CustomPersistentDatePickerState
    extends State<CustomPersistentDatePicker> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
    widget.onDateSelected(newDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCalendar(),
      ],
    );
  }

  Widget _buildCalendar() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xffD90206), // 빨간색 테마 적용
            brightness: Brightness.dark, // 다크 테마
          ).copyWith(
            primary: Color(0xffD90206), // 선택된 날짜
            onPrimary: Colors.white, // 선택된 날짜 텍스트
            surface: Colors.black, // 배경
            onSurface: Colors.white, // 달력 텍스트
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Color(0xffD90206), // 버튼 색상
            ),
          ),
        ),
        child: CalendarDatePicker(
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          onDateChanged: _onDateChanged,
        ),
      ),
    );
  }
}

/// 제목 텍스트와 `(선택)` 텍스트를 함께 보여주는 위젯
Widget sectionTitle(String titleText) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          titleText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Text(
          ' (필수)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

Widget sectionTitleOption(String titleText) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          titleText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Text(
          ' (선택)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

Widget sectionTitle2(String titleText) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          titleText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Text(
          ' (필수)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
