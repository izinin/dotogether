import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:dotogether_server/src/generated/protocol.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  final user1Id = '550e8400-e29b-41d4-a716-446655440001';
  final user2Id = '550e8400-e29b-41d4-a716-446655440002';

  withServerpod('Given ProjectEndpoint and UserEndpoint', (
    sessionBuilder,
    endpoints,
  ) {
    var authedUser1 = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        user1Id,
        {Scope('user')},
      ),
    );

    var authedUser2 = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        user2Id,
        {Scope('user')},
      ),
    );

    setUp(() async {
      final session = sessionBuilder.build();
      // Ensure AuthUser rows exist for user1 and user2
      final existing1 = await AuthUser.db.findById(
        session,
        UuidValue.withValidation(user1Id),
      );
      if (existing1 == null) {
        await AuthUser.db.insertRow(
          session,
          AuthUser(
            id: UuidValue.withValidation(user1Id),
            scopeNames: {'user'},
          ),
        );
      }
      final existing2 = await AuthUser.db.findById(
        session,
        UuidValue.withValidation(user2Id),
      );
      if (existing2 == null) {
        await AuthUser.db.insertRow(
          session,
          AuthUser(
            id: UuidValue.withValidation(user2Id),
            scopeNames: {'user'},
          ),
        );
      }
    });

    test(
      'when creating project with checklist items then overallStatus is pending',
      () async {
        // Setup profile for user 1
        await endpoints.user.updateProfile(
          authedUser1,
          phoneNumber: '+15550001111',
          displayName: 'User One',
        );

        final project = await endpoints.project.createProject(
          authedUser1,
          title: 'Launch MVP',
          description: 'First version launch checklist',
          assigneeName: 'Alice',
          assigneePhone: '+15550002222',
          checklistTitles: ['Database schema', 'API endpoints', 'Deploy'],
        );

        expect(project.id, isNotNull);
        expect(project.title, 'Launch MVP');
        expect(project.overallStatus, 'pending');
        expect(project.checklistItems, hasLength(3));

        // User 1 sees it under created projects
        final created = await endpoints.project.getCreatedProjects(authedUser1);
        expect(created, hasLength(1));
        expect(created.first.title, 'Launch MVP');

        // Toggling one checklist item makes status in_progress
        final firstItemId = project.checklistItems!.first.id!;
        final updated1 = await endpoints.project.toggleChecklistItem(
          authedUser1,
          itemId: firstItemId,
          isCompleted: true,
        );
        expect(updated1.overallStatus, 'in_progress');

        // Completing all items makes status completed
        for (var item in project.checklistItems!.skip(1)) {
          await endpoints.project.toggleChecklistItem(
            authedUser1,
            itemId: item.id!,
            isCompleted: true,
          );
        }
        final lastToggle = await endpoints.project.toggleChecklistItem(
          authedUser1,
          itemId: project.checklistItems!.last.id!,
          isCompleted: true,
        );
        expect(lastToggle.overallStatus, 'completed');
      },
    );

    test(
      'when user 2 registers phone then assigned projects are automatically linked',
      () async {
        // Ensure user 1 has a profile set up
        await endpoints.user.updateProfile(
          authedUser1,
          phoneNumber: '+15550001111',
          displayName: 'User One',
        );

        // User 1 creates project assigned to +15559998888
        await endpoints.project.createProject(
          authedUser1,
          title: 'Review PR',
          description: 'Code review',
          assigneeName: 'Bob',
          assigneePhone: '+15559998888',
          checklistTitles: ['Read code', 'Leave review'],
        );

        // User 2 registers with that phone
        await endpoints.user.updateProfile(
          authedUser2,
          phoneNumber: '+15559998888',
          displayName: 'User Two',
        );

        // User 2 should see this under received projects
        final received = await endpoints.project.getReceivedProjects(
          authedUser2,
        );
        expect(received, hasLength(1));
        expect(received.first.title, 'Review PR');
        expect(
          received.first.assignee?.registeredUserId,
          UuidValue.withValidation(user2Id),
        );
      },
    );

    test('when syncing contacts then registered users are detected', () async {
      // Ensure user 2 profile exists
      await endpoints.user.updateProfile(
        authedUser2,
        phoneNumber: '+15553334444',
        displayName: 'User Two',
      );

      final synced = await endpoints.contact.syncContacts(
        authedUser1,
        [
          Contact(
            ownerId: UuidValue.withValidation(user1Id),
            name: 'Bob',
            phoneNumber: '+15553334444',
            createdAt: DateTime.now(),
          ),
          Contact(
            ownerId: UuidValue.withValidation(user1Id),
            name: 'Charlie Unregistered',
            phoneNumber: '+15550009999',
            createdAt: DateTime.now(),
          ),
        ],
      );

      expect(synced, hasLength(2));
      final registeredContact = synced.firstWhere(
        (c) => c.phoneNumber == '+15553334444',
      );
      expect(registeredContact.isRegistered, isTrue);
      expect(
        registeredContact.registeredUserId,
        UuidValue.withValidation(user2Id),
      );

      final unregisteredContact = synced.firstWhere(
        (c) => c.phoneNumber == '+15550009999',
      );
      expect(unregisteredContact.isRegistered, isFalse);
    });

    test(
      'when getting contacts then only owner/assignee contacts from own projects are returned, deduplicated and excluding self',
      () async {
        await endpoints.user.updateProfile(
          authedUser1,
          phoneNumber: '+15551110000',
          displayName: 'User One',
        );
        await endpoints.user.updateProfile(
          authedUser2,
          phoneNumber: '+15552220000',
          displayName: 'User Two',
        );

        // User 1 creates two projects assigned to the same person,
        // which should be deduplicated by phone number.
        await endpoints.project.createProject(
          authedUser1,
          title: 'Task A',
          description: 'First task',
          assigneeName: 'Dana',
          assigneePhone: '+15553330000',
          checklistTitles: ['Step 1'],
        );
        await endpoints.project.createProject(
          authedUser1,
          title: 'Task B',
          description: 'Second task',
          assigneeName: 'Dana',
          assigneePhone: '+15553330000',
          checklistTitles: ['Step 1'],
        );

        // User 2 creates a project assigning user 1, which should surface
        // user 2 as a contact for user 1.
        await endpoints.project.createProject(
          authedUser2,
          title: 'Task C',
          description: 'Third task',
          assigneeName: 'User One',
          assigneePhone: '+15551110000',
          checklistTitles: ['Step 1'],
        );

        final contacts = await endpoints.contact.getContacts(authedUser1);
        final phones = contacts.map((c) => c.phoneNumber).toSet();

        // Dana appears once despite being assignee on two projects.
        expect(
          contacts.where((c) => c.phoneNumber == '+15553330000'),
          hasLength(1),
        );
        // User 2 shows up as a contact since they share a project.
        expect(phones, contains('+15552220000'));
        // User 1 never sees their own phone number in their contacts.
        expect(phones, isNot(contains('+15551110000')));
      },
    );
  });
}
