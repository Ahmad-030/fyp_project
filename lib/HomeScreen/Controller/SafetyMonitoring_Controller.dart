import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../Services/Notification_service.dart';

class SafetyMonitoringController extends GetxController {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  var proximityAlerts = <Map<String, dynamic>>[].obs;
  var soundAlerts = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var lastRefreshTime = DateTime.now().obs;
  var debugLogs = <String>[].obs; // Store debug logs for UI display
  var connectionStatus = 'Connecting...'.obs;

  late Set<String> _notifiedAlertIds;
  late Map<String, int> _lastSeenTimestamps;
  DatabaseReference? _alarmRef;

  @override
  void onInit() {
    super.onInit();
    _notifiedAlertIds = {};
    _lastSeenTimestamps = {};
    _addLog('🚀 Controller initialized');
    _initializeNotifications();
  }

  void _addLog(String message) {
    final timestamp = DateTime.now().toString().split('.')[0];
    final logMessage = '[$timestamp] $message';
    debugLogs.add(logMessage);
    print(logMessage);

    // Keep only last 100 logs
    if (debugLogs.length > 100) {
      debugLogs.removeAt(0);
    }
  }

  Future<void> _initializeNotifications() async {
    try {
      _addLog('📱 Initializing notifications...');
      final initialized = await NotificationService.initializeNotifications();

      if (initialized) {
        _addLog('✅ Notifications initialized successfully');
      } else {
        _addLog('⚠️ Notifications init returned false');
      }

      _listenToAlarms();
    } catch (e) {
      _addLog('❌ Notification init error: $e');
      _listenToAlarms();
    }
  }

