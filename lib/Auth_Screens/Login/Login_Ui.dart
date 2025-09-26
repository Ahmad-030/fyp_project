import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../Widgets/Custom_Button.dart';
import '../../Widgets/Custom_TextField.dart';
import 'Login_Controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

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
                  const SizedBox(height: 50),
                  _buildLoginForm(controller),
                  const SizedBox(height: 40),
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

  Widget _buildHeader(LoginController controller) {
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
                      'assets/animations/login.json',
                      fit: BoxFit.contain,
                      repeat: true,
                      animate: true,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Welcome Back',
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
                      'Sign in to continue your journey',
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

  Widget _buildLoginForm(LoginController controller) {
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
                      hintText: 'Enter your password',
                      controller: controller.passwordController,
                      isPassword: true,
                      validator: controller.validatePassword,
                      prefixIcon: Icon(
                        Icons.lock_rounded,
                        color: controller.getActiveIndicatorColor(),
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRememberMeAndForgotPassword(controller),
                    const SizedBox(height: 24),
                    _buildLoginButton(controller),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRememberMeAndForgotPassword(LoginController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() => Row(
          children: [
            GestureDetector(
              onTap: controller.toggleRememberMe,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: controller.rememberMe.value
                        ? controller.getActiveIndicatorColor()
                        : Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                  color: controller.rememberMe.value
                      ? controller.getActiveIndicatorColor()
                      : Colors.transparent,
                ),
                child: controller.rememberMe.value
                    ? const Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                )
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Remember me',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        )),
        GestureDetector(
          onTap: controller.navigateToForgotPassword,
          child: Text(
            'Forgot Password?',
            style: controller.getLinkTextStyle(),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(LoginController controller) {
    return Obx(() => CustomGradientButton(
      onPressed: controller.isLoading.value ? null : controller.login,
      text: controller.isLoading.value ? 'Signing In...' : 'Sign In',
      icon: controller.isLoading.value ? null : Icons.login_rounded,
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

  Widget _buildFooter(LoginController controller) {
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
                  "Don't have an account? ",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                GestureDetector(
                  onTap: controller.navigateToSignUp,
                  child: Text(
                    'Sign Up',
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