import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../HomeScreen/SafetyMonitoring_ui.dart';

class IntroController extends GetxController with GetTickerProviderStateMixin {
  // Animation Controllers
  late AnimationController mainController;
  late AnimationController pulseController;
  late AnimationController waveController;
  late AnimationController swipeHintController;

  // Main Animations
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<double> rotateAnimation;

  // Feature Card Animations
  late Animation<double> card1Animation;
  late Animation<double> card2Animation;
  late Animation<double> card3Animation;
  late Animation<double> card4Animation;

  // Pulse Animation for IoT indicator
  late Animation<double> pulseAnimation;

  // Wave Animation for background
  late Animation<double> waveAnimation;

  // Swipe hint animation
  late Animation<double> swipeHintAnimation;

  // Swipe state
  var swipeProgress = 0.0.obs;
  var isSwipeComplete = false.obs;
  var showSwipeHint = true.obs;

  // Feature data
  final List<Map<String, dynamic>> features = [
    {
      'icon': Icons.sensors_rounded,
      'title': 'IoT Sensors',
      'description': 'Real-time monitoring with ESP32 sensors',
      'color': const Color(0xFF4A90C2),
    },
    {
      'icon': Icons.location_on_rounded,
      'title': 'Proximity Alerts',
      'description': 'Instant notifications for distance warnings',
      'color': const Color(0xFFFF6B6B),
    },
    {
      'icon': Icons.volume_up_rounded,
      'title': 'Sound Detection',
      'description': 'Hazardous sound level monitoring',
      'color': const Color(0xFFFFA500),
    },
    {
      'icon': Icons.notifications_active_rounded,
      'title': 'Smart Alerts',
      'description': 'Push notifications to keep you informed',
      'color': const Color(0xFF059669),
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Main animation controller (3 seconds)
    mainController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Pulse animation controller (continuous)
    pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Wave animation controller (continuous)
    waveController = AnimationController(
      duration: const Duration(milliseconds: 4000),
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
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    // Scale animation
    scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: mainController,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
    ));

    // Slide animation
    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: mainController,
      curve: const Interval(0.1, 0.6, curve: Curves.easeOutCubic),
    ));

    // Rotate animation for IoT icon
    rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: pulseController,
      curve: Curves.linear,
    ));

    // Feature card staggered animations
    card1Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: mainController,
      curve: const Interval(0.3, 0.6, curve: Curves.easeOutBack),
    ));

    card2Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: mainController,
      curve: const Interval(0.4, 0.7, curve: Curves.easeOutBack),
    ));

    card3Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: mainController,
      curve: const Interval(0.5, 0.8, curve: Curves.easeOutBack),
    ));

    card4Animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: mainController,
      curve: const Interval(0.6, 0.9, curve: Curves.easeOutBack),
    ));

    // Pulse animation
    pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: pulseController,
      curve: Curves.easeInOut,
    ));

    // Wave animation
    waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: waveController,
      curve: Curves.linear,
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
    waveController.repeat();
    swipeHintController.repeat(reverse: true);
  }

  Animation<double> getCardAnimation(int index) {
    switch (index) {
      case 0:
        return card1Animation;
      case 1:
        return card2Animation;
      case 2:
        return card3Animation;
      case 3:
        return card4Animation;
      default:
        return card1Animation;
    }
  }

  // Handle swipe progress
  void updateSwipeProgress(double progress) {
    swipeProgress.value = progress.clamp(0.0, 1.0);
    showSwipeHint.value = false;

    if (progress >= 0.85 && !isSwipeComplete.value) {
      isSwipeComplete.value = true;
      _navigateToHome();
    }
  }

  void resetSwipe() {
    if (!isSwipeComplete.value) {
      swipeProgress.value = 0.0;
      showSwipeHint.value = true;
    }
  }

  void _navigateToHome() {
    // Haptic feedback
    Get.snackbar(
      'Welcome!',
      'Your child safety monitoring is now active',
      backgroundColor: const Color(0xFF059669).withOpacity(0.9),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      Get.off(() => const ChildSafetyMonitoringScreen());
    });
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

  List<Color> getSwipeButtonGradient() {
    return [
      const Color(0xFF4A90C2),
      const Color(0xFF87CEEB),
    ];
  }

  List<Color> getCardGradient() {
    return [
      const Color(0xFF87CEEB).withOpacity(0.15),
      const Color(0xFF4169E1).withOpacity(0.08),
    ];
  }

  Color getAccentColor() => const Color(0xFF87CEEB);
  Color getPrimaryColor() => const Color(0xFF4A90C2);

  @override
  void onClose() {
    mainController.dispose();
    pulseController.dispose();
    waveController.dispose();
    swipeHintController.dispose();
    super.onClose();
  }
}