import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'SplashScreen_Controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.put(SplashController());

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
            _buildAnimatedBackground(controller),
            _buildMainContent(controller),
            _buildLoadingDots(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground(SplashController controller) {
    return AnimatedBuilder(
      animation: controller.backgroundController,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(double.infinity, double.infinity),
          painter: BackgroundAnimationPainter(
            animationValue: controller.backgroundPulseAnimation.value,
            controller: controller,
          ),
        );
      },
    );
  }

  Widget _buildMainContent(SplashController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLottieAnimation(controller),
          const SizedBox(height: 10),
          _buildAnimatedAppName(controller),
          const SizedBox(height: 20),
          _buildSubtitle(controller),
        ],
      ),
    );
  }

  Widget _buildLottieAnimation(SplashController controller) {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: controller.scaleAnimation.value,
          child: FadeTransition(
            opacity: controller.fadeAnimation,
            child: SizedBox(
              width: 300,
              height: 300,
              child: Lottie.asset(
                'assets/animations/animationa.json',
                fit: BoxFit.contain,
                repeat: true,
                animate: true,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedAppName(SplashController controller) {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        return SlideTransition(
          position: controller.slideAnimation,
          child: FadeTransition(
            opacity: controller.fadeAnimation,
            child: Transform.scale(
              scale: controller.scaleAnimation.value,
              child: _buildTextWithAnimations(controller),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextWithAnimations(SplashController controller) {
    return AnimatedBuilder(
      animation: controller.textController,
      builder: (context, child) {
        return Transform.scale(
          scale: controller.textBounceAnimation.value,
          child: _buildShimmerText(controller),
        );
      },
    );
  }

  Widget _buildShimmerText(SplashController controller) {
    return AnimatedBuilder(
      animation: controller.textShimmerAnimation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: controller.getTextShimmerColors(),
              stops: controller.getShimmerStops(),
            ).createShader(bounds);
          },
          child: Text(
            'Robotic',
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 6.0,
              shadows: controller.getTextShadows(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubtitle(SplashController controller) {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: controller.subtitleFadeAnimation,
          child: SlideTransition(
            position: controller.subtitleSlideAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: controller.getSubtitleGradientColors(),
                ),
                border: Border.all(
                  color: const Color(0xFF87CEEB).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Text(
                'Welcome to the future',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2.0,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 4,
                      color: Color(0xFF4169E1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingDots(SplashController controller) {
    return Positioned(
      bottom: 80,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: controller.animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: controller.dotsAnimation,
            child: Center(
              child: CustomLoadingDots(controller: controller),
            ),
          );
        },
      ),
    );
  }
}

class BackgroundAnimationPainter extends CustomPainter {
  final double animationValue;
  final SplashController controller;

  BackgroundAnimationPainter({
    required this.animationValue,
    required this.controller,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw floating circles
    final circles = controller.getBackgroundCircles(size);
    for (var circle in circles) {
      final x = circle['x'] as double;
      final y = circle['y'] as double;
      final radius = (circle['radius'] as double) * animationValue;
      final color = circle['color'] as Color;

      paint.color = color.withOpacity(0.1);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Draw sparkle effects
    final sparkleColors = controller.getSparkleColors();
    for (int i = 0; i < 25; i++) {
      final x = (size.width * (i * 0.04)) % size.width;
      final y = (size.height * (i * 0.06 + animationValue)) % size.height;
      final colorIndex = i % sparkleColors.length;

      paint.color = sparkleColors[colorIndex].withOpacity(0.15);
      canvas.drawCircle(Offset(x, y), 2.5 * animationValue, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class CustomLoadingDots extends StatelessWidget {
  final SplashController controller;

  const CustomLoadingDots({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.backgroundController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final dotColors = controller.getLoadingDotColors();
            final scale = controller.getLoadingDotScale(index);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        dotColors[index].withOpacity(0.9),
                        dotColors[index].withOpacity(0.6),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: dotColors[index].withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}