class AppUrl {

  static const String baseUrl = 'http://192.168.0.167:8081/api';
  static const String login = '$baseUrl/login';
  static const String register = '$baseUrl/register';
  static const String resetPassword = '$baseUrl/password/reset';
  static const String logout = '$baseUrl/auth/logout';
  static const String updatePassword = '$baseUrl/users/auth/update-password';

  static const String items = '$baseUrl/components';

  static const String sales = '$baseUrl/sales';
  static const String leds = '$baseUrl/leds';

  static const String statistics = '$baseUrl/statistics';
  static const String salesStatistics = '$baseUrl/statistics/sales';
  static const String recommendations = '$baseUrl/statistics/recommendations';

  static const String outOfStocks = '$baseUrl/out_of_stocks';

  //profile
  static const String profile = '$baseUrl/users/profile';

  static const String restock = '$baseUrl/restocks';

  static const String users = '$baseUrl/users';
}
