/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';

// Screens

// Utils and Config
import 'providers/chat_provider.dart';
import 'providers/content_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/user_provider.dart';
import 'providers/auth_provider.dart' as app_auth;
import 'screens/chatbot_screen.dart';
import 'screens/contact_info_screen.dart';
import 'screens/help_support_screen.dart';
import 'screens/home_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/notification_screen.dart.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/terms_service_screen.dart';
import 'screens/welcome_screen.dart';
import 'services/firebase_init_service.dart';
import 'services/openAi_service.dart';
import 'services/quiz_generator_service.dart';
import 'utils/theme.dart';
import 'firebase_options.dart';

// Initialize global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Initialize Hive boxes
Future<void> initHiveBoxes() async {
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  await Hive.openBox('authBox');
  await Hive.openBox('contentBox');
  await Hive.openBox('progressBox');
  await Hive.openBox('userBox');
}

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Configure Firestore settings
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // Initialize Hive
    await initHiveBoxes();

    final prefs = await SharedPreferences.getInstance();
    bool isInitialized = prefs.getBool('education_system_initialized') ?? false;

    // Initialize education content if needed
    if (!isInitialized) {
      print('Initializing education content...');
      final firebaseInit = FirebaseInitService();
      await firebaseInit.initializeEducationContent();
      await prefs.setBool('education_system_initialized', true);
    }

    // Initialize services
    final openAIService = OpenAIService(
        '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');
    final quizGenerator = QuizGeneratorService(
        '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');

    // Create single UserProvider instance
    final userProvider = UserProvider();
    await userProvider.initializeUser();

    // Run app with providers
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
              value: userProvider), // Use existing instance
          ChangeNotifierProvider(create: (_) => ContentProvider()),
          ChangeNotifierProvider(create: (_) => ProgressProvider()),
          ChangeNotifierProvider(
            create: (_) => QuizProvider(quizGenerator, prefs),
          ),
          ChangeNotifierProvider(create: (_) => ChatProvider(openAIService)),
          ChangeNotifierProvider(create: (_) => app_auth.AuthProvider()),
        ],
        child: const AlgerianHistoryApp(),
      ),
    );
  } catch (e) {
    print('Error initializing app: $e');
  }
}

class AlgerianHistoryApp extends StatelessWidget {
  const AlgerianHistoryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Algerian History',
      theme: appTheme,
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/welcome': (context) => WelcomeScreen(),
        '/home': (context) => HomeScreen(),
        '/chat': (context) => ChatbotScreen(),
        '/profile': (context) => ProfileScreen(),
        '/notification': (context) => NotificationSettingsScreen(),
        '/help': (context) => HelpSupportScreen(),
        '/terms': (context) => TermsServiceScreen(),
        '/privacy': (context) => PrivacyPolicyScreen(),
        '/contact': (context) => ContactInfoScreen(),
      },
      builder: (context, child) {
        // Add error handling for the entire app
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  const Text(
                    'Something went wrong',
                    style: TextStyle(fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                    child: const Text('Return to Home'),
                  ),
                ],
              ),
            ),
          );
        };
        return child!;
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _checkSessionExpiry();
  }

  Future<void> _checkSessionExpiry() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final metadata = user.metadata;
        final lastSignIn = metadata.lastSignInTime;
        final now = DateTime.now();
        final difference = now.difference(lastSignIn!);

        // Check for session expiry (30 days)
        if (difference.inDays > 30) {
          await FirebaseAuth.instance.signOut();
          // Clear local storage
          await Hive.box('authBox').clear();
          await Hive.box('userBox').clear();
        }
      }
    } catch (e) {
      print('Error checking session expiry: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Handle connection states
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Handle errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  TextButton(
                    onPressed: () {
                      setState(() {}); // Retry
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // Check authentication state
        if (snapshot.hasData) {
          // Initialize user data if authenticated
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.loadUserData(snapshot.data!.uid);
          return HomeScreen();
        }

        // Return landing screen if not authenticated
        return LandingScreen();
      },
    );
  }
}
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/foundation.dart' show kIsWeb; // For platform checks
import 'package:shared_preferences/shared_preferences.dart';

// Screens
import 'screens/chatbot_screen.dart';
import 'screens/contact_info_screen.dart';
import 'screens/help_support_screen.dart';
import 'screens/home_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/terms_service_screen.dart';
import 'screens/welcome_screen.dart';

// Providers
import 'providers/chat_provider.dart';
import 'providers/content_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/user_provider.dart';
import 'providers/auth_provider.dart' as app_auth;

