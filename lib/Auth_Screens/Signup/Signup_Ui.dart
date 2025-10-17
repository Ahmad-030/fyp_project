import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Widgets/Custom_Button.dart';
import '../../Widgets/Custom_TextField.dart';
import '../../Theme/app_theme.dart';
import 'Signup_Controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure any existing controller is disposed first
    if (Get.isRegistered<SignupController>()) {
      Get.delete<SignupController>();
    }

    final SignupController controller = Get.put(SignupController(), permanent: false);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppTheme.backgroundGradient,
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  _buildHeader(controller),
                  const SizedBox(height: 40),
                  _buildSignupForm(controller),
                  const SizedBox(height: 30),
                  _buildFooter(controller),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(SignupController controller) {
    return AnimatedBuilder(
      animation: controller.animationController ??
          AnimationController(duration: Duration.zero, vsync: Navigator.of(Get.context!)),
      builder: (context, child) {
        // Safe animation values with fallbacks
        final fadeValue = controller.fadeAnimation?.value ?? 1.0;
        final scaleValue = controller.scaleAnimation?.value ?? 1.0;
        final slideOffset = controller.slideAnimation?.value ?? Offset.zero;

        return Opacity(
          opacity: fadeValue,
          child: Transform.translate(
            offset: Offset(slideOffset.dx * MediaQuery.of(context).size.width,
                slideOffset.dy * 100),
            child: Transform.scale(
              scale: scaleValue,
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: AppTheme.cardGradient,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.secondaryAccent.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Lottie.asset(
                      'assets/animations/signup.json',
                      fit: BoxFit.contain,
                      repeat: true,
                      animate: true,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Create Account',
                    style: AppTheme.headingXL,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: AppTheme.cardGradient,
                      ),
                      border: Border.all(
                        color: AppTheme.secondaryAccent.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Join us and start your amazing journey',
                      style: AppTheme.subtitle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignupForm(SignupController controller) {
    return AnimatedBuilder(
      animation: controller.formController ??
          AnimationController(duration: Duration.zero, vsync: Navigator.of(Get.context!)),
      builder: (context, child) {
        // Safe animation values with fallbacks
        final formSlideValue = controller.formSlideAnimation?.value ?? 0.0;
        final fadeValue = controller.fadeAnimation?.value ?? 1.0;

        return Transform.translate(
          offset: Offset(0, formSlideValue),
          child: Opacity(
            opacity: fadeValue,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: AppTheme.cardGradient,
                ),
                border: Border.all(
                  color: AppTheme.secondaryAccent.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.secondaryAccent.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    // First Name and Last Name Row
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'First Name',
                            hintText: 'Enter first name',
                            controller: controller.firstNameController,
                            keyboardType: TextInputType.name,
                            validator: controller.validateFirstName,
                            prefixIcon: Icon(
                              Icons.person_rounded,
                              color: AppTheme.secondaryAccent,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            label: 'Last Name',
                            hintText: 'Enter last name',
                            controller: controller.lastNameController,
                            keyboardType: TextInputType.name,
                            validator: controller.validateLastName,
                            prefixIcon: Icon(
                              Icons.person_outline_rounded,
                              color: AppTheme.secondaryAccent,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Phone Number',
                      hintText: 'Enter your phone number',
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      validator: controller.validatePhone,
                      prefixIcon: Icon(
                        Icons.phone_rounded,
                        color: AppTheme.secondaryAccent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Email Address',
                      hintText: 'Enter your email',
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: controller.validateEmail,
                      prefixIcon: Icon(
                        Icons.email_rounded,
                        color: AppTheme.secondaryAccent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Password',
                      hintText: 'Create a strong password',
                      controller: controller.passwordController,
                      isPassword: true,
                      validator: controller.validatePassword,
                      prefixIcon: Icon(
                        Icons.lock_rounded,
                        color: AppTheme.secondaryAccent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Confirm Password',
                      hintText: 'Confirm your password',
                      controller: controller.confirmPasswordController,
                      isPassword: true,
                      validator: controller.validateConfirmPassword,
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                        color: AppTheme.secondaryAccent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSignupButton(controller),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignupButton(SignupController controller) {
    return Obx(() => CustomGradientButton(
      onPressed: controller.isLoading.value ? null : controller.signUp,
      text: controller.isLoading.value ? 'Creating Account...' : 'Create Account',
      icon: controller.isLoading.value ? null : Icons.person_add_rounded,
      gradientColors: AppTheme.buttonGradient,
      shadowColor: AppTheme.primaryAccent,
      textStyle: AppTheme.buttonText,
      width: double.infinity,
      height: 56,
      borderRadius: 28,
      shadowBlurRadius: 15,
      shadowSpreadRadius: 2,
      shadowOffset: const Offset(0, 4),
      iconSize: 20,
      spaceBetween: 8,
      enabled: !controller.isLoading.value,
      showIcon: !controller.isLoading.value,
    ));
  }

  Widget _buildFooter(SignupController controller) {
    return AnimatedBuilder(
      animation: controller.animationController ??
          AnimationController(duration: Duration.zero, vsync: Navigator.of(Get.context!)),
      builder: (context, child) {
        // Safe animation values with fallbacks
        final fadeValue = controller.fadeAnimation?.value ?? 1.0;

        return Opacity(
          opacity: fadeValue,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: AppTheme.cardGradient,
              ),
              border: Border.all(
                color: AppTheme.secondaryAccent.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: AppTheme.bodySmall,
                ),
                GestureDetector(
                  onTap: controller.navigateToLogin,
                  child: Text(
                    'Sign In',
                    style: AppTheme.linkText.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: AppTheme.accentCyan,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}