import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/Auth_Screens/Signup/Signup_Ui.dart';
import 'package:get/get.dart';

import '../Login/Login_Ui.dart';

class ForgotPasswordController extends GetxController with GetTickerProviderStateMixin {
  // Controllers
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Reactive variables
  var isLoading = false.obs;
  var emailSent = false.obs;
  var countdown = 0.obs;

  // Animation controllers - nullable to handle initialization properly
  AnimationController? animationController;
  AnimationController? formController;

  // Animations - with safe defaults
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<double> formSlideAnimation;

  // Firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    try {
      // Dispose existing controllers if they exist
      animationController?.dispose();
      formController?.dispose();

      // Main animation controller
      animationController = AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this,
      );

      // Form animation controller
      formController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );

      // Initialize animations with safe defaults
      fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ));

      scaleAnimation = Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ));

      slideAnimation = Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.3, 0.9, curve: Curves.easeOutCubic),
      ));

      formSlideAnimation = Tween<double>(
        begin: 50.0,
        end: 0.0,
      ).animate(CurvedAnimation(
        parent: formController!,
        curve: Curves.easeOutCubic,
      ));

    } catch (e) {
      print('Error initializing animations: $e');
      // Create dummy controllers and animations as fallbacks
      _createFallbackAnimations();
    }
  }

  void _createFallbackAnimations() {
    // Create minimal animation controllers for fallback
    animationController ??= AnimationController(
      duration: Duration.zero,
      vsync: this,
    );
    formController ??= AnimationController(
      duration: Duration.zero,
      vsync: this,
    );

    // Create static animations
    fadeAnimation = AlwaysStoppedAnimation(1.0);
    scaleAnimation = AlwaysStoppedAnimation(1.0);
    slideAnimation = AlwaysStoppedAnimation(Offset.zero);
    formSlideAnimation = AlwaysStoppedAnimation(0.0);
  }

  void _startAnimations() {
    try {
      animationController?.forward();

      // Start form animation after a delay
      Future.delayed(const Duration(milliseconds: 500), () {
        formController?.forward();
      });
    } catch (e) {
      print('Error starting animations: $e');
    }
  }

  // Color scheme matching the beautiful blue gradient UI
  List<Color> getBackgroundGradientColors() {
    return [
      const Color(0xFF0F2A4A), // Deep navy blue
      const Color(0xFF1E4A6B), // Medium blue
      const Color(0xFF2D6A9A), // Sky blue
      const Color(0xFF4A90C2), // Light sky blue
    ];
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

  Color getPrimaryButtonColor() => const Color(0xFF4A90C2);
  Color getSecondaryButtonColor() => const Color(0xFF87CEEB);
  Color getActiveIndicatorColor() => const Color(0xFF87CEEB);

  TextStyle getTitleTextStyle() {
    return const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w900,
      color: Colors.white,
      letterSpacing: 2.0,
      shadows: [
        Shadow(
          offset: Offset(2, 2),
          blurRadius: 8,
          color: Color(0xFF4A90C2),
        ),
      ],
    );
  }

  TextStyle getSubtitleTextStyle() {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white.withOpacity(0.8),
      letterSpacing: 1.0,
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

  TextStyle getLinkTextStyle() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF06B6D4),
      letterSpacing: 0.5,
    );
  }

  TextStyle getBodyTextStyle() {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white.withOpacity(0.7),
      height: 1.5,
    );
  }

  // Validation methods
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value.trim())) {
      return 'Please enter a valid email format';
    }
    return null;
  }

  // Simplified snackbar methods using only GetX for consistency
  void _showSuccessSnackbar(String title, String message) {
    print('SUCCESS: $title - $message');

    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.transparent,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      shouldIconPulse: true,
      forwardAnimationCurve: Curves.elasticOut,
      reverseAnimationCurve: Curves.easeOut,
    );
  }

  void _showErrorSnackbar(String title, String message) {
    print('ERROR: $title - $message');

    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.transparent,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.error, color: Colors.white),
      shouldIconPulse: true,
      forwardAnimationCurve: Curves.elasticOut,
      reverseAnimationCurve: Curves.easeOut,
    );
  }

  void _showInfoSnackbar(String title, String message) {
    print('INFO: $title - $message');

    Get.snackbar(
      title,
      message,
      backgroundColor: getActiveIndicatorColor(),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.info, color: Colors.white),
      shouldIconPulse: true,
      forwardAnimationCurve: Curves.elasticOut,
      reverseAnimationCurve: Curves.easeOut,
    );
  }

  void _showWarningSnackbar(String title, String message) {
    print('WARNING: $title - $message');

    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.transparent,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.warning, color: Colors.white),
      shouldIconPulse: true,
      forwardAnimationCurve: Curves.elasticOut,
      reverseAnimationCurve: Curves.easeOut,
    );
  }

  void _showLoadingSnackbar(String message) {
    print('LOADING: $message');

    Get.snackbar(
      'Processing',
      message,
      backgroundColor: Colors.transparent,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
      showProgressIndicator: false,
      forwardAnimationCurve: Curves.elasticOut,
      reverseAnimationCurve: Curves.easeOut,
    );
  }

  // Enhanced Firebase Auth methods
  Future<void> sendPasswordResetEmail() async {
    print('\n========= PASSWORD RESET PROCESS STARTED =========');

    // Prevent multiple simultaneous attempts
    if (isLoading.value) {
      print('Already processing password reset, ignoring request');
      _showWarningSnackbar('Please Wait', 'Password reset is already in progress...');
      return;
    }

    // Validate form first
    print('Validating form...');
    if (!formKey.currentState!.validate()) {
      print('Form validation failed');
      _showErrorSnackbar('Validation Error', 'Please enter a valid email address');
      return;
    }

    // Get email and trim whitespace
    final email = emailController.text.trim().toLowerCase();

    // Check if email is empty after trimming
    if (email.isEmpty) {
      _showErrorSnackbar('Empty Email', 'Please enter your email address');
      return;
    }

    print('Form data validated successfully');
    print('  Email: $email');

    isLoading.value = true;
    _showLoadingSnackbar('Sending password reset email...');

    try {
      print('Sending password reset email via Firebase Auth...');

      // Send password reset email using Firebase Auth
      await _auth.sendPasswordResetEmail(email: email);

      print('Password reset email sent successfully!');

      // Mark email as sent and start countdown
      emailSent.value = true;
      _startCountdown();

      // Show success message
      _showSuccessSnackbar(
          'Email Sent Successfully',
          'Password reset instructions have been sent to $email. Please check your inbox and spam folder.'
      );

      print('Password reset email sent successfully to: $email');

    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Exception: ${e.code} - ${e.message}');

      // Handle specific Firebase Auth errors
      String errorMessage;
      String errorTitle;

      switch (e.code) {
        case 'user-not-found':
          errorTitle = 'Account Not Found';
          errorMessage = 'No account found with this email address. Please check your email or create a new account.';
          break;
        case 'invalid-email':
          errorTitle = 'Invalid Email';
          errorMessage = 'The email address format is invalid. Please enter a valid email address.';
          break;
        case 'too-many-requests':
          errorTitle = 'Too Many Attempts';
          errorMessage = 'Too many password reset requests. Please wait a few minutes before trying again.';
          break;
        case 'network-request-failed':
          errorTitle = 'Network Error';
          errorMessage = 'Network connection failed. Please check your internet connection and try again.';
          break;
        case 'user-disabled':
          errorTitle = 'Account Disabled';
          errorMessage = 'This account has been disabled. Please contact support for assistance.';
          break;
        default:
          errorTitle = 'Reset Failed';
          errorMessage = 'Failed to send password reset email: ${e.message ?? "Unknown error occurred"}. Please try again.';
          break;
      }

      _showErrorSnackbar(errorTitle, errorMessage);

    } catch (e) {
      print('Unexpected error during password reset: $e');
      _showErrorSnackbar(
          'Unexpected Error',
          'Something unexpected happened. Please check your internet connection and try again.'
      );
    } finally {
      print('Setting isLoading to false');
      isLoading.value = false;
      print('========= PASSWORD RESET PROCESS COMPLETED =========\n');
    }
  }

  void _startCountdown() {
    countdown.value = 60; // 60 seconds countdown

    void decrementTimer() {
      if (countdown.value > 0) {
        countdown.value--;
        Future.delayed(const Duration(seconds: 1), decrementTimer);
      }
    }

    decrementTimer();
  }

  void resendEmail() {
    if (countdown.value == 0) {
      emailSent.value = false; // Reset email sent status
      sendPasswordResetEmail();
    } else {
      _showInfoSnackbar(
          'Please Wait',
          'You can resend the email in ${countdown.value} seconds'
      );
    }
  }

  void navigateToLogin() {
    try {
      print('Navigating to Login Screen...');
      _showInfoSnackbar('Redirecting', 'Taking you back to sign in...');

      // Small delay for smooth transition
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.off(() => LoginScreen());
      });
    } catch (e) {
      print('Navigation error to Login: $e');
      // Fallback navigation
      Get.offAll(() => LoginScreen());
    }
  }

  void navigateToSignup() {
    try {
      print('Navigating to Signup Screen...');
      _showInfoSnackbar('Redirecting', 'Taking you to the sign up page...');

      // Small delay for smooth transition
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.off(() => SignupScreen());
      });
    } catch (e) {
      print('Navigation error to Signup: $e');
      // Fallback navigation
      Get.offAll(() => SignupScreen());
    }
  }

  // Method to clear form and reset state
  void resetForm() {
    print('Resetting form and state...');
    emailController.clear();
    emailSent.value = false;
    countdown.value = 0;
    isLoading.value = false;
    formKey.currentState?.reset();
    print('Form and state reset successfully');
  }

  // Method to check if user is currently signed in
  bool get isUserSignedIn => _auth.currentUser != null;

  // Method to get current user email
  String? get currentUserEmail => _auth.currentUser?.email;

  @override
  void onClose() {
    print('Disposing ForgotPasswordController resources...');

    // Dispose animation controllers safely
    animationController?.dispose();
    formController?.dispose();

    // Dispose text controller
    emailController.dispose();

    print('ForgotPasswordController disposed successfully');
    super.onClose();
  }
}