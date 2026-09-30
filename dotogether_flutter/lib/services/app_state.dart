import 'dart:async';
import 'dart:io';
import 'package:dotogether_client/dotogether_client.dart' as backend;
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_client.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/project.dart';
import '../utils/phone_number_utility.dart';
import '../client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppState extends ChangeNotifier {
  late RecaptchaClient _recaptchaClient;
  bool _isDemoMode = false; // Running with hardcoded demo functionality

  User? _currentUser;
  String? _currentUserUid;
  String? _currentPhoneNumber;
  bool _isLoading = false;

  // Stepper Registration State
  int _registrationStep =
      1; // 1: Input phone, 2: Loading/SMS code sent in progress, 3: Verify code
  String _registrationPhone = '';
  String _verificationId = '';
  String _smsCodeError = '';
  String _phoneError = '';

  int get registrationStep => _registrationStep;
  String get registrationPhone => _registrationPhone;
  String get smsCodeError => _smsCodeError;
  String get phoneError => _phoneError;

  String? _initializeError;
  String? get initializeError => _initializeError;

  // Contacts State
  List<Contact> _contacts = [];
  bool _isLoadingContacts = false;

  // Local/Mock Database State (for Demo Mode)
  final List<Project> _mockProjects = [];
  final StreamController<List<Project>> _mockProjectsController =
      StreamController<List<Project>>.broadcast();

  List<Project> _createdProjects = [];
  List<Project> _receivedProjects = [];

  // Getters
  RecaptchaClient get recaptchaClient => _recaptchaClient;
  bool get isDemoMode => _isDemoMode;
  String? get currentUserUid => _currentUserUid;
  String? get currentPhoneNumber => _currentPhoneNumber;
  bool get isLoading => _isLoading;

  List<Contact> get contacts => _contacts;
  List<Project> get createdProjects => _createdProjects;
  List<Project> get receivedProjects => _receivedProjects;
  bool get isLoadingContacts => _isLoadingContacts;

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
    await _initRecaptchaClient();

    await client.auth.restore();
    if (client.auth.isAuthenticated) {
      await ensureUserInDatabase();
    }
    notifyListeners();
  }

  Future<void> _initRecaptchaClient() async {
    // https://pub.dev/packages/recaptcha_enterprise_flutter
    final siteKey = Platform.isAndroid
        ? "6Le85c4tAAAAAIke5x8jNxjzOEQSujO36SyeXDJw"
        : "6Ldu-c4tAAAAAFZBglNMN6H-Cf8eZurqDwqNU6sG";

    // TODO: learn more about the RecaptchaClient usage and how to integrate it with the app's auth flow
    _recaptchaClient = await Recaptcha.fetchClient(siteKey);
  }

  /// Initialize Firebase or fallback to Demo Mode
  Future<void> _initFirebaseAuth() async {
    _isLoading = true;
    _initializeError = null;
    try {
      // Try to initialize Firebase
      await Firebase.initializeApp();
      _isDemoMode = false;
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
    _mockProjectsController.close();
    super.dispose();
  }

  void _onAuthChanged() {
    if (client.auth.isAuthenticated) {
      _isDemoMode = false;
      ensureUserInDatabase();
    } else if (!_isDemoMode) {
      _currentUserUid = null;
      _currentPhoneNumber = null;
      notifyListeners();
    }
  }

  /// Start demo mode with hardcoded demo functionality and initial mock data
  void startDemoMode() {
    _isDemoMode = true;
    _currentUserUid = 'demo_user_uid';
    _currentPhoneNumber = '+(simulated)12309344';
    _loadMockInitialData();
    notifyListeners();
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
        profile = await client.user.updateProfile();
        debugPrint('User profile created in database with id: ${profile.id}');
      } else {
        debugPrint(
          'Authenticated user found in database: ${profile.authUserId}',
        );
      }

      _currentUserUid = profile.authUserId.toString();
      _currentPhoneNumber = profile.phoneNumber;
      _updateMockStream();
    } catch (e) {
      debugPrint('Error syncing user with database: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load screenshot-matching data for the Simulation/Demo mode
  void _loadMockInitialData() {
    _mockProjects.clear();

    _mockProjects.addAll([
      Project(
        id: 'p1',
        title: 'tasks for you',
        description: 'Assigned to you by Hank. Please review and complete.',
        creatorUid: 'hank_uid',
        creatorPhone: '+(simulated)12309346',
        assigneePhone: '+(simulated)12309344',
        displayName: 'myself',
        status: 'pending',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        todos: [
          TodoItem(text: 'Review project requirements', isCompleted: false),
          TodoItem(text: 'Design splash screen layout', isCompleted: false),
          TodoItem(text: 'Coordinate with database admin', isCompleted: false),
        ],
      ),
      Project(
        id: 'p2',
        title: 'shopping list',
        description: 'Groceries for the weekend dinner.',
        creatorUid: 'john_uid',
        creatorPhone: '+(simulated)15556108',
        assigneePhone: '+(simulated)12309344',
        displayName: 'myself',
        status: 'pending',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        todos: [
          TodoItem(text: 'Tomatoes & Basil', isCompleted: false),
          TodoItem(text: 'Mozzarella cheese', isCompleted: false),
          TodoItem(text: 'Olive oil (extra virgin)', isCompleted: false),
          TodoItem(text: 'Pasta/Spaghetti', isCompleted: false),
        ],
      ),
      Project(
        id: 'p3',
        title: 'project "my company logo"',
        description: 'Design mockups and details.',
        creatorUid: 'me_uid',
        creatorPhone: '+(simulated)12309344',
        assigneePhone: '+(simulated)15555228',
        displayName: 'Anna Haro',
        status: 'completed',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        todos: [
          TodoItem(text: 'Research reference brand assets', isCompleted: true),
          TodoItem(text: 'Draw 3 vector variations', isCompleted: true),
          TodoItem(text: 'Select typography settings', isCompleted: true),
        ],
      ),
      Project(
        id: 'p4',
        title: 'your task for today',
        description: 'Urgent maintenance checks.',
        creatorUid: 'me_uid',
        creatorPhone: '+(simulated)12309344',
        assigneePhone: '+(simulated)15556106',
        displayName: 'Michael Appleseed',
        status: 'in_progress',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        todos: [
          TodoItem(text: 'Check server performance', isCompleted: true),
          TodoItem(text: 'Backup transaction logs', isCompleted: false),
        ],
      ),
    ]);

    _updateMockStream();
  }

  void _updateMockStream() {
    _createdProjects = _mockProjects
        .where((p) => p.creatorPhone == _currentPhoneNumber)
        .toList();
    _receivedProjects = _mockProjects
        .where((p) => p.assigneePhone == _currentPhoneNumber)
        .toList();
    _mockProjectsController.add(_mockProjects);
    notifyListeners();
  }

  /// Sign Out
  Future<void> signOut() async {
    try {
      if (client.auth.isAuthenticated) {
        await client.auth.signOutDevice();
      }
    } catch (e) {
      debugPrint('Error signing out of Serverpod: $e');
    }
    _isDemoMode = false;
    _currentUserUid = null;
    _currentPhoneNumber = null;
    _createdProjects = [];
    _receivedProjects = [];
    notifyListeners();
  }

  // ================= AUTHENTICATION FLOW =================

  /// Step 1: Send SMS Verification Code
  Future<void> sendSmsCode(String rawPhoneNumber) async {
    _isLoading = true;
    _phoneError = '';
    _registrationStep = 2; // Move to step 2 (Requesting SMS...)
    notifyListeners();

    _registrationPhone = PhoneNumberUtility.normalize(rawPhoneNumber);
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

  Future<void> mockSignIn(String phoneNumber) async {
    final authSuccess = await client.phoneAuth.authenticateWithFirebasePhone(
      backend.PhoneAuthPayload(
        phoneNumber: phoneNumber,
        displayName: _currentUser!.displayName ?? 'fake name',
        email: _currentUser!.email ?? 'fake email',
        photoUrl: _currentUser!.photoURL ?? 'fake photo',
      ),
    );

    // https://docs.serverpod.dev/next/concepts/authentication/basics#register-authentication
    await client.auth.updateSignedInUser(authSuccess);
    if (client.auth.isAuthenticated) {
      debugPrint('User is authenticated with Serverpod.');
    }

    var profile = await client.user.getProfile();
    debugPrint('Fetched user profile: $profile');

    _isLoading = false;
    _registrationStep = 1;
    notifyListeners();
  }

  Future<void> _onAuthSuccess() async {
    _currentUser = FirebaseAuth.instance.currentUser;
    _currentPhoneNumber = _currentUser?.phoneNumber;

    final authSuccess = await client.phoneAuth.authenticateWithFirebasePhone(
      backend.PhoneAuthPayload(
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

    _isLoading = false;
    _registrationStep = 1;
    notifyListeners();
  }

  /// Reset the verification stepper state
  void resetStepper() {
    _registrationStep = 1;
    _phoneError = '';
    _smsCodeError = '';
    _isLoading = false;
    notifyListeners();
  }

  // ================= CONTACTS HANDLER =================

  /// Fetch Contacts from device or load high-fidelity simulated contacts
  Future<void> fetchContacts() async {
    _isLoadingContacts = true;
    notifyListeners();

    try {
      // Direct plugin call to verify contacts permission
      final permission = await FlutterContacts.permissions.request(
        PermissionType.read,
      );

      if (!_isDemoMode &&
          [
            PermissionStatus.granted,
            PermissionStatus.limited,
          ].contains(permission)) {
        List<Contact> deviceContacts = await FlutterContacts.getAll(
          properties: {
            ContactProperty.name,
            ContactProperty.phone,
            ContactProperty.email,
          },
        );
        _contacts = deviceContacts;
      } else {
        _loadSimulatedContacts();
      }
    } catch (e) {
      debugPrint("Contacts Fetch Error: $e. Falling back to simulated list.");
      _loadSimulatedContacts();
    }

    _isLoadingContacts = false;
    notifyListeners();
  }

  void _loadSimulatedContacts() {
    _contacts = [
      Contact(
        displayName: 'Hank M. Zakroff',
        phones: [Phone(number: '+(simulated)12309346')],
      ),
      Contact(
        displayName: 'Michael Appleseed',
        phones: [Phone(number: '+(simulated)15556106')],
      ),
      Contact(
        displayName: 'Anna Haro',
        phones: [Phone(number: '+(simulated)15555228')],
      ),
      Contact(
        displayName: 'David Taylor',
        phones: [Phone(number: '+(simulated)15556108')],
      ),
      // Contacts not used in any initial task, available to create new tasks:
      Contact(
        displayName: 'Sarah Connor',
        phones: [Phone(number: '+(simulated)57890123')],
      ),
      Contact(
        displayName: 'John Doe',
        phones: [Phone(number: '+(simulated)85098760')],
      ),
    ];
  }

  // ================= COLLABORATIVE taskList OPERATIONS =================

  /// Create a shared Project / taskList, save to local mock db, and prepare invitation SMS parameters
  Future<Map<String, String>> createProject({
    required String title,
    required String description,
    required String displayName,
    required String assigneeRawPhone,
    required List<String> taskTexts,
  }) async {
    _isLoading = true;
    notifyListeners();

    String normalizedPhone = PhoneNumberUtility.normalize(assigneeRawPhone);

    List<TodoItem> items = taskTexts
        .where((t) => t.trim().isNotEmpty)
        .map((t) => TodoItem(text: t.trim(), isCompleted: false))
        .toList();

    String projectId = 'demo_${DateTime.now().millisecondsSinceEpoch}';

    Project newProject = Project(
      id: projectId,
      title: title.trim(),
      description: description.trim(),
      creatorUid: _currentUserUid ?? 'me_uid',
      creatorPhone: _currentPhoneNumber ?? '+(simulated)12309344',
      assigneePhone: normalizedPhone,
      displayName: displayName,
      status: 'pending',
      createdAt: DateTime.now(),
      todos: items,
    );

    // Save project in mock local state
    _mockProjects.insert(0, newProject);
    _updateMockStream();

    _isLoading = false;
    notifyListeners();

    // Prepare SMS body containing tasks summary and Play Store link
    String tasksSummary = items.map((e) => "- [ ] ${e.text}").join("\n");
    String smsMessage =
        "Hello $displayName!\n"
        "I have created a taskList '$title' for you:\n"
        "$tasksSummary\n\n"
        "${description.isNotEmpty ? 'Details: $description\n' : ''}"
        "Please download the DoTogether app from the Google Play Store to complete these tasks:\n"
        "https://play.google.com/store/apps/details?id=com.dotogether.app";

    return {'recipient': normalizedPhone, 'body': smsMessage};
  }

  /// Update task checkboxes and automatically recalculate overall project progress/status
  Future<void> toggleTask(
    Project project,
    int itemIndex,
    bool isCompleted,
  ) async {
    project.todos[itemIndex].isCompleted = isCompleted;

    // Recalculate status
    double completion = project.completionPercentage;
    String newStatus = 'pending';
    if (completion == 1.0) {
      newStatus = 'completed';
    } else if (completion > 0.0) {
      newStatus = 'in_progress';
    }

    project.status = newStatus;

    int idx = _mockProjects.indexWhere((p) => p.id == project.id);
    if (idx != -1) {
      _mockProjects[idx] = project;
    }
    _updateMockStream();
  }

  /// Launch SMS via standard device URL launcher
  Future<void> sendSMSInvitation(
    String recipientPhone,
    String messageBody,
  ) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: recipientPhone,
      queryParameters: <String, String>{'body': messageBody},
    );

    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        // Fallback standard text intent query launcher
        debugPrint(
          "Could not launch SMS URI directly. Pre-packaging URL standard scheme.",
        );
        String urlString =
            "sms:$recipientPhone?body=${Uri.encodeComponent(messageBody)}";
        Uri parsedUrl = Uri.parse(urlString);
        if (await canLaunchUrl(parsedUrl)) {
          await launchUrl(parsedUrl);
        } else {
          debugPrint("Fail to launch SMS app for $recipientPhone");
        }
      }
    } catch (e) {
      debugPrint("SMS Launch Exception: $e");
    }
  }
}
