import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import '../generated/protocol.dart';

class UserEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Returns the current authenticated user's profile and extra data (phone, token).
  Future<AppUserData?> getProfile(Session session) async {
    final authUserId = session.authenticated?.authUserId;
    if (authUserId == null) return null;

    final result = await AppUserData.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );
    return result;
  }

  /// Updates or creates the user's phone number and push notification device token.
  /// When phone number is registered/updated, pending projects assigned to this phone number
  /// are automatically linked to this user as executorId.
  Future<AppUserData> updateProfile(
    Session session, {
    String? phoneNumber,
    String? displayName,
    String? deviceToken,
  }) async {
    phoneNumber = phoneNumber?.trim();
    displayName = displayName?.trim();
    deviceToken = deviceToken?.trim();

    if (phoneNumber == null || phoneNumber.isEmpty) {
      throw StateError('Phone number is required');
    }

    if (displayName == null || displayName.isEmpty) {
      throw StateError('Display name is required');
    }

    final authUserId = session.authenticated?.authUserId;
    if (authUserId == null) {
      throw StateError('User is not authenticated');
    }

    var existing = await AppUserData.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );

    AppUserData result;
    if (existing == null) {
      result = await AppUserData.db.insertRow(
        session,
        AppUserData(
          authUserId: authUserId,
          phoneNumber: phoneNumber,
          displayName: displayName,
          deviceToken: deviceToken,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    } else {
      result = await AppUserData.db.updateRow(
        session,
        existing.copyWith(
          displayName: displayName,
          deviceToken: deviceToken,
          updatedAt: DateTime.now(),
        ),
      );
    }

    // Mark matching contacts as registered. Since Project references Contact
    // records for its owner/assignee, this automatically links any pending
    // projects assigned to this phone number to the current user.
    final contactsToUpdate = await Contact.db.find(
      session,
      where: (t) => t.phoneNumber.equals(phoneNumber),
    );
    for (var contact in contactsToUpdate) {
      await Contact.db.updateRow(
        session,
        contact.copyWith(
          isRegistered: true,
          registeredUserId: authUserId,
        ),
      );
    }

    return result;
  }

  /// Updates only the current user's push notification device token (FCM).
  /// Lighter-weight than [updateProfile] since it doesn't require
  /// phoneNumber/displayName, so it can be called right after the app
  /// obtains or refreshes its token without needing the full profile.
  Future<void> updateDeviceToken(
    Session session, {
    required String deviceToken,
  }) async {
    final authUserId = session.authenticated?.authUserId;
    if (authUserId == null) {
      throw StateError('User is not authenticated');
    }

    final existing = await AppUserData.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );
    if (existing == null) return;

    await AppUserData.db.updateRow(
      session,
      existing.copyWith(
        deviceToken: deviceToken.trim(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Permanently deletes the current user's account and associated data:
  /// projects they own or are assigned to, their profile, and the auth user.
  Future<void> deleteAccount(Session session) async {
    final authUserId = session.authenticated?.authUserId;
    if (authUserId == null) {
      throw StateError('User is not authenticated');
    }

    await session.db.transaction((transaction) async {
      final contacts = await Contact.db.find(
        session,
        where: (t) => t.registeredUserId.equals(authUserId),
        transaction: transaction,
      );
      final contactIds = contacts.map((c) => c.id!).toSet();

      if (contactIds.isNotEmpty) {
        await Project.db.deleteWhere(
          session,
          where: (t) =>
              t.ownerId.inSet(contactIds) | t.assigneeId.inSet(contactIds),
          transaction: transaction,
        );
      }

      for (final contact in contacts) {
        await Contact.db.updateRow(
          session,
          contact.copyWith(isRegistered: false, registeredUserId: null),
          transaction: transaction,
        );
      }

      await AppUserData.db.deleteWhere(
        session,
        where: (t) => t.authUserId.equals(authUserId),
        transaction: transaction,
      );
    });

    await AuthServices.instance.authUsers.delete(
      session,
      authUserId: authUserId,
    );
  }
}
