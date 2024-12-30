// contact_info_screen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_scaffold.dart';

class ContactInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "معلومات الاتصال",
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 16),
            Text(
              'يمكنك التواصل معنا عبر القنوات التالية:',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildContactSection(
              title: 'البريد الإلكتروني',
              content: 'support@example.com',
              icon: Icons.email,
            ),
            SizedBox(height: 16),
            _buildContactSection(
              title: 'رقم الهاتف',
              content: '+213 123 456 789',
              icon: Icons.phone,
            ),
            SizedBox(height: 16),
            _buildContactSection(
              title: 'العنوان',
              content: 'القطب الجامعي سيدي عبد الله، الجزائر العاصمة، الجزائر',
              icon: Icons.location_on,
            ),
            SizedBox(height: 16),
            _buildContactSection(
              title: 'ساعات العمل',
              content: 'من الأحد إلى الخميس: 9:00 صباحًا - 5:00 مساءً',
              icon: Icons.access_time,
            ),
            SizedBox(height: 16),
            Text(
              'إذا كان لديك أي استفسارات إضافية، يرجى عدم التردد في التواصل معنا عبر الوسائل المذكورة أعلاه. نحن هنا لخدمتك!',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Color(0xFF7A6C5D),
        ),
        title: Text(
          title,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF7A6C5D),
          ),
        ),
        subtitle: Text(
          content,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
