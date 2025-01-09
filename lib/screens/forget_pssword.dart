import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/error_message.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      SamsungNotification.show(
        context,
        message: 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني',
        icon: Icons.task_alt_sharp,
        duration: const Duration(seconds: 5),
        type: NotificationType.success,
      );
      Navigator.pop(context);
    } catch (e) {
      SamsungNotification.show(
        context,
        message: 'حدث خطأ أثناء إرسال رابط إعادة تعيين كلمة المرور',
        icon: Icons.error_outline_outlined,
        duration: const Duration(seconds: 5),
        type: NotificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إعادة تعيين كلمة المرور'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'البريد الإلكتروني',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _resetPassword(context),
              child: Text('إرسال رابط إعادة تعيين كلمة المرور'),
            ),
          ],
        ),
      ),
    );
  }
}
