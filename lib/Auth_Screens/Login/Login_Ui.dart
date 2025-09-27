import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'Login_Controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure any existing controller is disposed first
    if (Get.isRegistered<LoginController>()) {
      Get.delete<LoginController>();
    }

    final LoginController controller = Get.put(LoginController(), permanent: false);

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
      animation: controller.animationController ??
          AnimationController(duration: Duration.zero, vsync: Navigator.of(Get.context!)),
      builder: (context, child) {
        // Safe animation values with fallbacks
        final fadeValue = controller.fadeAnimation.value;
        final scaleValue = controller.scaleAnimation.value;
        final slideOffset = controller.slideAnimation.value;

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
                    child:
                    // You can uncomment this when you have the Lottie animation file
                    // child:
                     Lottie.asset(
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
      animation: controller.formController ??
          AnimationController(duration: Duration.zero, vsync: Navigator.of(Get.context!)),
      builder: (context, child) {
        // Safe animation values with fallbacks
        final formSlideValue = controller.formSlideAnimation.value;
        final fadeValue = controller.fadeAnimation.value;

        return Transform.translate(
          offset: Offset(0, formSlideValue),
          child: Opacity(
            opacity: fadeValue,
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
                    // Email Field - Enhanced with better styling
                    TextFormField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: controller.validateEmail,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        hintText: 'Enter your email',
                        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        prefixIcon: Icon(
                          Icons.email_rounded,
                          color: controller.getActiveIndicatorColor(),
                          size: 22,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: controller.getActiveIndicatorColor(), width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        errorStyle: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password Field - Enhanced with better styling
                    Obx(() => TextFormField(
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible.value,
                      validator: controller.validatePassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        prefixIcon: Icon(
                          Icons.lock_rounded,
                          color: controller.getActiveIndicatorColor(),
                          size: 22,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: controller.togglePasswordVisibility,
                          child: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            color: Colors.white.withOpacity(0.7),
                            size: 22,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: controller.getActiveIndicatorColor(), width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        errorStyle: const TextStyle(color: Colors.redAccent),
                      ),
                    )),
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
        Obx(() => GestureDetector(
          onTap: controller.toggleRememberMe,
          child: Row(
            children: [
              Container(
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
          ),
        )),
        GestureDetector(
          onTap: controller.navigateToForgotPassword,
          child: Text(
            'Forgot Password?',
            style: controller.getLinkTextStyle().copyWith(
              decoration: TextDecoration.underline,
              decorationColor: controller.getActiveIndicatorColor(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(LoginController controller) {
    return Obx(() => Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: controller.isLoading.value
            ? LinearGradient(colors: [Colors.grey, Colors.grey.shade400])
            : LinearGradient(colors: controller.getButtonGradientColors()),
        boxShadow: controller.isLoading.value
            ? []
            : [
          BoxShadow(
            color: controller.getPrimaryButtonColor().withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.isLoading.value ? null : () {
            // Add debug information
            print('Login button pressed');
            print('Email: ${controller.emailController.text}');
            print('Password length: ${controller.passwordController.text.length}');
            controller.login();
          },
          borderRadius: BorderRadius.circular(28),
          child: Container(
            alignment: Alignment.center,
            child: controller.isLoading.value
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Signing In...',
                  style: controller.getButtonTextStyle(),
                ),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.login_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Sign In',
                  style: controller.getButtonTextStyle(),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildFooter(LoginController controller) {
    return AnimatedBuilder(
      animation: controller.animationController ??
          AnimationController(duration: Duration.zero, vsync: Navigator.of(Get.context!)),
      builder: (context, child) {
        // Safe animation values with fallbacks
        final fadeValue = controller.fadeAnimation.value;

        return Opacity(
          opacity: fadeValue,
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