import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrd/page/recruit_detail_page.dart';

import '../components/buttons.dart';

class FindGroupPage extends StatefulWidget {
  const FindGroupPage({Key? key}) : super(key: key);

  @override
  _FindGroupPageState createState() => _FindGroupPageState();
}

class _FindGroupPageState extends State<FindGroupPage> {
  final Color red = Color(0xffD90206);
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool checkedRecruit = false;

  bool get _dateSelected => selectedDate != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Text(
          '일행 찾기',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildFilterRow(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return _buildGroupCard();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '테마명으로 검색하기',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.search, color: Colors.white)
        ],
      ),
    );
  }

  void showDatePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 12),
                          Text("날짜",
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
                  CustomPersistentDatePicker(
                    initialDate: DateTime.now(),
                    onDateSelected: (newDate) {
                      debugPrint(
                          "선택된 날짜: \${DateFormat('MM/dd/yyyy').format(newDate)}");
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() => selectedDate = newDate);
                        setModalState(() {});
                      });
                    },
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    color: selectedDate != null
                        ? Color(0xffD90206)
                        : Color(0xff515151),
                    child: GestureDetector(
                      onTap: selectedDate != null
                          ? () => Navigator.pop(context)
                          : null,
                      child: Text('선택 완료',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFilterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFilterChip(Icons.refresh, '날짜'),
        GestureDetector(
            onTap: () {
              setState(() {
                checkedRecruit = !checkedRecruit;
              });
            },
            child: _buildCheckIcon('모집마감 안보기', checkedRecruit)),
      ],
    );
  }

  Widget _buildFilterChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {});
            },
            child: Container(
                width: 19,
                height: 19,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(icon, color: Colors.black, size: 16)),
          ),
          const SizedBox(width: 12),
          Container(
            width: 1,
            height: 16,
            decoration: BoxDecoration(color: const Color(0xFF3F3F3F)),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              showDatePickerBottomSheet(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 26,
              decoration: ShapeDecoration(
                color: const Color(0xFF1B1B1B),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: selectedDate != null
                        ? Color(0xffD90206)
                        : const Color(0xFF1F1F1F),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    selectedDate != null
                        ? DateFormat('M월 d일').format(selectedDate!)
                        : '날짜',
                    style: TextStyle(
                      color:
                          selectedDate != null ? red : const Color(0xFFD1D1D1),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.white, size: 15)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckIcon(String label, bool isChecked) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: isChecked ? red : Color(0xff4A4A4A),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFFD1D1D1),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  Widget _buildGroupCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RecruitDetailPage()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding:
            const EdgeInsets.only(left: 10, top: 17, bottom: 17, right: 10),
        decoration: BoxDecoration(
          color: const Color(0xff131313),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey.shade900),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 119,
                  height: 146,
                  child: Image.network(
                    'https://handonglikelionpegbackend.s3.ap-northeast-2.amazonaws.com/scrd/%E1%84%80%E1%85%B3%E1%84%85%E1%85%B5%E1%86%B7%E1%84%8C%E1%85%A1+%E1%84%8B%E1%85%A5%E1%86%B8%E1%84%89%E1%85%B3%E1%86%AB%E3%84%B4+%E1%84%89%E1%85%A1%E1%86%BC%E1%84%8C%E1%85%A1.jpeg',
                    fit: BoxFit.cover,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0),
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 161 * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '3시 30분 상자 하실분 구해요 ~ 난이도 어려운 만큼 30방 이상만 !!',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Image.asset(
                          'assets/icon/door_open.png',
                          width: 13,
                          height: 13,
                        ),
                        const SizedBox(width: 6),
                        Text('머니머니부동산',
                            style:
                                TextStyle(color: Colors.white, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: Colors.white54, size: 14),
                        const SizedBox(width: 6),
                        Text('강남',
                            style:
                                TextStyle(color: Colors.white, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    color: Color(0xff9D9D9D), size: 12),
                                const SizedBox(width: 6),
                                Text('3월 23일(일) 14:20',
                                    style: TextStyle(color: red, fontSize: 11)),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/icon/people.png',
                                  width: 12,
                                  height: 12,
                                ),
                                const SizedBox(width: 6),
                                Text('1 ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 11)),
                                Text('/ 4인',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 11)),
                              ],
                            )
                          ],
                        ),
                        Container(
                          width: 63,
                          height: 26,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFD90206) /* red-6 */,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          child: Center(
                              child: Text(
                            '신청하기',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
