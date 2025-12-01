import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Theme/App_theme.dart';
import 'Intro_Controller.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IntroController controller = Get.put(IntroController());

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
            // Animated background waves
            _buildAnimatedBackground(controller),

            // Floating particles
            _buildFloatingParticles(controller),

            // Main content
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      _buildHeader(controller),
                      const SizedBox(height: 32),
                      _buildIoTIndicator(controller),
                      const SizedBox(height: 32),
                      _buildDescription(controller),
                      const SizedBox(height: 32),
                      _buildFeatureCards(controller),
                      const SizedBox(height: 40),
                      _buildSwipeToStart(controller, context),
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

  Widget _buildAnimatedBackground(IntroController controller) {
    return AnimatedBuilder(
      animation: controller.waveController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: WaveBackgroundPainter(
            animationValue: controller.waveAnimation.value,
            colors: [
              controller.getAccentColor().withOpacity(0.05),
              controller.getPrimaryColor().withOpacity(0.08),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFloatingParticles(IntroController controller) {
    return AnimatedBuilder(
      animation: controller.pulseController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: FloatingParticlesPainter(
            animationValue: controller.pulseAnimation.value,
            accentColor: controller.getAccentColor(),
          ),
        );
      },
    );
  }

  Widget _buildHeader(IntroController controller) {
    return AnimatedBuilder(
      animation: controller.mainController,
      builder: (context, child) {
        return FadeTransition(
          opacity: controller.fadeAnimation,
          child: SlideTransition(
            position: controller.slideAnimation,
            child: Column(
              children: [
                // App Icon with glow effect
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        controller.getAccentColor().withOpacity(0.3),
                        controller.getPrimaryColor().withOpacity(0.1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: controller.getAccentColor().withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: controller.getSwipeButtonGradient(),
                      ),
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title with shimmer effect
                ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [
                        Colors.white,
                        controller.getAccentColor(),
                        Colors.white,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ).createShader(bounds);
                  },
                  child: Text(
                    'Child Safety',
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 4),
                          blurRadius: 15,
                          color: controller.getPrimaryColor().withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: controller.getAccentColor().withOpacity(0.15),
                    border: Border.all(
                      color: controller.getAccentColor().withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
                        'IoT-Powered Protection',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 1.0,
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

  Widget _buildIoTIndicator(IntroController controller) {
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
                colors: controller.getCardGradient(),
              ),
              border: Border.all(
                color: controller.getAccentColor().withOpacity(0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: controller.getAccentColor().withOpacity(0.2),
                  blurRadius: 25,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Rotating rings
                ...List.generate(3, (index) {
                  return AnimatedBuilder(
                    animation: controller.waveController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: controller.waveAnimation.value * 2 * math.pi * (index % 2 == 0 ? 1 : -1),
                        child: Container(
                          width: 100 - (index * 15),
                          height: 100 - (index * 15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: controller.getAccentColor().withOpacity(0.2 - (index * 0.05)),
                              width: 1,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
                // Center icon
                Icon(
                  Icons.sensors_rounded,
                  size: 40,
                  color: controller.getAccentColor(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDescription(IntroController controller) {
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
                colors: controller.getCardGradient(),
              ),
              border: Border.all(
                color: controller.getAccentColor().withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Advanced Protection System',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Our IoT-based child safety system uses ESP32 sensors to monitor your child\'s environment in real-time. '
                      'Receive instant alerts for proximity dangers and hazardous sound levels directly to your phone. '
                      'Stay connected and ensure your child\'s safety with cutting-edge technology.',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.6,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureCards(IntroController controller) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildFeatureCard(controller, 0)),
            const SizedBox(width: 12),
            Expanded(child: _buildFeatureCard(controller, 1)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildFeatureCard(controller, 2)),
            const SizedBox(width: 12),
            Expanded(child: _buildFeatureCard(controller, 3)),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(IntroController controller, int index) {
    final feature = controller.features[index];

    return AnimatedBuilder(
      animation: controller.getCardAnimation(index),
      builder: (context, child) {
        final animValue = controller.getCardAnimation(index).value;

        return Transform.scale(
          scale: animValue,
          child: Opacity(
            opacity: animValue,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    (feature['color'] as Color).withOpacity(0.15),
                    (feature['color'] as Color).withOpacity(0.05),
                  ],
                ),
                border: Border.all(
                  color: (feature['color'] as Color).withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (feature['color'] as Color).withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (feature['color'] as Color).withOpacity(0.2),
                    ),
                    child: Icon(
                      feature['icon'] as IconData,
                      color: feature['color'] as Color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    feature['title'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feature['description'] as String,
                    style: GoogleFonts.roboto(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSwipeToStart(IntroController controller, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 48; // Account for padding
    const buttonWidth = 70.0;
    final maxSwipeDistance = screenWidth - buttonWidth - 16;

    return AnimatedBuilder(
      animation: controller.mainController,
      builder: (context, child) {
        return FadeTransition(
          opacity: controller.fadeAnimation,
          child: Column(
            children: [
              Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  gradient: LinearGradient(
                    colors: controller.getCardGradient(),
                  ),
                  border: Border.all(
                    color: controller.getAccentColor().withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: controller.getAccentColor().withOpacity(0.2),
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
                            controller.getPrimaryColor().withOpacity(0.3),
                            controller.getAccentColor().withOpacity(0.2),
                          ],
                        ),
                      ),
                    )),

                    // Center text with arrow hints
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
                                    color: Colors.white.withOpacity(0.5),
                                    size: 24,
                                  ),
                                );
                              },
                            ),
                            Text(
                              'Swipe to Start Monitoring',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.7),
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
                                    color: Colors.white.withOpacity(0.5),
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
                          final newProgress = controller.swipeProgress.value +
                              (details.delta.dx / maxSwipeDistance);
                          controller.updateSwipeProgress(newProgress);
                        },
                        onHorizontalDragEnd: (details) {
                          controller.resetSwipe();
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
                                  ? [const Color(0xFF059669), const Color(0xFF10B981)]
                                  : controller.getSwipeButtonGradient(),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (controller.swipeProgress.value > 0.7
                                    ? const Color(0xFF059669)
                                    : controller.getPrimaryColor()).withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            controller.swipeProgress.value > 0.7
                                ? Icons.check_rounded
                                : Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),

              // IoT badge
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.memory_rounded,
                      color: controller.getAccentColor().withOpacity(0.7),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Powered by ESP32 IoT Technology',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.6),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Custom painter for animated wave background
class WaveBackgroundPainter extends CustomPainter {
  final double animationValue;
  final List<Color> colors;

  WaveBackgroundPainter({
    required this.animationValue,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw multiple wave layers
    for (int i = 0; i < 3; i++) {
      paint.color = colors[i % colors.length].withOpacity(0.1 - (i * 0.02));

      final path = Path();
      path.moveTo(0, size.height);

      for (double x = 0; x <= size.width; x += 10) {
        final y = size.height * 0.7 +
            math.sin((x / size.width * 2 * math.pi) + (animationValue * 2 * math.pi) + (i * math.pi / 3)) * 30 +
            (i * 20);
        path.lineTo(x, y);
      }

      path.lineTo(size.width, size.height);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom painter for floating particles
class FloatingParticlesPainter extends CustomPainter {
  final double animationValue;
  final Color accentColor;

  FloatingParticlesPainter({
    required this.animationValue,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Generate particles
    final random = math.Random(42); // Fixed seed for consistent particles
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final y = (baseY + (animationValue * 100 * (i % 3 + 1))) % size.height;
      final radius = 2.0 + random.nextDouble() * 3;

      paint.color = accentColor.withOpacity(0.1 + random.nextDouble() * 0.15);
      canvas.drawCircle(Offset(x, y), radius * animationValue, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}