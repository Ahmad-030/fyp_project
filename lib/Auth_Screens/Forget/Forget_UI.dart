import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../Widgets/Custom_Button.dart';
import '../../Widgets/Custom_TextField.dart';
import 'Forget_Controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure any existing controller is disposed first
    if (Get.isRegistered<ForgotPasswordController>()) {
      Get.delete<ForgotPasswordController>();
    }

    final ForgotPasswordController controller = Get.put(ForgotPasswordController(), permanent: false);

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
                  _buildBackButton(controller),
                  const SizedBox(height: 20),
                  _buildHeader(controller),
                  const SizedBox(height: 40),
                  Obx(() => controller.emailSent.value
                      ? _buildSuccessView(controller)
                      : _buildResetForm(controller)
                  ),
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

  Widget _buildBackButton(ForgotPasswordController controller) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: controller.navigateToLogin,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: controller.getCardGradientColors(),
            ),
            border: Border.all(
              color: controller.getActiveIndicatorColor().withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: controller.getActiveIndicatorColor(),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ForgotPasswordController controller) {
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
              child: Obx(() => Column(
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

                    // You can uncomment these when you have the Lottie animation files
                    child: Lottie.asset(
                      controller.emailSent.value
                          ? 'assets/animations/emailsent.json'
                          : 'assets/animations/write.json',
                      fit: BoxFit.contain,
                      repeat: true,
                      animate: true,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    controller.emailSent.value ? 'Check Your Email' : 'Forgot Password?',
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
                      controller.emailSent.value
                          ? 'We\'ve sent password reset instructions to your email'
                          : 'Don\'t worry! Enter your email and we\'ll send you reset instructions',
                      style: controller.getSubtitleTextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResetForm(ForgotPasswordController controller) {
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
                      hintText: 'Enter your registered email',
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: controller.validateEmail,
                      prefixIcon: Icon(
                        Icons.email_rounded,
                        color: controller.getActiveIndicatorColor(),
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildResetButton(controller),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuccessView(ForgotPasswordController controller) {
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
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFF059669).withOpacity(0.1),
                      border: Border.all(
                        color: const Color(0xFF059669).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.mark_email_read_rounded,
                          color: const Color(0xFF059669),
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Email Sent Successfully!',
                          style: controller.getButtonTextStyle().copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Check your inbox and follow the instructions to reset your password.',
                          style: controller.getBodyTextStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildEmailInfo(controller),
                  const SizedBox(height: 24),
                  _buildResendButton(controller),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmailInfo(ForgotPasswordController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: controller.getActiveIndicatorColor().withOpacity(0.1),
        border: Border.all(
          color: controller.getActiveIndicatorColor().withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: controller.getActiveIndicatorColor(),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Important Information',
                style: controller.getButtonTextStyle().copyWith(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• Check your spam/junk folder if you don\'t see the email\n• The reset link will expire in 1 hour\n• Contact support if you need further assistance',
            style: controller.getBodyTextStyle().copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton(ForgotPasswordController controller) {
    return Obx(() => CustomGradientButton(
      onPressed: controller.isLoading.value ? null : controller.sendPasswordResetEmail,
      text: controller.isLoading.value ? 'Sending Email...' : 'Send Reset Email',
      icon: controller.isLoading.value ? null : Icons.send_rounded,
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

  Widget _buildResendButton(ForgotPasswordController controller) {
    return Obx(() => CustomGradientButton(
      onPressed: controller.countdown.value == 0 ? controller.resendEmail : null,
      text: controller.countdown.value > 0
          ? 'Resend in ${controller.countdown.value}s'
          : 'Resend Email',
      icon: controller.countdown.value == 0 ? Icons.refresh_rounded : null,
      gradientColors: controller.countdown.value > 0
          ? [Colors.grey.shade600, Colors.grey.shade700]
          : controller.getButtonGradientColors(),
      shadowColor: controller.countdown.value > 0
          ? Colors.grey.shade600
          : controller.getPrimaryButtonColor(),
      textStyle: controller.getButtonTextStyle(),
      width: double.infinity,
      height: 56,
      borderRadius: 28,
      shadowBlurRadius: 15,
      shadowSpreadRadius: 2,
      shadowOffset: const Offset(0, 4),
      iconSize: 20,
      spaceBetween: 8,
      enabled: controller.countdown.value == 0 && !controller.isLoading.value,
      showIcon: controller.countdown.value == 0,
    ));
  }

  Widget _buildFooter(ForgotPasswordController controller) {
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
                colors: controller.getCardGradientColors(),
              ),
              border: Border.all(
                color: controller.getActiveIndicatorColor().withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Remember your password? ",
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
                const SizedBox(height: 12),
                Row(
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
                      onTap: controller.navigateToSignup,
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
              ],
            ),
          ),
        );
      },
    );
  }
}