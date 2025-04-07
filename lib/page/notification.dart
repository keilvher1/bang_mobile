import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isActivityTab = true; // true: 활동, false: 일행

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text(
          '알림',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () => Navigator.pop(context),
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          /// 탭 버튼
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white24, width: 0.8),
              ),
            ),
            child: Row(
              children: [
                _buildTabButton('활동', true),
                _buildTabButton('일행', false),
              ],
            ),
          ),
          Expanded(
            child: isActivityTab ? _buildActivityList() : _buildGroupList(),
          ),
        ],
      ),
    );
  }

  /// 탭 버튼
  Widget _buildTabButton(String label, bool tabType) {
    final isSelected = isActivityTab == tabType;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isActivityTab = tabType;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// 활동 리스트
  Widget _buildActivityList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      children: [
        _buildNotificationItem(
          image: 'assets/icon/bell.png',
          title: '알림',
          description: '회원님이 저장한 테마의 일행을 구하는 게시글이 등록되었습니다.',
        ),
        _buildNotificationItem(
          image: 'assets/icon/comment.png',
          title: '댓글',
          boldText: 'abcdef ',
          description:
              '님이 3시 30분 상자 하실분 구해요 ~ 난이도 어려운 만큼 30방 이상만 !! 에 댓글을 남겼습니다.',
        ),
        _buildNotificationItem(
          image: 'assets/icon/speaker.png',
          title: '공지',
          description: '현재 저장하신 테마의 제휴 정보를 확인해보세요.',
        ),
        _buildNotificationItem(
          image: 'assets/icon/comment.png',
          title: '댓글',
          description: '회원님이 남긴 댓글에 답글이 게시되었습니다.',
          isDarkBackground: true,
        ),
      ],
    );
  }

  /// 일행 리스트
  Widget _buildGroupList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      children: [
        _buildGroupNotificationItem(
          title: '일행 신청',
          boldText: 'abcdef ',
          description:
              '님이 3시 30분 상자 하실분 구해요 ~ 난이도 어려운 만큼 30방 이상만 !! 에 일행을 신청하였습니다.',
        ),
      ],
    );
  }

  /// 일반 알림 아이템
  Widget _buildNotificationItem({
    required String image,
    required String title,
    String? boldText,
    required String description,
    bool isDarkBackground = false,
  }) {
    return Container(
      // margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.only(top: 12, bottom: 22, left: 12, right: 12),
      decoration: BoxDecoration(
        color: isDarkBackground ? const Color(0xff202020) : Colors.black,
        // borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            image,
            width: 18,
            height: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Color(0xFFCCCCCC),
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      if (boldText != null)
                        TextSpan(
                          text: boldText,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      TextSpan(
                        text: description,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('1일 전',
                  style: TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      fontWeight: FontWeight.w300)),
              const SizedBox(height: 6),
              const Icon(Icons.more_vert, color: Colors.white, size: 18),
            ],
          ),
        ],
      ),
    );
  }

  /// 일행 알림 아이템
  Widget _buildGroupNotificationItem({
    required String title,
    required String boldText,
    required String description,
    String? image,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff131313),
        // borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.group, color: Colors.red, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: boldText,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: description,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('1일 전',
                      style: TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                          fontWeight: FontWeight.w300)),
                  const SizedBox(height: 6),
                  const Icon(Icons.more_vert, color: Colors.white, size: 18),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 60,
                height: 30,
                decoration: ShapeDecoration(
                  color: const Color(0xFFD90206) /* red-6 */,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                child: const Center(
                    child: Text(
                  '수락하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                )),
              ),
              const SizedBox(width: 8),
              Container(
                width: 60,
                height: 30,
                decoration: ShapeDecoration(
                  color: const Color(0xFF515151),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                child: const Center(
                    child: Text(
                  '거절하기',
                  style: TextStyle(
                    color: const Color(0xFF9D9D9D),
                    fontSize: 11,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
