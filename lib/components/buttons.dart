import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/select_theme_provider.dart';
import '../provider/tag_selection_provider.dart';

Widget hashtag(List<String> tagStrList, Function(String) onTagAdded,
    Function(String) onTagRemoved) {
  final TextEditingController controller = TextEditingController();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 해시태그 입력 필드
      const Row(
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
                    color: const Color(0xFF515151),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Text(
                        tag,
                        style: const TextStyle(
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

Widget hashtagCenter(
  List<String> tagStrList,
  List<String> selectedTags, // 선택된 태그 리스트
  Function(String) onTagAdded,
  Function(String) onTagRemoved,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tagStrList.map((tag) {
            final bool isSelected = selectedTags.contains(tag);
            return GestureDetector(
              onTap: () {
                if (isSelected) {
                  onTagRemoved(tag);
                } else {
                  onTagAdded(tag);
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF515151),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFFD90206) : const Color(0xffD8D8D8),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ],
  );
}

class SelectThemeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isTapped;

  const SelectThemeButton({
    super.key,
    required this.onPressed,
    required this.isTapped,
  });

  @override
  Widget build(BuildContext context) {
    final selectedTheme = context.watch<SelectThemeProvider>().selectedTheme;

    return GestureDetector(
      onTap: () {
        onPressed();
        debugPrint('SelectThemeButton isTapped: $isTapped');
      },
      child: selectedTheme == null
          ? Container(
              width: 352,
              height: 80,
              padding: const EdgeInsets.only(left: 25),
              decoration: const BoxDecoration(
                color: Color(0xFF131313),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: Colors.grey, size: 22),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(
                            "이 곳을 눌러 테마를 선택해주세요.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "(같은 테마더라도 지점이 다를 수 있습니다.)",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          : SizedBox(
              width: 352,
              height: 80,
              child: Row(
                children: [
                  SizedBox(
                    width: 66,
                    height: 80,
                    child: Image.network(
                      selectedTheme.image,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 18.0),
                    width: MediaQuery.of(context).size.width - 98,
                    decoration: const BoxDecoration(color: Color(0xFF121212)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedTheme.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 13),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Color(0xFFB9B9B9),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              selectedTheme.location,
                              style: const TextStyle(
                                color: Color(0xFFB9B9B9),
                                fontSize: 10.5,
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
              ),
            ),
    );
  }
}

class CustomPersistentDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const CustomPersistentDatePicker({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  _CustomPersistentDatePickerState createState() =>
      _CustomPersistentDatePickerState();
}

class _CustomPersistentDatePickerState
    extends State<CustomPersistentDatePicker> {
  DateTime? _selectedDate; // 초기엔 null (오늘 강조 안 함)

  @override
  void initState() {
    super.initState();
    // _selectedDate = widget.initialDate; → 초기값 제거
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xffD90206),
            brightness: Brightness.dark,
          ).copyWith(
            primary: const Color(0xffD90206),
            onPrimary: const Color(0xFF121212),
            surface: Colors.black,
            onSurface: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xffD90206),
            ),
          ),
        ),
        child: CalendarDatePicker(
          initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
          onDateChanged: _onDateChanged,
          selectableDayPredicate: (day) {
            final today = DateTime.now();
            final justDate =
                DateTime(today.year, today.month, today.day); // 시/분/초 제거
            return !day.isBefore(justDate); // 오늘 포함하여 이후 날짜 선택 가능
          },
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          titleText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        // const Text(
        //   ' (필수)',
        //   style: TextStyle(
        //     color: Colors.white,
        //     fontSize: 8,
        //     fontWeight: FontWeight.w700,
        //   ),
        // ),
      ],
    ),
  );
}

Widget sectionTitleOption(String titleText) {
  return Padding(
    padding: const EdgeInsets.only(top: 35, bottom: 23),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          titleText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        // const Text(
        //   ' (선택)',
        //   style: TextStyle(
        //     color: Colors.white,
        //     fontSize: 8,
        //     fontWeight: FontWeight.w700,
        //   ),
        // ),
      ],
    ),
  );
}

Widget sectionTitle2(String titleText) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          titleText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        // const Text(
        //   ' (필수)',
        //   style: TextStyle(
        //     color: Colors.white,
        //     fontSize: 8,
        //     fontWeight: FontWeight.w700,
        //
        //   ),
        // ),
      ],
    ),
  );
}

class SelectableHashtagRow extends StatelessWidget {
  final List<String> tags;

  const SelectableHashtagRow({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    final selectedTags = context.watch<TagSelectionProvider>().selectedTags;
    final tagProvider = context.read<TagSelectionProvider>();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tags.map((tag) {
          final isSelected = selectedTags.contains(tag);

          return GestureDetector(
            onTap: () => tagProvider.toggleTag(tag),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFD90206)
                    : const Color(0xFF515151),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  color: Color(0xffD8D8D8),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
