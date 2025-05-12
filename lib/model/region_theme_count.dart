// class RegionThemeCount {
//   final String location;
//   final int count;
//
//   RegionThemeCount({required this.location, required this.count});
//
//   factory RegionThemeCount.fromJson(Map<String, dynamic> json) {
//     return RegionThemeCount(
//       location: json['location'],
//       count: json['count'],
//     );
//   }
// }
class RegionCount {
  final String location;
  final int count;

  RegionCount({required this.location, required this.count});

  factory RegionCount.fromJson(Map<String, dynamic> json) {
    return RegionCount(
      location: json['location'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}

class RegionCountResponse {
  final int total;
  final List<RegionCount> counts;

  RegionCountResponse({required this.total, required this.counts});

  factory RegionCountResponse.fromJson(Map<String, dynamic> json) {
    return RegionCountResponse(
      total: json['total'] ?? 0,
      counts: (json['counts'] as List)
          .map((item) => RegionCount.fromJson(item))
          .toList(),
    );
  }
}
