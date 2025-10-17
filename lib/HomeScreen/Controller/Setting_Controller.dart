import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../Services/Auth_Service.dart';
import '../../Services/Notification_service.dart';
import '../SafetyMonitoring_ui.dart';
import '../../Auth_Screens/Login/Login_Ui.dart';

class SettingsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  var currentUser = Rxn<User>();
  var isLoading = false.obs;
  var fullName = ''.obs;
  var phoneNumber = ''.obs;

  // ✅ Real-time monitoring status with Firebase sync
  var connectionStatus = RxString('🟢 Connected');
  var lastRefreshTime = Rx<DateTime>(DateTime.now());
  var firebaseLastUpdate = Rx<DateTime?>(null);
  var proximityAlerts = RxList<Map<String, dynamic>>();
  var soundAlerts = RxList<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
    _loadUserData();
    _setupRealtimeMonitoring();
  }

  void _loadCurrentUser() {
    currentUser.value = _auth.currentUser;
  }

  Future<void> _loadUserData() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final snapshot = await _database.ref().child('users/$userId').get();
        if (snapshot.exists) {
          final userData = Map<String, dynamic>.from(snapshot.value as Map);

          String firstName = userData['firstName'] ?? '';
          String lastName = userData['lastName'] ?? '';

          if (firstName.isNotEmpty && lastName.isNotEmpty) {
            fullName.value = '$firstName $lastName';
          } else if (firstName.isNotEmpty) {
            fullName.value = firstName;
          } else if (userData['fullName'] != null && userData['fullName'].toString().isNotEmpty) {
            fullName.value = userData['fullName'];
          } else {
            fullName.value = 'User';
          }

          phoneNumber.value = userData['phone'] ?? 'Not provided';

          print('✅ User data loaded successfully');
        } else {
          print('⚠️ No user data found in database');
          fullName.value = 'User';
          phoneNumber.value = 'Not provided';
        }
      }
    } catch (e) {
      print('❌ Error loading user data: $e');
      fullName.value = 'User';
      phoneNumber.value = 'Not provided';
    }
  }

  // ✅ Setup real-time monitoring with Firebase timestamp tracking
  void _setupRealtimeMonitoring() {
    try {
      print('🔗 Setting up real-time monitoring...');
      final ref = _database.ref().child('childSafety/alarms');

      ref.onValue.listen((event) {
        lastRefreshTime.value = DateTime.now();
        connectionStatus.value = '🟢 Connected';

        if (event.snapshot.exists) {
          proximityAlerts.clear();
          soundAlerts.clear();

          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          int latestTimestamp = 0;

          // Parse PROXIMITY alerts
          if (data.containsKey('PROXIMITY')) {
            final proxData = Map<String, dynamic>.from(data['PROXIMITY'] as Map);
            proxData.forEach((key, value) {
              if (value is Map) {
                final alertMap = Map<String, dynamic>.from(value);
                final timestamp = _normalizeTimestamp(alertMap['lastUpdate'] ?? alertMap['timestamp'] ?? 0);

                if (timestamp > latestTimestamp) {
                  latestTimestamp = timestamp;
                }

                proximityAlerts.add({
                  'id': key,
                  'message': alertMap['message'] ?? 'Proximity Alert',
                  'status': alertMap['status'] ?? 'ACTIVE',
                  'timestamp': timestamp,
                });
              }
            });
          }

          // Parse SOUND_HAZARD alerts
          if (data.containsKey('SOUND_HAZARD')) {
            final soundData = Map<String, dynamic>.from(data['SOUND_HAZARD'] as Map);
            soundData.forEach((key, value) {
              if (value is Map) {
                final alertMap = Map<String, dynamic>.from(value);
                final timestamp = _normalizeTimestamp(alertMap['lastUpdate'] ?? alertMap['timestamp'] ?? 0);

                if (timestamp > latestTimestamp) {
                  latestTimestamp = timestamp;
                }

                soundAlerts.add({
                  'id': key,
                  'message': alertMap['message'] ?? 'Sound Alert',
                  'status': alertMap['status'] ?? 'ACTIVE',
                  'timestamp': timestamp,
                });
              }
            });
          }

          // ✅ Update Firebase last update from latest alert
          if (latestTimestamp > 0) {
            firebaseLastUpdate.value = DateTime.fromMillisecondsSinceEpoch(latestTimestamp);
            print('⏱️ Latest Firebase Update: ${firebaseLastUpdate.value}');
          } else {
            firebaseLastUpdate.value = null;
          }

          print('✅ Real-time data updated');
        } else {
          print('⚠️ No alerts data found');
          connectionStatus.value = '⚠️ No data';
          firebaseLastUpdate.value = null;
        }
      }, onError: (error) {
        print('❌ Real-time listener error: $error');
        connectionStatus.value = '🔴 Error';
      });
    } catch (e) {
      print('❌ Error setting up monitoring: $e');
      connectionStatus.value = '🔴 Failed';
    }
  }

  // ✅ Normalize timestamp from Firebase
  int _normalizeTimestamp(dynamic rawTimestamp) {
    if (rawTimestamp == null) return 0;

    int timestamp = 0;

    if (rawTimestamp is int) {
      timestamp = rawTimestamp;
    } else if (rawTimestamp is double) {
      timestamp = rawTimestamp.toInt();
    } else if (rawTimestamp is String) {
      timestamp = int.tryParse(rawTimestamp) ?? 0;
    }

    // Smart conversion for milliseconds vs seconds
    if (timestamp > 0 && timestamp < 10000000000) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final diff = (now - timestamp).abs();

      if (diff > 3155760000000) {
        timestamp = timestamp * 1000;
      }
    }

    return timestamp;
  }

  // ✅ Get formatted Firebase last update
  String getFirebaseLastUpdateFormatted() {
    if (firebaseLastUpdate.value == null) {
      return 'No updates yet';
    }

    final lastUpdate = firebaseLastUpdate.value!;
    final now = DateTime.now();
    final diff = now.difference(lastUpdate);

    if (diff.inSeconds <= 0) {
      return '${diff.inSeconds}s ago • ${lastUpdate.hour.toString().padLeft(2, '0')}:${lastUpdate.minute.toString().padLeft(2, '0')}';
    }
    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago • ${lastUpdate.hour.toString().padLeft(2, '0')}:${lastUpdate.minute.toString().padLeft(2, '0')}';
    }
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago • ${lastUpdate.hour.toString().padLeft(2, '0')}:${lastUpdate.minute.toString().padLeft(2, '0')}';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h ago • ${lastUpdate.hour.toString().padLeft(2, '0')}:${lastUpdate.minute.toString().padLeft(2, '0')}';
    }
    return '${diff.inDays}d ago • ${lastUpdate.hour.toString().padLeft(2, '0')}:${lastUpdate.minute.toString().padLeft(2, '0')}';
  }

  // Test proximity notification
  Future<void> testProximityNotification() async {
    try {
      print('🧪 Testing proximity notification...');
      await NotificationService.showProximityAlert(
        message: 'This is a test proximity alert notification',
        alertId: 'test_proximity_${DateTime.now().millisecondsSinceEpoch}',
      );
      Get.snackbar(
        'Test Notification',
        'Proximity alert sent successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50).withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      print('✅ Test proximity notification sent');
    } catch (e) {
      print('❌ Error: $e');
      Get.snackbar(
        'Error',
        'Failed to send test notification: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF6B6B).withOpacity(0.9),
        colorText: Colors.white,
      );
    }
  }

  // Test sound hazard notification
  Future<void> testSoundNotification() async {
    try {
      print('🧪 Testing sound notification...');
      await NotificationService.showSoundHazardAlert(
        message: 'This is a test sound hazard alert notification',
        alertId: 'test_sound_${DateTime.now().millisecondsSinceEpoch}',
      );
      Get.snackbar(
        'Test Notification',
        'Sound hazard alert sent successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50).withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      print('✅ Test sound notification sent');
    } catch (e) {
      print('❌ Error: $e');
      Get.snackbar(
        'Error',
        'Failed to send test notification: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF6B6B).withOpacity(0.9),
        colorText: Colors.white,
      );
    }
  }

  // Clear all alerts from database
  Future<void> clearAllAlerts() async {
    try {
      isLoading.value = true;
      print('🗑️ Clearing all alerts...');

      final ref = _database.ref().child('childSafety/alarms');
      await ref.remove();
      print('✅ All alerts cleared');

      await NotificationService.cancelAllNotifications();
      print('✅ All notifications cancelled');

      Get.snackbar(
        'Success',
        'All alerts have been cleared',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50).withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      Get.back();
      await Future.delayed(const Duration(milliseconds: 100));
      Get.off(() => const ChildSafetyMonitoringScreen());
    } catch (e) {
      print('❌ Error clearing all alerts: $e');
      Get.snackbar(
        'Error',
        'Failed to clear alerts: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF6B6B).withOpacity(0.9),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear proximity alerts only
  Future<void> clearProximityAlerts() async {
    try {
      isLoading.value = true;
      print('🗑️ Clearing proximity alerts...');

      final ref = _database.ref().child('childSafety/alarms/PROXIMITY');
      await ref.remove();
      print('✅ Proximity alerts cleared');

      Get.snackbar(
        'Success',
        'Proximity alerts have been cleared',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50).withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      Get.back();
      await Future.delayed(const Duration(milliseconds: 100));
      Get.off(() => const ChildSafetyMonitoringScreen());
    } catch (e) {
      print('❌ Error clearing proximity alerts: $e');
      Get.snackbar(
        'Error',
        'Failed to clear proximity alerts: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF6B6B).withOpacity(0.9),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear sound alerts only
  Future<void> clearSoundAlerts() async {
    try {
      isLoading.value = true;
      print('🗑️ Clearing sound alerts...');

      final ref = _database.ref().child('childSafety/alarms/SOUND_HAZARD');
      await ref.remove();
      print('✅ Sound hazard alerts cleared');

      Get.snackbar(
        'Success',
        'Sound hazard alerts have been cleared',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50).withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      Get.back();
      await Future.delayed(const Duration(milliseconds: 100));
      Get.off(() => const ChildSafetyMonitoringScreen());
    } catch (e) {
      print('❌ Error clearing sound alerts: $e');
      Get.snackbar(
        'Error',
        'Failed to clear sound alerts: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF6B6B).withOpacity(0.9),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      print('🚪 Starting logout process...');
      isLoading.value = true;

      final user = _auth.currentUser;

      if (user != null) {
        print('📝 Updating user offline status...');
        await _database.ref().child('user_profiles').child(user.uid).update({
          'isOnline': false,
          'lastSeen': ServerValue.timestamp,
        });
        print('✅ User offline status updated');
      }

      print('🔐 Signing out from Firebase...');
      await _auth.signOut();
      print('✅ Firebase sign out successful');

      final authService = AuthService();
      await authService.clearUserSession();
      print('✅ User session cleared');

      await NotificationService.cancelAllNotifications();
      print('✅ Notifications cancelled');

      print('🔄 Navigating to login...');
      Get.offAll(
            () => const LoginScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 500),
      );

      Get.snackbar(
        'Success',
        'Logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50).withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      print('✅ Logout completed successfully');
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error during logout: $e');
      Get.snackbar(
        'Error',
        'Failed to logout: ${e.message}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF6B6B).withOpacity(0.9),
        colorText: Colors.white,
      );
    } catch (e) {
      print('❌ Unexpected error during logout: $e');
      Get.snackbar(
        'Error',
        'Failed to logout: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF6B6B).withOpacity(0.9),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    print('🧹 SettingsController disposed');
    super.onClose();
  }
}