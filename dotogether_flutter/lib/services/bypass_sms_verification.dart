import 'package:dotogether_client/dotogether_client.dart';
import 'package:dotogether_flutter/client.dart';
import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

class BypassSmsVerification {
  /// Predefined phone numbers that, when entered in non-demo mode, skip real
  /// SMS verification and go straight to the user name input step. Useful
  /// for manual/automated testing without needing a real SMS to arrive.
  static List<Contact> predefinedTestPhoneNumbers = [
    Contact(
      phoneNumber: '+35811111111',
      name: 'Test Contact 1',
      ownerId: UuidValue.fromString('4a1c78e2-8b9f-4310-a2d6-0e9b4185f20f'),
    ),
    Contact(
      phoneNumber: '+35822222222',
      name: 'Test Contact 2',
      ownerId: UuidValue.fromString('f2b09341-11e8-46c9-b7e5-523c091ad4d2'),
    ),
  ];

  /// When the current user is signed in with one of the
  /// [predefinedTestPhoneNumbers], surface the *other* predefined numbers
  /// as "simulated contact" entries in the contact list, so project
  /// creation can be exercised end-to-end without needing several real
  /// phone numbers to test with.
  static List<Contact> getSimulatedTestContacts(String? currentPhone) {
    if (currentPhone == null ||
        !BypassSmsVerification.predefinedTestPhoneNumbers.any(
          (c) => c.phoneNumber == currentPhone,
        )) {
      return [];
    }

    final existingNumbers = predefinedTestPhoneNumbers
        .map((c) => c.phoneNumber)
        .toSet();

    return predefinedTestPhoneNumbers
        .where(
          (phone) => !existingNumbers.contains(phone.phoneNumber),
        )
        .toList();
  }

  static bool isBypassedPhoneNumber(String? phoneNumber) {
    return phoneNumber != null &&
        predefinedTestPhoneNumbers.any((c) => c.phoneNumber == phoneNumber);
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
