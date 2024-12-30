import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:novo_historians/screens/chatbot_screen.dart';
import 'package:novo_historians/screens/contact_info_screen.dart';
import 'package:novo_historians/screens/help_support_screen.dart';
import 'package:novo_historians/screens/home_screen.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../screens/profile_screen.dart';

class CustomScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  CustomScaffold({
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.end, // Align the title to the right
          children: [
            Text(
              title,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ],
        ),
        backgroundColor: Color(0xFFEBEBD3),
        iconTheme: IconThemeData(
            color: Colors.black), // Ensures the drawer icon is visible
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Directionality(
              textDirection: TextDirection.rtl, // Reverses the direction
              child: Consumer<UserProvider>(
                builder: (context, userProvider, _) {
                  final user = userProvider.user;
                  return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(); // Close the drawer
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                      },
                      child: UserAccountsDrawerHeader(
                        accountName: Text(
                          user?.name ?? 'تلميذ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        accountEmail: Text(
                          'السنة ${user?.year ?? 'غير محددة'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        currentAccountPicture: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(
                            user?.avatar ?? 'assets/avatars/default.png',
                          ),
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color(0xFF7A6C5D),
                              Color(0xFF9B8B7A),
                            ],
                          ),
                        ),
                      ));
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.home_filled, size: 30),
              title: Text(
                'الرئيسية',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.support_agent, size: 30),
              title: Text(
                'الدردشة',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatbotScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle_outlined, size: 30),
              title: Text(
                'الملف الشخصي',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
            ),
            /*ListTile(
              leading: Icon(Icons.notifications, size: 30),
              title: Text(
                'الإشعارات',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/notification',
                  (route) => false,
                );
              },
            ),*/
            ListTile(
              leading: Icon(Icons.help, size: 30),
              title: Text(
                'المساعدة والدعم',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HelpSupportScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.phone_in_talk_sharp, size: 30),
              title: Text(
                'معلومات الاتصال',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactInfoScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
    );
  }
}
