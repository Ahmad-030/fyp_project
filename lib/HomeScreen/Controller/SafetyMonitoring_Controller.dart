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
  late Map<String, int> _lastSeenTimestamps;
  bool _isFirstLoad = true;

  @override
  void onInit() {
    super.onInit();
    _notifiedAlertIds = {};
    _lastSeenTimestamps = {};
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      await NotificationService.initializeNotifications();
      _listenToAlarms();
    } catch (e) {
      print('Error initializing notifications: $e');
      _listenToAlarms();
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
                final timestamp = alertMap['timestamp'] ?? 0;

                proximityAlerts.add({
                  'id': key,
                  'message':
                  alertMap['message'] ?? 'Proximity Alert Detected',
                  'status': alertMap['status'] ?? 'ACTIVE',
                  'timestamp': timestamp,
                });

                // Only notify on FIRST LOAD: skip old alerts from database
                // After first load: only notify if status just changed to ACTIVE
                if (alertMap['status'] == 'ACTIVE') {
                  if (_isFirstLoad) {
                    print('First load - skipping existing alert: $alertId');
                    // Just record the timestamp, don't notify
                    _lastSeenTimestamps[alertId] = timestamp;
                  } else if (!_notifiedAlertIds.contains(alertId)) {
                    // New alert that just became ACTIVE
                    print('Showing NEW active alert: $alertId');
                    _notifiedAlertIds.add(alertId);
                    NotificationService.showProximityAlert(
                      message: alertMap['message'] ?? 'Child entered danger zone',
                      alertId: alertId,
                    );
                  }
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
                final timestamp = alertMap['timestamp'] ?? 0;

                soundAlerts.add({
                  'id': key,
                  'message': alertMap['message'] ?? 'Dangerous sound detected',
                  'status': alertMap['status'] ?? 'ACTIVE',
                  'timestamp': timestamp,
                });

                // Only notify on FIRST LOAD: skip old alerts from database
                // After first load: only notify if status just changed to ACTIVE
                if (alertMap['status'] == 'ACTIVE') {
                  if (_isFirstLoad) {
                    print('First load - skipping existing alert: $alertId');
                    // Just record the timestamp, don't notify
                    _lastSeenTimestamps[alertId] = timestamp;
                  } else if (!_notifiedAlertIds.contains(alertId)) {
                    // New alert that just became ACTIVE
                    print('Showing NEW active alert: $alertId');
                    _notifiedAlertIds.add(alertId);
                    NotificationService.showSoundHazardAlert(
                      message: alertMap['message'] ??
                          'Dangerous sound level detected',
                      alertId: alertId,
                    );
                  }
                }
              }
            });
          }

          // Mark first load as complete after processing
          if (_isFirstLoad) {
            _isFirstLoad = false;
            print('First load completed. Future alerts will be notified immediately.');
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

    if (timestamp > 946684800000) {
      date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else if (timestamp > 946684800) {
      date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    } else {
      final now = DateTime.now();
      date = now.subtract(Duration(seconds: timestamp));
    }

    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    }

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }

    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }

    if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }

    if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '${weeks}w ago';
    }

    if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '${months}mo ago';
    }

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