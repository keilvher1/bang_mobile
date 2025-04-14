class ThemeModel {
  final int id;
  final String title;
  final String description;
  final String location;
  final int price;
  final String image;
  final String url;
  final String brand; // 카페 이름
  final String branch; // 매장 이름
  final int playtime;
  final String proportion; // 장치 비율
  final double rating; // 테마 평점
  final int horror; // 테마 공포도
  final int activity; // 테마 활동성
  final double level;
  final int reviewCount;

  ThemeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.price,
    required this.image,
    required this.url,
    required this.brand,
    required this.branch,
    required this.playtime,
    required this.proportion,
    required this.rating,
    required this.horror,
    required this.activity,
    required this.level,
    required this.reviewCount,
  });

  // JSON -> ThemeModel
  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      price: json['price'] ?? -1,
      image: json['image'] ?? '',
      url: json['url'] ?? '',
      brand: json['brand'] ?? '',
      branch: json['branch'] ?? '',
      playtime: json['playtime'] ?? -1,
      proportion: json['proportion'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      horror: json['horror'] ?? 0,
      activity: json['activity'] ?? 0,
      level: (json['level'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
    );
  }

  // ThemeModel -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'price': price,
      'image': image,
      'url': url,
      'brand': brand,
      'branch': branch,
      'playtime': playtime,
      'proportion': proportion,
      'rating': rating,
      'horror': horror,
      'activity': activity,
      'level': level,
      'reviewCount': reviewCount,
    };
  }
}
