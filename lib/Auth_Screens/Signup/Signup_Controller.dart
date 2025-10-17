import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/Auth_Screens/Login/Login_Ui.dart';
import 'package:get/get.dart';

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
  var isCheckingEmail = false.obs;

  // Animation controllers
  AnimationController? animationController;
  AnimationController? formController;

  // Animations - with safe defaults
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<double> formSlideAnimation;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _startAnimations();
    _setupEmailListener();
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
      fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController!,
          curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
        ),
      );

      scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController!,
          curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
        ),
      );

      slideAnimation =
          Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
            CurvedAnimation(
              parent: animationController!,
              curve: const Interval(0.3, 0.9, curve: Curves.easeOutCubic),
            ),
          );

      formSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
        CurvedAnimation(parent: formController!, curve: Curves.easeOutCubic),
      );
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

  void _setupEmailListener() {
    // Add listener to email field to check for existing accounts
    emailController.addListener(() {
      if (emailController.text.isNotEmpty &&
          GetUtils.isEmail(emailController.text)) {
        _debounceEmailCheck();
      }
    });
  }

  Timer? _emailCheckTimer;

  void _debounceEmailCheck() {
    _emailCheckTimer?.cancel();
    _emailCheckTimer = Timer(const Duration(milliseconds: 800), () {
      // We'll check for existing email during actual signup process instead
      // since fetchSignInMethodsForEmail is deprecated in newer Firebase versions
    });
  }

  // Enhanced validation methods
  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'First name is required';
    }
    if (value.trim().length < 2) {
      return 'First name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'First name can only contain letters';
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Last name is required';
    }
    if (value.trim().length < 2) {
      return 'Last name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Last name can only contain letters';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
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
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value.trim())) {
      return 'Please enter a valid email format';
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

  // Simplified snackbar methods using only GetX for reliability
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

  void _showInfoSnackbar(String title, String message) {
    print('INFO: $title - $message');

    Get.snackbar(
      title,
      message,
      backgroundColor: const Color(0xFF06B6D4),
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

  // Enhanced Firebase Auth methods with better error handling and user feedback
  Future<void> signUp() async {
    print('\n========= SIGNUP PROCESS STARTED =========');

    // Prevent multiple simultaneous signup attempts
    if (isLoading.value) {
      print('Already processing signup, ignoring request');
      _showWarningSnackbar(
        'Please Wait',
        'Account creation is already in progress...',
      );
      return;
    }

    // Validate form first
    print('Validating form...');
    if (!formKey.currentState!.validate()) {
      print('Form validation failed');
      _showErrorSnackbar(
        'Validation Error',
        'Please fix the errors in the form and try again',
      );
      return;
    }

    // Get trimmed values
    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text.trim();
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final phone = phoneController.text.trim();

    // Final validation check
    if (email.isEmpty ||
        password.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        phone.isEmpty) {
      _showErrorSnackbar('Empty Fields', 'Please fill in all required fields');
      return;
    }

    print('Form data validated successfully');
    print('  Email: $email');
    print('  Password: ${password.length} characters');
    print('  Name: $firstName $lastName');
    print('  Phone: $phone');

    isLoading.value = true;
    _showLoadingSnackbar('Creating your account...');

    try {
      print('Creating Firebase Auth account...');

      // Create user with Firebase Auth
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Firebase Auth account created successfully!');

      if (result.user != null) {
        final User user = result.user!;
        print('User UID: ${user.uid}');

        // Update user profile with display name
        print('Updating user profile...');
        await user.updateDisplayName('$firstName $lastName');

        // Reload user to get updated profile
        await user.reload();
        print('User profile updated successfully');

        // Store additional user data in Firebase Realtime Database
        print('Storing user data in database...');
        await _storeUserDataInRealtimeDB(user, firstName, lastName, phone);
        print('User data stored successfully');

        // Show success message
        print('Showing success message...');
        _showSuccessSnackbar(
          'Account Created Successfully!',
          'Welcome $firstName! Your account is ready to use.',
        );

        // Clear form
        print('Clearing form...');
        _clearForm();

        // Navigate to login screen after delay
        print('Preparing to navigate to login...');
        await Future.delayed(const Duration(seconds: 2));

        if (Get.isRegistered<SignupController>()) {
          print('Navigating to login screen...');
          Get.offAll(() => LoginScreen());
        }

        print('User created successfully with UID: ${user.uid}');
      } else {
        print('ERROR: User is null after creation');
        _showErrorSnackbar(
          'Account Creation Failed',
          'Something went wrong while creating your account. Please try again.',
        );
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Exception: ${e.code} - ${e.message}');

      String errorMessage;
      String errorTitle;

      switch (e.code) {
        case 'email-already-in-use':
          errorTitle = 'Email Already Registered';
          errorMessage =
          'This email is already associated with an account. Please use a different email or sign in instead.';
          break;
        case 'weak-password':
          errorTitle = 'Password Too Weak';
          errorMessage =
          'Please choose a stronger password with at least 6 characters, one uppercase letter, and one number.';
          break;
        case 'invalid-email':
          errorTitle = 'Invalid Email Address';
          errorMessage =
          'The email address format is not valid. Please enter a valid email address.';
          break;
        case 'operation-not-allowed':
          errorTitle = 'Service Temporarily Unavailable';
          errorMessage =
          'Account creation is temporarily disabled. Please try again later or contact support.';
          break;
        case 'network-request-failed':
          errorTitle = 'Network Connection Failed';
          errorMessage = 'Please check your internet connection and try again.';
          break;
        case 'too-many-requests':
          errorTitle = 'Too Many Attempts';
          errorMessage =
          'Too many signup attempts. Please wait a few minutes before trying again.';
          break;
        default:
          errorTitle = 'Account Creation Failed';
          errorMessage =
          'Unable to create account: ${e.message ?? "Unknown error occurred"}. Please try again.';
          break;
      }

      _showErrorSnackbar(errorTitle, errorMessage);
    } catch (e) {
      print('Unexpected error during signup: $e');
      _showErrorSnackbar(
        'Unexpected Error',
        'Something unexpected happened. Please check your internet connection and try again.',
      );
    } finally {
      print('Setting isLoading to false');
      isLoading.value = false;
      print('========= SIGNUP PROCESS COMPLETED =========\n');
    }
  }

  // Store user data in Firebase Realtime Database
  Future<void> _storeUserDataInRealtimeDB(
      User user,
      String firstName,
      String lastName,
      String phone,
      ) async {
    try {
      print('Creating database reference for user: ${user.uid}');

      final DatabaseReference userRef = _database.ref().child('users').child(user.uid);

      final Map<String, dynamic> userData = {
        'uid': user.uid,
        'firstName': firstName,
        'lastName': lastName,
        'fullName': '$firstName $lastName',
        'email': user.email,
        'phone': phone,
        'createdAt': ServerValue.timestamp,
        'lastLogin': ServerValue.timestamp,
        'isEmailVerified': true,
        'profilePicture': '',
        'isActive': true,
        'accountType': 'user',
        'signupMethod': 'email_password',
        'appVersion': '1.0.0',
      };

      print('Setting user data in /users/${user.uid}...');
      await userRef.set(userData);

      print('Creating user profile in /user_profiles/${user.uid}...');
      await _database.ref().child('user_profiles').child(user.uid).set({
        'fullName': '$firstName $lastName',
        'email': user.email,
        'isActive': true,
        'lastSeen': ServerValue.timestamp,
        'joinedDate': ServerValue.timestamp,
      });

      print('User data stored successfully in Realtime Database');
    } catch (e) {
      print('Error storing user data in Realtime Database: $e');
      _showWarningSnackbar(
        'Profile Data Warning',
        'Your account was created successfully, but some profile information might not have been saved. You can update it later in settings.',
      );
    }
  }

  // Clear form after successful signup
  void _clearForm() {
    print('Clearing all form fields...');
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    isPasswordVisible.value = false;
    isConfirmPasswordVisible.value = false;
    formKey.currentState?.reset();
    print('Form cleared successfully');
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void navigateToLogin() {
    try {
      print('Navigating to Login Screen...');
      _showInfoSnackbar('Redirecting', 'Taking you to the sign in page...');

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

  // Method to check current user status
  bool get isUserSignedIn => _auth.currentUser != null;

  // Method to get current user
  User? get currentUser => _auth.currentUser;

  @override
  void onClose() {
    print('Disposing SignupController resources...');

    // Cancel timer
    _emailCheckTimer?.cancel();

    // Dispose animation controllers safely
    animationController?.dispose();
    formController?.dispose();

    // Dispose text controllers
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    print('SignupController disposed successfully');
    super.onClose();
  }
}