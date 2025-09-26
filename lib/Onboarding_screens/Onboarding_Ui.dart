import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Widgets/Custom_Button.dart';
import 'Onboarding_Controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OnboardingController controller = Get.put(OnboardingController());

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: controller.getBackgroundGradientColors(),
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(controller),
              Expanded(
                child: _buildPageView(controller),
              ),
              _buildBottomSection(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(OnboardingController controller) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 60), // For balance
          _buildPageIndicators(controller),
          _buildSkipButton(controller),
        ],
      ),
    );
  }

  Widget _buildSkipButton(OnboardingController controller) {
    return Obx(() =>
    controller.isLastPage.value
        ? const SizedBox(width: 60)
        : GestureDetector(
      onTap: controller.skipPages,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: controller.getSecondaryButtonColor().withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Text(
          'Skip',
          style: controller.getButtonTextStyle().copyWith(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildPageIndicators(OnboardingController controller) {
    return Obx(() => Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: controller.currentPage.value == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: controller.currentPage.value == index
                ? controller.getActiveIndicatorColor()
                : controller.getInactiveIndicatorColor(),
            boxShadow: controller.currentPage.value == index
                ? [
              BoxShadow(
                color: controller.getActiveIndicatorColor().withOpacity(0.4),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ]
                : null,
          ),
        );
      }),
    ));
  }

  Widget _buildPageView(OnboardingController controller) {
    final onboardingData = controller.getOnboardingData();

    return PageView.builder(
      controller: controller.pageController,
      onPageChanged: (index) {
        controller.currentPage.value = index;
        controller.isLastPage.value = index == 2;
      },
      itemCount: onboardingData.length,
      itemBuilder: (context, index) {
        return _buildOnboardingPage(
          controller,
          onboardingData[index],
        );
      },
    );
  }

  Widget _buildOnboardingPage(
      OnboardingController controller,
      OnboardingData data,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          _buildImageSection(controller, data.image),
          const SizedBox(height: 40),
          _buildContentSection(controller, data),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildImageSection(OnboardingController controller, String imagePath) {
    return AnimatedBuilder(
      animation: controller.fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: controller.fadeAnimation,
          child: Transform.scale(
            scale: controller.scaleAnimation.value,
            child: Container(
              width: 280,
              height: 280,
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback when image is not found
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: controller.getCardGradientColors(),
                        ),
                      ),
                      child: Icon(
                        Icons.image,
                        size: 100,
                        color: controller.getActiveIndicatorColor().withOpacity(0.5),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContentSection(OnboardingController controller, OnboardingData data) {
    return AnimatedBuilder(
      animation: controller.slideAnimation,
      builder: (context, child) {
        return SlideTransition(
          position: controller.slideAnimation,
          child: FadeTransition(
            opacity: controller.fadeAnimation,
            child: Column(
              children: [
                Text(
                  data.title,
                  style: controller.getTitleTextStyle(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
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
                  child: Text(
                    data.description,
                    style: controller.getDescriptionTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSection(OnboardingController controller) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildNavigationButton(controller),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(OnboardingController controller) {
    return Obx(() => CustomGradientButton(
      onPressed: controller.nextPage,
      text: controller.isLastPage.value ? 'Get Started' : 'Next',
      icon: controller.isLastPage.value
          ? Icons.rocket_launch
          : Icons.arrow_forward,
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
    ));
  }
}

