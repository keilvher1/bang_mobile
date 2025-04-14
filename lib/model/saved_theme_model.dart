class SavedThemeModel {
  final int themeId;
  final String themeTitle;
  final String branch;
  final String location;
  final String imageUrl;

  SavedThemeModel({
    required this.themeId,
    required this.themeTitle,
    required this.branch,
    required this.location,
    required this.imageUrl,
  });

  factory SavedThemeModel.fromJson(Map<String, dynamic> json) {
    return SavedThemeModel(
      themeId: json['themeId'],
      themeTitle: json['themeTitle'],
      branch: json['branch'],
      location: json['location'],
      imageUrl: json['imageUrl'],
    );
  }
}
