import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/project.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Project project;
  final bool
  isReadOnly; // true for creator (read-only), false for assignee (can tick checkmarks)

  const TaskDetailsScreen({
    super.key,
    required this.project,
    required this.isReadOnly,
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    // Find the latest state of this project in the app state to ensure real-time changes are shown
    final latestProject = _findLatestProject(appState) ?? project;
    final double completion = latestProject.completionPercentage;
    final int completedCount = latestProject.todos
        .where((t) => t.isCompleted)
        .length;
    final int totalCount = latestProject.todos.length;

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
          latestProject.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card (Assigned information & Status indicator)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isReadOnly
                              ? Icons.assignment_ind_outlined
                              : Icons.assignment_outlined,
                          size: 24,
                          color: const Color(0xFF2196F3),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isReadOnly ? 'Assigned to:' : 'Assigned by:',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isReadOnly
                              ? latestProject.assigneeName
                              : 'Hank M. Zakroff',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 36),
                        const Text(
                          'Description:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            latestProject.description,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),

                    // Progress Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Overall execution',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          '${(completion * 100).toInt()}% ($completedCount/$totalCount done)',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2196F3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Visual horizontal progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: completion,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF2196F3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Status Badge
                    Row(
                      children: [
                        const Text(
                          'Status: ',
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusBgColor(latestProject.status),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            latestProject.status
                                .replaceAll('_', ' ')
                                .toUpperCase(),
                            style: TextStyle(
                              color: _getStatusTextColor(latestProject.status),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Checklist Section Header
              const Text(
                'CHECKLIST ITEMS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12),

              // Checklist Items List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: latestProject.todos.length,
                itemBuilder: (context, index) {
                  final item = latestProject.todos[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: InkWell(
                      onTap: isReadOnly
                          ? null // Locked in creator view
                          : () {
                              appState.toggleTask(
                                latestProject,
                                index,
                                !item.isCompleted,
                              );
                            },
                      borderRadius: BorderRadius.circular(8),
                      child: Row(
                        children: [
                          // Custom Checkbox
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: isReadOnly
                                ? Icon(
                                    item.isCompleted
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: item.isCompleted
                                        ? const Color(0xFF4CAF50)
                                        : Colors.grey.shade400,
                                    size: 24,
                                  )
                                : Checkbox(
                                    value: item.isCompleted,
                                    activeColor: const Color(0xFF2196F3),
                                    onChanged: (val) {
                                      if (val != null) {
                                        appState.toggleTask(
                                          latestProject,
                                          index,
                                          val,
                                        );
                                      }
                                    },
                                  ),
                          ),
                          const SizedBox(width: 8),
                          // Label text with strike-through if completed
                          Expanded(
                            child: Text(
                              item.text,
                              style: TextStyle(
                                fontSize: 16,
                                color: item.isCompleted
                                    ? Colors.grey
                                    : Colors.black87,
                                decoration: item.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                fontWeight: item.isCompleted
                                    ? FontWeight.normal
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              if (isReadOnly) ...[
                const SizedBox(height: 40),
                // Locked Notice card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lock_outline, color: Colors.grey, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'This is your project. The assignee must tick the checkmarks to report executing status.',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Project? _findLatestProject(AppState appState) {
    // Looks up project by ID in local streams to reflect real-time changes instantly
    try {
      final list = isReadOnly
          ? appState.createdProjects
          : appState.receivedProjects;
      return list.firstWhere((p) => p.id == project.id);
    } catch (_) {
      return null;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green.shade50;
      case 'in_progress':
        return Colors.blue.shade50;
      default:
        return Colors.red.shade50;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'completed':
        return const Color(0xFF4CAF50);
      case 'in_progress':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFFE53935);
    }
  }
}
