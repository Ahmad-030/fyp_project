import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Controller/Setting_Controller.dart';
import '../Theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());

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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildUserSection(controller),
                  const SizedBox(height: 24),
                  _buildTestSection(controller),
                  const SizedBox(height: 24),
                  _buildDataSection(controller),
                  const SizedBox(height: 24),
                  _buildLogoutButton(controller),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
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
                Icons.settings,
                color: AppTheme.secondaryAccent,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Settings',
              style: AppTheme.headingXL,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Manage your account and preferences',
          style: AppTheme.subtitle,
        ),
      ],
    );
  }

  Widget _buildUserSection(SettingsController controller) {
    return Obx(() {
      final user = controller.currentUser.value;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: AppTheme.cardGradient,
          ),
          border: Border.all(
            color: AppTheme.secondaryAccent.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.secondaryAccent.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppTheme.secondaryAccent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Account Information',
                  style: AppTheme.headingSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.person_outline,
              label: 'Name',
              value: controller.firstName.value.isEmpty
                  ? 'Loading...'
                  : controller.firstName.value,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.email_outlined,
              label: 'Email',
              value: user?.email ?? 'Not available',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: controller.phoneNumber.value.isEmpty
                  ? 'Loading...'
                  : controller.phoneNumber.value,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.6),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.caption,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTestSection(SettingsController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: AppTheme.cardGradient,
        ),
        border: Border.all(
          color: AppTheme.secondaryAccent.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
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
                  Icons.notifications_active,
                  color: AppTheme.warningOrange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Test Notifications',
                style: AppTheme.headingSmall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTestButton(
            label: 'Test Proximity Alert',
            icon: Icons.location_on_rounded,
            color: AppTheme.warningRed,
            onPressed: () => controller.testProximityNotification(),
          ),
          const SizedBox(height: 12),
          _buildTestButton(
            label: 'Test Sound Hazard Alert',
            icon: Icons.volume_up_rounded,
            color: AppTheme.warningOrange,
            onPressed: () => controller.testSoundNotification(),
          ),
        ],
      ),
    );
  }

  Widget _buildTestButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
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
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.play_arrow_rounded,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSection(SettingsController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: AppTheme.cardGradient,
        ),
        border: Border.all(
          color: AppTheme.secondaryAccent.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
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
                  Icons.delete_outline,
                  color: AppTheme.warningRed,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Data Management',
                style: AppTheme.headingSmall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            label: 'Clear All Alerts',
            icon: Icons.cleaning_services_outlined,
            color: AppTheme.warningRed,
            onPressed: () => _showDeleteConfirmation(
              context: Get.context!,
              title: 'Clear All Alerts?',
              message:
              'This will permanently delete all proximity and sound hazard alerts from the database.',
              onConfirm: () => controller.clearAllAlerts(),
            ),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            label: 'Clear Proximity Alerts',
            icon: Icons.location_off_outlined,
            color: AppTheme.warningRed,
            onPressed: () => _showDeleteConfirmation(
              context: Get.context!,
              title: 'Clear Proximity Alerts?',
              message: 'This will delete all proximity alerts from the database.',
              onConfirm: () => controller.clearProximityAlerts(),
            ),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            label: 'Clear Sound Alerts',
            icon: Icons.volume_off_outlined,
            color: AppTheme.warningOrange,
            onPressed: () => _showDeleteConfirmation(
              context: Get.context!,
              title: 'Clear Sound Alerts?',
              message: 'This will delete all sound hazard alerts from the database.',
              onConfirm: () => controller.clearSoundAlerts(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
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
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(SettingsController controller) {
    return InkWell(
      onTap: () => _showLogoutConfirmation(controller),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              AppTheme.warningRed.withOpacity(0.2),
              AppTheme.warningRed.withOpacity(0.1),
            ],
          ),
          border: Border.all(
            color: AppTheme.warningRed.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout,
              color: AppTheme.warningRed,
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              'Logout',
              style: AppTheme.buttonSmall.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.primaryMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          title,
          style: AppTheme.headingSmall,
        ),
        content: Text(
          message,
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTheme.linkText.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: Text(
              'Delete',
              style: AppTheme.linkText.copyWith(
                color: AppTheme.warningRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(SettingsController controller) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.primaryMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Logout',
          style: AppTheme.headingSmall,
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTheme.linkText.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.logout();
            },
            child: Text(
              'Logout',
              style: AppTheme.linkText.copyWith(
                color: AppTheme.warningRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}