// privacy_policy_screen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_scaffold.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "سياسة الخصوصية",
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'سياسة الخصوصية',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7A6C5D),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'نحن نقدر خصوصيتك ونلتزم بحماية بياناتك الشخصية. يرجى قراءة سياسة الخصوصية التالية لفهم كيفية جمع البيانات واستخدامها وحمايتها:',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildSection(
              title: '1. جمع البيانات',
              content:
                  'نقوم بجمع بياناتك الشخصية عند استخدامك للتطبيق، مثل اسمك والمعلومات الأخرى التي تقدمها طواعية.',
            ),
            SizedBox(height: 16),
            _buildSection(
              title: '2. استخدام البيانات',
              content:
                  'نستخدم البيانات التي نجمعها لتحسين خدماتنا، توفير تجربة مستخدم أفضل، والتواصل معك عند الحاجة.',
            ),
            SizedBox(height: 16),
            _buildSection(
              title: '3. حماية البيانات',
              content:
                  'نحن نستخدم إجراءات أمان متقدمة لضمان حماية بياناتك الشخصية من الوصول غير المصرح به أو التغيير أو الإفصاح.',
            ),
            SizedBox(height: 16),
            _buildSection(
              title: '4. مشاركة البيانات',
              content:
                  'لن نقوم بمشاركة بياناتك الشخصية مع أي طرف ثالث بدون موافقتك، إلا إذا كان ذلك مطلوبًا بموجب القانون.',
            ),
            SizedBox(height: 16),
            _buildSection(
              title: '5. ملفات تعريف الارتباط',
              content:
                  'قد نستخدم ملفات تعريف الارتباط لجمع بيانات إضافية حول كيفية استخدامك للتطبيق، بهدف تحسين أدائنا.',
            ),
            SizedBox(height: 16),
            _buildSection(
              title: '6. حقوقك',
              content:
                  'لديك الحق في الوصول إلى بياناتك الشخصية، تعديلها، أو طلب حذفها في أي وقت. إذا كنت ترغب في ممارسة هذه الحقوق، يرجى التواصل معنا.',
            ),
            SizedBox(height: 16),
            Text(
              'إذا كانت لديك أي استفسارات حول سياسة الخصوصية، يرجى التواصل معنا عبر البريد الإلكتروني: privacy@example.com',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7A6C5D),
          ),
        ),
        SizedBox(height: 8),
        Text(
          content,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
