class PartyUpload {
  final String title;
  final String content;
  final int currentParticipants;
  final int maxParticipants;
  final String deadline; // ISO 형식의 날짜-시간 문자열

  PartyUpload({
    required this.title,
    required this.content,
    required this.currentParticipants,
    required this.maxParticipants,
    required this.deadline,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "currentParticipants": currentParticipants,
        "maxParticipants": maxParticipants,
        "deadline": deadline,
      };
}
