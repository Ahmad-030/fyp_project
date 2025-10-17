import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize notifications with permission request
  static Future<bool> initializeNotifications() async {
    try {
      print('📱 Initializing notification service...');

      // ✅ Android initialization with color settings
      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization with permission requests
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

      // Request permissions
      await _requestPermissions();

      return initialized ?? false;
    } catch (e) {
      print('❌ Error initializing notifications: $e');
      return false;
    }
  }

  // ✅ Background notification handler
  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse notificationResponse) {
    print('🎯 Background notification tapped: ${notificationResponse.payload}');
  }

  // Request notification permissions
  static Future<bool> _requestPermissions() async {
    try {
      print('🔔 Requesting notification permissions...');

      // For Android 13+ (API level 33+)
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final bool? granted =
        await androidImplementation.requestNotificationsPermission();
        print('✅ Android notification permission: $granted');
      }

      // For iOS
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

  // Check if notifications are enabled
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

  // ✅ IMPROVED: Show proximity alert notification with color dot
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
        // ✅ KEY: Set color using Android color resource
        color: Color(0xFF4A90C2),  // Sky Blue - matches colors.xml
        colorized: true,            // ✅ Makes color more visible
        icon: '@mipmap/ic_launcher',
        ongoing: false,
        autoCancel: true,
        showWhen: true,
        // ✅ Add style for better visual appearance
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
        // ✅ iOS color support
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

  // ✅ IMPROVED: Show sound hazard notification with color dot
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
        // ✅ KEY: Set color using Android color resource
        color: Color(0xFFFFA500),  // Orange - warning color
        colorized: true,            // ✅ Makes color more visible
        icon: '@mipmap/ic_launcher',
        ongoing: false,
        autoCancel: true,
        showWhen: true,
        // ✅ Add style for better visual appearance
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
        // ✅ iOS color support
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

  // Cancel notification
  static Future<void> cancelNotification(String alertId) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(alertId.hashCode);
      print('✅ Cancelled notification: $alertId');
    } catch (e) {
      print('❌ Error cancelling notification: $e');
    }
  }

  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
      print('✅ All notifications cancelled');
    } catch (e) {
      print('❌ Error cancelling all notifications: $e');
    }
  }

  // Get pending notifications count
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