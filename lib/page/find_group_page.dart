import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrd/page/recruit_detail_page.dart';

import '../components/buttons.dart';
import '../model/party.dart';
import '../provider/party_provider.dart';

class FindGroupPage extends StatefulWidget {
  const FindGroupPage({super.key});

  @override
  _FindGroupPageState createState() => _FindGroupPageState();
}

class _FindGroupPageState extends State<FindGroupPage> {
  final Color red = const Color(0xffD90206);
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool checkedRecruit = false;
  late ScrollController _scrollController;

  TextEditingController searchController = TextEditingController();
  String _searchQuery = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PartyProvider>(context, listen: false)
          .fetchInitialParties(_searchQuery);
    });
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          final partyProvider =
              Provider.of<PartyProvider>(context, listen: false);

          if (!partyProvider.isLoading && partyProvider.hasMore) {
            debugPrint("📦 추가 데이터 불러오는 중...");
            partyProvider.fetchMoreParties(_searchQuery);
          }
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: const Text(
            '일행 찾기',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Consumer<PartyProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // if (provider.parties.isEmpty) {
            //   return const Center(child: Text("모집글이 없습니다."));
            // }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildFilterRow(),
                  const SizedBox(height: 16),
                  if (provider.parties.isEmpty)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2),
                        const Center(
                          child: Text("모집글이 없습니다.",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  if (provider.parties.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: provider.parties.length,
                        itemBuilder: (context, index) {
                          final party = provider.parties[index];
                          if (_searchQuery.isNotEmpty) {
                            if (party.themeTitle
                                .toLowerCase()
                                .contains(_searchQuery)) {
                              return _buildGroupCard(party);
                            }
                          } else {
                            if (party.isClosed == false) {
                              return _buildGroupCard(party);
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: '테마명으로 검색하기',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          const Icon(Icons.search, color: Colors.white)
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
        return SafeArea(
          child: Container(
            decoration: const BoxDecoration(
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
                        const Row(
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
                          padding: const EdgeInsets.only(bottom: 20, right: 25),
                          icon: const Icon(Icons.close, color: Colors.white),
                          alignment: const Alignment(-1, 1),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                    CustomPersistentDatePicker(
                      initialDate: DateTime.now(),
                      onDateSelected: (newDate) {
                        debugPrint("선택된 날짜: $newDate");
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() => selectedDate = newDate);
                          setModalState(() {});
                        });
                        context
                            .read<PartyProvider>()
                            .fetchPartyByDeadline(newDate);
                      },
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      color: selectedDate != null
                          ? const Color(0xffD90206)
                          : const Color(0xff515151),
                      child: GestureDetector(
                        onTap: selectedDate != null
                            ? () => Navigator.pop(context)
                            : null,
                        child: const Text('선택 완료',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterRow() {
    return GestureDetector(
      onTap: () {
        setState(() {
          checkedRecruit = !checkedRecruit;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFilterChip(Icons.refresh, '날짜'),
          _buildCheckIcon('모집마감 안보기', checkedRecruit),
        ],
      ),
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
            decoration: const BoxDecoration(color: Color(0xFF3F3F3F)),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              showDatePickerBottomSheet(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 26,
              decoration: ShapeDecoration(
                color: const Color(0xFF1B1B1B),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: selectedDate != null
                        ? const Color(0xffD90206)
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
                  const Icon(Icons.arrow_drop_down,
                      color: Colors.white, size: 15)
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
            color: isChecked ? red : const Color(0xff4A4A4A),
            shape: BoxShape.circle,
          ),
          child: const Center(
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
          style: const TextStyle(
            color: Color(0xFFD1D1D1),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  Widget _buildGroupCard(Party party) {
    final formattedDate = DateFormat('M월 d일(E) HH:mm', 'ko_KR')
        .format(party.deadline); // DateTime -> 원하는 형식의 문자열
    if (checkedRecruit == true && party.deadline.isBefore(DateTime.now())) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(10),
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
              SizedBox(
                width: 104,
                height: 115,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    party.image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 146 * 0.2,
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
            //우측 영역
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  party.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 21),
                Row(
                  children: [
                    Image.asset(
                      'assets/icon/door_open.png',
                      width: 13,
                      height: 13,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      party.themeTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.white54, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      party.location,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                color: Color(0xff9D9D9D), size: 12),
                            const SizedBox(width: 6),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                color: party.deadline.isBefore(DateTime.now())
                                    ? Colors.grey
                                    : const Color(0xFFD90206),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Image.asset(
                              'assets/icon/people.png',
                              width: 12,
                              height: 12,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${party.currentParticipants} ',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 11),
                            ),
                            Text(
                              '/ ${party.maxParticipants}인',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        if (party.deadline.isBefore(DateTime.now())) {
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  RecruitDetailPage(partyId: party.id)),
                        );
                      },
                      child: Container(
                        width: 63,
                        height: 26,
                        decoration: ShapeDecoration(
                          color: party.deadline.isBefore(DateTime.now())
                              ? Colors.grey
                              : const Color(0xFFD90206),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            party.deadline.isBefore(DateTime.now())
                                ? '마감'
                                : '상세보기',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
