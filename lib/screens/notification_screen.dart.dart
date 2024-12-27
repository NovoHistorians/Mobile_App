import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import '../widgets/custom_scaffold.dart';

class NotificationSettingsScreen extends StatefulWidget {
  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
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
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('study_reminders', _studyReminders);
    await prefs.setBool('achievement_notifications', _achievementNotifications);
    await prefs.setBool('streak_notifications', _streakNotifications);
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
            onTimeSelected(picked);
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
