// help_support_screen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_scaffold.dart';

class HelpSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "المساعدة والدعم",
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'المساعدة والدعم',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7A6C5D),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'ستجد هنا إجابات على الأسئلة الشائعة حول استخدام التطبيق. إذا كنت بحاجة إلى مزيد من المساعدة، يمكنك التواصل معنا عبر البريد الإلكتروني أو الهاتف.',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildHelpSection(
              'كيف يمكنني استخدام التطبيق؟',
              'يمكنك استخدام التطبيق من خلال تسجيل الدخول باستخدام بياناتك. بعد تسجيل الدخول، ستتمكن من تصفح جميع الميزات المتاحة واستخدامها بسهولة.',
            ),
            SizedBox(height: 16),
            _buildHelpSection(
              'كيف يمكنني تغيير إعدادات حسابي؟',
              'لتغيير إعدادات حسابك، انتقل إلى قسم "الملف الشخصي" من القائمة، ثم اختر "إعدادات الحساب" وقم بإجراء التغييرات المطلوبة.',
            ),
            SizedBox(height: 16),
            _buildHelpSection(
              'كيف يمكنني الإبلاغ عن مشكلة؟',
              'إذا واجهت أي مشكلة أثناء استخدام التطبيق، يمكنك الإبلاغ عنها من خلال قسم "اتصل بنا" الموجود في القائمة الرئيسية. يرجى تقديم تفاصيل واضحة لمساعدتنا في حل المشكلة بسرعة.',
            ),
            SizedBox(height: 16),
            _buildHelpSection(
              'هل يمكنني استخدام التطبيق دون اتصال بالإنترنت؟',
              'يمكنك الوصول إلى بعض الميزات دون اتصال بالإنترنت، ولكن الميزات التي تتطلب مزامنة مع الخادم ستحتاج إلى اتصال إنترنت نشط.',
            ),
            SizedBox(height: 16),
            _buildHelpSection(
              'كيف يمكنني التواصل مع الدعم الفني؟',
              'للتواصل مع الدعم الفني، يمكنك إرسال بريد إلكتروني إلى support@example.com أو الاتصال بنا عبر الهاتف على الرقم 123456789.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection(String question, String answer) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF7A6C5D),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              answer,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
