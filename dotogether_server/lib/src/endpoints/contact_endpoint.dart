import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import '../generated/protocol.dart';

class ContactEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Set once the `get_contacts` Postgres function has been (re)created in
  /// this server process, so the DDL isn't re-issued on every call.
  static bool _getContactsFunctionReady = false;

  /// Syncs phone contacts into the global Contact registry (deduplicated by
  /// phone number) and checks which contacts match registered app users.
  /// Existing rows for a phone number are updated in place (name and
  /// registration status) rather than deleted and reinserted, since
  /// `phoneNumber` must be unique.
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
      if (profile.phoneNumber.trim().isNotEmpty) {
        phoneToUserId[profile.phoneNumber.trim()] = profile.authUserId;
      }
    }

    List<Contact> synced = [];
    for (var c in inputContacts) {
      final cleanPhone = c.phoneNumber.trim();
      final cleanName = c.name.trim();
      final isRegistered = phoneToUserId.containsKey(cleanPhone);
      final registeredUserId = phoneToUserId[cleanPhone];

      final existing = await Contact.db.findFirstRow(
        session,
        where: (t) => t.phoneNumber.equals(cleanPhone),
      );
      if (existing == null) {
        synced.add(
          await Contact.db.insertRow(
            session,
            Contact(
              name: cleanName,
              phoneNumber: cleanPhone,
              isRegistered: isRegistered,
              registeredUserId: registeredUserId,
              createdAt: DateTime.now(),
            ),
          ),
        );
      } else if (existing.name != cleanName ||
          existing.isRegistered != isRegistered ||
          existing.registeredUserId != registeredUserId) {
        synced.add(
          await Contact.db.updateRow(
            session,
            existing.copyWith(
              name: cleanName,
              isRegistered: isRegistered,
              registeredUserId: registeredUserId,
            ),
          ),
        );
      } else {
        synced.add(existing);
      }
    }

    return synced;
  }

  /// Returns the distinct Contacts (deduplicated by phone number) found as
  /// the owner or assignee of any of the current user's Projects (created or
  /// received), excluding the current user's own contact entry. The lookup
  /// and de-duplication is performed by the `get_contacts` Postgres function
  /// so that work runs in the database instead of in Dart.
  Future<List<Contact>> getContacts(Session session) async {
    final authUserId = session.authenticated?.authUserId;
    if (authUserId == null) return [];

    final userProfile = await AppUserData.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );
    final userPhone = userProfile?.phoneNumber ?? '';

    await _ensureGetContactsFunction(session);

    final result = await session.db.unsafeQuery(
      r'SELECT * FROM get_contacts($1, $2)',
      parameters: QueryParameters.positional([
        authUserId.toString(),
        userPhone,
      ]),
    );

    return result.map((row) {
      final cols = row.toColumnMap();
      return Contact(
        id: _asInt(cols['id']),
        name: cols['name'] as String,
        phoneNumber: cols['phoneNumber'] as String,
        isRegistered: cols['isRegistered'] as bool,
        registeredUserId: _asUuid(cols['registeredUserId']),
        createdAt: cols['createdAt'] as DateTime,
      );
    }).toList();
  }

  /// Creates (or replaces) the `get_contacts(uuid_text, phone) RETURNS SETOF
  /// contact` Postgres function used by [getContacts]. The function finds
  /// every Project where the given user is owner or assignee (matched by
  /// registered user id, or by phone number for not-yet-registered
  /// assignees), collects the owner/assignee Contact rows of those Projects,
  /// excludes the user's own phone number, and returns one row per distinct
  /// phone number. Idempotent; only executed once per server process.
  Future<void> _ensureGetContactsFunction(Session session) async {
    if (_getContactsFunctionReady) return;

    await session.db.unsafeExecute(r'''
CREATE OR REPLACE FUNCTION get_contacts(p_auth_user_id text, p_user_phone text)
RETURNS SETOF "contact"
LANGUAGE sql
STABLE
AS $$
  SELECT DISTINCT ON (c."phoneNumber") c.*
  FROM "contact" c
  WHERE c."phoneNumber" <> p_user_phone
    AND c."id" IN (
      SELECT p."ownerId"
      FROM "project" p
      JOIN "contact" oc ON oc."id" = p."ownerId"
      JOIN "contact" ac ON ac."id" = p."assigneeId"
      WHERE oc."registeredUserId" = p_auth_user_id::uuid
         OR ac."registeredUserId" = p_auth_user_id::uuid
         OR ac."phoneNumber" = p_user_phone
      UNION
      SELECT p."assigneeId"
      FROM "project" p
      JOIN "contact" oc ON oc."id" = p."ownerId"
      JOIN "contact" ac ON ac."id" = p."assigneeId"
      WHERE oc."registeredUserId" = p_auth_user_id::uuid
         OR ac."registeredUserId" = p_auth_user_id::uuid
         OR ac."phoneNumber" = p_user_phone
    )
  ORDER BY c."phoneNumber", c."name";
$$;
''');

    _getContactsFunctionReady = true;
  }

  /// Converts a bigint/int result column (returned as either [int] or
  /// [BigInt] depending on the Postgres driver's decoding) to a Dart [int].
  int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is BigInt) return value.toInt();
    return value as int;
  }

  /// Converts a uuid result column (returned as a [String] by the raw SQL
  /// driver) to a [UuidValue].
  UuidValue? _asUuid(dynamic value) {
    if (value == null) return null;
    if (value is UuidValue) return value;
    return UuidValue.withValidation(value as String);
  }
}
