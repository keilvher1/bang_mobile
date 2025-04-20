// lib/model/theme_detail.dart

class ThemeDetail {
  final int id;
  final String title;
  final String location;
  final int price;
  final String image;
  final String url;
  final String brand;
  final String branch;
  final int playtime;
  final double rating;
  final String proportion; // 👈 새로 추가된 필드
  final int horror;
  final int activity;
  final double level;
  final int reviewCount;

  ThemeDetail({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.image,
    required this.url,
    required this.brand,
    required this.branch,
    required this.playtime,
    required this.rating,
    required this.proportion,
    required this.horror,
    required this.activity,
    required this.level,
    required this.reviewCount,
  });

  factory ThemeDetail.fromJson(Map<String, dynamic> json) {
    return ThemeDetail(
      id: json['id'],
      title: json['title'],
      location: json['location'],
      price: json['price'],
      image: json['image'],
      url: json['url'],
      brand: json['brand'],
      branch: json['branch'],
      playtime: json['playtime'],
      rating: (json['rating'] as num).toDouble(),
      proportion: json['proportion'] ?? '', // 👈 proportion은 String이야
      horror: json['horror'],
      activity: json['activity'],
      level: (json['level'] as num).toDouble(),
      reviewCount: json['reviewCount'],
    );
  }
}
