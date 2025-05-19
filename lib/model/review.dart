class Review {
  final int userId;
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
  final String regDate;
  // "hintUsageCount": null,
  // "isSuccessful": null,
  // "clearTime": null
  final int hintUsageCount;
  final bool isSuccessful;
  final String clearTime;

  Review({
    required this.userId,
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
    required this.regDate,
    required this.hintUsageCount,
    required this.isSuccessful,
    required this.clearTime,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    // regDate가 문자열이면 ISO 포맷으로 들어오는 경우가 많음
    String regDateRaw = json['regDate'] ?? '';
    String regDateKST = '';

    if (regDateRaw.isNotEmpty) {
      try {
        final utcDateTime = DateTime.parse(regDateRaw);
        final kstDateTime = utcDateTime.add(const Duration(hours: 9));
        regDateKST = kstDateTime.toIso8601String(); // 또는 format 변환 가능
      } catch (e) {
        regDateKST = regDateRaw; // 파싱 실패 시 원본 사용
      }
    }

    return Review(
      userId: json['userId'] ?? 0,
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
      regDate: regDateKST, // ✅ 한국시간 적용된 값
      hintUsageCount: json['hintUsageCount'] ?? 0,
      isSuccessful: json['isSuccessful'],
      clearTime: json['clearTime'] ?? '',
    );
  }
}
