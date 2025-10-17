import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/Auth_Screens/Forget/Forget_UI.dart';
import 'package:fyp_project/Auth_Screens/Signup/Signup_Ui.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../HomeScreen/SafetyMonitoring_ui.dart';
import 'Login_Ui.dart';

class LoginController extends GetxController with GetTickerProviderStateMixin {
  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Reactive variables
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var rememberMe = false.obs;

  // Animation controllers - nullable to handle initialization properly
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
    _loadRememberedCredentials();
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

  // Load remembered credentials
  Future<void> _loadRememberedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('remembered_email');
      final savedRememberMe = prefs.getBool('remember_me') ?? false;

      if (savedRememberMe && savedEmail != null) {
        emailController.text = savedEmail;
        rememberMe.value = true;
      }
    } catch (e) {
      print('Error loading remembered credentials: $e');
    }
  }

  // Save or clear remembered credentials
  Future<void> _handleRememberMe(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (rememberMe.value) {
        await prefs.setString('remembered_email', email);
        await prefs.setBool('remember_me', true);
      } else {
        await prefs.remove('remembered_email');
        await prefs.setBool('remember_me', false);
      }
    } catch (e) {
      print('Error handling remember me: $e');
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

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
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
      'Signing In',
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

  // Enhanced Firebase Auth login method
  Future<void> login() async {
    print('\n========= LOGIN PROCESS STARTED =========');

    // Prevent multiple simultaneous login attempts
    if (isLoading.value) {
      print('Already processing login, ignoring request');
      _showWarningSnackbar('Please Wait', 'Sign in is already in progress...');
      return;
    }

    // Validate form first
    print('Validating form...');
    if (!formKey.currentState!.validate()) {
      print('Form validation failed');
      _showErrorSnackbar('Validation Error', 'Please fix the errors in the form');
      return;
    }

    // Get trimmed values
    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text.trim();

    // Check if fields are empty after trimming
    if (email.isEmpty || password.isEmpty) {
      _showErrorSnackbar('Empty Fields', 'Please enter both email and password');
      return;
    }

    print('Form data validated successfully');
    print('  Email: $email');
    print('  Password: ${password.length} characters');

    isLoading.value = true;
    _showLoadingSnackbar('Signing you in...');

    try {
      print('Attempting Firebase Auth sign in...');

      // Sign in with Firebase Auth
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Firebase Auth sign in successful!');

      if (result.user != null) {
        final User user = result.user!;
        print('User UID: ${user.uid}');

        // Reload user to get latest data
        await user.reload();
        print('User reloaded successfully');

        print('Updating user data...');

        // Update user data in Firebase Realtime Database
        await _updateUserLoginData(user);

        // Handle remember me functionality
        await _handleRememberMe(email);

        // Get user profile data
        final userProfile = await _getUserProfile(user.uid);
        final userName = userProfile['fullName'] ?? userProfile['firstName'] ?? 'User';

        print('Login successful, showing success message...');

        // Show success message
        _showSuccessSnackbar(
            'Welcome Back!',
            'Hello $userName! You have been signed in successfully.'
        );

        // Clear form if not remembering
        if (!rememberMe.value) {
          _clearForm();
        } else {
          passwordController.clear(); // Always clear password
        }

        // Navigate to home screen with improved error handling
        print('Navigating to Safety Monitoring screen...');
        await Future.delayed(const Duration(seconds: 1)); // Reduced delay

        try {
          // Navigate to Safety Monitoring screen
          if (Get.isRegistered<LoginController>()) {
            print('Controller still registered, proceeding with navigation...');
            Get.offAll(() => const ChildSafetyMonitoringScreen());
            print('Navigation to SafetyMonitoringScreen completed successfully');
          } else {
            print('Controller no longer registered, forcing navigation...');
            Get.offAll(() => const ChildSafetyMonitoringScreen());
          }
        } catch (navError) {
          print('Navigation error: $navError');
          // Force navigation as backup
          Get.offAll(() => const ChildSafetyMonitoringScreen());
        }

        print('User logged in successfully: ${user.uid}');
      } else {
        print('ERROR: User is null after authentication');
        _showErrorSnackbar(
          'Authentication Failed',
          'Authentication succeeded but user data is unavailable. Please try again.',
        );
      }

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
        case 'wrong-password':
          errorTitle = 'Invalid Password';
          errorMessage = 'The password you entered is incorrect. Please try again or reset your password.';
          break;
        case 'invalid-email':
          errorTitle = 'Invalid Email';
          errorMessage = 'The email address format is invalid. Please enter a valid email address.';
          break;
        case 'user-disabled':
          errorTitle = 'Account Disabled';
          errorMessage = 'This account has been disabled. Please contact support for assistance.';
          break;
        case 'too-many-requests':
          errorTitle = 'Too Many Attempts';
          errorMessage = 'Too many failed login attempts. Please wait a few minutes before trying again.';
          break;
        case 'network-request-failed':
          errorTitle = 'Network Error';
          errorMessage = 'Network connection failed. Please check your internet connection and try again.';
          break;
        case 'invalid-credential':
          errorTitle = 'Invalid Credentials';
          errorMessage = 'The email or password you entered is incorrect. Please check your credentials and try again.';
          break;
        default:
          errorTitle = 'Sign In Failed';
          errorMessage = 'Unable to sign in: ${e.message ?? "Unknown error occurred"}. Please try again.';
          break;
      }

      _showErrorSnackbar(errorTitle, errorMessage);

    } catch (e) {
      print('Unexpected error during login: $e');
      _showErrorSnackbar(
          'Unexpected Error',
          'Something unexpected happened. Please check your internet connection and try again.'
      );
    } finally {
      print('Setting isLoading to false');
      isLoading.value = false;
      print('========= LOGIN PROCESS COMPLETED =========\n');
    }
  }

  // Update user login data in Firebase Realtime Database
  Future<void> _updateUserLoginData(User user) async {
    try {
      print('Updating user login data in database...');
      final DatabaseReference userRef = _database.ref().child('users').child(user.uid);

      // Update last login time and other login-related data
      await userRef.update({
        'lastLogin': ServerValue.timestamp,
        'isEmailVerified': true,
        'lastLoginDevice': 'mobile',
      });

      // Update user profile last seen
      await _database.ref().child('user_profiles').child(user.uid).update({
        'lastSeen': ServerValue.timestamp,
        'isOnline': true,
      });

      print('User login data updated successfully');

    } catch (e) {
      print('Error updating user login data: $e');
      // Don't throw error here as login was successful
      _showWarningSnackbar(
        'Profile Update Warning',
        'Signed in successfully, but some profile data may not have been updated.',
      );
    }
  }

  // Get user profile data from Realtime Database
  Future<Map<String, dynamic>> _getUserProfile(String uid) async {
    try {
      print('Fetching user profile from database...');
      final DatabaseReference userRef = _database.ref().child('users').child(uid);
      final DatabaseEvent event = await userRef.once();

      if (event.snapshot.exists) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        print('User profile fetched successfully');
        return data;
      }
      print('User profile not found in database');
      return {};
    } catch (e) {
      print('Error getting user profile: $e');
      return {};
    }
  }

  // Method to clear form
  void _clearForm() {
    print('Clearing form fields...');
    emailController.clear();
    passwordController.clear();
    isPasswordVisible.value = false;
    formKey.currentState?.reset();
    print('Form cleared successfully');
  }

  // Sign out method
  Future<void> signOut() async {
    try {
      print('Starting sign out process...');
      final user = _auth.currentUser;

      if (user != null) {
        // Update online status
        await _database.ref().child('user_profiles').child(user.uid).update({
          'isOnline': false,
          'lastSeen': ServerValue.timestamp,
        });
        print('Updated user offline status');
      }

      await _auth.signOut();
      print('Firebase Auth sign out successful');

      // Clear form and navigate to login
      _clearForm();
      rememberMe.value = false;

      // Clear remembered credentials if needed
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_me', false);

      Get.offAll(() => LoginScreen());
      _showInfoSnackbar('Signed Out', 'You have been signed out successfully');

    } catch (e) {
      print('Error signing out: $e');
      _showErrorSnackbar('Sign Out Failed', 'Failed to sign out. Please try again.');
    }
  }

  // Check if user is already signed in
  bool get isUserSignedIn => _auth.currentUser != null;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auto login check
  Future<void> checkAutoLogin() async {
    try {
      print('Checking auto login status...');

      if (isUserSignedIn) {
        final user = currentUser!;
        print('User found: ${user.uid}');

        print('User authenticated, updating login data and navigating to home...');

        // Update login data
        await _updateUserLoginData(user);

        // Navigate to Safety Monitoring screen
        Get.offAll(() => const ChildSafetyMonitoringScreen());
      } else {
        print('No user signed in');
      }
    } catch (e) {
      print('Error in auto login check: $e');
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void navigateToSignUp() {
    try {
      print('Navigating to SignUp Screen...');
      _showInfoSnackbar('Redirecting', 'Taking you to the sign up page...');

      // Small delay for smooth transition
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.off(() => SignupScreen());
      });
    } catch (e) {
      print('Navigation error to SignUp: $e');
      Get.offAll(() => SignupScreen());
    }
  }

  void navigateToForgotPassword() {
    try {
      print('Navigating to Forgot Password Screen...');
      _showInfoSnackbar('Redirecting', 'Taking you to password recovery...');

      // Small delay for smooth transition
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.off(() => ForgotPasswordScreen());
      });
    } catch (e) {
      print('Navigation error to ForgotPassword: $e');
      Get.offAll(() => ForgotPasswordScreen());
    }
  }

  @override
  void onClose() {
    print('Disposing LoginController resources...');

    // Dispose animation controllers safely
    animationController?.dispose();
    formController?.dispose();

    // Dispose text controllers
    emailController.dispose();
    passwordController.dispose();

    print('LoginController disposed successfully');
    super.onClose();
  }
}