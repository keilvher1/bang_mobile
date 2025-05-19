class SavedThemeModel {
  final int id;
  final String title;
  final String description;
  final String location;
  final int price;
  final String image;
  final String url;
  final String brand;
  final String branch;
  final int playtime;
  final double rating;
  final String proportion;
  final int horror;
  final int activity;
  final double level;
  final int reviewCount;
  List<dynamic>? availableTimes; // or List<String> if known

  SavedThemeModel({
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
    required this.rating,
    required this.proportion,
    required this.horror,
    required this.activity,
    required this.level,
    required this.reviewCount,
    required this.availableTimes,
  });

  factory SavedThemeModel.fromJson(Map<String, dynamic> json) {
    return SavedThemeModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      price: json['price'] ?? 0,
      image: json['image'] ?? '',
      url: json['url'] ?? '',
      brand: json['brand'] ?? '',
      branch: json['branch'] ?? '',
      playtime: json['playtime'] ?? 0,
      rating: (json['rating'] as num).toDouble() ?? 0.0,
      proportion: json['proportion'] ?? '',
      horror: json['horror'] ?? 0,
      activity: json['activity'] ?? 0,
      level: (json['level'] as num).toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      availableTimes: json['availableTimes'] ?? [],
    );
  }
}
