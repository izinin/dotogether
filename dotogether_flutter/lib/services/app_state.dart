import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/project.dart';
import '../utils/phone_number_utility.dart';
import '../client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

class AppState extends ChangeNotifier {
  bool _isInitialized = false;

  String? _currentUserUid;
  String? _currentPhoneNumber;
  bool _isLoading = false;

  // Contacts State
  List<Contact> _contacts = [];
  bool _isLoadingContacts = false;
  bool _hasContactPermission = false;

  // Local/Mock Database State (for Demo Mode)
  final List<Project> _mockProjects = [];
  final StreamController<List<Project>> _mockProjectsController =
      StreamController<List<Project>>.broadcast();

  List<Project> _createdProjects = [];
  List<Project> _receivedProjects = [];

  // Getters
  bool get isInitialized => _isInitialized;
  String? get currentUserUid => _currentUserUid;
  String? get currentPhoneNumber => _currentPhoneNumber;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => client.auth.isAuthenticated;

  List<Contact> get contacts => _contacts;
  bool get isLoadingContacts => _isLoadingContacts;
  bool get hasContactPermission => _hasContactPermission;

  List<Project> get createdProjects => _createdProjects;
  List<Project> get receivedProjects => _receivedProjects;

  AppState() {
    _initialize();
    client.auth.authInfoListenable.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_onAuthChanged);
    _mockProjectsController.close();
    super.dispose();
  }

  void _onAuthChanged() {
    if (client.auth.isAuthenticated) {
      ensureUserInDatabase();
    } else {
      _currentUserUid = null;
      _currentPhoneNumber = null;
      notifyListeners();
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
        profile = await client.user.updateProfile();
        debugPrint('User profile created in database with id: ${profile.id}');
      } else {
        debugPrint('Authenticated user found in database: ${profile.authUserId}');
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

  /// Initialize state
  Future<void> _initialize() async {
    if (client.auth.isAuthenticated) {
      await ensureUserInDatabase();
    }
    _loadMockInitialData();
    _isInitialized = true;
    notifyListeners();
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
        creatorPhone: '+358401234567',
        assigneePhone: '+358442096093',
        assigneeName: 'Hank M. Zakroff',
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
        creatorPhone: '+15556106679',
        assigneePhone: '+358442096093',
        assigneeName: 'John Appleseed',
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
        creatorPhone: '+358442096093',
        assigneePhone: '+15555228243',
        assigneeName: 'Anna Haro',
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
        creatorPhone: '+358442096093',
        assigneePhone: '+15556106680',
        assigneeName: 'David Taylor',
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
    _currentUserUid = null;
    _currentPhoneNumber = null;
    _createdProjects = [];
    _receivedProjects = [];
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
      _hasContactPermission = permission == PermissionStatus.granted;

      if (permission == PermissionStatus.granted) {
        List<Contact> deviceContacts = await FlutterContacts.getAll();
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
        name: Name(first: 'Hank', last: 'M. Zakroff'),
        phones: [Phone(number: '+358401234567')],
      ),
      Contact(
        name: Name(first: 'John', last: 'Appleseed'),
        phones: [Phone(number: '+1 (555) 610-6679')],
      ),
      Contact(
        name: Name(first: 'Anna', last: 'Haro'),
        phones: [Phone(number: '+1 (555) 522-8243')],
      ),
      Contact(
        name: Name(first: 'David', last: 'Taylor'),
        phones: [Phone(number: '+1 (555) 610-6680')],
      ),
    ];
  }

  // ================= COLLABORATIVE taskList OPERATIONS =================

  /// Create a shared Project / taskList, save to local mock db, and prepare invitation SMS parameters
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
      creatorPhone: _currentPhoneNumber ?? '+358442096093',
      assigneePhone: normalizedPhone,
      assigneeName: assigneeName,
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
        "Hello $assigneeName!\n"
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
