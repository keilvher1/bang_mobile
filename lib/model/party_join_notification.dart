class PartyJoinNotification {
  final int joinId;
  final int userId;
  final String username;
  final String status;

  PartyJoinNotification({
    required this.joinId,
    required this.userId,
    required this.username,
    required this.status,
  });

  factory PartyJoinNotification.fromJson(Map<String, dynamic> json) {
    return PartyJoinNotification(
      joinId: json['joinId'] ?? 0,
      userId: json['userId'] ?? 0,
      username: json['username'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
