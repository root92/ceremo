import 'dart:convert';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'graphql_client.dart';

class AuthService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _userKey = 'user_data';
  static const String _currentOrganizationKey = 'current_organization';
  
  // GraphQL Queries and Mutations
  static const String loginMutation = '''
    mutation Login(\$input: LoginInput!) {
      login(input: \$input) {
        token
        refreshToken
        user {
          id
          email
          name
          role
          country
          currency
          isActive
          createdAt
        }
        errors
      }
    }
  ''';
  
  static const String registerMutation = '''
    mutation Register(\$input: RegisterInput!) {
      register(input: \$input) {
        success
        user {
          id
          email
          name
          role
          country
          currency
          isActive
          createdAt
        }
        token
        refreshToken
        errors
      }
    }
  ''';
  
  static const String refreshTokenMutation = '''
    mutation RefreshToken(\$refreshToken: String!) {
      refreshToken(refreshToken: \$refreshToken) {
        success
        token
        refreshToken
        errors
      }
    }
  ''';
  
  static const String meQuery = '''
    query Me {
      me {
        id
        email
        name
        role
        country
        currency
        isActive
        createdAt
        hasSubscription
        subscriptionTier
        subscriptionStatus
      }
    }
  ''';
  
  // Authentication methods
  static Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await CeremoGraphQLClient.client.mutate(
        MutationOptions(
          document: gql(loginMutation),
          variables: {
            'input': {
              'email': email,
              'password': password,
            },
          },
        ),
      );
      
      if (result.hasException) {
        throw Exception('Login failed: ${result.exception.toString()}');
      }
      
      final data = result.data?['login'];
      if (data == null || (data['errors'] != null && data['errors'].isNotEmpty)) {
        throw Exception('Login failed: ${data?['errors']?.join(', ') ?? 'Unknown error'}');
      }
      
      // Store tokens
      await _storeTokens(
        data['token'],
        data['refreshToken'],
      );
      
      // Store user data (clean the data to remove GraphQL metadata)
      final userData = Map<String, dynamic>.from(data['user']);
      userData.remove('__typename'); // Remove GraphQL metadata
      await _storeUserData(userData);
      
      // Refresh GraphQL client to use new token
      CeremoGraphQLClient.refreshClient();
      
      return data;
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }
  
  static Future<Map<String, dynamic>?> register({
    required String email,
    required String password,
    required String name,
    String? country,
    String? currency,
  }) async {
    try {
      final result = await CeremoGraphQLClient.client.mutate(
        MutationOptions(
          document: gql(registerMutation),
          variables: {
            'input': {
              'email': email,
              'password': password,
              'name': name,
              if (country != null) 'country': country,
              if (currency != null) 'currency': currency,
            },
          },
        ),
      );
      
      if (result.hasException) {
        throw Exception('Registration failed: ${result.exception.toString()}');
      }
      
      final data = result.data?['register'];
      if (data == null || !data['success'] || (data['errors'] != null && data['errors'].isNotEmpty)) {
        throw Exception('Registration failed: ${data?['errors']?.join(', ') ?? 'Unknown error'}');
      }
      
      // Store tokens
      await _storeTokens(
        data['token'],
        data['refreshToken'],
      );
      
      // Store user data (clean the data to remove GraphQL metadata)
      final userData = Map<String, dynamic>.from(data['user']);
      userData.remove('__typename'); // Remove GraphQL metadata
      await _storeUserData(userData);
      
      // Refresh GraphQL client to use new token
      CeremoGraphQLClient.refreshClient();
      
      return data;
    } catch (e) {
      print('Registration error: $e');
      rethrow;
    }
  }
  
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final result = await CeremoGraphQLClient.client.query(
        QueryOptions(
          document: gql(meQuery),
        ),
      );
      
      if (result.hasException) {
        throw Exception('Failed to get user: ${result.exception.toString()}');
      }
      
      return result.data?['me'];
    } catch (e) {
      print('Get current user error: $e');
      rethrow;
    }
  }
  
  static Future<bool> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(_refreshTokenKey);
      
      if (refreshToken == null) {
        return false;
      }
      
      final result = await CeremoGraphQLClient.client.mutate(
        MutationOptions(
          document: gql(refreshTokenMutation),
          variables: {
            'refreshToken': refreshToken,
          },
        ),
      );
      
      if (result.hasException) {
        return false;
      }
      
      final data = result.data?['refreshToken'];
      if (data == null || !data['success']) {
        return false;
      }
      
      await _storeTokens(
        data['token'],
        data['refreshToken'],
      );
      
      return true;
    } catch (e) {
      print('Refresh token error: $e');
      return false;
    }
  }
  
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_accessTokenKey);
    return token != null && token.isNotEmpty;
  }
  
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userKey);
    await prefs.remove(_currentOrganizationKey);
    await CeremoGraphQLClient.clearCache();
  }
  
  // Clear corrupted data and force re-authentication
  static Future<void> clearCorruptedData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_currentOrganizationKey);
    print('AuthService: Cleared corrupted user data');
  }
  
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }
  
  static Future<Map<String, dynamic>?> getCurrentUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    if (userData != null) {
      try {
        return Map<String, dynamic>.from(jsonDecode(userData));
      } catch (e) {
        print('Error parsing user data: $e');
        return null;
      }
    }
    return null;
  }
  
  static Future<void> setCurrentOrganization(String organizationId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentOrganizationKey, organizationId);
  }
  
  static Future<String?> getCurrentOrganization() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentOrganizationKey);
  }
  
  // Private helper methods
  static Future<void> _storeTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }
  
  static Future<void> _storeUserData(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    // Store user data as proper JSON string
    final userJson = jsonEncode(user);
    await prefs.setString(_userKey, userJson);
  }
}
