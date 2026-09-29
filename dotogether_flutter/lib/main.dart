import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'services/app_state.dart';
import 'screens/welcome_screen.dart';

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

class DoTogetherApp extends StatelessWidget {
  const DoTogetherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoTogether',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const WelcomeScreen(),
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
