import 'dart:convert';

import 'package:firebase_admin_sdk/firebase_admin_sdk.dart';
import 'package:firebase_admin_sdk/messaging.dart';
import 'package:serverpod/serverpod.dart';

/// Sends Firebase Cloud Messaging push notifications to users' registered
/// devices (see `AppUserData.deviceToken`).
///
/// Configured via the `firebaseServiceAccountJson` secret in
/// `config/passwords.yaml` (the full JSON contents of a Firebase service
/// account key). When that secret is absent, push notifications are
/// silently skipped so the app keeps working in local/test environments
/// that don't have Firebase credentials set up.
class PushNotificationService {
  PushNotificationService._();

  static FirebaseApp? _app;
  static bool _initAttempted = false;

  static FirebaseApp? _getApp(Session session) {
    if (_initAttempted) return _app;
    _initAttempted = true;

    final json = session.passwords['firebaseServiceAccountJson'];
    if (json == null || json.trim().isEmpty) {
      session.log(
        'PushNotificationService: "firebaseServiceAccountJson" secret not '
        'configured; push notifications are disabled.',
        level: LogLevel.info,
      );
      return null;
    }

    try {
      final serviceAccount = jsonDecode(json) as Map<String, dynamic>;
      final credential = Credential.fromServiceAccountParams(
        clientId: serviceAccount['client_id'] as String?,
        privateKey: serviceAccount['private_key'] as String,
        email: serviceAccount['client_email'] as String,
        projectId: serviceAccount['project_id'] as String,
      );
      _app = FirebaseApp.initializeApp(
        options: AppOptions(credential: credential),
      );
      session.log(
        'PushNotificationService: "firebaseServiceAccountJson" secret not is initialized successfully.',
        level: LogLevel.info,
      );
    } catch (e) {
      session.log(
        'PushNotificationService: failed to initialize Firebase Admin SDK: $e',
        level: LogLevel.error,
      );
      _app = null;
    }

    return _app;
  }

  /// Sends a push notification to [deviceToken]. No-ops (and never throws)
  /// if [deviceToken] is null/empty or Firebase isn't configured, so a
  /// notification failure never breaks the endpoint call that triggered it.
  static Future<void> sendToDevice(
    Session session, {
    required String? deviceToken,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    if (deviceToken == null || deviceToken.trim().isEmpty) return;

    final app = _getApp(session);
    if (app == null) return;

    try {
      await app.messaging().send(
        TokenMessage(
          token: deviceToken,
          notification: Notification(title: title, body: body),
          data: data,
        ),
      );
    } catch (e) {
      session.log(
        'PushNotificationService: failed to send push notification "$title": $e',
        level: LogLevel.error,
      );
    }
  }
}
