import 'package:flutter/material.dart';
import 'package:novo_historians/screens/contact_info_screen.dart';
import 'package:novo_historians/screens/help_support_screen.dart';
import 'package:novo_historians/screens/privacy_policy_screen.dart';
import 'package:novo_historians/screens/terms_service_screen.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'screens/chatbot_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/notification_screen.dart.dart';
import 'screens/profile_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';
import 'utils/theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // Add other providers here
      ],
      child: AlgerianHistoryApp(),
    ),
  );
}

class AlgerianHistoryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Algerian History',
      theme: appTheme,
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => LandingScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/home': (context) => HomeScreen(),
        '/chat': (context) => ChatbotScreen(),
        '/profile': (context) => ProfileScreen(),
        '/notification': (context) => NotificationSettingsScreen(),
        '/help': (context) => HelpSupportScreen(),
        '/terms': (context) => TermsServiceScreen(),
        '/privacy': (context) => PrivacyPolicyScreen(),
        '/contact': (context) => ContactInfoScreen()
      },
    );
  }
}
