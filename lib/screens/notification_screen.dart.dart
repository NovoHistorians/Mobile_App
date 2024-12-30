import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import '../widgets/custom_scaffold.dart';
import 'dart:developer' as developer;

class NotificationSettingsScreen extends StatefulWidget {
  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final _notificationService = StudyNotificationService();
  bool _studyReminders = true;
  bool _achievementNotifications = true;
  bool _streakNotifications = true;
  TimeOfDay _morningReminder = TimeOfDay(hour: 10, minute: 0);
  TimeOfDay _eveningReminder = TimeOfDay(hour: 18, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _studyReminders = prefs.getBool('study_reminders') ?? true;
      _achievementNotifications =
          prefs.getBool('achievement_notifications') ?? true;
      _streakNotifications = prefs.getBool('streak_notifications') ?? true;

      // Load saved times
      final morningHour = prefs.getInt('morning_reminder_hour') ?? 10;
      final morningMinute = prefs.getInt('morning_reminder_minute') ?? 0;
      final eveningHour = prefs.getInt('evening_reminder_hour') ?? 18;
      final eveningMinute = prefs.getInt('evening_reminder_minute') ?? 0;

      _morningReminder = TimeOfDay(hour: morningHour, minute: morningMinute);
      _eveningReminder = TimeOfDay(hour: eveningHour, minute: eveningMinute);
    });
  }

  Future<void> _savePreferences() async {
    await _notificationService.updateNotificationSettings(
      studyReminders: _studyReminders,
      achievementNotifications: _achievementNotifications,
      streakNotifications: _streakNotifications,
    );

    if (_studyReminders) {
      await _notificationService.scheduleDailyStudyReminder(_morningReminder,
          type: 'morning');
      await _notificationService.scheduleDailyStudyReminder(_eveningReminder,
          type: 'evening');
    }
  }

  Future<void> _saveReminderTime(TimeOfDay time, String type) async {
    final prefs = await SharedPreferences.getInstance();
    if (type == 'morning') {
      await prefs.setInt('morning_reminder_hour', time.hour);
      await prefs.setInt('morning_reminder_minute', time.minute);
    } else {
      await prefs.setInt('evening_reminder_hour', time.hour);
      await prefs.setInt('evening_reminder_minute', time.minute);
    }
    await _notificationService.scheduleDailyStudyReminder(time, type: type);
    developer.log('Study Reminders: $_studyReminders');
    developer.log(
        'Morning Reminder: ${_morningReminder.hour}:${_morningReminder.minute}');
    developer.log(
        'Evening Reminder: ${_eveningReminder.hour}:${_eveningReminder.minute}');
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "الإشعارات",
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildSectionTitle('تذكيرات الدراسة'),
                  _buildNotificationSwitch(
                    'تذكيرات يومية',
                    _studyReminders,
                    (value) {
                      setState(() {
                        _studyReminders = value;
                      });
                      _savePreferences();
                    },
                    Icons.access_time,
                  ),
                  if (_studyReminders) ...[
                    _buildTimeSelector(
                      'تذكير الصباح',
                      _morningReminder,
                      (TimeOfDay? time) {
                        if (time != null) {
                          setState(() {
                            _morningReminder = time;
                          });
                        }
                      },
                    ),
                    _buildTimeSelector(
                      'تذكير المساء',
                      _eveningReminder,
                      (TimeOfDay? time) {
                        if (time != null) {
                          setState(() {
                            _eveningReminder = time;
                          });
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildSectionTitle('إشعارات الإنجازات'),
                  _buildNotificationSwitch(
                    'الإنجازات والجوائز',
                    _achievementNotifications,
                    (value) {
                      setState(() {
                        _achievementNotifications = value;
                      });
                      _savePreferences();
                    },
                    Icons.emoji_events,
                  ),
                  _buildNotificationSwitch(
                    'سلسلة الدراسة',
                    _streakNotifications,
                    (value) {
                      setState(() {
                        _streakNotifications = value;
                      });
                      _savePreferences();
                    },
                    Icons.local_fire_department,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF7A6C5D),
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildNotificationSwitch(
    String title,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF7A6C5D)),
        title: Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Color(0xFF7A6C5D),
        ),
      ),
    );
  }

  Widget _buildTimeSelector(
    String title,
    TimeOfDay time,
    Function(TimeOfDay?) onTimeSelected,
  ) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListTile(
        leading: Icon(Icons.access_time, color: Color(0xFF7A6C5D)),
        title: Text(title),
        trailing: TextButton(
          onPressed: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: time,
            );
            if (picked != null) {
              onTimeSelected(picked);
              await _saveReminderTime(
                picked,
                title.contains('الصباح') ? 'morning' : 'evening',
              );
            }
          },
          child: Text(
            '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: Color(0xFF7A6C5D),
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
