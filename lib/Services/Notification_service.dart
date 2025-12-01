import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<bool> initializeNotifications() async {
    try {
      print('📱 Initializing notification service...');

      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        requestCriticalPermission: true,
      );

      const InitializationSettings initializationSettings =
      InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      final bool? initialized = await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          print('✅ Notification tapped: ${response.payload}');
        },
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );

      print('✅ Notification initialization result: $initialized');

      await _requestPermissions();

      return initialized ?? false;
    } catch (e) {
      print('❌ Error initializing notifications: $e');
      return false;
    }
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse notificationResponse) {
    print('🎯 Background notification tapped: ${notificationResponse.payload}');
  }

  static Future<bool> _requestPermissions() async {
    try {
      print('🔔 Requesting notification permissions...');

      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final bool? granted =
        await androidImplementation.requestNotificationsPermission();
        print('✅ Android notification permission: $granted');
      }

      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
        critical: true,
      );

      print('✅ iOS notification permission: $result');

      return result ?? true;
    } catch (e) {
      print('❌ Error requesting permissions: $e');
      return false;
    }
  }

  static Future<bool> areNotificationsEnabled() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final bool? enabled =
        await androidImplementation.areNotificationsEnabled();
        print('✅ Notifications enabled (Android): $enabled');
        return enabled ?? false;
      }

      return true;
    } catch (e) {
      print('❌ Error checking notification status: $e');
      return false;
    }
  }

  static Future<void> showProximityAlert({
    required String message,
    required String alertId,
  }) async {
    try {
      print('📍 Showing proximity alert: $message');

      const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'proximity_alerts',
        'Proximity Alerts',
        channelDescription: 'Notifications for proximity warnings',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        fullScreenIntent: true,
        color: Color(0xFF4A90C2),
        colorized: true,
        icon: '@mipmap/ic_launcher',
        ongoing: false,
        autoCancel: true,
        showWhen: true,
        styleInformation: const BigTextStyleInformation(
          'Proximity Hazard Detected!',
          contentTitle: '🚨 Safety Alert',
          summaryText: 'Tap to view details',
        ),
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        interruptionLevel: InterruptionLevel.timeSensitive,
        threadIdentifier: 'proximity_alerts',
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        alertId.hashCode,
        '🚨 Proximity Alert',
        message,
        notificationDetails,
        payload: alertId,
      );

      print('✅ Proximity alert shown successfully');
    } catch (e) {
      print('❌ Error showing proximity alert: $e');
      rethrow;
    }
  }

  static Future<void> showSoundHazardAlert({
    required String message,
    required String alertId,
  }) async {
    try {
      print('🔊 Showing sound hazard alert: $message');

      const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'sound_hazard_alerts',
        'Sound Hazard Alerts',
        channelDescription: 'Notifications for sound hazards',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        fullScreenIntent: true,
        color: Color(0xFFFFA500),
        colorized: true,
        icon: '@mipmap/ic_launcher',
        ongoing: false,
        autoCancel: true,
        showWhen: true,
        styleInformation: const BigTextStyleInformation(
          'Sound Hazard Detected!',
          contentTitle: '🔊 Safety Alert',
          summaryText: 'Tap to view details',
        ),
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        interruptionLevel: InterruptionLevel.timeSensitive,
        threadIdentifier: 'sound_hazard_alerts',
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        alertId.hashCode,
        '🔊 Sound Hazard Alert',
        message,
        notificationDetails,
        payload: alertId,
      );

      print('✅ Sound hazard alert shown successfully');
    } catch (e) {
      print('❌ Error showing sound hazard alert: $e');
      rethrow;
    }
  }

  // ✅ NEW: Cry Detection Alert
  static Future<void> showCryDetectionAlert({
    required String message,
    required String alertId,
  }) async {
    try {
      print('👶 Showing cry detection alert: $message');

      const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'cry_detection_alerts',
        'Cry Detection Alerts',
        channelDescription: 'Notifications for child cry detection',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        fullScreenIntent: true,
        color: Color(0xFFFF6B9D), // Pink/magenta for child-related alerts
        colorized: true,
        icon: '@mipmap/ic_launcher',
        ongoing: false,
        autoCancel: true,
        showWhen: true,
        styleInformation: const BigTextStyleInformation(
          'Child Cry Detected!',
          contentTitle: '👶 Cry Alert',
          summaryText: 'Tap to view details',
        ),
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        interruptionLevel: InterruptionLevel.timeSensitive,
        threadIdentifier: 'cry_detection_alerts',
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        alertId.hashCode,
        '👶 Cry Detection Alert',
        message,
        notificationDetails,
        payload: alertId,
      );

      print('✅ Cry detection alert shown successfully');
    } catch (e) {
      print('❌ Error showing cry detection alert: $e');
      rethrow;
    }
  }

  static Future<void> cancelNotification(String alertId) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(alertId.hashCode);
      print('✅ Cancelled notification: $alertId');
    } catch (e) {
      print('❌ Error cancelling notification: $e');
    }
  }

  static Future<void> cancelAllNotifications() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
      print('✅ All notifications cancelled');
    } catch (e) {
      print('❌ Error cancelling all notifications: $e');
    }
  }

  static Future<int> getPendingNotificationCount() async {
    try {
      final List<PendingNotificationRequest> pendingNotifications =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      return pendingNotifications.length;
    } catch (e) {
      print('❌ Error getting pending notifications: $e');
      return 0;
    }
  }
}