import 'dart:async';
import 'dart:io';
import 'package:dotogether_client/dotogether_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_client.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/phone_number_utility.dart';
import '../client.dart';
import 'bypass_sms_verification.dart';
import 'mock_data.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppState extends ChangeNotifier {
  // 1. Background message handler
  // This MUST be a top-level, global function annotated with @pragma('vm:entry-point')
  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    // Ensure Firebase engine is alive inside the background isolate process
    await Firebase.initializeApp();
    debugPrint("Handling a background message: ${message.messageId}");
  }

  // Global reference to the local notification client engine
  static final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late RecaptchaClient _recaptchaClient;
  final MockData _mockData = MockData();

  bool _isLoadingContacts = false;
  bool get isLoadingContacts => _isLoadingContacts;

  User? _currentUser;
  String? _currentPhoneNumber;
  bool _isLoading = false;

  // Latest FCM device token obtained from Firebase Messaging; kept here so
  // it can be (re)sent to the server once the user becomes authenticated.
  String? _deviceToken;

  List<Project> _createdProjects = [];
  List<Project> _receivedProjects = [];
  List<Project> get createdProjects =>
      _mockData.isDemoMode ? _mockData.createdProjects : _createdProjects;
  List<Project> get receivedProjects =>
      _mockData.isDemoMode ? _mockData.receivedProjects : _receivedProjects;
  // Contacts State
  List<Contact> _contacts = [];
  List<Contact> get contacts =>
      _mockData.isDemoMode ? _mockData.contacts : _contacts;

  // Stepper Registration State
  int _registrationStep =
      1; // 1: Input phone, 2: Loading/SMS code sent in progress, 3: Verify code,
  // 4: Checking/editing user name, 5: Confirm & continue
  String _registrationPhone = '';
  String _verificationId = '';
  String _smsCodeError = '';
  String _phoneError = '';
  String _userName = '';
  String _userNameError = '';

  int get registrationStep => _registrationStep;
  String get registrationPhone => _registrationPhone;
  String get smsCodeError => _smsCodeError;
  String get phoneError => _phoneError;
  String get userName => _userName;
  String get userNameError => _userNameError;

  String? _initializeError;
  String? get initializeError => _initializeError;

  // Getters
  RecaptchaClient get recaptchaClient => _recaptchaClient;
  bool get isDemoMode => _mockData.isDemoMode;
  String? get currentPhoneNumber => _currentPhoneNumber;
  bool get isLoading => _isLoading;

  // Private constructor
  AppState._internal() {
    client.auth.authInfoListenable.addListener(_onAuthChanged);
  }

  /// Async factory initializer
  static Future<AppState> create() async {
    final state = AppState._internal();
    if (kIsWeb) {
      return state;
    }
    await state._initialize();
    return state;
  }

  Future<void> _initialize() async {
    await _initFirebaseAuth();
    await _initPushNotifications();
    await _initRecaptchaClient();

    await client.auth.restore();
    if (client.auth.isAuthenticated) {
      await ensureUserInDatabase();
    }
    notifyListeners();
  }

  Future<void> _initPushNotifications() async {
    // Register background hook entry point early
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Setup high-importance channel configuration explicitly for Android foregrounds
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Channel for high importance notifications',
      importance: Importance.high,
    );

    await localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> _initRecaptchaClient() async {
    // https://pub.dev/packages/recaptcha_enterprise_flutter
    final siteKey = Platform.isAndroid
        ? "6Le85c4tAAAAAIke5x8jNxjzOEQSujO36SyeXDJw"
        : "6Ldu-c4tAAAAAFZBglNMN6H-Cf8eZurqDwqNU6sG";

    _recaptchaClient = await Recaptcha.fetchClient(siteKey);
  }

  /// Initialize Firebase or fallback to Demo Mode
  Future<void> _initFirebaseAuth() async {
    _isLoading = true;
    _initializeError = null;
    try {
      // Try to initialize Firebase
      await Firebase.initializeApp();
      _mockData.isDemoMode = false;
      debugPrint(
        "DoTogether: Firebase initialized successfully. Running in LIVE mode.",
      );

      // Listen to Auth State
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        _currentUser = user;
        _currentPhoneNumber = user?.phoneNumber;
        notifyListeners();
      });
    } catch (e) {
      _initializeError = 'Failed to initialize app: ${e.toString()}';
    }
    _isLoading = false;
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    if (client.auth.isAuthenticated) {
      _mockData.isDemoMode = false;
      ensureUserInDatabase();
      _syncDeviceTokenWithServer();
    } else if (!_mockData.isDemoMode) {
      _currentPhoneNumber = null;
      notifyListeners();
    }
  }

  /// Records the current FCM device token (obtained/refreshed in `main.dart`)
  /// and, if the user is already authenticated, immediately pushes it to the
  /// server so push notifications can target this device. If the user isn't
  /// authenticated yet, the token is simply remembered and sent later from
  /// [_onAuthChanged] once sign-in completes.
  Future<void> registerDeviceToken(String? token) async {
    if (token == null || token.isEmpty || token == _deviceToken) return;
    _deviceToken = token;
    await _syncDeviceTokenWithServer();
  }

  Future<void> _syncDeviceTokenWithServer() async {
    if (_deviceToken == null || !client.auth.isAuthenticated) return;
    try {
      await client.user.updateDeviceToken(deviceToken: _deviceToken!);
    } catch (e) {
      debugPrint('Error registering device token with server: $e');
    }
  }

  /// Ensure authenticated user is in the database and loaded into state
  Future<void> ensureUserInDatabase() async {
    if (!client.auth.isAuthenticated) return;

    _isLoading = true;
    notifyListeners();

    try {
      var profile = await client.user.getProfile();
      if (profile == null) {
        debugPrint('User not found in database, inserting new profile...');
        profile = await client.user.updateProfile(
          phoneNumber: _registrationPhone,
          deviceToken: _deviceToken,
          displayName: "unknown",
        );
        debugPrint('User profile created in database with id: ${profile.id}');
      } else {
        debugPrint(
          'Authenticated user found in database: ${profile.authUserId}',
        );
      }

      _currentPhoneNumber = profile.phoneNumber;
      _currentUser = FirebaseAuth.instance.currentUser;
      _userName = profile.displayName;
      await refreshProjects();
    } catch (e) {
      debugPrint('Error syncing user with database: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh the created/received project lists from the appropriate source:
  /// the local mock data in Demo Mode, or the Serverpod backend for
  /// authenticated (non-demo) users.
  Future<void> refreshProjects() async {
    if (_mockData.isDemoMode) {
      _mockData.updateMockProjects();
    } else if (client.auth.isAuthenticated) {
      try {
        final results = await Future.wait([
          client.project.getCreatedProjects(),
          client.project.getReceivedProjects(),
        ]);
        _createdProjects = results[0];
        _receivedProjects = results[1];
      } catch (e) {
        debugPrint('Error loading projects from server: $e');
      }
    }
    notifyListeners();
  }

  /// Sign Out
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await client.auth.signOutDevice();
    } catch (e) {
      debugPrint('Error signing out of Serverpod: $e');
    }
    _mockData.isDemoMode = false;
    _currentPhoneNumber = null;
    _createdProjects = [];
    _receivedProjects = [];
    _userName = '';
    _verificationId = '';
    _registrationPhone = '';
    resetStepper();
  }

  // ================= AUTHENTICATION FLOW =================

  /// Step 1: Send SMS Verification Code
  Future<void> sendSmsCode(String rawPhoneNumber) async {
    _isLoading = true;
    _phoneError = '';
    _registrationStep = 2; // Move to step 2 (Requesting SMS...)
    notifyListeners();

    _registrationPhone = PhoneNumberUtility.normalize(rawPhoneNumber);

    // Predefined test phone numbers bypass real SMS verification entirely
    // (in non-demo mode) and jump straight to the user name input step.
    if (!_mockData.isDemoMode &&
        BypassSmsVerification.isBypassedPhoneNumber(_registrationPhone)) {
      await BypassSmsVerification.signInWithPredefinedTestPhoneNumber(
        _registrationPhone,
      );
      try {
        final profile = await client.user.getProfile();
        _userName = profile?.displayName ?? '';
      } catch (e) {
        debugPrint('Error fetching user profile: $e');
      }
      _isLoading = false;
      _registrationStep = 4;
      notifyListeners();
      return;
    }

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _registrationPhone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          _onAuthSuccess();
        },
        verificationFailed: (FirebaseAuthException e) {
          _isLoading = false;
          _registrationStep = 1;
          _phoneError = e.message ?? "Phone verification failed.";
          notifyListeners();
        },
        codeSent: (String verificationId, int? resendToken) {
          _isLoading = false;
          _verificationId = verificationId;
          _registrationStep = 3; // Prompts code entry screen
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      _isLoading = false;
      _registrationStep = 1;
      _phoneError = e.toString();
      notifyListeners();
    }
  }

  /// Step 3: Verify the SMS Code and Sign In
  Future<bool> verifySmsCode(String smsCode) async {
    _isLoading = true;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );
      UserCredential userCred = await FirebaseAuth.instance
          .signInWithCredential(credential);
      if (userCred.user != null) {
        await _onAuthSuccess();
        return true;
      }
      return false;
    } catch (e) {
      _isLoading = false;
      _smsCodeError = "SMS Code Verification Error: ${e.toString()}";
      notifyListeners();
      return false;
    }
  }

  Future<void> _onAuthSuccess() async {
    _currentUser = FirebaseAuth.instance.currentUser;
    _currentPhoneNumber = _currentUser?.phoneNumber;

    final authSuccess = await client.phoneAuth.authenticateWithFirebasePhone(
      PhoneAuthPayload(
        phoneNumber: _currentUser!.phoneNumber!,
        displayName: _currentUser!.displayName ?? 'please fill your name',
        email: _currentUser!.email ?? 'please add your email',
        photoUrl: _currentUser!.photoURL ?? 'please add your photo',
      ),
    );

    // https://docs.serverpod.dev/next/concepts/authentication/basics#register-authentication
    await client.auth.updateSignedInUser(authSuccess);
    if (client.auth.isAuthenticated) {
      debugPrint('User is authenticated with Serverpod.');
    }

    // Step 4: fetch the signed-in user's profile so the name step can be
    // prefilled with the name currently stored in the database.
    try {
      final profile = await client.user.getProfile();
      _userName = profile?.displayName ?? '';
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
    }

    _isLoading = false;
    _registrationStep = 4;
    notifyListeners();
  }

  /// Step 4: Save the (possibly edited) user name and move to step 5.
  Future<bool> submitUserName(String name) async {
    name = name.trim();
    if (name.isEmpty) {
      _userNameError = 'Please enter your name';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _userNameError = '';
    notifyListeners();

    try {
      await client.user.updateProfile(
        phoneNumber: _currentPhoneNumber,
        displayName: name,
        deviceToken: _deviceToken,
      );
      _userName = name;
      _registrationStep = 5;
      return true;
    } catch (e) {
      _userNameError = 'Could not save your name: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Step 5: Go back to step 4 to allow editing the user name again.
  void backToEditUserName() {
    _registrationStep = 4;
    _userNameError = '';
    notifyListeners();
  }

  /// Reset the verification stepper state
  void resetStepper() {
    _registrationStep = 1;
    _phoneError = '';
    _smsCodeError = '';
    _userNameError = '';
    _isLoading = false;
    notifyListeners();
  }

  // ================= CONTACTS HANDLER =================

  /// Fetch the list of known contacts for the "Create todo list for" screen.
  /// In Demo Mode this is the local simulated list; otherwise it's fetched
  /// from the server, which derives it from the Contact records (owner/
  /// assignee) found across all of the current user's Projects (created +
  /// received), deduplicated by phone number and excluding the current
  /// user's own contact entry.
  Future<void> fetchContacts() async {
    if (_mockData.isDemoMode) return;

    _isLoadingContacts = true;
    notifyListeners();

    List<Contact> serverContacts = [];
    try {
      serverContacts = await client.contact.getContacts();
    } catch (e) {
      debugPrint('Error loading contacts: $e');
    }

    // Test numbers are added client-side regardless of server data, skipping
    // any the server already returned.
    final knownNumbers = serverContacts.map((c) => c.phoneNumber).toSet();
    _contacts = [
      ...serverContacts,
      ...BypassSmsVerification.getSimulatedTestContacts(
        _currentPhoneNumber,
      ).where((c) => !knownNumbers.contains(c.phoneNumber)),
    ];

    _isLoadingContacts = false;
    notifyListeners();
  }

  // ================= COLLABORATIVE taskList OPERATIONS =================

  /// Create a shared Project / taskList and prepare invitation SMS parameters.
  /// In Demo Mode this only mutates the local mock database; otherwise it
  /// creates the owner/assignee Contact records and the Project on the
  /// real Serverpod backend.
  Future<Map<String, String>> createProject({
    required String title,
    required String description,
    required String assigneeName,
    required String assigneeRawPhone,
    required List<String> taskTexts,
  }) async {
    _isLoading = true;
    notifyListeners();

    String normalizedPhone = PhoneNumberUtility.normalize(assigneeRawPhone);
    List<String> checklistTitles = taskTexts
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    if (_mockData.isDemoMode) {
      _mockData.createMockProject(
        title: title,
        description: description,
        assigneeName: assigneeName,
        normalizedPhone: normalizedPhone,
        checklistTitles: checklistTitles,
      );
    } else {
      try {
        await client.project.createProject(
          title: title.trim(),
          description: description.trim(),
          assigneeName: assigneeName,
          assigneePhone: normalizedPhone,
          checklistTitles: checklistTitles,
        );
        await refreshProjects();
      } catch (e) {
        debugPrint('Error creating project on server: $e');
      }
    }

    _isLoading = false;
    notifyListeners();

    String smsMessage =
        "Hello $assigneeName!\n"
        "I have created a taskList '$title' for you:\n"
        "${description.isNotEmpty ? 'Details: $description\n' : ''}\n\n"
        "Could you please complete it at your earliest convenience in DoTogether app? Get it from the Play Store or Apple App Store:\n"
        "https://play.google.com/store/apps/details?id=com.dotogether.app\n"
        "https://apps.apple.com/us/app/world-tunes/id1485312499";

    return {'recipient': normalizedPhone, 'body': smsMessage};
  }

  /// Update task checkboxes and automatically recalculate overall project progress/status.
  /// In Demo Mode this only mutates the local mock database; otherwise it
  /// calls the real Serverpod backend and refreshes the project lists.
  Future<void> toggleTask(
    Project project,
    int itemIndex,
    bool isCompleted,
  ) async {
    if (_mockData.isDemoMode) {
      await _mockData.toggleTask(project, itemIndex, isCompleted);
    } else {
      final items = project.checklistItems;
      final itemId = (items != null && itemIndex < items.length)
          ? items[itemIndex].id
          : null;
      if (itemId == null) return;
      try {
        await client.project.toggleChecklistItem(
          itemId: itemId,
          isCompleted: isCompleted,
        );
        await refreshProjects();
      } catch (e) {
        debugPrint('Error toggling checklist item on server: $e');
      }
    }
    notifyListeners();
  }

  /// Launch SMS via standard device URL launcher
  Future<void> sendSMSInvitation(
    String recipientPhone,
    String messageBody,
  ) async {
    // Uri(queryParameters:) encodes spaces as '+', which SMS apps show
    // literally; encodeComponent uses %20 instead.
    final Uri smsUri = Uri.parse(
      "sms:$recipientPhone?body=${Uri.encodeComponent(messageBody)}",
    );

    try {
      // canLaunchUrl can wrongly return false on Android 11+, so just try launching.
      final launched = await launchUrl(smsUri);
      if (!launched) {
        debugPrint("Fail to launch SMS app for $recipientPhone");
      }
    } catch (e) {
      debugPrint("SMS Launch Exception: $e");
    }
  }

  void startDemoMode() {
    _mockData.startDemoMode();
    notifyListeners();
  }
}
