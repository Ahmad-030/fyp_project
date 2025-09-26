import 'package:flutter/material.dart';
import 'package:fyp_project/Auth_Screens/Login/Login_Ui.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController with GetTickerProviderStateMixin {
  // Page Controller
  late PageController pageController;

  // Animation Controllers
  late AnimationController fadeController;
  late AnimationController slideController;
  late AnimationController dotsController;

  // Animations
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<double> scaleAnimation;

  // Observable variables
  var currentPage = 0.obs;
  var isLastPage = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeControllers() {
    pageController = PageController();

    fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    dotsController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  void _initializeAnimations() {
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeInOut,
    ));

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: slideController,
      curve: Curves.elasticOut,
    ));

    scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: fadeController,
      curve: Curves.elasticOut,
    ));
  }

  void _startAnimations() {
    fadeController.forward();
    slideController.forward();
    dotsController.forward();
  }

  // Onboarding data
  List<OnboardingData> getOnboardingData() {
    return [
      OnboardingData(
        image: 'assets/images/onboardinga.jpg', // Replace with your image
        title: 'Welcome to the Future',
        description: 'Discover amazing features that will transform your daily experience with cutting-edge technology.',
      ),
      OnboardingData(
        image: 'assets/images/onboarding.jpg', // Replace with your image
        title: 'Smart & Intuitive',
        description: 'Experience seamless interaction with our intelligent interface designed for modern users.',
      ),
      OnboardingData(
        image: 'assets/images/onboardinga.jpg', // Replace with your image
        title: 'Get Started Today',
        description: 'Join millions of users who have already transformed their workflow with our innovative solutions.',
      ),
    ];
  }

  // Navigation methods
  void nextPage() {
    if (currentPage.value < 2) {
      currentPage.value++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _restartAnimations();
    } else {
      // Navigate to home or login screen
      Get.off(() => LoginScreen());// Replace with your route
    }
    _updateLastPageStatus();
  }

  void skipPages() {
    // Skip to the last page instead of exiting
    if (currentPage.value < 2) {
      currentPage.value = 2; // Go to last page (index 2)
      isLastPage.value = true; // Update the last page status

      pageController.animateToPage(
        2, // Last page index
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      _restartAnimations();
    } else {
      // If already on last page, go to home
      Get.off(() => LoginScreen()); // Replace with your route
    }
  }

  void goToPage(int index) {
    currentPage.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _restartAnimations();
    _updateLastPageStatus();
  }

  void _updateLastPageStatus() {
    isLastPage.value = currentPage.value == 2;
  }

  void _restartAnimations() {
    fadeController.reset();
    slideController.reset();
    fadeController.forward();
    slideController.forward();
  }

  // Color scheme methods
  List<Color> getBackgroundGradientColors() {
    return [
      const Color(0xFF0F2A4A), // Deep navy blue
      const Color(0xFF1E4A6B), // Medium blue
      const Color(0xFF2D6A9A), // Sky blue
      const Color(0xFF4A90C2), // Light sky blue
    ];
  }

  Color getPrimaryButtonColor() {
    return const Color(0xFF4A90C2);
  }

  Color getSecondaryButtonColor() {
    return const Color(0xFF87CEEB);
  }

  Color getActiveIndicatorColor() {
    return const Color(0xFF87CEEB);
  }

  Color getInactiveIndicatorColor() {
    return const Color(0xFF4169E1).withOpacity(0.3);
  }

  List<Color> getButtonGradientColors() {
    return [
      const Color(0xFF4A90C2),
      const Color(0xFF87CEEB),
    ];
  }

  List<Color> getCardGradientColors() {
    return [
      const Color(0xFF87CEEB).withOpacity(0.1),
      const Color(0xFF4169E1).withOpacity(0.05),
    ];
  }

  // Text styles
  TextStyle getTitleTextStyle() {
    return const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: 1.2,
      shadows: [
        Shadow(
          offset: Offset(0, 2),
          blurRadius: 8,
          color: Color(0xFF4169E1),
        ),
      ],
    );
  }

  TextStyle getDescriptionTextStyle() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white70,
      letterSpacing: 0.5,
      height: 1.5,
    );
  }

  TextStyle getButtonTextStyle() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      letterSpacing: 1.0,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    fadeController.dispose();
    slideController.dispose();
    dotsController.dispose();
    super.onClose();
  }
}

// Data model for onboarding content
class OnboardingData {
  final String image;
  final String title;
  final String description;

  OnboardingData({
    required this.image,
    required this.title,
    required this.description,
  });
}