import 'package:dotogether_flutter/client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import '../services/app_state.dart';
import 'auth_with_sms_screen.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInitialAuth();
    });
  }

  Future<void> _checkInitialAuth() async {
    if (!mounted) return;
    if (client.auth.isAuthenticated) {
      final appState = Provider.of<AppState>(context, listen: false);
      await appState.ensureUserInDatabase();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void _handleTutorial() {
    debugPrint('Starting tutorial in demo mode.');
    final appState = Provider.of<AppState>(context, listen: false);
    appState.startDemoMode();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    // If authenticated and finished loading, navigate to HomeScreen
    if (client.auth.isAuthenticated && !appState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    }

    final ButtonStyle authButtonStyle = OutlinedButton.styleFrom(
      foregroundColor: Colors.black87, // Dark text/icon color
      backgroundColor: Colors.white, // White background
      side: const BorderSide(
        color: Color(0xFFE0E0E0),
        width: 1,
      ), // Light border outline
      shape: const StadiumBorder(), // Pill rounded shape
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 0,
    );

    final ButtonStyle normalButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2196F3),
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 50),
      shape: const StadiumBorder(),
      elevation: 1,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(
          0xFF2196F3,
        ), // Vibrant Blue
        title: const Text(
          'Welcome',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // App Logo / Welcome Header
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.handshake_outlined,
                    size: 48,
                    color: Color(0xFF2196F3),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome to Do together',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Collaborate on tasks and projects effortlessly.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
              ),

              if (kIsWeb) ...[
                const SizedBox(height: 12),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF2196F3)),
                    SizedBox(width: 12),
                    Text(
                      'available only on Android and iOS devices',
                      style: TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                  ],
                ),
              ],
              const Spacer(),

              if (appState.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF2196F3),
                      ),
                    ),
                  ),
                )
              else ...[
                SizedBox(
                  width: 250, // Match width of Google Button
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: _handleTutorial,
                    icon: const Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Demo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: normalButtonStyle,
                  ),
                ),
                const SizedBox(height: 24),

                // Display inline error view if initialization failed
                if (appState.initializeError != null)
                  Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          appState.initializeError!,
                          style: TextStyle(color: Colors.black87, fontSize: 12),
                        ),
                      ),
                    ],
                  )
                else if (!kIsWeb)
                  SizedBox(
                    width: 250, // Match width of Google Button
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: _handleSignInWithSMS,
                      icon: const Icon(
                        Icons.sms_outlined,
                        color: Colors.blueGrey,
                      ),
                      label: const Text(
                        'Sign in with SMS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey,
                        ),
                      ),
                      style: authButtonStyle,
                    ),
                  ),
              ],
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSignInWithSMS() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const AuthWithSmsScreen()),
    );
  }
}
