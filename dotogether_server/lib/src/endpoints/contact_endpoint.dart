import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import '../generated/protocol.dart';

class ContactEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Syncs phone contacts to the database and checks which contacts match registered app users.
  Future<List<Contact>> syncContacts(
    Session session,
    List<Contact> inputContacts,
  ) async {
    final authUserId = session.authenticated?.authUserId;
    if (authUserId == null) {
      throw StateError('User is not authenticated');
    }

    // Get all registered user profiles with phone numbers
    final allProfiles = await AppUserData.db.find(session);
    final phoneToUserId = <String, UuidValue>{};
    for (var profile in allProfiles) {
      if (profile.phoneNumber != null &&
          profile.phoneNumber!.trim().isNotEmpty) {
        phoneToUserId[profile.phoneNumber!.trim()] = profile.authUserId;
      }
    }

    // Remove old contacts for this owner to maintain clean sync
    final existingContacts = await Contact.db.find(
      session,
      where: (t) => t.ownerId.equals(authUserId),
    );
    for (var c in existingContacts) {
      await Contact.db.deleteRow(session, c);
    }

    List<Contact> synced = [];
    for (var c in inputContacts) {
      final cleanPhone = c.phoneNumber.trim();
      final isRegistered = phoneToUserId.containsKey(cleanPhone);
      final registeredUserId = phoneToUserId[cleanPhone];

      final inserted = await Contact.db.insertRow(
        session,
        Contact(
          ownerId: authUserId,
          name: c.name.trim(),
          phoneNumber: cleanPhone,
          isRegistered: isRegistered,
          registeredUserId: registeredUserId,
          createdAt: DateTime.now(),
        ),
      );
      synced.add(inserted);
    }

    return synced;
  }

  /// Returns all synced contacts for current user.
  Future<List<Contact>> getContacts(Session session) async {
    final authUserId = session.authenticated?.authUserId;
    if (authUserId == null) return [];

    return await Contact.db.find(
      session,
      where: (t) => t.ownerId.equals(authUserId),
      orderBy: (t) => t.name,
    );
  }
}
