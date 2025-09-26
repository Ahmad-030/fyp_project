import 'package:flutter/material.dart';
import 'package:fyp_project/Auth_Screens/Forget/Forget_UI.dart';
import 'package:fyp_project/Auth_Screens/Signup/Signup_Ui.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class LoginController extends GetxController with GetTickerProviderStateMixin {
  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Reactive variables
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var rememberMe = false.obs;

  // Animation controllers
  late AnimationController animationController;
  late AnimationController formController;

  // Animations
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<double> formSlideAnimation;

  // Firebase instances (commented out)
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
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

    // Initialize animations
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
    ));

    scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.3, 0.9, curve: Curves.easeOutCubic),
    ));

    formSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: formController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    animationController.forward();

    // Start form animation after a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      formController.forward();
    });
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

  // Validation methods
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email format';
    }
    if (!value.toLowerCase().contains('@gmail.com')) {
      return 'Only Gmail accounts are allowed';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  // Custom snackbar methods
  void _showSuccessSnackbar(String title, String message) {
    showTopSnackBar(
      Overlay.of(Get.context!),
      CustomSnackBar.success(
        message: message,
        backgroundColor: const Color(0xFF059669),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      displayDuration: const Duration(seconds: 3),
    );
  }

  void _showErrorSnackbar(String title, String message) {
    showTopSnackBar(
      Overlay.of(Get.context!),
      CustomSnackBar.error(
        message: message,
        backgroundColor: const Color(0xFFDC2626),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      displayDuration: const Duration(seconds: 4),
    );
  }

  void _showInfoSnackbar(String title, String message) {
    showTopSnackBar(
      Overlay.of(Get.context!),
      CustomSnackBar.info(
        message: message,
        backgroundColor: getActiveIndicatorColor(),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      displayDuration: const Duration(seconds: 3),
    );
  }

  // Firebase Auth methods (commented out for now)
  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      _showErrorSnackbar('Validation Error', 'Please fix the errors in the form');
      return;
    }

    // Additional email validation for @gmail.com
    if (!emailController.text.toLowerCase().contains('@gmail.com')) {
      _showErrorSnackbar('Invalid Email', 'Only Gmail accounts (@gmail.com) are allowed');
      return;
    }

    isLoading.value = true;

    try {
      // Simulate login delay for demo
      await Future.delayed(const Duration(seconds: 2));

      // Demo: Simulate password mismatch for testing
      // Remove this in production
      if (passwordController.text == 'wrongpassword') {
        throw Exception('Invalid email or password');
      }

      // Firebase Auth code (commented out)
      /*
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (result.user != null) {
        // Store user data in Firestore
        await _storeUserData(result.user!);

        // Show success message
        _showSuccessSnackbar('Success', 'Welcome back! Login successful');

        // Navigate to home screen
        Get.offAllNamed('/home');
      }
      */

      // Demo success
      _showSuccessSnackbar('Login Successful', 'Welcome back! You have been logged in successfully');

    } on Exception catch (e) {
      String errorMessage = e.toString().replaceAll('Exception: ', '');

      // Handle specific Firebase Auth errors
      if (errorMessage.contains('user-not-found')) {
        _showErrorSnackbar('Account Not Found', 'No account found with this email address');
      } else if (errorMessage.contains('wrong-password') ||
          errorMessage.contains('Invalid email or password')) {
        _showErrorSnackbar('Invalid Credentials', 'The email or password you entered is incorrect');
      } else if (errorMessage.contains('user-disabled')) {
        _showErrorSnackbar('Account Disabled', 'This account has been disabled. Please contact support');
      } else if (errorMessage.contains('too-many-requests')) {
        _showErrorSnackbar('Too Many Attempts', 'Too many failed attempts. Please try again later');
      } else if (errorMessage.contains('network-request-failed')) {
        _showErrorSnackbar('Network Error', 'Please check your internet connection and try again');
      } else {
        _showErrorSnackbar('Login Failed', errorMessage);
      }
    } catch (e) {
      _showErrorSnackbar('Unexpected Error', 'Something went wrong. Please try again');
    } finally {
      isLoading.value = false;
    }
  }

  // Store user data in Firestore (commented out)
  /*
  Future<void> _storeUserData(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'lastLogin': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error storing user data: $e');
    }
  }
  */

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void navigateToSignUp() {
    Get.off(() => SignupScreen());
    _showInfoSnackbar('Navigation', 'Redirecting to Sign Up Screen...');
  }

  void navigateToForgotPassword() {
    Get.off(() => ForgotPasswordScreen());
    _showInfoSnackbar('Navigation', 'Redirecting to Forgot Password Screen...');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    animationController.dispose();
    formController.dispose();
    super.onClose();
  }
}