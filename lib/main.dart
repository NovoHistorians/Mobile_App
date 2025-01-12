import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:novo_historians/providers/github_auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/foundation.dart' show kIsWeb; // For platform checks
import 'package:shared_preferences/shared_preferences.dart';

// Screens
import 'data/level_years.dart';
import 'providers/google_auth_provider.dart';
import 'screens/chatbot_screen.dart';
import 'screens/contact_info_screen.dart';
import 'screens/forget_pssword.dart';
import 'screens/help_support_screen.dart';
import 'screens/home_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/login_screen.dart';
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
import 'services/initilize.dart';
import 'services/openAi_service.dart';
import 'services/quiz_generator_service.dart';

// Utils and Config
import 'services/test.dart';
import 'services/test_2.dart';
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

    await clearHiveCache();

    final contentGenerationService = ContentGenerationService(
      modelUrl: 'https://api.groq.com/openai/v1/chat/completions',
      apiKey: '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',
      maxRetries: 3, // optional, defaults to 3
      initialRetryDelay: Duration(seconds: 1), // optional, defaults to 1 second
    );

    final databaseInitializationService = DatabaseInitializationService(
      contentGenerationService: contentGenerationService,
    );

    final prefs = await SharedPreferences.getInstance();

    // Check if Firestore data has already been initialized
    bool isInitialized =
        await databaseInitializationService.isDatabaseInitialized();

    if (!isInitialized) {
      await databaseInitializationService.initializeDatabase();
      print('تم تهيئة قاعدة البيانات بنجاح');
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
          ChangeNotifierProvider.value(value: userProvider),
          ChangeNotifierProvider(create: (_) => ContentProvider()),
          ChangeNotifierProvider(create: (_) => ProgressProvider()),
          ChangeNotifierProvider(
            create: (_) => QuizProvider(quizGenerator, prefs),
          ),
          ChangeNotifierProvider(create: (_) => ChatProvider(openAIService)),
          ChangeNotifierProvider(create: (_) => app_auth.AuthProvider()),
          ChangeNotifierProvider(create: (_) => googleAuthProvider()),
          ChangeNotifierProvider(create: (_) => gitHubAuthProvider()),
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
        '/login': (context) => LoginScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/home': (context) => HomeScreen(),
        '/chat': (context) => ChatbotScreen(),
        '/profile': (context) => ProfileScreen(),
        '/help': (context) => HelpSupportScreen(),
        '/terms': (context) => TermsServiceScreen(),
        '/privacy': (context) => PrivacyPolicyScreen(),
        '/contact': (context) => ContactInfoScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
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
          // Use a FutureBuilder to handle asynchronous loading of user data
          return FutureBuilder<void>(
            future: _loadUserData(context, snapshot.data!.uid),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // Check if the user has completed the welcome screen process
              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              final user = userProvider.user;

              // Check if the user has completed the welcome process
              if (user != null &&
                  user.level.isNotEmpty &&
                  user.year.isNotEmpty) {
                return HomeScreen(); // Redirect to HomeScreen
              } else {
                return WelcomeScreen(); // Redirect to WelcomeScreen
              }
            },
          );
        }

        // Return landing screen if not authenticated
        return LandingScreen();
      },
    );
  }

  Future<void> _loadUserData(BuildContext context, String userId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUserData(userId);
  }
}
