import 'package:flutter/cupertino.dart';
import 'package:scrd/utils/api_server.dart';

import '../model/region_theme_count.dart';

class RegionCountProvider with ChangeNotifier {
  // List<RegionThemeCount> _counts = [];
  // bool isLoading = false;
  //
  // List<RegionThemeCount> get counts => _counts;
  //
  // Future<void> fetchCounts() async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     _counts = await ApiService().fetchRegionThemeCounts();
  //     debugPrint("Fetched counts: $_counts");
  //   } catch (e) {
  //     _counts = [];
  //   }
  //   isLoading = false;
  //   notifyListeners();
  // }
  //
  // int getCountByRegion(String region) {
  //   return _counts
  //       .firstWhere((e) => e.location == region,
  //           orElse: () => RegionThemeCount(location: region, count: 0))
  //       .count;
  // }
  bool isLoading = false;
  List<RegionCount> counts = [];
  int total = 0;

  Future<void> fetchRegionCounts() async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await ApiService().fetchRegionCounts();
      counts = result.counts;
      total = result.total;
    } catch (e) {
      debugPrint("지역 카운트 불러오기 에러: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  int getCountByLocation(String location) {
    return counts
        .firstWhere(
          (rc) => rc.location == location,
          orElse: () => RegionCount(location: location, count: 0),
        )
        .count;
  }
}
