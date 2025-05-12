class Party {
  final int id;
  final String image;
  final String title;
  final String themeTitle;
  final String location;
  final bool isClosed;
  final DateTime deadline;
  final int currentParticipants;
  final int maxParticipants;

  Party({
    required this.id,
    required this.image,
    required this.title,
    required this.themeTitle,
    required this.location,
    required this.isClosed,
    required this.deadline,
    required this.currentParticipants,
    required this.maxParticipants,
  });

  factory Party.fromJson(Map<String, dynamic> json) {
    return Party(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      themeTitle: json['themeTitle'] ?? '',
      location: json['location'] ?? '',
      isClosed: json['isClosed'] ?? false,
      deadline: DateTime.parse(json['deadline']),
      currentParticipants: json['currentParticipants'] ?? 0,
      maxParticipants: json['maxParticipants'] ?? 0,
    );
  }
}
