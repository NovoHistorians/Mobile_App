// notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/chapter_model.dart';
import '../models/course_model.dart';
import '../models/user_model.dart';

class StudyNotificationService {
  static final StudyNotificationService _instance =
      StudyNotificationService._internal();
  factory StudyNotificationService() => _instance;
  StudyNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleDailyStudyReminder(UserModel user) async {
    final nextCourse = _findNextUncompletedCourse(user);
    if (nextCourse != null) {
      await _notificationsPlugin.zonedSchedule(
        1,
        'حان وقت المراجعة! 📚',
        'لديك درس جديد في انتظارك: ${nextCourse.title}',
        _nextInstanceOfTime(hour: 10, minute: 0),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_study',
            'المراجعة اليومية',
            channelDescription: 'تذكيرات المراجعة اليومية',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  Future<void> notifyChapterProgress(Chapter chapter) async {
    final completedCourses =
        chapter.courses.where((course) => course.isCompleted).length;
    final totalCourses = chapter.courses.length;

    if (completedCourses == totalCourses) {
      await _notificationsPlugin.show(
        2,
        'مبروك! 🎉',
        'أكملت جميع دروس الفصل: ${chapter.title}',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'progress',
            'تقدم التعلم',
            channelDescription: 'إشعارات حول تقدم التعلم والإنجازات',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    } else if (completedCourses > 0 && completedCourses == totalCourses ~/ 2) {
      await _notificationsPlugin.show(
        3,
        'أحسنت! 🌟',
        'أكملت نصف دروس الفصل: ${chapter.title}',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'progress',
            'تقدم التعلم',
            channelDescription: 'إشعارات حول تقدم التعلم والإنجازات',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    }
  }

  Future<void> notifyQuizAvailable(Course course) async {
    if (!course.isCompleted && course.quiz != null) {
      await _notificationsPlugin.show(
        4,
        'اختبار جديد متاح! ✍️',
        'جرب معلوماتك في درس: ${course.title}',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'quiz',
            'الاختبارات',
            channelDescription: 'تذكيرات وتحديثات الاختبارات',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    }
  }

  Future<void> notifyStudyStreak(int streakDays) async {
    await _notificationsPlugin.show(
      5,
      'سلسلة دراسة رائعة! 🔥',
      'حافظت على الدراسة لمدة $streakDays أيام متتالية',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'progress',
          'تقدم التعلم',
          channelDescription: 'إشعارات حول تقدم التعلم والإنجازات',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> notifyInactivity() async {
    await _notificationsPlugin.show(
      6,
      'نفتقدك! 👋',
      'عد إلى الدراسة للحفاظ على تقدمك',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_study',
          'المراجعة اليومية',
          channelDescription: 'تذكيرات المراجعة اليومية',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  Course? _findNextUncompletedCourse(UserModel user) {
    for (var chapter in user.chapters) {
      for (var course in chapter.courses) {
        if (!course.isCompleted) {
          return course;
        }
      }
    }
    return null;
  }

  tz.TZDateTime _nextInstanceOfTime({required int hour, required int minute}) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
