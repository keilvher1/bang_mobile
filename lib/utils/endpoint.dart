class ApiConstants {
  static const String baseUrl = "http://172.17.205.100:8080";
  //static const String baseUrl = "http://192.168.45.92:8080"; // 집
  static const String mainList = "$baseUrl/scrd/api/theme/paged";
  static const String reviewList = "$baseUrl/scrd/api/review";
  //static const String mainList = "$baseUrl/scrd/every";
  static const String loginUrl = "http://172.17.205.100"; //갈대상자
  //static const String loginUrl = "http://192.168.45.92";
  static const String filteredThemeList = "$baseUrl/scrd/api/theme/filter";
  static const baseHost = "172.17.205.100:8080";
  static String myReviewList(String userId) =>
      "$baseUrl/scrd/api/review/$userId";
  static const String mySavedList = '/scrd/api/save';
  static const String themeDetail = "$baseUrl/scrd/api/web/theme"; // <- 추가
}
