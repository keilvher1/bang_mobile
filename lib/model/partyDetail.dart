class PartyDetail {
  final int postId;
  final String regDate;
  final String title;
  final String content;
  final int currentParticipants;
  final int maxParticipants;
  final String deadline;
  final int writerId;
  final String writerNickname;
  final String writerTier;
  final String themeTitle;
  final String themeImage;
  final int horror;
  final int activity;
  final double level;
  final int playTime;
  final String location;
  final String branch;
  final String brand;
  final bool closed;

  PartyDetail({
    required this.postId,
    required this.regDate,
    required this.title,
    required this.content,
    required this.currentParticipants,
    required this.maxParticipants,
    required this.deadline,
    required this.writerId,
    required this.writerNickname,
    required this.writerTier,
    required this.themeTitle,
    required this.themeImage,
    required this.horror,
    required this.activity,
    required this.level,
    required this.playTime,
    required this.location,
    required this.branch,
    required this.brand,
    required this.closed,
  });

  factory PartyDetail.fromJson(Map<String, dynamic> json) {
    return PartyDetail(
      postId: json['postId'],
      regDate: json['regDate'],
      title: json['title'],
      content: json['content'],
      currentParticipants: json['currentParticipants'],
      maxParticipants: json['maxParticipants'],
      deadline: json['deadline'],
      writerId: json['writerId'],
      writerNickname: json['writerNickname'],
      writerTier: json['writerTier'],
      themeTitle: json['themeTitle'],
      themeImage: json['themeImage'],
      horror: json['horror'],
      activity: json['activity'],
      level: (json['level'] as num).toDouble(),
      playTime: json['playTime'],
      location: json['location'],
      branch: json['branch'],
      brand: json['brand'],
      closed: json['closed'],
    );
  }
}
