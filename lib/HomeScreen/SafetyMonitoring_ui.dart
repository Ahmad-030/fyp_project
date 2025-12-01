import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Theme/App_theme.dart';
import 'Controller/SafetyMonitoring_Controller.dart';
import 'Setting.dart';

class ChildSafetyMonitoringScreen extends StatelessWidget {
  const ChildSafetyMonitoringScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SafetyMonitoringController controller =
    Get.put(SafetyMonitoringController());

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppTheme.backgroundGradient,
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Loading alerts...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildStatusCards(controller),
                    const SizedBox(height: 32),
                    _buildProximitySection(controller),
                    const SizedBox(height: 24),
                    _buildSoundHazardSection(controller),
                    const SizedBox(height: 24),
                    _buildCryDetectionSection(controller), // ✅ NEW
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Safety Monitor',
              style: AppTheme.headingXL,
            ),
            InkWell(
              onTap: () {
                Get.to(() => OutroScreen());
              },
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: AppTheme.cardGradient,
                  ),
                  border: Border.all(
                    color: AppTheme.secondaryAccent.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.exit_to_app_sharp,
                  color: AppTheme.secondaryAccent,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Real-time child safety alerts with notifications',
          style: AppTheme.subtitle,
        ),
      ],
    );
  }

  Widget _buildStatusCards(SafetyMonitoringController controller) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatusCard(
                title: 'Proximity',
                count: controller.proximityAlerts.length,
                icon: Icons.location_on_rounded,
                color: AppTheme.warningRed,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatusCard(
                title: 'Sound',
                count: controller.soundAlerts.length,
                icon: Icons.volume_up_rounded,
                color: AppTheme.warningOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // ✅ NEW: Cry Detection Status Card
        _buildStatusCard(
          title: 'Cry Detection',
          count: controller.cryAlerts.length,
          icon: Icons.child_care_rounded,
          color: const Color(0xFFFF6B9D),
          fullWidth: true,
        ),
      ],
    );
  }

  Widget _buildStatusCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    bool fullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.15),
            color.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: fullWidth
          ? Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.bodySmall,
              ),
              Text(
                '$count',
                style: AppTheme.headingLarge.copyWith(
                  fontSize: 28,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      )
          : Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: AppTheme.headingLarge.copyWith(
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildProximitySection(SafetyMonitoringController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.warningRed.withOpacity(0.2),
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: AppTheme.warningRed,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Proximity Alerts',
              style: AppTheme.headingMedium,
            ),
          ],
        ),
        const SizedBox(height: 12),
        controller.proximityAlerts.isEmpty
            ? _buildEmptyState('No proximity alerts')
            : Column(
          children: controller.proximityAlerts
              .map((alert) => _buildAlertCard(
            alert: alert,
            controller: controller,
            colors: [
              AppTheme.warningRed.withOpacity(0.1),
              AppTheme.warningRed.withOpacity(0.05),
            ],
            icon: Icons.location_on_rounded,
            iconColor: AppTheme.warningRed,
          ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSoundHazardSection(SafetyMonitoringController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.warningOrange.withOpacity(0.2),
              ),
              child: const Icon(
                Icons.volume_up_rounded,
                color: AppTheme.warningOrange,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Sound Hazard Alerts',
              style: AppTheme.headingMedium,
            ),
          ],
        ),
        const SizedBox(height: 12),
        controller.soundAlerts.isEmpty
            ? _buildEmptyState('No sound hazard alerts')
            : Column(
          children: controller.soundAlerts
              .map((alert) => _buildAlertCard(
            alert: alert,
            controller: controller,
            colors: [
              AppTheme.warningOrange.withOpacity(0.1),
              AppTheme.warningOrange.withOpacity(0.05),
            ],
            icon: Icons.volume_up_rounded,
            iconColor: AppTheme.warningOrange,
          ))
              .toList(),
        ),
      ],
    );
  }

  // ✅ NEW: Cry Detection Section
  Widget _buildCryDetectionSection(SafetyMonitoringController controller) {
    const cryColor = Color(0xFFFF6B9D);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cryColor.withOpacity(0.2),
              ),
              child: const Icon(
                Icons.child_care_rounded,
                color: cryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Cry Detection Alerts',
              style: AppTheme.headingMedium,
            ),
          ],
        ),
        const SizedBox(height: 12),
        controller.cryAlerts.isEmpty
            ? _buildEmptyState('No cry detection alerts')
            : Column(
          children: controller.cryAlerts
              .map((alert) => _buildAlertCard(
            alert: alert,
            controller: controller,
            colors: [
              cryColor.withOpacity(0.1),
              cryColor.withOpacity(0.05),
            ],
            icon: Icons.child_care_rounded,
            iconColor: cryColor,
          ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildAlertCard({
    required Map<String, dynamic> alert,
    required SafetyMonitoringController controller,
    required List<Color> colors,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: colors),
        border: Border.all(
          color: iconColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.2),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert['message'] ?? 'Alert',
                  style: AppTheme.bodyLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      controller.formatTimestamp(alert['timestamp'] ?? 0),
                      style: AppTheme.caption,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: iconColor.withOpacity(0.2),
                      ),
                      child: Text(
                        alert['status'] == 'active' || alert['status'] == 'ACTIVE'
                            ? 'ACTIVE'
                            : 'RESOLVED',
                        style: AppTheme.labelText.copyWith(
                          color: iconColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.02),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 48,
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: AppTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}