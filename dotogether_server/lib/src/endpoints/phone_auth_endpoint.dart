// Serverpod Custom Endpoint (server-side)
import 'package:dotogether_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

// Provides: AuthenticationResponse, UserInfo, userAuthentication, etc.
class PhoneAuthEndpoint extends Endpoint {
  Future<AuthenticationResponse> authenticateWithFirebasePhone(
    Session session,
    PhoneAuthPayload firebaseUser,
  ) async {
    final newUserInfo = UserInfo(
      userIdentifier: firebaseUser.phoneNumber!, // Required: e.g., phone number or provider UID
      created: DateTime.now().toUtc(), // Required: timestamp in UTC
      scopeNames: [], // Required: list of access scope strings
      blocked: false, // Required: sign-in block status
      // Optional fields:
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

    // 3. Issue Serverpod Auth Key
    return _authenticateUser(session, userInfo!);
  }

  Future<AuthenticationResponse> _authenticateUser(
    Session session,
    UserInfo userInfo,
  ) async {
    // Ensure the user has a valid DB ID
    if (userInfo.id == null) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    // ✅ Correct way to issue a Serverpod Auth Key:
    final authKey = await UserAuthentication.signInUser(
      session,
      userInfo.id!,
      'phone', // Auth method / provider name
    );

    return AuthenticationResponse(
      success: true,
      keyId: authKey.id,
      key: authKey.key,
      userInfo: userInfo,
    );
  }
}
