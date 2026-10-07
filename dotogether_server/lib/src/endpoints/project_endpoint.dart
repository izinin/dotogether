import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import '../generated/protocol.dart';
import '../services/push_notification_service.dart';

class ProjectEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Creates a new Project. Finds (or creates) the Contact records that
  /// represent the owner (the creator's own entry in their address book)
  /// and the assignee, then creates the Project referencing both.
  /// If the assignee phone matches an existing registered user, the
  /// assignee Contact is immediately marked as registered.
  ///
  /// Contact rows are shared globally (deduplicated by phone number, which
  /// along with `ownerId` must be unique): a phone number that is already
  /// known (e.g. as someone else's assignee, or as that person's own
  /// registered profile) is reused rather than re-inserted.
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
    // (the creator's own entry in the global Contact registry).
    final ownerContact = await _findOrCreateContact(
      session,
      phone: ownerPhone,
      name: userProfile.displayName,
      isRegistered: true,
      registeredUserId: authUserId,
      ownerIdForNew: authUserId,
    );

    // Find or create the Contact record representing the assignee.
    final assigneeContact = await _findOrCreateContact(
      session,
      phone: cleanAssigneePhone,
      name: cleanAssigneeName,
      isRegistered: assigneeProfile != null,
      registeredUserId: assigneeProfile?.authUserId,
      // If the assignee is already a registered user, their own authUserId
      // is used as the (unique) ownerId; otherwise mint a fresh one, since
      // `ownerId` must be unique and not null across all Contact rows.
      ownerIdForNew: assigneeProfile?.authUserId ?? const Uuid().v4obj(),
    );

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

    // Notify the assignee if they're a registered user with a device token.
    if (assigneeProfile != null) {
      await PushNotificationService.sendToDevice(
        session,
        deviceToken: assigneeProfile.deviceToken,
        title: 'New task list assigned to you',
        body: '${userProfile.displayName} assigned you "${title.trim()}"',
        data: {'projectId': project.id.toString(), 'type': 'project_assigned'},
      );
    }

    final createdProject = project.copyWith(
      owner: ownerContact,
      assignee: assigneeContact,
      checklistItems: insertedItems,
    );

    // Broadcast project update in real-time to owner and assignee channels
    await broadcastProjectUpdate(session, createdProject);

    return createdProject;
  }

  static String _userChannel(UuidValue authUserId) =>
      'user_projects_$authUserId';
  static String _projectChannel(int projectId) => 'project_$projectId';

  /// Returns a real-time stream of all projects created by the current user (Task Owner).
  /// Emits the current list immediately, and subsequent updates whenever a project is created or updated.
  Stream<List<Project>> getCreatedProjects(Session session) async* {
    final authUserId = session.authenticated?.authUserId;
    if (authUserId == null) {
      throw StateError('User is not authenticated');
    }

    final updateStream = session.messages.createStream<Project>(
      _userChannel(authUserId),
    );

    yield await _fetchCreatedProjects(session, authUserId);

    await for (final _ in updateStream) {
      yield await _fetchCreatedProjects(session, authUserId);
    }
  }

  Future<List<Project>> _fetchCreatedProjects(
    Session session,
    UuidValue authUserId,
  ) async {
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

  /// Returns a real-time stream of all projects assigned to the current user (Task Executor).
  /// Matches either by the assignee Contact's registeredUserId or by the
  /// user's registered phone number.
  /// Emits the current list immediately, and subsequent updates whenever projects change.
  Stream<List<Project>> getReceivedProjects(Session session) async* {
    final authUserId = session.authenticated?.authUserId;
    if (authUserId == null) {
      throw StateError('User is not authenticated');
    }

    final updateStream = session.messages.createStream<Project>(
      _userChannel(authUserId),
    );

    yield await _fetchReceivedProjects(session, authUserId);

    await for (final _ in updateStream) {
      yield await _fetchReceivedProjects(session, authUserId);
    }
  }

  Future<List<Project>> _fetchReceivedProjects(
    Session session,
    UuidValue authUserId,
  ) async {
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

  /// Broadcasts a project update to its dedicated project channel and to the owner and assignee user channels.
  static Future<void> broadcastProjectUpdate(
    Session session,
    Project project,
  ) async {
    if (project.id != null) {
      await session.messages.postMessage(
        _projectChannel(project.id!),
        project,
      );
    }

    final ownerUserId = project.owner?.registeredUserId;
    if (ownerUserId != null) {
      await session.messages.postMessage(
        _userChannel(ownerUserId),
        project,
      );
    }

    final assigneeUserId = project.assignee?.registeredUserId;
    if (assigneeUserId != null && assigneeUserId != ownerUserId) {
      await session.messages.postMessage(
        _userChannel(assigneeUserId),
        project,
      );
    }
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

    final project = await Project.db.findById(
      session,
      item.projectId,
      include: Project.include(
        owner: Contact.include(),
        assignee: Contact.include(),
      ),
    );
    if (project == null) {
      throw ArgumentError('Project ${item.projectId} not found');
    }

    final updatedProject = await Project.db.updateRow(
      session,
      project.copyWith(overallStatus: newStatus),
    );

    // Notify the project owner when the assignee just finished all tasks.
    if (newStatus == 'completed' && project.overallStatus != 'completed') {
      await _notifyOwnerOfCompletion(session, updatedProject);
    }

    final fullUpdatedProject = updatedProject.copyWith(
      checklistItems: allItems,
      owner: project.owner,
      assignee: project.assignee,
    );

    // Broadcast project update in real-time
    await broadcastProjectUpdate(session, fullUpdatedProject);

    return fullUpdatedProject;
  }

  /// Sends a push notification to the project owner (if they're a
  /// registered user with a device token) when [project] has just been
  /// completed by its assignee.
  Future<void> _notifyOwnerOfCompletion(
    Session session,
    Project project,
  ) async {
    final ownerContact = await Contact.db.findById(session, project.ownerId);
    if (ownerContact?.registeredUserId == null) return;

    final ownerProfile = await AppUserData.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(ownerContact!.registeredUserId!),
    );
    if (ownerProfile == null) return;

    final assigneeContact = await Contact.db.findById(
      session,
      project.assigneeId,
    );

    await PushNotificationService.sendToDevice(
      session,
      deviceToken: ownerProfile.deviceToken,
      title: 'Task list completed',
      body:
          '${assigneeContact?.name ?? 'Your assignee'} completed "${project.title}"',
      data: {'projectId': project.id.toString(), 'type': 'project_completed'},
    );
  }

  /// Allows explicit update of project status.
  Future<Project> updateProjectStatus(
    Session session, {
    required int projectId,
    required String status,
  }) async {
    final project = await Project.db.findById(
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
    if (project == null) {
      throw ArgumentError('Project $projectId not found');
    }

    final updatedProject = await Project.db.updateRow(
      session,
      project.copyWith(overallStatus: status),
    );

    final fullProject = updatedProject.copyWith(
      owner: project.owner,
      assignee: project.assignee,
      checklistItems: project.checklistItems,
    );

    // Broadcast status change in real-time
    await broadcastProjectUpdate(session, fullProject);

    return fullProject;
  }

  /// Finds the Contact row matching [phone] in the global Contact registry,
  /// updating its name if it changed, or creates a new one with
  /// [ownerIdForNew] if no row for that phone number exists yet. Contact
  /// rows are shared across all users (deduplicated by phone number), so an
  /// existing row's `ownerId` is never reassigned.
  Future<Contact> _findOrCreateContact(
    Session session, {
    required String phone,
    required String name,
    required bool isRegistered,
    required UuidValue? registeredUserId,
    required UuidValue ownerIdForNew,
  }) async {
    final existing = await Contact.db.findFirstRow(
      session,
      where: (t) => t.phoneNumber.equals(phone),
    );
    if (existing == null) {
      return await Contact.db.insertRow(
        session,
        Contact(
          ownerId: ownerIdForNew,
          name: name,
          phoneNumber: phone,
          isRegistered: isRegistered,
          registeredUserId: registeredUserId,
          createdAt: DateTime.now(),
        ),
      );
    }
    if (existing.name != name) {
      return await Contact.db.updateRow(
        session,
        existing.copyWith(name: name),
      );
    }
    return existing;
  }
}
