import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';
import '../models/chapter_model.dart';
import 'dart:developer' as developer;

class StudyNotificationService {
  static final StudyNotificationService _instance =
      StudyNotificationService._internal();
  factory StudyNotificationService() => _instance;
  StudyNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<bool> checkNotificationPermissions() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        // Request permissions for iOS
        final bool? result = await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );

        developer.log('Notification permissions status (iOS): $result');
        return result ?? false;
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        // Check for Android 13+ permissions
        final bool isAndroid13OrHigher = await _isAndroid13OrHigher();
        if (isAndroid13OrHigher) {
          final permissionGranted =
              await Permission.notification.request().isGranted;

          developer.log(
              'Notification permissions status (Android 13+): $permissionGranted');
          return permissionGranted;
        } else {
          // Notifications are granted by default for older Android versions
          developer.log('Notification permissions granted by default.');
          return true;
        }
      }
    } catch (e) {
      developer.log('Error checking notification permissions: $e');
    }

    // Default return in case of unexpected platform or error
    return false;
  }

  Future<bool> _isAndroid13OrHigher() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    return sdkInt >= 33; // Android 13 corresponds to API level 33
  }

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();

    // Check for Android 13+ permissions
    if (defaultTargetPlatform == TargetPlatform.android) {
      final bool isAndroid13OrHigher = await _isAndroid13OrHigher();
      if (isAndroid13OrHigher) {
        await Permission.notification.request();
      }
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification taps
        if (response.payload != null) {
          developer.log('Notification payload: ${response.payload}');
          navigatorKey.currentState?.pushNamed('/home'); // Example action
        }
      },
    );

    _isInitialized = true;
  }

  Future<void> notifyInactivity() async {
    final prefs = await SharedPreferences.getInstance();
    final studyRemindersEnabled = prefs.getBool('study_reminders') ?? true;

    if (!studyRemindersEnabled) return;

    await _notificationsPlugin.show(
      6, // Unique ID for inactivity notifications
      'نفتقدك! 👋',
      'عد إلى الدراسة للحفاظ على تقدمك',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'inactivity',
          'تذكيرات النشاط',
          channelDescription: 'تذكيرات عند عدم النشاط',
          importance: Importance.high,
          priority: Priority.high,
          enableLights: true,
          enableVibration: true,
          icon: 'notification_icon',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  Future<void> scheduleDailyStudyReminder(TimeOfDay reminderTime,
      {required String type}) async {
    final notificationId = type == 'morning' ? 1 : 2;
    final title = type == 'morning' ? 'تذكير الصباح 🌅' : 'تذكير المساء 🌙';

    developer.log(
        'Scheduling $type reminder at ${reminderTime.hour}:${reminderTime.minute}');

    await _notificationsPlugin.zonedSchedule(
      notificationId,
      title,
      'حان وقت المراجعة! 📚',
      _nextInstanceOfTime(hour: reminderTime.hour, minute: reminderTime.minute),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_study',
          'المراجعة اليومية',
          channelDescription: 'تذكيرات المراجعة اليومية',
          importance: Importance.high,
          priority: Priority.high,
          enableLights: true,
          enableVibration: true,
          icon: 'notification_icon',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelDailyReminders() async {
    await _notificationsPlugin.cancel(1); // Morning reminder
    await _notificationsPlugin.cancel(2); // Evening reminder
  }

  Future<void> updateNotificationSettings({
    required bool studyReminders,
    required bool achievementNotifications,
    required bool streakNotifications,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('study_reminders', studyReminders);
    await prefs.setBool('achievement_notifications', achievementNotifications);
    await prefs.setBool('streak_notifications', streakNotifications);

    if (!studyReminders) {
      await cancelDailyReminders();
    }
  }

  Future<void> notifyChapterProgress(Chapter chapter) async {
    final prefs = await SharedPreferences.getInstance();
    final achievementNotificationsEnabled =
        prefs.getBool('achievement_notifications') ?? true;

    if (!achievementNotificationsEnabled) return;

    final completedCourses =
        chapter.courses.where((course) => course.isCompleted).length;
    final totalCourses = chapter.courses.length;

    if (completedCourses == totalCourses) {
      await _showAchievementNotification(
        'مبروك! 🎉',
        'أكملت جميع دروس الفصل: ${chapter.title}',
      );
    } else if (completedCourses > 0 && completedCourses == totalCourses ~/ 2) {
      await _showAchievementNotification(
        'أحسنت! 🌟',
        'أكملت نصف دروس الفصل: ${chapter.title}',
      );
    }
  }

  Future<void> notifyStudyStreak(int streakDays) async {
    final prefs = await SharedPreferences.getInstance();
    final streakNotificationsEnabled =
        prefs.getBool('streak_notifications') ?? true;

    if (!streakNotificationsEnabled) return;

    await _showAchievementNotification(
      'سلسلة دراسة رائعة! 🔥',
      'حافظت على الدراسة لمدة $streakDays أيام متتالية',
    );
  }

  Future<void> _showAchievementNotification(String title, String body) async {
    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'achievements',
          'الإنجازات',
          channelDescription: 'إشعارات الإنجازات والتقدم',
          importance: Importance.high,
          priority: Priority.high,
          enableLights: true,
          enableVibration: true,
          icon: 'notification_icon',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  tz.TZDateTime _nextInstanceOfTime({required int hour, required int minute}) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    developer
        .log('Scheduling notification at ${scheduledDate.toIso8601String()}');

    return scheduledDate;
  }

  Future<void> testNotification() async {
    try {
      await _notificationsPlugin.show(
        99, // Test notification ID
        'اختبار الإشعارات',
        'هذا اختبار للتأكد من عمل الإشعارات',
        NotificationDetails(
          android: AndroidNotificationDetails(
            'test_channel',
            'اختبار',
            channelDescription: 'قناة اختبار الإشعارات',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );
      developer.log('Test notification sent successfully');
    } catch (e) {
      developer.log('Error sending test notification: $e');
    }
  }

  Future<bool> verifyNotificationSettings() async {
    try {
      final List<PendingNotificationRequest> pendingNotifications =
          await _notificationsPlugin.pendingNotificationRequests();

      developer.log('Pending notifications: ${pendingNotifications.length}');

      final prefs = await SharedPreferences.getInstance();
      final studyRemindersEnabled = prefs.getBool('study_reminders') ?? true;

      if (studyRemindersEnabled) {
        // Should have at least morning and evening reminders
        return pendingNotifications.length >= 2;
      }

      return true;
    } catch (e) {
      developer.log('Error verifying notification settings: $e');
      return false;
    }
  }
}
