import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import '../generated/protocol.dart';

class ProjectEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Creates a new Project. Finds (or creates) the Contact records that
  /// represent the owner (the creator's own entry in their address book)
  /// and the assignee, then creates the Project referencing both.
  /// If the assignee phone matches an existing registered user, the
  /// assignee Contact is immediately marked as registered.
  Future<Project> createProject(
    Session session, {
    required String title,
    required String description,
    required String assigneeName,
    required String assigneePhone,
    required List<String> checklistTitles,
  }) async {
    final authUserId = session.authenticated?.authUserId;
    if (authUserId == null) {
      throw StateError('User is not authenticated');
    }

    // Get current user's profile to build/find their own Contact record.
    final userProfile = await AppUserData.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );
    if (userProfile == null) {
      throw StateError('User profile not found');
    }
    final ownerPhone = userProfile.phoneNumber;

    // Check if assignee is registered
    final cleanAssigneePhone = assigneePhone.trim();
    final cleanAssigneeName = assigneeName.trim();
    final assigneeProfile = await AppUserData.db.findFirstRow(
      session,
      where: (t) => t.phoneNumber.equals(cleanAssigneePhone),
    );

    // Find or create the Contact record representing the project owner
    // (the creator's own entry in their own address book).
    var ownerContact = await Contact.db.findFirstRow(
      session,
      where: (t) =>
          t.ownerId.equals(authUserId) & t.phoneNumber.equals(ownerPhone),
    );
    ownerContact ??= await Contact.db.insertRow(
      session,
      Contact(
        ownerId: authUserId,
        name: userProfile.displayName,
        phoneNumber: ownerPhone,
        isRegistered: true,
        registeredUserId: authUserId,
        createdAt: DateTime.now(),
      ),
    );

    // Find or create the Contact record representing the assignee.
    var assigneeContact = await Contact.db.findFirstRow(
      session,
      where: (t) =>
          t.ownerId.equals(authUserId) &
          t.phoneNumber.equals(cleanAssigneePhone),
    );
    if (assigneeContact == null) {
      assigneeContact = await Contact.db.insertRow(
        session,
        Contact(
          ownerId: authUserId,
          name: cleanAssigneeName,
          phoneNumber: cleanAssigneePhone,
          isRegistered: assigneeProfile != null,
          registeredUserId: assigneeProfile?.authUserId,
          createdAt: DateTime.now(),
        ),
      );
    } else if (assigneeContact.name != cleanAssigneeName) {
      assigneeContact = await Contact.db.updateRow(
        session,
        assigneeContact.copyWith(name: cleanAssigneeName),
      );
    }

    // Create project referencing the owner's and assignee's Contact records
    final project = await Project.db.insertRow(
      session,
      Project(
        title: title.trim(),
        description: description.trim(),
        ownerId: ownerContact.id!,
        assigneeId: assigneeContact.id!,
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

    return project.copyWith(
      owner: ownerContact,
      assignee: assigneeContact,
      checklistItems: insertedItems,
    );
  }

  /// Returns all projects created by the current user (Task Owner).
  Future<List<Project>> getCreatedProjects(Session session) async {
    final authUserId = session.authenticated?.authUserId;
    if (authUserId == null) return [];

    return await Project.db.find(
      session,
      where: (t) => t.owner.registeredUserId.equals(authUserId),
      orderBy: (t) => t.createdAt.desc(),
      include: Project.include(
        owner: Contact.include(),
        assignee: Contact.include(),
        checklistItems: ChecklistItem.includeList(),
      ),
    );
  }

  /// Returns all projects assigned to the current user (Task Executor).
  /// Matches either by the assignee Contact's registeredUserId or by the
  /// user's registered phone number.
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
            t.assignee.registeredUserId.equals(authUserId) |
            (t.assignee.phoneNumber.equals(userPhone) &
                t.owner.registeredUserId.notEquals(authUserId)),
        orderBy: (t) => t.createdAt.desc(),
        include: Project.include(
          owner: Contact.include(),
          assignee: Contact.include(),
          checklistItems: ChecklistItem.includeList(),
        ),
      );
    } else {
      return await Project.db.find(
        session,
        where: (t) => t.assignee.registeredUserId.equals(authUserId),
        orderBy: (t) => t.createdAt.desc(),
        include: Project.include(
          owner: Contact.include(),
          assignee: Contact.include(),
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
        owner: Contact.include(),
        assignee: Contact.include(),
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
