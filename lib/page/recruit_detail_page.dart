import 'package:flutter/material.dart';

class RecruitDetailPage extends StatelessWidget {
  final bool hasComments;

  RecruitDetailPage({this.hasComments = false});

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
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            Text(
              '일행 찾기',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                // height: 1,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white, // 배경색 설정
                        radius: 20, // 아바타 크기 설정
                        child: ClipOval(
                          child: Image.asset(
                            'assets/needle.png',
                            width: 26,
                            height: 26,
                            fit: BoxFit.contain, // 원 안에 이미지 맞추기
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '우당탕탕 탕구리',
                            style: TextStyle(
                              color: const Color(0xFFFFF8F8),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '1일 전',
                            style: TextStyle(
                              color: const Color(0xFF878787),
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '3시 30분 상자 하실분 구해요 ~ 난이도 어려운 만큼 30방 이상만 !!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Text('날짜 ',
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '3월 23일(일) 14:20',
                        style: TextStyle(
                          color: const Color(0xFFB80205),
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Text('인원 ',
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                      SizedBox(
                        width: 10,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: ' ',
                              style: TextStyle(
                                color: const Color(0xFF9D9D9D),
                                fontSize: 13,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: '/ 4인',
                              style: TextStyle(
                                color: const Color(0xFFA3A3A3),
                                fontSize: 13,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('1인에서 2인 구합니다 20대 남성 분만 구해요 !!',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
                SizedBox(height: 97),
                Divider(
                  color: const Color(0xFF363131),
                ),
                SizedBox(height: 10),
                _buildThemeCard(),
                SizedBox(height: 15),
                Container(
                  width: 344,
                  height: 36,
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
                        fontSize: 13,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Divider(
                  color: const Color(0xFF181818),
                  thickness: 6,
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.only(left: 8),
                  width: 42,
                  height: 30,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 35,
                        top: 0,
                        child: SizedBox(
                          width: 13,
                          height: 13,
                          child: Text(
                            '2',
                            style: TextStyle(
                              color: const Color(0xFFA3A3A3),
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        child: SizedBox(
                          width: 36,
                          child: Text(
                            '댓글',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                if (!hasComments)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 54,
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(),
                        child: Image.asset('assets/icon/textballoon.png'),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '첫 번째 코멘트를 남겨 보세요!',
                        style: TextStyle(
                          color: const Color(0xFFB9B9B9),
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      )
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildComment(
                          name: '우당탕탕 탕구리',
                          time: '1일 전',
                          text: '안녕하세요, 10방 정도해본 방린이도 가능한가요?'),
                      _buildComment(
                          name: '한 대 피카츄',
                          time: '1일 전',
                          text: '아뇨 죄송요.',
                          isReply: true)
                    ],
                  ),
              ],
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildThemeCard() {
    return Container(
      decoration: BoxDecoration(
        // color: Color(0xff1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 16),
          Image.network(
            'https://handonglikelionpegbackend.s3.ap-northeast-2.amazonaws.com/scrd/%E1%84%80%E1%85%B3%E1%84%85%E1%85%B5%E1%86%B7%E1%84%8C%E1%85%A1+%E1%84%8B%E1%85%A5%E1%86%B8%E1%84%89%E1%85%B3%E1%86%AB%E3%84%B4+%E1%84%89%E1%85%A1%E1%86%BC%E1%84%8C%E1%85%A1.jpeg',
            width: 110,
            height: 120,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '머니머니부동산',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  '키이스케이프  |  스테이션점',
                  style: TextStyle(
                    color: const Color(0xFFB9B9B9),
                    fontSize: 9,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 1),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          '강남',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 9,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.watch_later_outlined,
                          color: Colors.white, size: 16),
                      SizedBox(width: 3),
                      Text(
                        '80분',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ]),
                  ],
                ),
                SizedBox(height: 10),
                // Text(
                //   '30,000 원',
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 13,
                //     fontFamily: 'Pretendard',
                //     fontWeight: FontWeight.w700,
                //   ),
                // ),
                SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRatingItem(
                        label: '난이도',
                        value: '5',
                        imagePath: 'assets/icon/puzzle_red.png',
                        titleSize: 9,
                        imageSize: 19,
                        fontSize: 9,
                        color: Color(0xffD90206)),
                    SizedBox(width: 14),
                    _buildRatingItem(
                        titleSize: 9,
                        label: '공포도',
                        imagePath: 'assets/icon/ghost.png',
                        fontSize: 10,
                        imageSize: 19),
                    SizedBox(width: 14),
                    _buildRatingItem(
                        titleSize: 9,
                        label: '활동성',
                        imagePath: 'assets/icon/shoe_in.png',
                        fontSize: 10,
                        imageSize: 19),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 25,
              ))
        ],
      ),
    );
  }

  Widget _buildRatingItem({
    required String label,
    String? imagePath, // 이미지 경로를 위한 필드 추가
    Color? color,
    String? value,
    String? subText,
    double? imageSize,
    double? fontSize,
    double? titleSize,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: titleSize ?? 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        if (imagePath != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(),
              Image.asset(
                alignment: Alignment.center,
                imagePath,
                color: color,
                width: imageSize,
                height: imageSize,
              ),
              value != null
                  ? Text(
                      value,
                      style: TextStyle(
                          color: color,
                          fontSize: fontSize ?? 11,
                          fontWeight: FontWeight.w700),
                    )
                  : SizedBox(),
            ],
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize ?? 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subText != null)
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(
                    subText,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildIconLabel(IconData icon, String text,
      {Color iconColor = Colors.white}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: iconColor),
        SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.white, fontSize: 11))
      ],
    );
  }

  Widget _buildComment({
    required String name,
    required String time,
    required String text,
    bool isReply = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: isReply ? 40 : 0, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white, // 배경색 설정
                radius: 20, // 아바타 크기 설정
                child: ClipOval(
                  child: Image.asset(
                    'assets/needle.png',
                    width: 26,
                    height: 26,
                    fit: BoxFit.contain, // 원 안에 이미지 맞추기
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: const Color(0xFFFFF8F8),
                          fontSize: 11,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: const Color(0xFF878787),
                          fontSize: 9,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          color: const Color(0xFFD2D2D2),
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        '답글 달기',
                        style: TextStyle(
                          color: const Color(0xFFA3A3A3),
                          fontSize: 8,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          Icon(
            Icons.more_vert,
            color: Color(0xff878787),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1E1E1E),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                style: TextStyle(
                  color: const Color(0xFFA0A0A0),
                  fontSize: 10,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '댓글을 남겨 자세한 사항을 물어보세요!',
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: Colors.white38),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
