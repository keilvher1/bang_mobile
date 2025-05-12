class Review {
  final int id;
  final String userTier;
  final String nickName;
  final String text;
  final int level;
  final int stars;
  final int horror;
  final int activity;
  final List<String> tagNames;
  final String themeTitle;
  final String themeBranch;
  final String themeLocation;
  final String themeImage;

  Review({
    required this.id,
    required this.userTier,
    required this.nickName,
    required this.text,
    required this.level,
    required this.stars,
    required this.horror,
    required this.activity,
    required this.tagNames,
    required this.themeTitle,
    required this.themeBranch,
    required this.themeLocation,
    required this.themeImage,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0,
      userTier: json['userTier'] ?? '',
      nickName: json['nickName'] ?? '',
      text: json['text'] ?? '',
      level: json['level'] ?? 0,
      stars: json['stars'] ?? 0,
      horror: json['horror'] ?? 0,
      activity: json['activity'] ?? 0,
      tagNames: List<String>.from(json['tagNames'] ?? []),
      themeTitle: json['themeTitle'] ?? '',
      themeBranch: json['themeBranch'] ?? '',
      themeLocation: json['themeLocation'] ?? '',
      themeImage: json['themeImage'] ?? '',
    );
  }
}
