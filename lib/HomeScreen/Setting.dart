import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Theme/App_theme.dart';
import 'Controller/Setting_Controller.dart';

class OutroScreen extends StatelessWidget {
  const OutroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OutroController controller = Get.put(OutroController());

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
        child: Stack(
          children: [
            // Animated background
            _buildAnimatedBackground(controller),

            // Main content
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildHeader(controller),
                      const SizedBox(height: 40),
                      _buildProfileAvatar(controller),
                      const SizedBox(height: 32),
                      _buildAccountInfoCard(controller),
                      const SizedBox(height: 40),
                      _buildIoTStatusCard(controller),
                      const SizedBox(height: 40),
                      _buildSwipeToLogout(controller, context),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground(OutroController controller) {
    return AnimatedBuilder(
      animation: controller.pulseController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: OutroBackgroundPainter(
            animationValue: controller.pulseAnimation.value,
            accentColor: controller.getAccentColor(),
          ),
        );
      },
    );
  }

  Widget _buildHeader(OutroController controller) {
    return AnimatedBuilder(
      animation: controller.mainController,
      builder: (context, child) {
        return FadeTransition(
          opacity: controller.fadeAnimation,
          child: Transform.translate(
            offset: Offset(0, controller.slideAnimation.value),
            child: Row(
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: controller.getCardGradient(),
                      ),
                      border: Border.all(
                        color: controller.getAccentColor().withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: controller.getAccentColor(),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        'Manage your profile & device',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileAvatar(OutroController controller) {
    return AnimatedBuilder(
      animation: controller.pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: controller.pulseAnimation.value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  controller.getPrimaryColor(),
                  controller.getAccentColor(),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: controller.getAccentColor().withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                ),
                // Inner avatar
                Obx(() => Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Text(
                      controller.fullName.value.isNotEmpty
                          ? controller.fullName.value[0].toUpperCase()
                          : 'U',
                      style: GoogleFonts.poppins(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )),
                // Online indicator
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF059669),
                      border: Border.all(
                        color: controller.getPrimaryColor(),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF059669).withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
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

  Widget _buildAccountInfoCard(OutroController controller) {
    return AnimatedBuilder(
      animation: controller.mainController,
      builder: (context, child) {
        return FadeTransition(
          opacity: controller.fadeAnimation,
          child: Transform.translate(
            offset: Offset(0, controller.slideAnimation.value),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: controller.getCardGradient(),
                ),
                border: Border.all(
                  color: controller.getAccentColor().withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: controller.getAccentColor().withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.getAccentColor().withOpacity(0.2),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          color: controller.getAccentColor(),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Account Information',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Info rows
                  _buildInfoRow(
                    controller: controller,
                    icon: Icons.badge_rounded,
                    label: 'Full Name',
                    valueWidget: Obx(() => Text(
                      controller.fullName.value.isEmpty
                          ? 'Loading...'
                          : controller.fullName.value,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    )),
                  ),
                  _buildDivider(controller),

                  _buildInfoRow(
                    controller: controller,
                    icon: Icons.email_rounded,
                    label: 'Email Address',
                    valueWidget: Obx(() => Text(
                      controller.email.value,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                  _buildDivider(controller),

                  _buildInfoRow(
                    controller: controller,
                    icon: Icons.phone_rounded,
                    label: 'Phone Number',
                    valueWidget: Obx(() => Text(
                      controller.phoneNumber.value.isEmpty
                          ? 'Loading...'
                          : controller.phoneNumber.value,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    )),
                  ),
                  _buildDivider(controller),

                  _buildInfoRow(
                    controller: controller,
                    icon: Icons.calendar_today_rounded,
                    label: 'Member Since',
                    valueWidget: Obx(() => Text(
                      controller.memberSince.value.isEmpty
                          ? 'Loading...'
                          : controller.memberSince.value,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow({
    required OutroController controller,
    required IconData icon,
    required String label,
    required Widget valueWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: controller.getAccentColor().withOpacity(0.1),
            ),
            child: Icon(
              icon,
              color: controller.getAccentColor().withOpacity(0.8),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.6),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                valueWidget,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(OutroController controller) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            controller.getAccentColor().withOpacity(0.2),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildIoTStatusCard(OutroController controller) {
    return AnimatedBuilder(
      animation: controller.mainController,
      builder: (context, child) {
        return FadeTransition(
          opacity: controller.fadeAnimation,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF059669).withOpacity(0.15),
                  const Color(0xFF059669).withOpacity(0.05),
                ],
              ),
              border: Border.all(
                color: const Color(0xFF059669).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Animated IoT indicator
                AnimatedBuilder(
                  animation: controller.pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF059669).withOpacity(0.2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF059669).withOpacity(
                                0.3 * controller.pulseAnimation.value),
                            blurRadius: 15 * controller.pulseAnimation.value,
                            spreadRadius: 5 * controller.pulseAnimation.value,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.sensors_rounded,
                        color: Color(0xFF059669),
                        size: 28,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF059669),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF059669).withOpacity(0.5),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'IoT Device Active',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ESP32 sensors are monitoring your child\'s safety',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSwipeToLogout(OutroController controller, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 48;
    const buttonWidth = 70.0;
    final maxSwipeDistance = screenWidth - buttonWidth - 16;

    return AnimatedBuilder(
      animation: controller.mainController,
      builder: (context, child) {
        return FadeTransition(
          opacity: controller.fadeAnimation,
          child: Column(
            children: [
              // Warning text
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: controller.getWarningColor().withOpacity(0.1),
                  border: Border.all(
                    color: controller.getWarningColor().withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: controller.getWarningColor(),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'This will disconnect your IoT device',
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: controller.getWarningColor(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Swipe button container
              Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  gradient: LinearGradient(
                    colors: [
                      controller.getWarningColor().withOpacity(0.15),
                      controller.getWarningColor().withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(
                    color: controller.getWarningColor().withOpacity(0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: controller.getWarningColor().withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Progress fill
                    Obx(() => AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: (screenWidth * controller.swipeProgress.value).clamp(0.0, screenWidth),
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        gradient: LinearGradient(
                          colors: [
                            controller.getWarningColor().withOpacity(0.4),
                            controller.getWarningColor().withOpacity(0.2),
                          ],
                        ),
                      ),
                    )),

                    // Center text with icon hints
                    Center(
                      child: Obx(() => AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: controller.showSwipeHint.value ? 1.0 : 0.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: controller.swipeHintController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(controller.swipeHintAnimation.value * 10, 0),
                                  child: Icon(
                                    Icons.chevron_right_rounded,
                                    color: controller.getWarningColor().withOpacity(0.6),
                                    size: 24,
                                  ),
                                );
                              },
                            ),
                            Icon(
                              Icons.power_settings_new_rounded,
                              color: controller.getWarningColor().withOpacity(0.8),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Swipe to Turn Off & Logout',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: controller.getWarningColor().withOpacity(0.9),
                                letterSpacing: 0.5,
                              ),
                            ),
                            AnimatedBuilder(
                              animation: controller.swipeHintController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(controller.swipeHintAnimation.value * 10, 0),
                                  child: Icon(
                                    Icons.chevron_right_rounded,
                                    color: controller.getWarningColor().withOpacity(0.6),
                                    size: 24,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )),
                    ),

                    // Swipe button
                    Obx(() => Positioned(
                      left: 4 + (maxSwipeDistance * controller.swipeProgress.value),
                      top: 4,
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          if (!controller.isLoggingOut.value) {
                            final newProgress = controller.swipeProgress.value +
                                (details.delta.dx / maxSwipeDistance);
                            controller.updateSwipeProgress(newProgress);
                          }
                        },
                        onHorizontalDragEnd: (details) {
                          if (!controller.isLoggingOut.value) {
                            controller.resetSwipe();
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          width: buttonWidth - 8,
                          height: buttonWidth - 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: controller.swipeProgress.value > 0.7
                                  ? [const Color(0xFFDC2626), const Color(0xFFEF4444)]
                                  : controller.getSwipeButtonGradient(),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (controller.swipeProgress.value > 0.7
                                    ? const Color(0xFFDC2626)
                                    : controller.getWarningColor()).withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: controller.isLoggingOut.value
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : Icon(
                            controller.swipeProgress.value > 0.7
                                ? Icons.power_off_rounded
                                : Icons.power_settings_new_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),

              // Footer text
              const SizedBox(height: 24),
              Text(
                'You can reconnect anytime by logging in again',
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}

// Custom painter for animated background
class OutroBackgroundPainter extends CustomPainter {
  final double animationValue;
  final Color accentColor;

  OutroBackgroundPainter({
    required this.animationValue,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw floating circles
    final random = math.Random(42);
    for (int i = 0; i < 15; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 3.0 + random.nextDouble() * 5;

      paint.color = accentColor.withOpacity(0.05 + random.nextDouble() * 0.08);
      canvas.drawCircle(
        Offset(x, y),
        radius * animationValue,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}