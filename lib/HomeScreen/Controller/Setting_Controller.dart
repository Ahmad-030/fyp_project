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
  var fullName = ''.obs; // Changed from firstName to fullName
  var phoneNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
    _loadUserData();
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

          // Try to get full name from different possible fields
          String firstName = userData['firstName'] ?? '';
          String lastName = userData['lastName'] ?? '';

          // If both firstName and lastName exist, combine them
          if (firstName.isNotEmpty && lastName.isNotEmpty) {
            fullName.value = '$firstName $lastName';
          }
          // If only firstName exists
          else if (firstName.isNotEmpty) {
            fullName.value = firstName;
          }
          // If fullName field exists directly
          else if (userData['fullName'] != null && userData['fullName'].toString().isNotEmpty) {
            fullName.value = userData['fullName'];
          }
          // Fallback
          else {
            fullName.value = 'User';
          }

          phoneNumber.value = userData['phone'] ?? 'Not provided';

          print('User data loaded successfully:');
          print('Full Name: ${fullName.value}');
          print('Phone: ${phoneNumber.value}');
        } else {
          print('No user data found in database for UID: $userId');
          fullName.value = 'User';
          phoneNumber.value = 'Not provided';
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      fullName.value = 'User';
      phoneNumber.value = 'Not provided';
    }
  }

  // Test proximity notification
  Future<void> testProximityNotification() async {
    try {
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
    } catch (e) {
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
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send test notification: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF6B6B).withOpacity(0.9),
        colorText: Colors.white,
      );
    }
  }

  // Clear all alerts from database - FIXED
  Future<void> clearAllAlerts() async {
    try {
      isLoading.value = true;

      print('Clearing all alerts from Firebase...');
      final ref = _database.ref().child('childSafety/alarms');
      await ref.remove();
      print('All alerts cleared from Firebase');

      // Cancel all notifications
      await NotificationService.cancelAllNotifications();
      print('All notifications cancelled');

      // Show success message
      Get.snackbar(
        'Success',
        'All alerts have been cleared',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50).withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate back to home screen to refresh UI
      Get.back(); // Close settings screen

      // Force rebuild of home screen with cleared data
      await Future.delayed(const Duration(milliseconds: 100));
      Get.off(() => const ChildSafetyMonitoringScreen());

    } catch (e) {
      print('Error clearing all alerts: $e');
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

  // Clear proximity alerts only - FIXED
  Future<void> clearProximityAlerts() async {
    try {
      isLoading.value = true;

      print('Clearing proximity alerts from Firebase...');
      final ref = _database.ref().child('childSafety/alarms/PROXIMITY');
      await ref.remove();
      print('Proximity alerts cleared from Firebase');

      // Show success message
      Get.snackbar(
        'Success',
        'Proximity alerts have been cleared',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50).withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate back to home screen to refresh UI
      Get.back(); // Close settings screen

      // Force rebuild of home screen with cleared data
      await Future.delayed(const Duration(milliseconds: 100));
      Get.off(() => const ChildSafetyMonitoringScreen());

    } catch (e) {
      print('Error clearing proximity alerts: $e');
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

  // Clear sound alerts only - FIXED
  Future<void> clearSoundAlerts() async {
    try {
      isLoading.value = true;

      print('Clearing sound hazard alerts from Firebase...');
      final ref = _database.ref().child('childSafety/alarms/SOUND_HAZARD');
      await ref.remove();
      print('Sound hazard alerts cleared from Firebase');

      // Show success message
      Get.snackbar(
        'Success',
        'Sound hazard alerts have been cleared',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50).withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate back to home screen to refresh UI
      Get.back(); // Close settings screen

      // Force rebuild of home screen with cleared data
      await Future.delayed(const Duration(milliseconds: 100));
      Get.off(() => const ChildSafetyMonitoringScreen());

    } catch (e) {
      print('Error clearing sound alerts: $e');
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

  // Logout - FIXED VERSION
  Future<void> logout() async {
    try {
      print('Starting logout process...');
      isLoading.value = true;

      final user = _auth.currentUser;

      if (user != null) {
        print('Updating user offline status...');
        await _database.ref().child('user_profiles').child(user.uid).update({
          'isOnline': false,
          'lastSeen': ServerValue.timestamp,
        });
        print('User offline status updated');
      }

      print('Signing out from Firebase Auth...');
      await _auth.signOut();
      print('Firebase Auth sign out successful');

      // Clear user session
      final authService = AuthService();
      await authService.clearUserSession();
      print('User session cleared');

      print('Cancelling all notifications...');
      await NotificationService.cancelAllNotifications();

      print('Navigating to Login screen...');
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

      print('Logout completed successfully');

    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error during logout: $e');
      Get.snackbar(
        'Error',
        'Failed to logout: ${e.message}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF6B6B).withOpacity(0.9),
        colorText: Colors.white,
      );
    } catch (e) {
      print('Unexpected error during logout: $e');
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
    print('SettingsController disposed');
    super.onClose();
  }
}