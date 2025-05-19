class ApiConstants {
  static const String loginUrl = "https://test.apiofpeg.com";
  static const String baseUrl = loginUrl;
  //static const String baseUrl = "http://192.168.45.92:8080"; // 집
  //static const String baseUrl = "https://test.apiofpeg.com";
  static const String mainList = "$baseUrl/scrd/api/theme/paged";
  static const String reviewList = "$baseUrl/scrd/api/review";
  //static const String mainList = "$baseUrl/scrd/every";
  //static const String loginUrl = "http://172.17.205.100"; //갈대상자
  //갈대상자관
  //static const String loginUrl = "http://192.168.45.92";
  static const String filteredThemeList = "$baseUrl/scrd/api/theme/filter";
  //static const baseHost = "172.17.205.100:8080";
  static String baseHost = baseUrl.replaceAll("https://", "");
  static String myReviewList(String userId) =>
      "$baseUrl/scrd/api/review/$userId";
  static const String mySavedList = '/scrd/api/save';
  static const String themeDetail = "$baseUrl/scrd/api/web/theme"; // <- 추가

  //static const String clientId = "f77e1396028dc1a29468fd99dda85ef6";
  static const String clientId = "6b4d8cc48ec73499504d519e26c84c91";
}
