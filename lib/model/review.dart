class Review {
  final int id;
  final String nickName;
  final String text;
  final int level;
  final int stars;
  final int horror;
  final int activity;
  final List<String> tagNames;
  final String userTier; // 추가!

  Review({
    required this.id,
    required this.nickName,
    required this.text,
    required this.level,
    required this.stars,
    required this.horror,
    required this.activity,
    required this.tagNames,
    required this.userTier,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      nickName: json['nickName'],
      text: json['text'],
      level: json['level'],
      stars: json['stars'],
      horror: json['horror'],
      activity: json['activity'],
      tagNames: List<String>.from(json['tagNames'] ?? []),
      userTier: json['userTier'],
    );
  }
}
