import 'dart:convert'; // 👈 추가

String fixBrokenText(String brokenText) {
  List<int> bytes = brokenText.codeUnits;
  return utf8.decode(bytes);
}

class ThemeModel {
  final int id;
  final String title;
  final String? description; // <- nullable
  final String location;
  final int price;
  final String image;
  final String? url; // <- nullable
  final String brand;
  final String branch;
  final int playtime;
  final double rating;
  final int horror;
  final int activity;
  final double level;
  final int reviewCount;
  final String proportion; // 👈 새로 추가된 필드
  List<String>? availableTimes; // 추가

  ThemeModel({
    required this.id,
    required this.title,
    this.description, // <- required 제거
    required this.location,
    required this.price,
    required this.image,
    this.url, // <- required 제거
    required this.brand,
    required this.branch,
    required this.playtime,
    required this.rating,
    required this.horror,
    required this.activity,
    required this.level,
    required this.reviewCount,
    required this.proportion, // 👈 새로 추가된 필드
    this.availableTimes,
  });

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    List<String>? parsedAvailableTimes;
    if (json.containsKey('availableTimes')) {
      final rawTimes = json['availableTimes'];
      if (rawTimes is List) {
        parsedAvailableTimes = rawTimes
            .map((e) => e?.toString() ?? '')
            .where((time) => time != '예약불가')
            .toList();
        if (parsedAvailableTimes.isEmpty) parsedAvailableTimes = null;
      } else if (rawTimes is String && rawTimes != '예약불가') {
        parsedAvailableTimes = [rawTimes];
      }
    }
    return ThemeModel(
      id: json.containsKey('id') && json['id'] != null ? json['id'] : '',
      title: fixBrokenText(json['title'] ?? ''),
      description: fixBrokenText(json['description'] ?? ''),
      location: fixBrokenText(json['location'] ?? ''),
      price:
          json.containsKey('price') && json['price'] is num ? json['price'] : 0,
      image: json.containsKey('image') && json['image'] != null
          ? json['image']
          : '',
      url: json.containsKey('url') && json['url'] != null ? json['url'] : '',
      brand: fixBrokenText(json['brand'] ?? ''),
      branch: fixBrokenText(json['branch'] ?? ''),
      playtime: json.containsKey('playtime') && json['playtime'] is num
          ? json['playtime']
          : 0,
      rating: json.containsKey('rating') && json['rating'] is num
          ? (json['rating'] as num).toDouble()
          : 0.0,
      horror: json.containsKey('horror') && json['horror'] is num
          ? json['horror']
          : 0,
      activity: json.containsKey('activity') && json['activity'] is num
          ? json['activity']
          : 0,
      level: json.containsKey('level') && json['level'] is num
          ? (json['level'] as num).toDouble()
          : 0.0,
      reviewCount: json.containsKey('reviewCount') && json['reviewCount'] is num
          ? json['reviewCount']
          : 0,
      proportion: fixBrokenText(json['proportion'] ?? ''),
      availableTimes: parsedAvailableTimes,
    );
  }
}
