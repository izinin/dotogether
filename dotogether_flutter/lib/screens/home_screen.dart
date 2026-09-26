import 'package:dotogether_flutter/client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import 'projects_list_screen.dart';
import 'friends_screen.dart';
import 'welcome_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    // Dynamic list calculations for sub-labels matching items in corresponding screens
    int receivedCount = appState.receivedProjects.length;
    int createdCount = appState.createdProjects.length;

    String tasksSubtitle = receivedCount == 1
        ? '1 active task for you'
        : receivedCount > 1
        ? '$receivedCount active tasks for you'
        : 'no active tasks';
    String projectsSubtitle = createdCount == 1
        ? '1 active project'
        : createdCount > 1
        ? '$createdCount active projects'
        : 'no active projects';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        title: const Text(
          'Do together',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Developer indicators and sign out
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Sign Out',
            onPressed: () => _showSignOutDialog(context, appState),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // List Row 1: My tasks
            _buildNavigationItem(
              context,
              icon: Icons.menu_book, // Matches mockup book/map outline icon
              title: 'My tasks',
              subtitle: tasksSubtitle,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        const ProjectsListScreen(isReceivedMode: true),
                  ),
                );
              },
            ),
            const SizedBox(height: 28),

            // List Row 2: My projects
            _buildNavigationItem(
              context,
              icon: Icons.photo_outlined, // Matches mockup picture icon
              title: 'My projects',
              subtitle: projectsSubtitle,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        const ProjectsListScreen(isReceivedMode: false),
                  ),
                );
              },
            ),
            const SizedBox(height: 28),

            // List Row 3: My friends
            _buildNavigationItem(
              context,
              icon:
                  Icons.phone_enabled_outlined, // Matches mockup telephone icon
              title: 'My friends',
              subtitle: 'find and assign tasks',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FriendsScreen(),
                  ),
                );
              },
            ),

            const Spacer(),
            // Developer Notice (Premium styling)
            if (appState.isDemoMode)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF2196F3)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Running in Demo Mode. Real-time lists and registration are simulated locally with screenshots mock data.',
                        style: TextStyle(color: Colors.black87, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container with modern grey coloring
            Icon(icon, size: 28, color: Colors.grey.shade600),
            const SizedBox(width: 24),
            // Text details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text(
          'Are you sure you want to sign out and register a different device?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              appState.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
            child: const Text('SIGN OUT', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
