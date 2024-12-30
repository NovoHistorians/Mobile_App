// terms_service_screen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_scaffold.dart';

class TermsServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "شروط الخدمة",
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'شروط الخدمة',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7A6C5D),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'يرجى قراءة شروط الخدمة التالية بعناية قبل استخدام التطبيق:',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildSection(
              title: '1. قبول الشروط',
              content:
                  'عند استخدام هذا التطبيق، فإنك توافق على الالتزام بشروط الخدمة الحالية. إذا كنت لا توافق على أي جزء منها، يرجى عدم استخدام التطبيق.',
            ),
            SizedBox(height: 16),
            _buildSection(
              title: '2. استخدام التطبيق',
              content:
                  'هذا التطبيق مصمم للاستخدام الشخصي فقط. يُحظر استخدامه لأي أغراض غير قانونية أو غير مصرح بها. يجب أن تلتزم بجميع القوانين واللوائح المعمول بها أثناء استخدامك للتطبيق.',
            ),
            SizedBox(height: 16),
            _buildSection(
              title: '3. حقوق الملكية الفكرية',
              content:
                  'جميع حقوق الملكية الفكرية المتعلقة بالمحتوى والمواد المتوفرة في هذا التطبيق محفوظة لمالك التطبيق. يُمنع نسخ أو تعديل أو توزيع أي محتوى دون الحصول على إذن مسبق.',
            ),
            SizedBox(height: 16),
            _buildSection(
              title: '4. المسؤولية',
              content:
                  'لا يتحمل التطبيق أو مالكه أي مسؤولية عن أي أضرار مباشرة أو غير مباشرة قد تنتج عن استخدام التطبيق. يُستخدم التطبيق "كما هو" دون أي ضمانات صريحة أو ضمنية.',
            ),
            SizedBox(height: 16),
            _buildSection(
              title: '5. تعديلات الشروط',
              content:
                  'نحتفظ بالحق في تعديل شروط الخدمة في أي وقت. سيتم إشعار المستخدمين بأي تغييرات كبيرة، ويعتبر استمرار استخدام التطبيق بعد التعديلات موافقة ضمنية على الشروط الجديدة.',
            ),
            SizedBox(height: 16),
            Text(
              'إذا كان لديك أي استفسارات حول شروط الخدمة، يرجى التواصل معنا عبر البريد الإلكتروني: support@example.com',
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
