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
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('게시글', style: TextStyle(color: Colors.white)),
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
                Text(
                  '3시 30분 상자 하실분 구해요 ~ 난이도 어려운 만큼 30방 이상만 !!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.edit, color: Colors.black),
                    ),
                    SizedBox(width: 8),
                    Text('우당탕탕 탕구리',
                        style: TextStyle(color: Colors.white, fontSize: 14))
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('날짜 ',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    Text('3월 23일(일) 14:20',
                        style:
                            TextStyle(color: Color(0xffD90206), fontSize: 14))
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Text('인원 ',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    Text('1 / 4인',
                        style: TextStyle(color: Colors.white70, fontSize: 14))
                  ],
                ),
                SizedBox(height: 16),
                Text('1인에서 2인 구합니다 20대 남성 분만 구해요 !!',
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                SizedBox(height: 30),
                _buildThemeCard(),
                SizedBox(height: 30),
                Text('댓글 2',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                if (!hasComments)
                  Column(
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          color: Colors.white38, size: 48),
                      SizedBox(height: 8),
                      Text("첫 번째 코멘트를 남겨 보세요!",
                          style: TextStyle(color: Colors.white54))
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
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xff1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Image.network(
            'https://handonglikelionpegbackend.s3.ap-northeast-2.amazonaws.com/scrd/%E1%84%80%E1%85%B3%E1%84%85%E1%85%B5%E1%86%B7%E1%84%8C%E1%85%A1+%E1%84%8B%E1%85%A5%E1%86%B8%E1%84%89%E1%85%B3%E1%86%AB%E3%84%B4+%E1%84%89%E1%85%A1%E1%86%BC%E1%84%8C%E1%85%A1.jpeg',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('머니머니부동산',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Text('키이스케이프 | 스테이션점',
                    style: TextStyle(color: Colors.white54, fontSize: 12)),
                SizedBox(height: 10),
                Text('30,000 원',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Row(
                  children: [
                    _buildIconLabel(Icons.access_time, '80분'),
                    SizedBox(width: 8),
                    _buildIconLabel(Icons.whatshot, '5',
                        iconColor: Color(0xffD90206)),
                    _buildIconLabel(Icons.emoji_emotions, '')
                  ],
                )
              ],
            ),
          )
        ],
      ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextStyle(color: Colors.white, fontSize: 13)),
              Text(time, style: TextStyle(color: Colors.white54, fontSize: 11)),
            ],
          ),
          SizedBox(height: 4),
          Text(text, style: TextStyle(color: Colors.white, fontSize: 14))
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
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '댓글을 입력하세요.',
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
