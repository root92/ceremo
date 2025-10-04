class ApiConfig {
  // Backend API configuration
  static const String baseUrl = 'https://c23534bb1b42.ngrok-free.app';
  static const String graphqlEndpoint = '$baseUrl/graphql/';
  
  // API endpoints
  static const String loginEndpoint = '$baseUrl/api/auth/login/';
  static const String registerEndpoint = '$baseUrl/api/auth/register/';
  static const String refreshTokenEndpoint = '$baseUrl/api/auth/refresh/';
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Timeout settings
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
