class ThemeAvailableTime {
  final String date;
  final List<String> availableTime;

  ThemeAvailableTime({required this.date, required this.availableTime});

  factory ThemeAvailableTime.fromJson(Map<String, dynamic> json) {
    return ThemeAvailableTime(
      date: json['dateOfThemeAvailableTime'],
      availableTime: List<String>.from(json['availableTime']),
    );
  }
}
