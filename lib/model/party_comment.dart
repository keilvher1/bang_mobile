class PartyComment {
  final int id;
  final String content;
  final String writerName;
  final int? parentId;
  final String regDate;
  final List<PartyComment> children;

  PartyComment({
    required this.id,
    required this.content,
    required this.writerName,
    required this.parentId,
    required this.regDate,
    required this.children,
  });

  factory PartyComment.fromJson(Map<String, dynamic> json) {
    return PartyComment(
      id: json['id'],
      content: json['content'],
      writerName: json['writerName'],
      parentId: json['parentId'],
      regDate: json['regDate'],
      children: (json['children'] as List<dynamic>)
          .map((e) => PartyComment.fromJson(e))
          .toList(),
    );
  }
}
