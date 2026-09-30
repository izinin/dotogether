// Serverpod Custom Endpoint (server-side)
import 'package:dotogether_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

// Provides: AuthenticationResponse, UserInfo, userAuthentication, etc.
class PhoneAuthEndpoint extends Endpoint {
  // Create a constant namespace UUID for your app's phone IDs
  static final _phoneNamespace = UuidValue.fromString(
    '6ba7b810-9dad-11d1-80b4-00c04fd430c8',
  );

  /// Converts any phone number string deterministically into a valid UuidValue
  UuidValue _phoneToUuid(String phoneNumber) {
    // Generate UUID v5 based on the phone string
    final uuidString = const Uuid().v5(_phoneNamespace.uuid, phoneNumber);
    return UuidValue.fromString(uuidString);
  }

  Future<AuthSuccess?> authenticateWithFirebasePhone(
    Session session,
    PhoneAuthPayload firebaseUser,
  ) async {
    final userUuid = _phoneToUuid(firebaseUser.phoneNumber);
    final newUserInfo = UserInfo(
      userIdentifier: userUuid.toString(),
      created: DateTime.now().toUtc(), // Required: timestamp in UTC
      scopeNames: [], // Required: list of access scope strings
      blocked: false, // Required: sign-in block status
      // Optional fields:
      fullName: firebaseUser.phoneNumber,
      userName: firebaseUser.displayName,
      email: firebaseUser.email,
      imageUrl: firebaseUser.photoUrl,
    );

    // 2. Find or create user in Serverpod DB
    var userInfo = await Users.findUserByIdentifier(
      session,
      newUserInfo.userIdentifier,
    );
    userInfo ??= await Users.createUser(session, newUserInfo);
    return _authenticateUser(session, userInfo!, userUuid);
  }

  Future<AuthSuccess?> _authenticateUser(
    Session session,
    UserInfo userInfo,
    UuidValue userUuid,
  ) async {
    if (userInfo.id == null) {
      return null;
    }

    var authUser = await AuthUser.db.findById(session, userUuid);
    if (authUser == null) {
      await AuthUser.db.insertRow(
        session,
        AuthUser(
          id: userUuid,
          scopeNames: {},
          blocked: false,
        ),
      );
    }

    return await AuthServices.instance.tokenManager.issueToken(
      session,
      authUserId: userUuid,
      method: 'phone',
      scopes: {},
    );
  }
}
