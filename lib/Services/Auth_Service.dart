import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Check if user is already logged in
  Future<bool> isUserLoggedIn() async {
    try {
      print('Checking if user is already logged in...');

      // Check if Firebase has an active session
      final currentUser = _auth.currentUser;

      if (currentUser != null) {
        print('User found in Firebase session: ${currentUser.uid}');

        // Verify token is still valid by reloading user
        await currentUser.reload();

        // Update last activity timestamp
        await _updateLastActivity(currentUser.uid);

        return true;
      }

      print('No active Firebase session found');
      return false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // Get current logged-in user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Save user session info to SharedPreferences
  Future<void> saveUserSession(String uid, String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_uid', uid);
      await prefs.setString('user_email', email);
      await prefs.setInt('login_timestamp', DateTime.now().millisecondsSinceEpoch);
      print('User session saved: $uid');
    } catch (e) {
      print('Error saving user session: $e');
    }
  }

  // Get saved user session info
  Future<Map<String, dynamic>> getSavedUserSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('user_uid');
      final email = prefs.getString('user_email');

      if (uid != null && email != null) {
        return {'uid': uid, 'email': email};
      }
      return {};
    } catch (e) {
      print('Error getting user session: $e');
      return {};
    }
  }

  // Clear user session
  Future<void> clearUserSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_uid');
      await prefs.remove('user_email');
      await prefs.remove('login_timestamp');
      print('User session cleared');
    } catch (e) {
      print('Error clearing user session: $e');
    }
  }

  // Update last activity in database
  Future<void> _updateLastActivity(String uid) async {
    try {
      await _database.ref().child('user_profiles').child(uid).update({
        'lastSeen': ServerValue.timestamp,
        'isOnline': true,
      });
    } catch (e) {
      print('Error updating last activity: $e');
    }
  }

  // Sign out user
  Future<void> signOut() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _database.ref().child('user_profiles').child(user.uid).update({
          'isOnline': false,
          'lastSeen': ServerValue.timestamp,
        });
      }

      await _auth.signOut();
      await clearUserSession();
      print('User signed out successfully');
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }
}
