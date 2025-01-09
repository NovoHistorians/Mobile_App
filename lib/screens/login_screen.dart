import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import '../components/error_message.dart';
import '../components/name_input.dart';
import '../components/welcome_message.dart';
import '../providers/github_auth_provider.dart';
import '../providers/google_auth_provider.dart';
import '../providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Provider.of<UserProvider>(context, listen: false).login(
        _emailController.text,
        _passwordController.text,
      );

      final user = Provider.of<UserProvider>(context, listen: false).user;
      if (user != null && user.level.isNotEmpty && user.year.isNotEmpty) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'البريد الإلكتروني غير موجود';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'كلمة المرور غير صحيحة';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'البريد الإلكتروني غير صحيح';
      } else {
        errorMessage = 'حدث خطأ أثناء تسجيل الدخول';
      }
      SamsungNotification.show(
        context,
        message: errorMessage,
        icon: Icons.warning_amber_rounded,
        duration: const Duration(seconds: 5),
        type: NotificationType.error,
      );
    } catch (e) {
      SamsungNotification.show(
        context,
        message: 'حدث خطأ غير متوقع',
        icon: Icons.warning_amber_rounded,
        duration: const Duration(seconds: 3),
        type: NotificationType.error,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        SamsungNotification.show(
          context,
          message: 'كلمات المرور غير متطابقة',
          icon: Icons.password_outlined,
          duration: const Duration(seconds: 5),
          type: NotificationType.error,
        );
      });
      return;
    }

    if (_passwordController.text.length < 6) {
      setState(() {
        SamsungNotification.show(
          context,
          message: 'كلمة المرور يجب أن تكون على الأقل 6 أحرف',
          icon: Icons.password_outlined,
          duration: const Duration(seconds: 5),
          type: NotificationType.warning,
        );
      });
      return;
    }

    if (!_emailController.text.contains('@')) {
      setState(() {
        SamsungNotification.show(
          context,
          message: 'البريد الإلكتروني غير صحيح',
          icon: Icons.password_outlined,
          duration: const Duration(seconds: 5),
          type: NotificationType.error,
        );
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Provider.of<UserProvider>(context, listen: false).signUp(
        _emailController.text,
        _passwordController.text,
        '', // Default name (empty for now)
        '', // Default level (empty for now)
        '', // Default year (empty for now)
        null, // No department
      );

      Navigator.pushReplacementNamed(context, '/welcome');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage = 'البريد الإلكتروني مستخدم بالفعل';
      } else {
        errorMessage = 'حدث خطأ أثناء إنشاء الحساب: ${e.message}';
      }
      SamsungNotification.show(
        context,
        message: errorMessage,
        icon: Icons.email,
        duration: const Duration(seconds: 5),
        type: NotificationType.error,
      );
    } catch (e) {
      SamsungNotification.show(
        context,
        message: 'حدث خطأ غير متوقع',
        icon: Icons.warning_amber_rounded,
        duration: const Duration(seconds: 3),
        type: NotificationType.error,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleNetworkError() async {
    try {
      // Simulate a network request
      await Future.delayed(Duration(seconds: 1));
      throw Exception('No internet connection');
    } catch (e) {
      SamsungNotification.show(
        context,
        message: 'لا يوجد اتصال بالإنترنت',
        icon: Icons.wifi_off,
        duration: const Duration(seconds: 3),
        type: NotificationType.warning,
      );
    }
  }

  /*Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await Provider.of<googleAuthProvider>(context, listen: false)
          .signInWithGoogle();
      if (user != null) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.loadUserData(user.uid);

        // Check if the user has completed the welcome screen process
        if (userProvider.user != null &&
            userProvider.user!.level.isNotEmpty &&
            userProvider.user!.year.isNotEmpty) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/welcome');
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ أثناء تسجيل الدخول باستخدام Google: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleGitHubSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await Provider.of<gitHubAuthProvider>(context, listen: false)
          .signInWithGitHub();
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ أثناء تسجيل الدخول باستخدام GitHub: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              WelcomeMessage(),
              SizedBox(height: 20),
              NameInput(
                controller: _emailController,
                hintText: 'ادخل بريدك الإلكتروني',
                labelText: 'البريد الإلكتروني',
              ),
              SizedBox(height: 20),
              NameInput(
                controller: _passwordController,
                hintText: 'ادخل كلمة المرور',
                labelText: 'كلمة المرور',
                isPassword: true,
              ),
              if (!_isLogin)
                Column(
                  children: [
                    SizedBox(height: 20),
                    NameInput(
                      controller: _confirmPasswordController,
                      hintText: 'أعد إدخال كلمة المرور',
                      labelText: 'تأكيد كلمة المرور',
                      isPassword: true,
                    ),
                  ],
                ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.right,
                  ),
                ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: _isLogin ? _login : _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7A6C5D),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    textStyle:
                        TextStyle(fontSize: 18, color: Color(0xFFFFFFFF)),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    _isLogin ? 'تسجيل الدخول' : 'إنشاء حساب',
                    style: TextStyle(
                      fontSize: 25,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(
                  _isLogin
                      ? 'إنشاء حساب جديد'
                      : 'لديك حساب بالفعل؟ تسجيل الدخول',
                  style: TextStyle(color: Color(0xFF7A6C5D)),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot-password');
                },
                child: Text(
                  'نسيت كلمة المرور؟',
                  style: TextStyle(color: Color(0xFF7A6C5D)),
                ),
              ),
              SizedBox(height: 20),
              /*Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SignInButton(
                      padding: EdgeInsets.all(10),
                      shape: Border.all(width: double.minPositive),
                      Buttons.Google,
                      text: "Google",
                      onPressed: _handleGoogleSignIn,
                    ),
                    SizedBox(height: 10),
                    SignInButton(
                      Buttons.GitHub,
                      text: "GitHub",
                      onPressed: _handleGitHubSignIn,
                    )
                  ],
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
