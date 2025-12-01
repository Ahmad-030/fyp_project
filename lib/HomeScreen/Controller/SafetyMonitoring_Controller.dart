import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../Services/Notification_service.dart';

class SafetyMonitoringController extends GetxController {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  var proximityAlerts = <Map<String, dynamic>>[].obs;
  var soundAlerts = <Map<String, dynamic>>[].obs;
  var cryAlerts = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var lastRefreshTime = DateTime.now().obs;
  var debugLogs = <String>[].obs;
  var connectionStatus = 'Connecting...'.obs;

  var firebaseLastUpdate = Rx<DateTime?>(null);
  var serverTime = DateTime.now().obs;

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
    _syncServerTime();
  }

  void _addLog(String message) {
    final timestamp = DateTime.now().toString().split('.')[0];
    final logMessage = '[$timestamp] $message';
    debugLogs.add(logMessage);
    print(logMessage);

    if (debugLogs.length > 100) {
      debugLogs.removeAt(0);
    }
  }

  Future<void> _syncServerTime() async {
    try {
      _addLog('⏰ Syncing with Firebase server time...');

      final serverRef = _database.ref().child('.info/serverTimeOffset');
      final event = await serverRef.once();

      if (event.snapshot.exists) {
        final offset = (event.snapshot.value as num?)?.toInt() ?? 0;
        serverTime.value = DateTime.now().add(Duration(milliseconds: offset));
        _addLog('✅ Server time synced (offset: ${offset}ms)');
      }
    } catch (e) {
      _addLog('⚠️ Server time sync error: $e');
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
      _addLog('📍 Database URL: ${_database.app.options.databaseURL}');

      _alarmRef = _database.ref().child('childSafety/alarms');

      _addLog('📍 Listening to path: childSafety/alarms');
      _addLog('🔄 Setting up onValue listener...');

      _alarmRef!.onValue.listen(
            (DatabaseEvent event) {
          _addLog('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
          _addLog('📡 FIREBASE UPDATE RECEIVED');
          _addLog('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

          connectionStatus.value = '🟢 Connected';
          lastRefreshTime.value = DateTime.now();

          // Debug: Check if snapshot exists
          _addLog('📊 Snapshot exists: ${event.snapshot.exists}');
          _addLog('📊 Snapshot value type: ${event.snapshot.value?.runtimeType}');

          if (event.snapshot.value != null) {
            _addLog('📊 Snapshot value: ${event.snapshot.value}');
          }

          if (event.snapshot.exists && event.snapshot.value != null) {
            try {
              final data = Map<String, dynamic>.from(event.snapshot.value as Map);
              _addLog('✅ Data exists in database');
              _addLog('📊 Root Keys: ${data.keys.toList()}');

              proximityAlerts.clear();
              soundAlerts.clear();
              cryAlerts.clear();

              int latestTimestamp = 0;
              int totalAlerts = 0;

              // Parse PROXIMITY alerts
              if (data.containsKey('PROXIMITY')) {
                _addLog('');
                _addLog('🔍 PROXIMITY ALERTS:');
                try {
                  final proxData = Map<String, dynamic>.from(data['PROXIMITY'] as Map);
                  _addLog('   Alert IDs: ${proxData.keys.toList()}');
                  _addLog('   Count: ${proxData.length}');

                  proxData.forEach((key, value) {
                    totalAlerts++;
                    _addLog('   Processing alert: $key');
                    if (value is Map) {
                      final alertMap = Map<String, dynamic>.from(value);
                      _addLog('   Alert data: $alertMap');
                      final timestamp = _normalizeTimestamp(
                          alertMap['lastUpdate'] ?? alertMap['timestamp'] ?? 0
                      );

                      if (timestamp > latestTimestamp) {
                        latestTimestamp = timestamp;
                      }

                      _parseAndProcessAlert(
                        key: key,
                        alertMap: alertMap,
                        alertType: 'PROXIMITY',
                        alertCategory: 'proximity',
                      );
                    } else {
                      _addLog('   ⚠️ Alert $key has invalid format: ${value.runtimeType}');
                    }
                  });
                } catch (e) {
                  _addLog('   ❌ Error parsing PROXIMITY: $e');
                }
              } else {
                _addLog('📍 No PROXIMITY key found in data');
              }

              // Parse SOUND_HAZARD alerts
              if (data.containsKey('SOUND_HAZARD')) {
                _addLog('');
                _addLog('🔊 SOUND_HAZARD ALERTS:');
                try {
                  final soundData = Map<String, dynamic>.from(data['SOUND_HAZARD'] as Map);
                  _addLog('   Alert IDs: ${soundData.keys.toList()}');
                  _addLog('   Count: ${soundData.length}');

                  soundData.forEach((key, value) {
                    totalAlerts++;
                    _addLog('   Processing alert: $key');
                    if (value is Map) {
                      final alertMap = Map<String, dynamic>.from(value);
                      _addLog('   Alert data: $alertMap');
                      final timestamp = _normalizeTimestamp(
                          alertMap['lastUpdate'] ?? alertMap['timestamp'] ?? 0
                      );

                      if (timestamp > latestTimestamp) {
                        latestTimestamp = timestamp;
                      }

                      _parseAndProcessAlert(
                        key: key,
                        alertMap: alertMap,
                        alertType: 'SOUND_HAZARD',
                        alertCategory: 'sound',
                      );
                    } else {
                      _addLog('   ⚠️ Alert $key has invalid format: ${value.runtimeType}');
                    }
                  });
                } catch (e) {
                  _addLog('   ❌ Error parsing SOUND_HAZARD: $e');
                }
              } else {
                _addLog('🔊 No SOUND_HAZARD key found in data');
              }

              // Parse CRY_DETECTION alerts
              if (data.containsKey('CRY_DETECTION')) {
                _addLog('');
                _addLog('👶 CRY_DETECTION ALERTS:');
                try {
                  final cryData = Map<String, dynamic>.from(data['CRY_DETECTION'] as Map);
                  _addLog('   Alert IDs: ${cryData.keys.toList()}');
                  _addLog('   Count: ${cryData.length}');

                  cryData.forEach((key, value) {
                    totalAlerts++;
                    _addLog('   Processing alert: $key');
                    if (value is Map) {
                      final alertMap = Map<String, dynamic>.from(value);
                      _addLog('   Alert data: $alertMap');
                      final timestamp = _normalizeTimestamp(
                          alertMap['lastUpdate'] ?? alertMap['timestamp'] ?? 0
                      );

                      if (timestamp > latestTimestamp) {
                        latestTimestamp = timestamp;
                      }

                      _parseAndProcessAlert(
                        key: key,
                        alertMap: alertMap,
                        alertType: 'CRY_DETECTION',
                        alertCategory: 'cry',
                      );
                    } else {
                      _addLog('   ⚠️ Alert $key has invalid format: ${value.runtimeType}');
                    }
                  });
                } catch (e) {
                  _addLog('   ❌ Error parsing CRY_DETECTION: $e');
                }
              } else {
                _addLog('👶 No CRY_DETECTION key found in data');
              }

              if (latestTimestamp > 0) {
                firebaseLastUpdate.value = DateTime.fromMillisecondsSinceEpoch(latestTimestamp);
                _addLog('⏱️ Latest Firebase Update: ${firebaseLastUpdate.value}');
              }

              _addLog('');
              _addLog('📊 PARSING SUMMARY:');
              _addLog('   Total Alerts Found: $totalAlerts');
              _addLog('   Total Proximity: ${proximityAlerts.length}');
              _addLog('   Total Sound: ${soundAlerts.length}');
              _addLog('   Total Cry: ${cryAlerts.length}');
              _addLog('   Tracked Alert IDs: ${_lastSeenTimestamps.keys.length}');

            } catch (e) {
              _addLog('❌ CRITICAL ERROR parsing data: $e');
              _addLog('Stack trace: ${StackTrace.current}');
            }

          } else {
            _addLog('⚠️ No data in database or snapshot is null');
            _addLog('📍 Path: childSafety/alarms');
            _addLog('💡 Please check:');
            _addLog('   1. Data exists at this path in Firebase');
            _addLog('   2. Firebase rules allow read access');
            _addLog('   3. Database URL is correct');
            connectionStatus.value = '⚠️ No data';
            firebaseLastUpdate.value = null;
          }

          isLoading.value = false;
          _addLog('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
          _addLog('');
        },
        onError: (error) {
          _addLog('❌ FIREBASE LISTENER ERROR: $error');
          _addLog('Error type: ${error.runtimeType}');
          _addLog('Error details: ${error.toString()}');
          connectionStatus.value = '🔴 Error';
          isLoading.value = false;
        },
        cancelOnError: false,
      );

      _addLog('✅ Real-time listener attached successfully');
      _addLog('⏳ Waiting for Firebase data...');

    } catch (e) {
      _addLog('❌ CRITICAL: Listener setup error: $e');
      _addLog('Stack trace: ${StackTrace.current}');
      connectionStatus.value = '🔴 Connection failed';
      isLoading.value = false;
    }
  }

  void _parseAndProcessAlert({
    required String key,
    required dynamic alertMap,
    required String alertType,
    required String alertCategory,
  }) {
    try {
      final alert = Map<String, dynamic>.from(alertMap as Map);
      final alertId = '${alertType}_$key';

      final message = alert['message'] ?? alert['type'] ?? 'Unknown Alert';
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

      // Add to appropriate list
      final alertData = {
        'id': key,
        'message': message,
        'status': status,
        'timestamp': timestamp,
        'type': alertType,
      };

      switch (alertCategory) {
        case 'proximity':
          proximityAlerts.add(alertData);
          _addLog('      ✅ Added to proximityAlerts');
          break;
        case 'sound':
          soundAlerts.add(alertData);
          _addLog('      ✅ Added to soundAlerts');
          break;
        case 'cry':
          cryAlerts.add(alertData);
          _addLog('      ✅ Added to cryAlerts');
          break;
      }

      // Handle notifications for ACTIVE alerts
      if (status.toLowerCase() == 'active') {
        _handleAlertNotification(
          alertId: alertId,
          timestamp: timestamp,
          message: message,
          alertCategory: alertCategory,
        );
      } else {
        _addLog('      ℹ️ Skipping notification (status: $status)');
      }
    } catch (e) {
      _addLog('   ❌ Parse error for alert $key: $e');
      _addLog('   Stack trace: ${StackTrace.current}');
    }
  }

  int _normalizeTimestamp(dynamic rawTimestamp) {
    if (rawTimestamp == null) {
      _addLog('      ⚠️ Null timestamp received');
      return 0;
    }

    int timestamp = 0;

    try {
      if (rawTimestamp is int) {
        timestamp = rawTimestamp;
        _addLog('      📅 Timestamp is int: $timestamp');
      } else if (rawTimestamp is double) {
        timestamp = rawTimestamp.toInt();
        _addLog('      📅 Timestamp is double, converted: $timestamp');
      } else if (rawTimestamp is String) {
        _addLog('      📅 Timestamp is string: $rawTimestamp');
        // Try parsing as ISO 8601
        try {
          final dateTime = DateTime.parse(rawTimestamp);
          timestamp = dateTime.millisecondsSinceEpoch;
          _addLog('      ✅ Parsed ISO 8601 to milliseconds: $timestamp');
          return timestamp;
        } catch (e) {
          _addLog('      ⚠️ Not ISO 8601, trying integer parse...');
          timestamp = int.tryParse(rawTimestamp) ?? 0;
          _addLog('      📅 Parsed as int: $timestamp');
        }
      } else {
        _addLog('      ❌ Unknown timestamp type: ${rawTimestamp.runtimeType}');
        return 0;
      }

      // Smart conversion for seconds vs milliseconds
      if (timestamp > 0 && timestamp < 10000000000) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final diff = (now - timestamp).abs();

        if (diff > 3155760000000) {
          _addLog('      🔄 Converting seconds to milliseconds');
          timestamp = timestamp * 1000;
        }
      }

      return timestamp;
    } catch (e) {
      _addLog('      ❌ Error normalizing timestamp: $e');
      return 0;
    }
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

  String getFirebaseLastUpdateFormatted() {
    if (firebaseLastUpdate.value == null) {
      return 'No updates yet';
    }

    final lastUpdate = firebaseLastUpdate.value!;
    final now = DateTime.now();
    final diff = now.difference(lastUpdate);

    if (diff.inSeconds <= 0) {
      return 'Just now';
    }
    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago • ${lastUpdate.hour.toString().padLeft(2, '0')}:${lastUpdate.minute.toString().padLeft(2, '0')}';
    }
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago • ${lastUpdate.hour.toString().padLeft(2, '0')}:${lastUpdate.minute.toString().padLeft(2, '0')}';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h ago • ${lastUpdate.hour.toString().padLeft(2, '0')}:${lastUpdate.minute.toString().padLeft(2, '0')}';
    }
    return 'Recently';
  }

  String getConnectionStatusDisplay() {
    if (connectionStatus.value.contains('Error')) {
      return '🔴 Connection Failed';
    }
    if (connectionStatus.value.contains('No data')) {
      return '⚠️ No Data';
    }
    if (firebaseLastUpdate.value != null) {
      return '🟢 Connected';
    }
    return '🟡 Connecting...';
  }

  void _handleAlertNotification({
    required String alertId,
    required int timestamp,
    required String message,
    required String alertCategory,
  }) {
    if (_lastSeenTimestamps.containsKey(alertId)) {
      final lastSeenTimestamp = _lastSeenTimestamps[alertId]!;

      if (timestamp != lastSeenTimestamp) {
        _addLog('      🔔 NEW alert detected');
        _addLog('      Changed: $lastSeenTimestamp → $timestamp');
        _addLog('      ✅ CONDITION MET: Timestamp changed + Status ACTIVE');

        _lastSeenTimestamps[alertId] = timestamp;
        _sendNotification(alertId, message, alertCategory);
      } else {
        _addLog('      ℹ️ Duplicate (same timestamp - no notification)');
      }
    } else {
      _addLog('      📝 First occurrence (recording - no notification yet)');
      _addLog('      Will notify when lastUpdate changes');
      _lastSeenTimestamps[alertId] = timestamp;
    }
  }

  void _sendNotification(String alertId, String message, String alertCategory) {
    try {
      _addLog('      📤 Sending notification...');

      switch (alertCategory) {
        case 'proximity':
          NotificationService.showProximityAlert(
            message: message,
            alertId: alertId,
          );
          break;
        case 'sound':
          NotificationService.showSoundHazardAlert(
            message: message,
            alertId: alertId,
          );
          break;
        case 'cry':
          NotificationService.showCryDetectionAlert(
            message: message,
            alertId: alertId,
          );
          break;
      }

      _addLog('      ✅ Notification sent successfully!');
    } catch (e) {
      _addLog('      ❌ Notification error: $e');
    }
  }

  Future<void> testNotification(String alertType) async {
    try {
      _addLog('🧪 Testing $alertType notification...');

      switch (alertType) {
        case 'proximity':
          await NotificationService.showProximityAlert(
            message: 'This is a TEST proximity alert',
            alertId: 'test_proximity_${DateTime.now().millisecondsSinceEpoch}',
          );
          break;
        case 'sound':
          await NotificationService.showSoundHazardAlert(
            message: 'This is a TEST sound alert',
            alertId: 'test_sound_${DateTime.now().millisecondsSinceEpoch}',
          );
          break;
        case 'cry':
          await NotificationService.showCryDetectionAlert(
            message: 'This is a TEST cry detection alert',
            alertId: 'test_cry_${DateTime.now().millisecondsSinceEpoch}',
          );
          break;
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

  // Manual refresh method for testing
  Future<void> manualRefresh() async {
    _addLog('🔄 Manual refresh triggered');
    isLoading.value = true;

    try {
      final snapshot = await _alarmRef?.get();
      if (snapshot != null && snapshot.exists) {
        _addLog('✅ Manual fetch successful');
        _addLog('📊 Data: ${snapshot.value}');
      } else {
        _addLog('⚠️ No data found on manual fetch');
      }
    } catch (e) {
      _addLog('❌ Manual refresh error: $e');
    } finally {
      isLoading.value = false;
    }
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