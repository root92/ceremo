import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isAuthenticated = false;
  Map<String, dynamic>? _user;
  String? _error;

  // Getters
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get user => _user;
  String? get error => _error;

  // Initialize auth state
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      print('AuthProvider: Initializing authentication...');
      _isAuthenticated = await AuthService.isLoggedIn();
      print('AuthProvider: Is logged in: $_isAuthenticated');
      
      if (_isAuthenticated) {
        try {
          _user = await AuthService.getCurrentUserData();
          print('AuthProvider: User data loaded: ${_user != null}');
          if (_user != null) {
            print('AuthProvider: User email: ${_user!['email']}');
          } else {
            // If no user data found, try to fetch from server
            print('AuthProvider: No user data found, fetching from server...');
            try {
              final serverUserData = await AuthService.getCurrentUser();
              if (serverUserData != null) {
                _user = serverUserData;
                print('AuthProvider: User data fetched from server: ${_user!['email']}');
              }
            } catch (e) {
              print('AuthProvider: Error fetching user from server: $e');
            }
          }
        } catch (e) {
          print('AuthProvider: Error loading user data: $e');
          // Clear corrupted data and force re-authentication
          await AuthService.clearCorruptedData();
          _isAuthenticated = false;
          _user = null;
        }
      }
    } catch (e) {
      print('AuthProvider: Initialization error: $e');
      _error = e.toString();
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('AuthProvider: Starting login for $email');
      final result = await AuthService.login(
        email: email,
        password: password,
      );

      if (result != null) {
        print('AuthProvider: Login successful');
        _isAuthenticated = true;
        _user = result['user'];
        _error = null;
        print('AuthProvider: User data: ${_user}');
        notifyListeners();
        return true;
      }
      print('AuthProvider: Login failed - no result');
      return false;
    } catch (e) {
      print('AuthProvider: Login error: $e');
      _error = e.toString();
      _isAuthenticated = false;
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    String? country,
    String? currency,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await AuthService.register(
        email: email,
        password: password,
        name: name,
        country: country,
        currency: currency,
      );

      if (result != null) {
        _isAuthenticated = true;
        _user = result['user'];
        _error = null;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.logout();
      _isAuthenticated = false;
      _user = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh user data
  Future<void> refreshUser() async {
    if (!_isAuthenticated) return;

    try {
      final userData = await AuthService.getCurrentUser();
      if (userData != null) {
        _user = userData;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
