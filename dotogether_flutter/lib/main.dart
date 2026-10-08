import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/app_state.dart';
import 'screens/welcome_screen.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'client.dart';

void main() async {
  // Ensure Flutter engine integrations are ready
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Serverpod Client
  await initializeClient();

  // Set default status bar coloring to match our header styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  // Await initialization before running the UI root
  final appState = await AppState.create();

  runApp(
    ChangeNotifierProvider(
      create: (context) => appState,
      child: const DoTogetherApp(),
    ),
  );
}

ThemeData _buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  return ThemeData(
    useMaterial3: true,
    primaryColor: const Color(0xFF2196F3),
    scaffoldBackgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2196F3),
      primary: const Color(0xFF2196F3),
      secondary: Colors.blueAccent,
      brightness: brightness,
    ),
    // Input fields default text styling
    inputDecorationTheme: const InputDecorationTheme(
      // Keep input text or label styling consistent
      hintStyle: TextStyle(color: Colors.black54),
      labelStyle: TextStyle(color: Colors.black87),
    ),
    // Premium Typography and component spacing
    textTheme: const TextTheme(
      // TextField/TextFormField in Material 3 defaults text style to bodyLarge
      bodyLarge: TextStyle(
        fontSize: 16.0,
        letterSpacing: 0.1,
        color: Colors.black87,
      ),
      // AlertDialog content text defaults to contentTextStyle or bodyMedium
      bodyMedium: TextStyle(
        fontSize: 14.0,
        letterSpacing: 0.1,
      ),
      titleLarge: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.1,
      ),
    ),
    // Explicitly configure DialogThemeData so AlertDialog content text
    // respects theme brightness regardless of any bodyLarge or text field overrides
    dialogTheme: DialogThemeData(
      contentTextStyle: TextStyle(
        fontSize: 14.0,
        letterSpacing: 0.1,
        color: isDark ? Colors.white70 : Colors.black87,
      ),
      titleTextStyle: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.1,
        color: isDark ? Colors.white : Colors.black87,
      ),
    ),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

class DoTogetherApp extends StatefulWidget {
  const DoTogetherApp({super.key});

  @override
  State<DoTogetherApp> createState() => _DoTogetherAppState();
}

class _DoTogetherAppState extends State<DoTogetherApp> {
  @override
  void initState() {
    super.initState();
    _initializeNotificationServices();
  }

  Future<void> _initializeNotificationServices() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 2. Request System Permissions (Required for iOS; Safe to execute globally)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted messaging authorization.');

      // 3. Extract the Unique Device Registration Token and persist it to
      // the server so push notifications can target this device. Also
      // listen for token refreshes (tokens can rotate at any time) and keep
      // the server copy up to date.
      String? token = await messaging.getToken();
      debugPrint("FCM Device Token: $token");
      if (mounted) {
        await context.read<AppState>().registerDeviceToken(token);
      }
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        if (mounted) {
          context.read<AppState>().registerDeviceToken(newToken);
        }
      });

      // 4. FOREGROUND STREAM LISTENER (App is wide open and active)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (mounted) {
          context.read<AppState>().refreshProjects();
        }
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        // Manually build visual overlay banner since Android suppresses it in foreground
        if (notification != null && android != null) {
          AppState.localNotificationsPlugin.show(
            id: notification.hashCode,
            title: notification.title,
            body: notification.body,
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'High Importance Notifications',
                channelDescription: 'Channel for high importance notifications',
                icon: '@mipmap/ic_launcher', // Default system app icon
              ),
            ),
          );
        }
      });

      // 5. TERMINATED STATE INTERACTION (User clicks banner while app is completely closed)
      RemoteMessage? initialMessage = await FirebaseMessaging.instance
          .getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationRouting(initialMessage.data);
      }

      // 6. BACKGROUND STATE INTERACTION (User clicks banner while app is minimized)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (mounted) {
          context.read<AppState>().refreshProjects();
        }
        _handleNotificationRouting(message.data);
      });
    }
  }

  // Custom function to process metadata payloads and handle target navigation routing
  void _handleNotificationRouting(Map<String, dynamic> data) {
    debugPrint(
      "User engaged notification banner. Payload payload details: $data",
    );
    // Example target routing:
    // if (data.containsKey('route')) {
    //   Navigator.pushNamed(context, data['route']);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoTogether',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: (client.auth.isAuthenticated)
          ? const HomeScreen()
          : const WelcomeScreen(),
      onGenerateRoute: (settings) {
        // Intercept Firebase reCAPTCHA deep links and prevent Flutter Navigator errors
        if (settings.name != null && settings.name!.startsWith('/link')) {
          // Return a transparent route that immediately dismisses itself
          return PageRouteBuilder(
            opaque:
                false, // Prevents black screen by keeping underlying screen visible
            pageBuilder: (context, _, _) {
              FocusManager.instance.primaryFocus?.unfocus();
              // Pop immediately on the next frame so Navigator stays on AuthWithSmsScreen
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              });
              return const SizedBox.shrink();
            },
          );
        }
        return null; // Fall back to normal route handling
      },
    );
  }
}
