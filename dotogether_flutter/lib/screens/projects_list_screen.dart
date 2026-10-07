import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import 'package:dotogether_client/dotogether_client.dart';
import 'task_details_screen.dart';

class ProjectsListScreen extends StatelessWidget {
  final bool
  isReceivedMode; // true: My Tasks (assigned to me), false: My Projects (assigned to others)

  const ProjectsListScreen({super.key, required this.isReceivedMode});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    // Select the correct list based on the navigation path
    final projects = isReceivedMode
        ? appState.receivedProjects
        : appState.createdProjects;

    final pageTitle = isReceivedMode ? 'My tasks' : 'My projects';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          pageTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: projects.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isReceivedMode
                        ? Icons.assignment_outlined
                        : Icons.assignment_turned_in_outlined,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isReceivedMode
                        ? 'You do not have any tasks assigned to you.'
                        : 'You have not created any projects yet.',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return _buildProjectTile(
                  pageTitle,
                  context,
                  project,
                  isReceivedMode,
                );
              },
            ),
    );
  }

  Widget _buildProjectTile(
    String pageTitle,
    BuildContext context,
    Project project,
    bool isReceivedMode,
  ) {
    // Determine the status icon and coloring based on project status
    // Matches screenshot 1 exactly:
    // - Red calendar icon for completely pending (0% done)
    // - Green checked icon for completed (100% done)
    // - Blue history/clock icon for in_progress
    IconData statusIcon = Icons.calendar_today_outlined;
    Color iconColor = Colors.red;

    if (project.overallStatus == 'completed') {
      statusIcon = Icons.check_circle;
      iconColor = const Color(0xFF4CAF50); // Premium Green
    } else if (project.overallStatus == 'in_progress') {
      statusIcon =
          Icons.history; // Matches clock/time logo from David Taylor item
      iconColor = const Color(0xFF2196F3); // Premium Blue
    } else {
      // Pending
      statusIcon = Icons.calendar_today; // Calendar with date indicator
      iconColor = const Color(0xFFE53935); // Solid Red
    }

    return InkWell(
      onTap: () {
        // Navigate to the checklist details page
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TaskDetailsScreen(
              title: pageTitle,
              project: project,
              isReadOnly:
                  !isReceivedMode, // Assignees can check boxes, creators read progress
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Icon with color
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Icon(statusIcon, size: 24, color: iconColor),
            ),
            const SizedBox(width: 24),
            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isReceivedMode
                        ? project.owner?.name ?? ''
                        : project.assignee?.name ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    project.title,
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
}
