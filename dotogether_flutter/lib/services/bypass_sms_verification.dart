import 'package:dotogether_client/dotogether_client.dart';
import 'package:dotogether_flutter/client.dart';
import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

class BypassSmsVerification {
  /// Predefined phone numbers that, when entered in non-demo mode, skip real
  /// SMS verification and go straight to the user name input step. Useful
  /// for manual/automated testing without needing a real SMS to arrive.
  static List<Contact> _getSimulatedTestContacts = [
    Contact(
      phoneNumber: '+35811111111',
      name: 'Test Contact 1',
    ),
    Contact(
      phoneNumber: '+35822222222',
      name: 'Test Contact 2',
    ),
  ];

  /// When the current user is signed in with one of the
  /// [_getSimulatedTestContacts], surface the *other* predefined numbers
  /// as "simulated contact" entries in the contact list, so project
  /// creation can be exercised end-to-end without needing several real
  /// phone numbers to test with.
  static List<Contact> getSimulatedTestContacts(String? currentPhone) {
    if (!isBypassedPhoneNumber(currentPhone)) return [];

    return _getSimulatedTestContacts
        .where((c) => c.phoneNumber != currentPhone)
        .toList();
  }

  static bool isBypassedPhoneNumber(String? phoneNumber) {
    return phoneNumber != null &&
        _getSimulatedTestContacts.any((c) => c.phoneNumber == phoneNumber);
  }

  /// Sign in a predefined test phone number without going through real
  /// Firebase SMS verification. Authenticates directly with the Serverpod
  /// backend and moves straight to the user name input step (step 4), the
  /// same place real users land after successfully verifying their SMS code.
  static Future<void> signInWithPredefinedTestPhoneNumber(
    String normalizedPhone,
  ) async {
    final authSuccess = await client.phoneAuth.authenticateWithFirebasePhone(
      PhoneAuthPayload(
        phoneNumber: normalizedPhone,
        displayName: 'please fill your name',
        email: 'please add your email',
        photoUrl: 'please add your photo',
      ),
    );

    // https://docs.serverpod.dev/next/concepts/authentication/basics#register-authentication
    await client.auth.updateSignedInUser(authSuccess);
    if (client.auth.isAuthenticated) {
      debugPrint('User is authenticated with Serverpod.');
    }
  }
}