  void _listenToAlarms() {
    try {
      _addLog('🔗 Connecting to Firebase...');
      _alarmRef = _database.ref().child('childSafety/alarms');

      _alarmRef!.onValue.listen(
            (event) {
          _addLog('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
          _addLog('📡 FIREBASE UPDATE RECEIVED');
          _addLog('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

          connectionStatus.value = '🟢 Connected';
          lastRefreshTime.value = DateTime.now();

          if (event.snapshot.exists) {
            final data = Map<String, dynamic>.from(event.snapshot.value as Map);
            _addLog('✅ Data exists in database');
            _addLog('📊 Keys: ${data.keys.toList()}');

            proximityAlerts.clear();
            soundAlerts.clear();

            // Parse PROXIMITY alerts
            if (data.containsKey('PROXIMITY')) {
              _addLog('');
              _addLog('🔍 PROXIMITY ALERTS:');
              final proxData = Map<String, dynamic>.from(data['PROXIMITY'] as Map);
              _addLog('   Count: ${proxData.length}');

              proxData.forEach((key, value) {
                if (value is Map) {
                  _parseAndProcessAlert(
                    key: key,
                    alertMap: value,
                    alertType: 'PROXIMITY',
                    isProximity: true,
                  );
                }
              });
            } else {
              _addLog('📍 No PROXIMITY alerts found');
            }

            // Parse SOUND_HAZARD alerts
            if (data.containsKey('SOUND_HAZARD')) {
              _addLog('');
              _addLog('🔊 SOUND_HAZARD ALERTS:');
              final soundData = Map<String, dynamic>.from(data['SOUND_HAZARD'] as Map);
              _addLog('   Count: ${soundData.length}');

              soundData.forEach((key, value) {
                if (value is Map) {
                  _parseAndProcessAlert(
                    key: key,
                    alertMap: value,
                    alertType: 'SOUND_HAZARD',
                    isProximity: false,
                  );
                }
              });
            } else {
              _addLog('🔊 No SOUND_HAZARD alerts found');
            }

            // Summary
            _addLog('');
            _addLog('📊 SUMMARY:');
            _addLog('   Total Proximity: ${proximityAlerts.length}');
            _addLog('   Total Sound: ${soundAlerts.length}');
            _addLog('   Tracked Alerts: ${_lastSeenTimestamps.keys.length}');

          } else {
            _addLog('⚠️ No data in database');
            connectionStatus.value = '⚠️ No data';
          }

          isLoading.value = false;
          _addLog('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
          _addLog('');
        },
        onError: (error) {
          _addLog('❌ FIREBASE ERROR: $error');
          connectionStatus.value = '🔴 Error';
          isLoading.value = false;
        },
      );

      _addLog('✅ Real-time listener attached');
    } catch (e) {
      _addLog('❌ Listener setup error: $e');
      connectionStatus.value = '🔴 Connection failed';
      isLoading.value = false;
    }
  }

  void _parseAndProcessAlert({
    required String key,
    required dynamic alertMap,
    required String alertType,
    required bool isProximity,
  }) {
    try {
      final alert = Map<String, dynamic>.from(alertMap as Map);
      final alertId = '${alertType}_$key';

      // Extract fields
      final message = alert['message'] ?? 'No message';
      final status = alert['status'] ?? 'UNKNOWN';
      final rawLastUpdate = alert['lastUpdate'] ?? alert['timestamp'] ?? 0;
      final timestamp = _normalizeTimestamp(rawLastUpdate);
      final formattedTime = formatTimestamp(timestamp);

      _addLog('   [$key]');
      _addLog('      Message: $message');
      _addLog('      Status: $status');
      _addLog('      Raw LastUpdate: $rawLastUpdate');
      _addLog('      Normalized: $timestamp');
      _addLog('      Formatted: $formattedTime');

      // Add to list
      if (isProximity) {
        proximityAlerts.add({
          'id': key,
          'message': message,
          'status': status,
          'timestamp': timestamp,
        });
      } else {
        soundAlerts.add({
          'id': key,
          'message': message,
          'status': status,
          'timestamp': timestamp,
        });
      }

      // Handle notifications for ACTIVE alerts
      if (status == 'ACTIVE') {
        _handleAlertNotification(
          alertId: alertId,
          timestamp: timestamp,
          message: message,
          isProximity: isProximity,
        );
      } else {
        _addLog('      ℹ️ Skipping notification (status: $status)');
      }
    } catch (e) {
      _addLog('   ❌ Parse error: $e');
    }
  }

  int _normalizeTimestamp(dynamic rawTimestamp) {
    if (rawTimestamp == null) return 0;

    int timestamp = 0;

    if (rawTimestamp is int) {
      timestamp = rawTimestamp;
    } else if (rawTimestamp is double) {
      timestamp = rawTimestamp.toInt();
    } else if (rawTimestamp is String) {
      timestamp = int.tryParse(rawTimestamp) ?? 0;
    }

    // Smart conversion
    if (timestamp > 0 && timestamp < 10000000000) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final diff = (now - timestamp).abs();

      if (diff > 3155760000000) {
        timestamp = timestamp * 1000;
      }
    }

    return timestamp;
  }

  String formatTimestamp(int timestamp) {
    if (timestamp == 0) return 'Unknown';

    try {
      DateTime date;

      if (timestamp > 946684800000) {
        date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else if (timestamp > 946684800) {
        date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      } else {
        return 'SEEN';
      }

      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inSeconds <= 0) {
        return 'Just now';
      }
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
        return '${(diff.inDays / 7).floor()}w ago';
      }
      if (diff.inDays < 365) {
        return '${(diff.inDays / 30).floor()}mo ago';
      }
      return '${(diff.inDays / 365).floor()}y ago';
    } catch (e) {
      return 'Error';
    }
  }

  void _handleAlertNotification({
    required String alertId,
    required int timestamp,
    required String message,
    required bool isProximity,
  }) {
    // ✅ Only send notification if BOTH conditions are met:
    // 1. We've seen this alert before AND timestamp changed (new event)
    // 2. OR it's the first time AND timestamp is recent

    if (_lastSeenTimestamps.containsKey(alertId)) {
      final lastSeenTimestamp = _lastSeenTimestamps[alertId]!;

      // ✅ Check if timestamp CHANGED (indicating new alert)
      if (timestamp != lastSeenTimestamp) {
        _addLog('      🔔 NEW alert detected');
        _addLog('      Changed: $lastSeenTimestamp → $timestamp');
        _addLog('      ✅ CONDITION MET: Timestamp changed + Status ACTIVE');

        _lastSeenTimestamps[alertId] = timestamp;
        _sendNotification(alertId, message, isProximity);
      } else {
        _addLog('      ℹ️ Duplicate (same timestamp - no notification)');
      }
    } else {
      // First time seeing this alert - record but DON'T notify
      _addLog('      📝 First occurrence (recording - no notification yet)');
      _addLog('      Will notify when lastUpdate changes');
      _lastSeenTimestamps[alertId] = timestamp;
    }
  }

  void _sendNotification(String alertId, String message, bool isProximity) {
    try {
      _addLog('      📤 Sending notification...');

      if (isProximity) {
        NotificationService.showProximityAlert(
          message: message,
          alertId: alertId,
        );
      } else {
        NotificationService.showSoundHazardAlert(
          message: message,
          alertId: alertId,
        );
      }

      _addLog('      ✅ Notification sent successfully!');
    } catch (e) {
      _addLog('      ❌ Notification error: $e');
    }
  }

  Future<void> testNotification(bool isProximity) async {
    try {
      _addLog('🧪 Testing ${isProximity ? 'PROXIMITY' : 'SOUND'} notification...');

      if (isProximity) {
        await NotificationService.showProximityAlert(
          message: 'This is a TEST proximity alert',
          alertId: 'test_proximity_${DateTime.now().millisecondsSinceEpoch}',
        );
      } else {
        await NotificationService.showSoundHazardAlert(
          message: 'This is a TEST sound alert',
          alertId: 'test_sound_${DateTime.now().millisecondsSinceEpoch}',
        );
      }

      _addLog('✅ Test notification sent!');
    } catch (e) {
      _addLog('❌ Test notification failed: $e');
    }
  }

  Future<void> clearAllLogs() async {
    debugLogs.clear();
    _addLog('🧹 Logs cleared');
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
    _addLog('🧹 Controller disposed');
    super.onClose();
  }
}