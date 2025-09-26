import 'package:flutter/material.dart';
import 'package:fyp_project/Auth_Screens/Login/Login_Ui.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class SignupController extends GetxController with GetTickerProviderStateMixin {
  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Reactive variables
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var acceptTerms = false.obs;

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
  String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'First name is required';
    }
    if (value.length < 2) {
      return 'First name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'First name can only contain letters';
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Last name is required';
    }
    if (value.length < 2) {
      return 'Last name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Last name can only contain letters';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Remove any spaces, dashes, or parentheses
    String cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (cleanPhone.length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    if (!RegExp(r'^[0-9+]+$').hasMatch(cleanPhone)) {
      return 'Phone number can only contain numbers and +';
    }
    return null;
  }

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

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter (A-Z)';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number (0-9)';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
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
  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) {
      _showErrorSnackbar('Validation Error', 'Please fix the errors in the form');
      return;
    }

    if (!acceptTerms.value) {
      _showErrorSnackbar('Terms Required', 'Please accept the terms and conditions to continue');
      return;
    }

    // Additional email validation for @gmail.com
    if (!emailController.text.toLowerCase().contains('@gmail.com')) {
      _showErrorSnackbar('Invalid Email', 'Only Gmail accounts (@gmail.com) are allowed');
      return;
    }

    isLoading.value = true;

    try {
      // Simulate signup delay for demo
      await Future.delayed(const Duration(seconds: 3));

      // Demo: Simulate email already exists for testing
      // Remove this in production
      if (emailController.text.toLowerCase() == 'test@gmail.com') {
        throw Exception('email-already-in-use');
      }

      // Firebase Auth code (commented out)
      /*
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (result.user != null) {
        // Update user profile with name
        await result.user!.updateDisplayName('${firstNameController.text} ${lastNameController.text}');

        // Store additional user data in Firestore
        await _storeUserData(result.user!);

        // Show success message
        _showSuccessSnackbar('Success', 'Account created successfully! Welcome aboard!');

        // Navigate to home screen or email verification
        Get.offAllNamed('/home');
      }
      */

      // Demo success
      _showSuccessSnackbar('Account Created', 'Welcome aboard! Your account has been created successfully');

    } on Exception catch (e) {
      String errorMessage = e.toString().replaceAll('Exception: ', '');

      // Handle specific Firebase Auth errors
      if (errorMessage.contains('email-already-in-use')) {
        _showErrorSnackbar('Email Already Exists', 'An account with this email already exists. Please use a different email or sign in instead');
      } else if (errorMessage.contains('weak-password')) {
        _showErrorSnackbar('Weak Password', 'The password provided is too weak. Please choose a stronger password');
      } else if (errorMessage.contains('invalid-email')) {
        _showErrorSnackbar('Invalid Email', 'The email address is not valid. Please check and try again');
      } else if (errorMessage.contains('operation-not-allowed')) {
        _showErrorSnackbar('Service Unavailable', 'Email/password accounts are not enabled. Please contact support');
      } else if (errorMessage.contains('network-request-failed')) {
        _showErrorSnackbar('Network Error', 'Please check your internet connection and try again');
      } else {
        _showErrorSnackbar('Signup Failed', errorMessage);
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
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'fullName': '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
        'email': user.email,
        'phone': phoneController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'isEmailVerified': user.emailVerified,
      });
    } catch (e) {
      print('Error storing user data: $e');
    }
  }
  */

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void toggleAcceptTerms() {
    acceptTerms.value = !acceptTerms.value;
  }

  void navigateToLogin() {
    Get.off(() => LoginScreen());

    _showInfoSnackbar('Navigation', 'Redirecting to Login Screen...');
  }

  void navigateToTerms() {
    _showInfoSnackbar('Navigation', 'Opening Terms and Conditions...');
  }

  void navigateToPrivacyPolicy() {
    _showInfoSnackbar('Navigation', 'Opening Privacy Policy...');
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    animationController.dispose();
    formController.dispose();
    super.onClose();
  }
}