class ReviewUpload {
  final String text; // 후기 내용
  final int level; // 난이도
  final int stars; // 별점
  final int horror; // 공포도
  final int activity; // 활동성
  final int themeId; // 테마 ID
  final List<int> tagIds; // 해시태그 ID 리스트
  final bool isSuccessful; // 성공 여부
  final int hintUsageCount; // 힌트 사용 횟수
  final String clearTime; // 클리어 시간 (null 가능)

  ReviewUpload({
    required this.text,
    required this.level,
    required this.stars,
    required this.horror,
    required this.activity,
    required this.themeId,
    required this.tagIds,
    required this.isSuccessful,
    required this.hintUsageCount,
    required this.clearTime,
  });

  Map<String, dynamic> toJson() => {
        "text": text,
        "level": level,
        "stars": stars,
        "horror": horror,
        "activity": activity,
        "themeId": themeId,
        "tagIds": tagIds,
        "isSuccessful": isSuccessful,
        "hintUsageCount": hintUsageCount,
        "clearTime": clearTime,
      };
}
