class SavedThemeModel {
  final int themeId;
  final String title;
  final String description;
  final String image;
  final String brand;
  final String branch;

  SavedThemeModel({
    required this.themeId,
    required this.title,
    required this.description,
    required this.image,
    required this.brand,
    required this.branch,
  });

  factory SavedThemeModel.fromJson(Map<String, dynamic> json) {
    return SavedThemeModel(
      themeId: json['themeId'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      brand: json['brand'] ?? '',
      branch: json['branch'] ?? '',
    );
  }
}
