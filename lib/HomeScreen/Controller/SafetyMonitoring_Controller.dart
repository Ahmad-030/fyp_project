import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import '../../Services/Notification_service.dart';

class SafetyMonitoringController extends GetxController {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  var proximityAlerts = <Map<String, dynamic>>[].obs;
  var soundAlerts = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  late Set<String> _notifiedAlertIds;

  @override
  void onInit() {
    super.onInit();
    _notifiedAlertIds = {};
    _initializeNotifications();
    _listenToAlarms();
  }

  Future<void> _initializeNotifications() async {
    try {
      await NotificationService.initializeNotifications();
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  void _listenToAlarms() {
    try {
      final ref = _database.ref().child('childSafety/alarms');

      ref.onValue.listen((event) {
        if (event.snapshot.exists) {
          proximityAlerts.clear();
          soundAlerts.clear();

          final data = Map<String, dynamic>.from(event.snapshot.value as Map);

          // Parse PROXIMITY alerts
          if (data.containsKey('PROXIMITY')) {
            final proxData =
            Map<String, dynamic>.from(data['PROXIMITY'] as Map);
            proxData.forEach((key, value) {
              if (value is Map) {
                final alertMap = Map<String, dynamic>.from(value);
                final alertId = 'PROXIMITY_$key';

                proximityAlerts.add({
                  'id': key,
                  'message':
                  alertMap['message'] ?? 'Proximity Alert Detected',
                  'status': alertMap['status'] ?? 'ACTIVE',
                  'timestamp': alertMap['timestamp'] ?? 0,
                });

                // Show notification if not already notified
                if (!_notifiedAlertIds.contains(alertId) &&
                    alertMap['status'] == 'ACTIVE') {
                  _notifiedAlertIds.add(alertId);
                  NotificationService.showProximityAlert(
                    message: alertMap['message'] ?? 'Child entered danger zone',
                    alertId: alertId,
                  );
                }
              }
            });
          }

          // Parse SOUND_HAZARD alerts
          if (data.containsKey('SOUND_HAZARD')) {
            final soundData =
            Map<String, dynamic>.from(data['SOUND_HAZARD'] as Map);
            soundData.forEach((key, value) {
              if (value is Map) {
                final alertMap = Map<String, dynamic>.from(value);
                final alertId = 'SOUND_$key';

                soundAlerts.add({
                  'id': key,
                  'message': alertMap['message'] ?? 'Dangerous sound detected',
                  'status': alertMap['status'] ?? 'ACTIVE',
                  'timestamp': alertMap['timestamp'] ?? 0,
                });

                // Show notification if not already notified
                if (!_notifiedAlertIds.contains(alertId) &&
                    alertMap['status'] == 'ACTIVE') {
                  _notifiedAlertIds.add(alertId);
                  NotificationService.showSoundHazardAlert(
                    message: alertMap['message'] ??
                        'Dangerous sound level detected',
                    alertId: alertId,
                  );
                }
              }
            });
          }
        }
        isLoading.value = false;
      });
    } catch (e) {
      print('Error listening to alarms: $e');
      isLoading.value = false;
    }
  }

  String formatTimestamp(int timestamp) {
    if (timestamp == 0) return 'Just now';

    DateTime date;

    // Check if timestamp is in milliseconds or seconds
    // Timestamps after year 2000 in seconds are > 946684800
    // Timestamps in milliseconds are much larger (> 946684800000)
    if (timestamp > 946684800000) {
      // Already in milliseconds
      date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else if (timestamp > 946684800) {
      // In seconds, convert to milliseconds
      date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    } else {
      // Very small number - treat as seconds from now (relative time)
      // This might be seconds elapsed, not absolute timestamp
      final now = DateTime.now();
      date = now.subtract(Duration(seconds: timestamp));
    }

    final now = DateTime.now();
    final diff = now.difference(date);

    // Less than 1 minute
    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    }

    // Less than 1 hour
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }

    // Less than 1 day (24 hours)
    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }

    // Less than 7 days
    if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }

    // Less than 30 days
    if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '${weeks}w ago';
    }

    // Less than 365 days
    if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '${months}mo ago';
    }

    // More than 365 days
    final years = (diff.inDays / 365).floor();
    return '${years}y ago';
  }

  List<Color> getBackgroundGradientColors() {
    return [
      const Color(0xFF0F2A4A),
      const Color(0xFF1E4A6B),
      const Color(0xFF2D6A9A),
      const Color(0xFF4A90C2),
    ];
  }

  @override
  void onClose() {
    print('SafetyMonitoringController disposed');
    super.onClose();
  }
}