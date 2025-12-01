import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../IntroScreen/IntroScreen.dart';
import '../Services/Auth_Service.dart';
import '../Onboarding_screens/Onboarding_Ui.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  // Animation Controllers
  late AnimationController animationController;
  late AnimationController backgroundController;
  late AnimationController textController;

  // Main Animations
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  // Background Animations
  late Animation<double> backgroundPulseAnimation;

  // Text Animations
  late Animation<double> textBounceAnimation;
  late Animation<double> textShimmerAnimation;

  // Loading Dots Animation
  late Animation<double> dotsAnimation;

  // Subtitle Animation
  late Animation<double> subtitleFadeAnimation;
  late Animation<Offset> subtitleSlideAnimation;

  // Auth Service
  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Main Animation Controller (3 seconds)
    animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Background Animation Controller (continuous loop)
    backgroundController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    // Text Animation Controller (2 seconds, repeating)
    textController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Initialize Main Animations
    scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
    ));

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.3, 0.9, curve: Curves.bounceOut),
    ));

    // Background Pulse Animation
    backgroundPulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: backgroundController,
      curve: Curves.easeInOut,
    ));

    // Text Animations
    textBounceAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: textController,
      curve: Curves.elasticInOut,
    ));

    textShimmerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: textController,
      curve: Curves.linear,
    ));

    // Loading Dots Animation
    dotsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
    ));

    // Subtitle Animations
    subtitleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
    ));

    subtitleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
    ));
  }

  void _startAnimations() {
    // Start auto-login check immediately (parallel to animations)
    _checkAutoLogin();

    // Start main animation
    animationController.forward();

    // Start repeating animations
    backgroundController.repeat(reverse: true);
    textController.repeat();
  }

  // Check if user is already logged in
  Future<void> _checkAutoLogin() async {
    try {
      print('Starting auto-login check...');

      // Check if user is logged in (runs parallel to animations)
      final isLoggedIn = await _authService.isUserLoggedIn();

      print('Auto-login check result: $isLoggedIn');

      // Wait for animation to complete before navigating
      await animationController.forward();

      // Small delay for smooth transition
      await Future.delayed(const Duration(milliseconds: 500));

      if (isLoggedIn) {
        // *** UPDATED: Navigate to IntroScreen instead of SafetyMonitoring ***
        print('User is logged in, navigating to intro screen...');
        Get.off(() => const IntroScreen());
      } else {
        print('User is not logged in, navigating to onboarding...');
        Get.off(() => const OnboardingScreen());
      }
    } catch (e) {
      print('Error in auto-login check: $e');
      // Wait for animation even on error
      await animationController.forward();
      await Future.delayed(const Duration(milliseconds: 500));
      Get.off(() => const OnboardingScreen());
    }
  }

  // Gradient Colors for Text Background
  List<Color> getTextBackgroundGradientColors() {
    return [
      const Color(0xFF87CEEB).withOpacity(0.3), // Sky blue
      const Color(0xFF4169E1).withOpacity(0.2), // Royal blue
      const Color(0xFF00BFFF).withOpacity(0.3), // Deep sky blue
    ];
  }

  // Gradient Colors for Text Shimmer Effect
  List<Color> getTextShimmerColors() {
    return [
      Colors.white,
      const Color(0xFF87CEEB), // Sky blue
      const Color(0xFF4169E1), // Royal blue
      Colors.white,
      const Color(0xFF00BFFF), // Deep sky blue
      Colors.white,
      const Color(0xFF87CEEB),
    ];
  }

  // Shimmer Gradient Stops
  List<double> getShimmerStops() {
    return [
      0.0,
      textShimmerAnimation.value * 0.15,
      textShimmerAnimation.value * 0.35,
      textShimmerAnimation.value * 0.5,
      textShimmerAnimation.value * 0.75,
      textShimmerAnimation.value * 0.9,
      1.0,
    ];
  }

  // Background Circle Data
  List<Map<String, dynamic>> getBackgroundCircles(Size size) {
    return [
      {'x': size.width * 0.1, 'y': size.height * 0.2, 'radius': 30.0, 'color': const Color(0xFF87CEEB)},
      {'x': size.width * 0.8, 'y': size.height * 0.3, 'radius': 20.0, 'color': const Color(0xFF4169E1)},
      {'x': size.width * 0.3, 'y': size.height * 0.7, 'radius': 25.0, 'color': const Color(0xFF00BFFF)},
      {'x': size.width * 0.9, 'y': size.height * 0.8, 'radius': 15.0, 'color': const Color(0xFF87CEEB)},
      {'x': size.width * 0.2, 'y': size.height * 0.5, 'radius': 35.0, 'color': const Color(0xFF4169E1)},
      {'x': size.width * 0.7, 'y': size.height * 0.6, 'radius': 18.0, 'color': const Color(0xFF00BFFF)},
    ];
  }

  // Sparkle Colors for Background
  List<Color> getSparkleColors() {
    return [
      const Color(0xFF87CEEB),
      const Color(0xFF4169E1),
      const Color(0xFF00BFFF),
      Colors.white,
    ];
  }

  // Loading Dots Colors
  List<Color> getLoadingDotColors() {
    return [
      const Color(0xFF87CEEB),
      const Color(0xFF4169E1),
      const Color(0xFF00BFFF),
    ];
  }

  // Calculate Loading Dot Scale
  double getLoadingDotScale(int index) {
    final delay = index * 0.3;
    final animationValue = (backgroundController.value + delay) % 1.0;
    return 0.6 + (0.8 * (1 - (animationValue - 0.5).abs() * 2).clamp(0.0, 1.0));
  }

  // Get Text Shadow List
  List<Shadow> getTextShadows() {
    return [
      Shadow(
        offset: const Offset(0, 2),
        blurRadius: 10,
        color: Colors.black.withOpacity(0.3),
      ),
      Shadow(
        offset: const Offset(0, 4),
        blurRadius: 20,
        color: const Color(0xFF4169E1).withOpacity(0.4),
      ),
      Shadow(
        offset: const Offset(2, 2),
        blurRadius: 15,
        color: const Color(0xFF87CEEB).withOpacity(0.6),
      ),
      Shadow(
        offset: const Offset(-1, -1),
        blurRadius: 8,
        color: const Color(0xFF00BFFF).withOpacity(0.3),
      ),
    ];
  }

  // Get Background Gradient Colors
  List<Color> getBackgroundGradientColors() {
    return [
      const Color(0xFF0F2A4A), // Deep navy blue
      const Color(0xFF1E4A6B), // Medium blue
      const Color(0xFF2D6A9A), // Sky blue
      const Color(0xFF4A90C2), // Light sky blue
    ];
  }

  // Get Subtitle Gradient Colors
  List<Color> getSubtitleGradientColors() {
    return [
      const Color(0xFF87CEEB).withOpacity(0.2),
      const Color(0xFF4169E1).withOpacity(0.1),
    ];
  }

  @override
  void onClose() {
    animationController.dispose();
    backgroundController.dispose();
    textController.dispose();
    super.onClose();
  }
}