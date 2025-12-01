import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../Services/Auth_Service.dart';
import '../../Services/Notification_service.dart';
import '../../Auth_Screens/Login/Login_Ui.dart';

class OutroController extends GetxController with GetTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // User data
  var currentUser = Rxn<User>();
  var isLoading = false.obs;
  var fullName = ''.obs;
  var phoneNumber = ''.obs;
  var email = ''.obs;
  var memberSince = ''.obs;

  // Animation controllers
  late AnimationController mainController;
  late AnimationController pulseController;
  late AnimationController swipeHintController;

  // Animations
  late Animation<double> fadeAnimation;
  late Animation<double> slideAnimation;
  late Animation<double> pulseAnimation;
  late Animation<double> swipeHintAnimation;

  // Swipe state
  var swipeProgress = 0.0.obs;
  var isSwipeComplete = false.obs;
  var showSwipeHint = true.obs;
  var isLoggingOut = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _startAnimations();
    _loadCurrentUser();
    _loadUserData();
  }

  void _initializeAnimations() {
    // Main animation controller
    mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Pulse animation controller (continuous)
    pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Swipe hint animation controller
    swipeHintController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Fade animation
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: mainController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    // Slide animation
    slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: mainController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    // Pulse animation
    pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: pulseController,
      curve: Curves.easeInOut,
    ));

    // Swipe hint animation
    swipeHintAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: swipeHintController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    mainController.forward();
    pulseController.repeat(reverse: true);
    swipeHintController.repeat(reverse: true);
  }

  void _loadCurrentUser() {
    currentUser.value = _auth.currentUser;
    email.value = currentUser.value?.email ?? 'Not available';
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

          // Format member since date
          if (userData['createdAt'] != null) {
            final createdAt = DateTime.fromMillisecondsSinceEpoch(userData['createdAt'] as int);
            memberSince.value = '${_getMonthName(createdAt.month)} ${createdAt.year}';
          } else {
            memberSince.value = 'Recently joined';
          }

          print('✅ User data loaded successfully');
        } else {
          print('⚠️ No user data found in database');
          fullName.value = 'User';
          phoneNumber.value = 'Not provided';
          memberSince.value = 'Recently joined';
        }
      }
    } catch (e) {
      print('❌ Error loading user data: $e');
      fullName.value = 'User';
      phoneNumber.value = 'Not provided';
      memberSince.value = 'Recently joined';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  // Handle swipe progress
  void updateSwipeProgress(double progress) {
    swipeProgress.value = progress.clamp(0.0, 1.0);
    showSwipeHint.value = false;

    if (progress >= 0.85 && !isSwipeComplete.value) {
      isSwipeComplete.value = true;
      _performLogout();
    }
  }

  void resetSwipe() {
    if (!isSwipeComplete.value) {
      swipeProgress.value = 0.0;
      showSwipeHint.value = true;
    }
  }

  Future<void> _performLogout() async {
    try {
      isLoggingOut.value = true;
      print('🔌 Turning off IoT device and logging out...');

      // Show turning off message
      Get.snackbar(
        '🔌 Turning Off IoT Device',
        'Disconnecting from ESP32 sensors...',
        backgroundColor: const Color(0xFFFFA500).withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.sensors_off_rounded, color: Colors.white),
      );

      await Future.delayed(const Duration(seconds: 2));

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

      // Show success message
      Get.snackbar(
        '✅ IoT Device Turned Off',
        'You have been logged out successfully',
        backgroundColor: const Color(0xFF059669).withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      print('🔄 Navigating to login...');
      Get.offAll(
            () => const LoginScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 500),
      );

      print('✅ Logout completed successfully');
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error during logout: $e');
      isSwipeComplete.value = false;
      swipeProgress.value = 0.0;
      Get.snackbar(
        'Error',
        'Failed to logout: ${e.message}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFFF6B6B).withOpacity(0.9),
        colorText: Colors.white,
      );
    } catch (e) {
      print('❌ Unexpected error during logout: $e');
      isSwipeComplete.value = false;
      swipeProgress.value = 0.0;
      Get.snackbar(
        'Error',
        'Failed to logout: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFFF6B6B).withOpacity(0.9),
        colorText: Colors.white,
      );
    } finally {
      isLoggingOut.value = false;
    }
  }

  // Color getters matching app theme
  List<Color> getBackgroundGradientColors() {
    return [
      const Color(0xFF0F2A4A),
      const Color(0xFF1E4A6B),
      const Color(0xFF2D6A9A),
      const Color(0xFF4A90C2),
    ];
  }

  List<Color> getCardGradient() {
    return [
      const Color(0xFF87CEEB).withOpacity(0.15),
      const Color(0xFF4169E1).withOpacity(0.08),
    ];
  }

  List<Color> getSwipeButtonGradient() {
    return [
      const Color(0xFFFF6B6B),
      const Color(0xFFFF8E8E),
    ];
  }

  Color getAccentColor() => const Color(0xFF87CEEB);
  Color getPrimaryColor() => const Color(0xFF4A90C2);
  Color getWarningColor() => const Color(0xFFFF6B6B);

  @override
  void onClose() {
    mainController.dispose();
    pulseController.dispose();
    swipeHintController.dispose();
    print('🧹 OutroController disposed');
    super.onClose();
  }
}