import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrd/model/partyDetail.dart';
import 'package:scrd/utils/api_server.dart';
import 'package:scrd/utils/endpoint.dart';

import '../model/party_comment.dart';
import '../provider/party_comment_provider.dart';
import '../provider/party_detail_provider.dart';
import '../provider/party_join_provider.dart';

class RecruitDetailPage extends StatefulWidget {
  final int partyId;

  const RecruitDetailPage({Key? key, required this.partyId}) : super(key: key);

  @override
  State<RecruitDetailPage> createState() => _RecruitDetailPageState();
}

class _RecruitDetailPageState extends State<RecruitDetailPage> {
  final bool hasComments = false;
  TextEditingController _commentController = TextEditingController();
  int? _parentCommentId; // null이면 일반 댓글
  int? replyingToCommentId; // 대댓글 대상 ID (없으면 null)
  //RecruitDetailPage({super.key, this.hasComments = false});
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<PartyDetailProvider>(context, listen: false);
      provider.fetchPartyDetail(widget.partyId);
      Provider.of<PartyCommentProvider>(context, listen: false)
          .fetchComments(widget.partyId); //
    });
  }

  String _getTimeAgoText(String regDateString) {
    try {
      final regDate = DateTime.parse(regDateString);
      final now = DateTime.now();
      final difference = now.difference(regDate);

      if (difference.inDays >= 1) {
        return '${difference.inDays}일 전';
      } else if (difference.inHours >= 1) {
        return '${difference.inHours}시간 전';
      } else if (difference.inMinutes >= 1) {
        return '${difference.inMinutes}분 전';
      } else {
        return '방금 전';
      }
    } catch (e) {
      return ''; // 변환 실패 시 빈 문자열 처리
    }
  }

  String _formatDeadline(String deadlineString) {
    try {
      final deadline = DateTime.parse(deadlineString);
      final formatter = DateFormat('M월 d일(E) HH:mm', 'ko_KR');
      return formatter.format(deadline);
    } catch (e) {
      return ''; // 실패 시 빈 문자열
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = Provider.of<PartyDetailProvider>(context).party;
    if (detail == null) {
      return const Center(child: CircularProgressIndicator()); // 또는 다른 로딩/에러 위젯
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const Text(
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
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: Column(
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
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              detail.writerNickname.toString(),
                              style: TextStyle(
                                color: Color(0xFFFFF8F8),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              _getTimeAgoText(detail.regDate),
                              style: const TextStyle(
                                color: Color(0xFF878787),
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
                  const SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      detail.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1.33,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Text('날짜 ',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          _formatDeadline(detail.deadline),
                          style: const TextStyle(
                            color: Color(0xFFB80205),
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Text('인원 ',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        SizedBox(
                          width: 10,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: detail.currentParticipants.toString(),
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
                                  color: Color(0xFF9D9D9D),
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: '/ ${detail.maxParticipants}인',
                                style: TextStyle(
                                  color: Color(0xFFA3A3A3),
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
                  const SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(detail.content,
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                  const SizedBox(height: 97),
                  const Divider(
                    color: Color(0xFF363131),
                  ),
                  const SizedBox(height: 10),
                  _buildThemeCard(detail),
                  const SizedBox(height: 15),
                  Consumer<PartyJoinProvider>(
                    builder: (context, joinProvider, child) {
                      return GestureDetector(
                        onTap: () async {
                          await joinProvider.toggleJoin(widget.partyId);
                          // final msg =
                          //     joinProvider.joinSuccess ? "신청 완료!" : "신청 실패 😢";
                          // ScaffoldMessenger.of(context)
                          //     .showSnackBar(SnackBar(content: Text(msg)));
                        },
                        child: Container(
                          width: 344,
                          height: 36,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFD90206),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Center(
                            child: joinProvider.isJoining
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(
                                    !joinProvider.hasJoined ? '신청하기' : '신청취소',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: Color(0xFF181818),
                    thickness: 6,
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.only(left: 8),
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
                              Provider.of<PartyCommentProvider>(context)
                                  .comments
                                  .length
                                  .toString(),
                              style: const TextStyle(
                                color: Color(0xFFA3A3A3),
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
                  const SizedBox(height: 12),
                  Consumer<PartyCommentProvider>(
                    builder: (context, provider, _) {
                      if (provider.isLoading)
                        return CircularProgressIndicator();
                      if (provider.comments.isEmpty)
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 54,
                            ),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(),
                              child: Image.asset('assets/icon/textballoon.png'),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '첫 번째 코멘트를 남겨 보세요!',
                              style: TextStyle(
                                color: Color(0xFFB9B9B9),
                                fontSize: 10,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            )
                          ],
                        );
                      return _buildComments(provider.comments);
                    },
                  ),
                  // if (!hasComments)
                  //   Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       const SizedBox(
                  //         height: 54,
                  //       ),
                  //       Container(
                  //         width: 60,
                  //         height: 60,
                  //         decoration: const BoxDecoration(),
                  //         child: Image.asset('assets/icon/textballoon.png'),
                  //       ),
                  //       const SizedBox(height: 8),
                  //       const Text(
                  //         '첫 번째 코멘트를 남겨 보세요!',
                  //         style: TextStyle(
                  //           color: Color(0xFFB9B9B9),
                  //           fontSize: 10,
                  //           fontFamily: 'Inter',
                  //           fontWeight: FontWeight.w700,
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         height: 40,
                  //       )
                  //     ],
                  //   )
                  // else
                  //   Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       _buildComment(
                  //           name: '우당탕탕 탕구리',
                  //           time: '1일 전',
                  //           text: '안녕하세요, 10방 정도해본 방린이도 가능한가요?'),
                  //       _buildComment(
                  //           name: '한 대 피카츄',
                  //           time: '1일 전',
                  //           text: '아뇨 죄송요.',
                  //           isReply: true)
                  //     ],
                  //   ),
                ],
              ),
            ),
            _buildCommentInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard(PartyDetail detail) {
    return Container(
      decoration: BoxDecoration(
        // color: Color(0xff1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 16),
          Image.network(
            // 'https://handonglikelionpegbackend.s3.ap-northeast-2.amazonaws.com/scrd/%E1%84%80%E1%85%B3%E1%84%85%E1%85%B5%E1%86%B7%E1%84%8C%E1%85%A1+%E1%84%8B%E1%85%A5%E1%86%B8%E1%84%89%E1%85%B3%E1%86%AB%E3%84%B4+%E1%84%89%E1%85%A1%E1%86%BC%E1%84%8C%E1%85%A1.jpeg',
            detail.themeImage,
            width: 110,
            height: 120,
            fit: BoxFit.fill,
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  detail.themeTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  "${detail.brand} | ${detail.branch}",
                  style: TextStyle(
                    color: Color(0xFFB9B9B9),
                    fontSize: 9,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
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
                          detail.location,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 9,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.watch_later_outlined,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 3),
                      Text(
                        '${detail.playTime}분',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ]),
                  ],
                ),
                const SizedBox(height: 10),
                // Text(
                //   '30,000 원',
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 13,
                //     fontFamily: 'Pretendard',
                //     fontWeight: FontWeight.w700,
                //   ),
                // ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRatingItem(
                        label: '난이도',
                        value: detail.level.toStringAsFixed(0),
                        imagePath: 'assets/icon/puzzle_red.png',
                        titleSize: 9,
                        imageSize: 19,
                        fontSize: 9,
                        color: Color(0xffD90206)),
                    const SizedBox(width: 14),
                    _buildRatingItem(
                        titleSize: 9,
                        label: '공포도',
                        imagePath: detail.horror == 0
                            ? 'assets/icon/ghost_in.png'
                            : 'assets/icon/ghost.png',
                        fontSize: 10,
                        imageSize: 19),
                    const SizedBox(width: 14),
                    _buildRatingItem(
                        titleSize: 9,
                        label: '활동성',
                        imagePath: detail.activity == 0
                            ? 'assets/icon/shoe_in.png'
                            : 'assets/icon/shoe.png',
                        fontSize: 10,
                        imageSize: 19),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
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
              const SizedBox(),
              Image.asset(
                alignment: Alignment.center,
                imagePath,
                color: color,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.contain,
              ),
              value != null
                  ? Text(
                      value,
                      style: TextStyle(
                          color: color,
                          fontSize: fontSize ?? 11,
                          fontWeight: FontWeight.w700),
                    )
                  : const SizedBox(),
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
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 11))
      ],
    );
  }

  Widget _buildComments(List<PartyComment> comments, {bool isReply = false}) {
    return Column(
      children: comments.map((comment) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildComment(
              name: comment.writerName,
              time: _formatRelativeTime(comment.regDate),
              text: comment.content,
              comment: comment,
              isReply: isReply,
            ),
            if (comment.children.isNotEmpty)
              _buildComments(comment.children, isReply: true),
          ],
        );
      }).toList(),
    );
  }

  String _formatRelativeTime(String regDateStr) {
    final now = DateTime.now();
    final regDate = DateTime.parse(regDateStr);
    final diff = now.difference(regDate);

    if (diff.inSeconds < 60) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    return DateFormat('M월 d일').format(regDate);
  }

  Widget _buildComment({
    required PartyComment comment,
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
              const SizedBox(
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
                        style: const TextStyle(
                          color: Color(0xFFFFF8F8),
                          fontSize: 11,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          color: Color(0xFF878787),
                          fontSize: 9,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 130,
                        child: Text(
                          text,
                          style: const TextStyle(
                            color: Color(0xFFD2D2D2),
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            replyingToCommentId = comment.id; // 대댓글 대상 설정
                          });
                        },
                        child: const Text(
                          '답글 달기',
                          style: TextStyle(
                            color: Color(0xFFA3A3A3),
                            fontSize: 8,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'delete') {
                //debugPrint('댓글 삭제: ${comment.id}');
                await Provider.of<PartyCommentProvider>(context, listen: false)
                    .deleteComment(comment.id);
                await Provider.of<PartyCommentProvider>(context, listen: false)
                    .fetchComments(widget.partyId);
                setState(() {});
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('삭제'),
              ),
            ],
            icon:
                const Icon(Icons.more_vert, color: Color(0xff878787), size: 20),
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
                color: const Color(0xff1E1E1E),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _commentController,
                style: const TextStyle(
                  color: Color(0xFFA0A0A0),
                  fontSize: 10,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '댓글을 남겨 자세한 사항을 물어보세요!',
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white38),
            onPressed: () async {
              final content = _commentController.text.trim();
              if (content.isEmpty) return;

              final provider =
                  Provider.of<PartyCommentProvider>(context, listen: false);
              final success = await provider.postComment(
                postId: widget.partyId,
                content: content,
                parentId: replyingToCommentId,
              );

              if (success) {
                _commentController.clear();
                replyingToCommentId = null;
                await provider.fetchComments(widget.partyId);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("댓글 등록에 실패했습니다.")),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
