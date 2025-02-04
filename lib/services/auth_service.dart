import 'package:mis_project/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String keyUsername = 'username';
  static const String keyRole = 'role';

  static Future<void> login(String username, String password) async {
    // Mock login validation
    if (password == '123') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(keyUsername, username);
      await prefs.setString(keyRole, 'student'); // Mock role
    } else {
      throw Exception('Invalid credentials');
    }
  }

  static Future<User?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(keyUsername);
    final role = prefs.getString(keyRole);

    if (username != null && role != null) {
      return User(username: username, role: role);
    }
    return null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