// Services
import 'services/firebase_init_service.dart';
import 'services/openAi_service.dart';
import 'services/quiz_generator_service.dart';

// Utils and Config
import 'utils/theme.dart';
import 'firebase_options.dart';

// Initialize global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Initialize Hive boxes (skip on web)
Future<void> initHiveBoxes() async {
  if (!kIsWeb) {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    await Hive.openBox('authBox');
    await Hive.openBox('contentBox');
    await Hive.openBox('progressBox');
    await Hive.openBox('userBox');
  }
}

// Get application documents directory (mobile only)
Future<String> getApplicationDocumentsDirectory() async {
  if (kIsWeb) {
    throw UnsupportedError(
        'getApplicationDocumentsDirectory is not supported on the web.');
  }
  final dir = await path_provider.getApplicationDocumentsDirectory();
  return dir.path;
}

Future<void> clearHiveCache() async {
  try {
    final box = await Hive.openBox('contentBox'); // Replace with your box name
    await box.clear();
    print('Hive cache cleared successfully');
  } catch (e) {
    print('Error clearing Hive cache: $e');
  }
}

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Configure Firestore settings
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // Initialize Hive (skip on web)
    await initHiveBoxes();

    // Clear Hive cache (for development only)
    const bool isDevelopment = true; // Set this to false in production
    if (isDevelopment) {
      await clearHiveCache();
    }

    // Initialize SharedPreferences (works on both web and mobile)
    final prefs = await SharedPreferences.getInstance();
    bool isInitialized = prefs.getBool('education_system_initialized') ?? false;

    // Initialize education content if needed
    if (!isInitialized) {
      print('Initializing education content...');
      final firebaseInit = FirebaseInitService();
      await firebaseInit.initializeEducationContent();
      await prefs.setBool('education_system_initialized', true);
    }

    // Initialize services
    final openAIService = OpenAIService(
        '');
    final quizGenerator = QuizGeneratorService(
        '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');

    // Create single UserProvider instance
    final userProvider = UserProvider();
    await userProvider.initializeUser();

    // Run app with providers
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: userProvider),
          ChangeNotifierProvider(create: (_) => ContentProvider()),
          ChangeNotifierProvider(create: (_) => ProgressProvider()),
          ChangeNotifierProvider(
            create: (_) => QuizProvider(quizGenerator, prefs),
          ),
          ChangeNotifierProvider(create: (_) => ChatProvider(openAIService)),
          ChangeNotifierProvider(create: (_) => app_auth.AuthProvider()),
        ],
        child: const AlgerianHistoryApp(),
      ),
    );
  } catch (e) {
    print('Error initializing app: $e');
  }
}

class AlgerianHistoryApp extends StatelessWidget {
  const AlgerianHistoryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Algerian History',
      theme: appTheme,
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/welcome': (context) => WelcomeScreen(),
        '/home': (context) => HomeScreen(),
        '/chat': (context) => ChatbotScreen(),
        '/profile': (context) => ProfileScreen(),
        '/help': (context) => HelpSupportScreen(),
        '/terms': (context) => TermsServiceScreen(),
        '/privacy': (context) => PrivacyPolicyScreen(),
        '/contact': (context) => ContactInfoScreen(),
      },
      builder: (context, child) {
        // Add error handling for the entire app
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  const Text(
                    'Something went wrong',
                    style: TextStyle(fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                    child: const Text('Return to Home'),
                  ),
                ],
              ),
            ),
          );
        };
        return child!;
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _checkSessionExpiry();
  }

  Future<void> _checkSessionExpiry() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final metadata = user.metadata;
        final lastSignIn = metadata.lastSignInTime;
        final now = DateTime.now();
        final difference = now.difference(lastSignIn!);

        // Check for session expiry (30 days)
        if (difference.inDays > 30) {
          await FirebaseAuth.instance.signOut();
          // Clear local storage (skip on web)
          if (!kIsWeb) {
            await Hive.box('authBox').clear();
            await Hive.box('userBox').clear();
          }
        }
      }
    } catch (e) {
      print('Error checking session expiry: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Handle connection states
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Handle errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  TextButton(
                    onPressed: () {
                      setState(() {}); // Retry
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // Check authentication state
        if (snapshot.hasData) {
          // Initialize user data if authenticated
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.loadUserData(snapshot.data!.uid);
          return HomeScreen();
        }

        // Return landing screen if not authenticated
        return LandingScreen();
      },
    );
  }
}
