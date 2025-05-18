import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/common/local/shared_prefs/shared_pref.dart';
import 'package:hotel_app/di/injector.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  final SharedPref _sharedPref = injector<SharedPref>();
  static const String _userIdKey = 'user_id';
  static const String _tokenKey = 'auth_token';

  // Get current user ID
  Future<int?> getCurrentUserId() async {
    try {
      final userIdStr = await _sharedPref.get(_userIdKey);
      if (userIdStr != null) {
        return int.tryParse(userIdStr.toString());
      }
      return null;
    } catch (e) {
      print('Error getting current user ID: $e');
      return null;
    }
  }

  // Save user ID after login
  Future<bool> saveUserId(int userId) async {
    try {
      return await _sharedPref.set(_userIdKey, userId.toString());
    } catch (e) {
      print('Error saving user ID: $e');
      return false;
    }
  }

  // Clear user data on logout
  Future<void> logout() async {
    try {
      await _sharedPref.remove(_userIdKey);
      await _sharedPref.remove(_tokenKey);
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final userId = await getCurrentUserId();
    return userId != null;
  }

  // Save auth token
  Future<bool> saveAuthToken(String token) async {
    try {
      return await _sharedPref.set(_tokenKey, token);
    } catch (e) {
      print('Error saving auth token: $e');
      return false;
    }
  }

  // Get auth token
  Future<String?> getAuthToken() async {
    try {
      final token = await _sharedPref.get(_tokenKey);
      return token?.toString();
    } catch (e) {
      print('Error getting auth token: $e');
      return null;
    }
  }
}