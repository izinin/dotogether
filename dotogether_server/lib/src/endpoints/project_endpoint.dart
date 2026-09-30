import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import '../generated/protocol.dart';

class ProjectEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Creates a new Project and its interactive checklist items.
  /// If the assignee phone matches an existing registered user, executorId is set immediately.
  Future<Project> createProject(
    Session session, {
    required String title,
    required String description,
    required String displayName,
    required String assigneePhone,
    required List<String> checklistTitles,
  }) async {
    final authUserId = session.authenticated?.authUserId;
    if (authUserId == null) {
      throw StateError('User is not authenticated');
    }

    // Get current user's profile to record ownerPhone
    final userProfile = await AppUserData.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );

    // Check if assignee is registered
    final cleanAssigneePhone = assigneePhone.trim();
    final assigneeProfile = await AppUserData.db.findFirstRow(
      session,
      where: (t) => t.phoneNumber.equals(cleanAssigneePhone),
    );

    // Create project
    final project = await Project.db.insertRow(
      session,
      Project(
        title: title.trim(),
        description: description.trim(),
        ownerId: authUserId,
        ownerPhone: userProfile?.phoneNumber,
        executorId: assigneeProfile?.authUserId,
        assigneePhone: cleanAssigneePhone,
        displayName: displayName.trim(),
        overallStatus: 'pending',
        createdAt: DateTime.now(),
      ),
    );

    // Insert checklist items
    final filteredTitles = checklistTitles
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    List<ChecklistItem> insertedItems = [];
    for (var i = 0; i < filteredTitles.length; i++) {
      final item = await ChecklistItem.db.insertRow(
        session,
        ChecklistItem(
          projectId: project.id!,
          title: filteredTitles[i],
          isCompleted: false,
          sortOrder: i,
        ),
      );
      insertedItems.add(item);
    }

    return project.copyWith(checklistItems: insertedItems);
  }

  /// Returns all projects created by the current user (Task Owner).
  Future<List<Project>> getCreatedProjects(Session session) async {
    final authUserId = session.authenticated?.authUserId;
    if (authUserId == null) return [];

    return await Project.db.find(
      session,
      where: (t) => t.ownerId.equals(authUserId),
      orderBy: (t) => t.createdAt.desc(),
      include: Project.include(
        checklistItems: ChecklistItem.includeList(),
      ),
    );
  }

  /// Returns all projects assigned to the current user (Task Executor).
  /// Matches either by executorId or by the user's registered phone number.
  Future<List<Project>> getReceivedProjects(Session session) async {
    final authUserId = session.authenticated?.authUserId;
    if (authUserId == null) return [];

    final userProfile = await AppUserData.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );
    final userPhone = userProfile?.phoneNumber;

    if (userPhone != null && userPhone.isNotEmpty) {
      return await Project.db.find(
        session,
        where: (t) =>
            t.executorId.equals(authUserId) |
            (t.assigneePhone.equals(userPhone) &
                t.ownerId.notEquals(authUserId)),
        orderBy: (t) => t.createdAt.desc(),
        include: Project.include(
          checklistItems: ChecklistItem.includeList(),
        ),
      );
    } else {
      return await Project.db.find(
        session,
        where: (t) => t.executorId.equals(authUserId),
        orderBy: (t) => t.createdAt.desc(),
        include: Project.include(
          checklistItems: ChecklistItem.includeList(),
        ),
      );
    }
  }

  /// Returns details of a specific project including all its checklist items.
  Future<Project?> getProjectDetails(Session session, int projectId) async {
    return await Project.db.findById(
      session,
      projectId,
      include: Project.include(
        checklistItems: ChecklistItem.includeList(
          orderBy: (t) => t.sortOrder,
        ),
      ),
    );
  }

  /// Toggles completion of a checklist item and automatically recalculates
  /// the overall project completion percentage and overallStatus ('pending', 'in_progress', 'completed').
  Future<Project> toggleChecklistItem(
    Session session, {
    required int itemId,
    required bool isCompleted,
  }) async {
    final item = await ChecklistItem.db.findById(session, itemId);
    if (item == null) {
      throw ArgumentError('ChecklistItem with id $itemId not found');
    }

    // Update item
    await ChecklistItem.db.updateRow(
      session,
      item.copyWith(
        isCompleted: isCompleted,
        completedAt: isCompleted ? DateTime.now() : null,
      ),
    );

    // Fetch all items for the project to recalculate status
    final allItems = await ChecklistItem.db.find(
      session,
      where: (t) => t.projectId.equals(item.projectId),
      orderBy: (t) => t.sortOrder,
    );

    final total = allItems.length;
    final completedCount = allItems.where((i) => i.isCompleted).length;

    String newStatus = 'pending';
    if (total > 0 && completedCount == total) {
      newStatus = 'completed';
    } else if (completedCount > 0) {
      newStatus = 'in_progress';
    }

    final project = await Project.db.findById(session, item.projectId);
    if (project == null) {
      throw ArgumentError('Project ${item.projectId} not found');
    }

    final updatedProject = await Project.db.updateRow(
      session,
      project.copyWith(overallStatus: newStatus),
    );

    return updatedProject.copyWith(checklistItems: allItems);
  }

  /// Allows explicit update of project status.
  Future<Project> updateProjectStatus(
    Session session, {
    required int projectId,
    required String status,
  }) async {
    final project = await Project.db.findById(session, projectId);
    if (project == null) {
      throw ArgumentError('Project $projectId not found');
    }

    return await Project.db.updateRow(
      session,
      project.copyWith(overallStatus: status),
    );
  }
}
