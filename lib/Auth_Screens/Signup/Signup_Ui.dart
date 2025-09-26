import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../Widgets/Custom_Button.dart';
import '../../Widgets/Custom_TextField.dart';
import 'Signup_Controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: controller.getBackgroundGradientColors(),
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
      animation: controller.animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: controller.fadeAnimation,
          child: SlideTransition(
            position: controller.slideAnimation,
            child: Transform.scale(
              scale: controller.scaleAnimation.value,
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: controller.getCardGradientColors(),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: controller.getActiveIndicatorColor().withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Lottie.asset(
                      'assets/animations/signup.json', // You can use a different animation or the same login.json
                      fit: BoxFit.contain,
                      repeat: true,
                      animate: true,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Create Account',
                    style: controller.getTitleTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: controller.getCardGradientColors(),
                      ),
                      border: Border.all(
                        color: controller.getActiveIndicatorColor().withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Join us and start your amazing journey',
                      style: controller.getSubtitleTextStyle(),
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
      animation: controller.formController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, controller.formSlideAnimation.value),
          child: FadeTransition(
            opacity: controller.fadeAnimation,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: controller.getCardGradientColors(),
                ),
                border: Border.all(
                  color: controller.getActiveIndicatorColor().withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: controller.getActiveIndicatorColor().withOpacity(0.2),
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
                              color: controller.getActiveIndicatorColor(),
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
                              color: controller.getActiveIndicatorColor(),
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
                        color: controller.getActiveIndicatorColor(),
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
                        color: controller.getActiveIndicatorColor(),
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
                        color: controller.getActiveIndicatorColor(),
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
                        color: controller.getActiveIndicatorColor(),
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTermsAndConditions(controller),
                    const SizedBox(height: 24),
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

  Widget _buildTermsAndConditions(SignupController controller) {
    return Obx(() => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: controller.toggleAcceptTerms,
          child: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: controller.acceptTerms.value
                    ? controller.getActiveIndicatorColor()
                    : Colors.white.withOpacity(0.5),
                width: 2,
              ),
              color: controller.acceptTerms.value
                  ? controller.getActiveIndicatorColor()
                  : Colors.transparent,
            ),
            child: controller.acceptTerms.value
                ? const Icon(
              Icons.check,
              size: 14,
              color: Colors.white,
            )
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    const TextSpan(text: 'I agree to the '),
                    TextSpan(
                      text: 'Terms and Conditions',
                      style: controller.getLinkTextStyle().copyWith(
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                        decorationColor: controller.getActiveIndicatorColor(),
                      ),
                      // You can add onTap here for navigation
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: controller.getLinkTextStyle().copyWith(
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                        decorationColor: controller.getActiveIndicatorColor(),
                      ),
                      // You can add onTap here for navigation
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _buildSignupButton(SignupController controller) {
    return Obx(() => CustomGradientButton(
      onPressed: controller.isLoading.value ? null : controller.signUp,
      text: controller.isLoading.value ? 'Creating Account...' : 'Create Account',
      icon: controller.isLoading.value ? null : Icons.person_add_rounded,
      gradientColors: controller.getButtonGradientColors(),
      shadowColor: controller.getPrimaryButtonColor(),
      textStyle: controller.getButtonTextStyle(),
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
      animation: controller.fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: controller.fadeAnimation,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: controller.getCardGradientColors(),
              ),
              border: Border.all(
                color: controller.getActiveIndicatorColor().withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                GestureDetector(
                  onTap: controller.navigateToLogin,
                  child: Text(
                    'Sign In',
                    style: controller.getLinkTextStyle().copyWith(
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: controller.getActiveIndicatorColor(),
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