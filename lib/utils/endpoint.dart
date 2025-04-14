class ApiConstants {
  static const String baseUrl = "http://172.18.139.181:8080";
  static const String mainList = "$baseUrl/scrd/api/theme?sort=rating";
  static const String reviewList = "$baseUrl/scrd/api/review";
  //static const String mainList = "$baseUrl/scrd/every";
  static const String loginUrl = "http://172.18.139.181"; //갈대상자
  static const String filteredThemeList = "$baseUrl/scrd/api/theme/filter";
  static const baseHost = "172.18.139.181:8080";
  static String myReviewList(String userId) =>
      "$baseUrl/scrd/api/review/$userId";
  static const String mySavedList = '/scrd/api/save';
}
