// Hardcoded demo/mock data used only when the app is running in Demo Mode
// (see `AppState.isDemoMode`). Kept separate from `app_state.dart` so the
// real (server-backed) logic isn't cluttered with fixture data.
import 'package:dotogether_client/dotogether_client.dart';
import '../utils/project_extension.dart';

class MockData {
  // Local/Mock Database State (for Demo Mode)
  final List<Project> _mockProjects = [];
  bool isDemoMode = false; // Running with hardcoded demo functionality

  String? _currentPhoneNumber;

  String? get currentPhoneNumber => _currentPhoneNumber;

  List<Project> _createdProjects = [];
  List<Project> _receivedProjects = [];
  List<Project> get createdProjects => _createdProjects;
  List<Project> get receivedProjects => _receivedProjects;

  // Contacts State
  List<Contact> _contacts = [];
  List<Contact> get contacts => _contacts;

  /// Start demo mode with hardcoded demo functionality and initial mock data
  void startDemoMode() {
    isDemoMode = true;
    _currentPhoneNumber = '+(simulated)12309344';
    _mockProjects.clear();
    _mockProjects.addAll(_predefinedProjects());
    _contacts = _buildSimulatedContacts();
    updateMockProjects();
  }

  void updateMockProjects() {
    _createdProjects = _mockProjects
        .where((p) => p.owner?.phoneNumber == _currentPhoneNumber)
        .toList();
    _receivedProjects = _mockProjects
        .where((p) => p.assignee?.phoneNumber == _currentPhoneNumber)
        .toList();
  }

  /// Demo-mode-only: build and insert a `Project` into the local mock db.
  void createMockProject({
    required String title,
    required String description,
    required String assigneeName,
    required String normalizedPhone,
    required List<String> checklistTitles,
  }) {
    int projectId = DateTime.now().millisecondsSinceEpoch;

    List<ChecklistItem> items = [];
    int sortIdx = 0;
    for (var taskTitle in checklistTitles) {
      items.add(
        ChecklistItem(
          id: DateTime.now().millisecondsSinceEpoch + sortIdx,
          projectId: projectId,
          title: taskTitle,
          isCompleted: false,
          sortOrder: sortIdx++,
        ),
      );
    }

    Project newProject = Project(
      id: projectId,
      title: title.trim(),
      description: description.trim(),
      ownerId: projectId * 10 + 1,
      owner: Contact(
        id: projectId * 10 + 1,
        name: 'myself',
        phoneNumber: _currentPhoneNumber ?? '+(simulated)12309344',
        isRegistered: true,
        registeredUserId: UuidValue.fromString(
          '6ba7b810-9dad-11d1-80b4-00c04fd430c8',
        ),
        createdAt: DateTime.now(),
      ),
      assigneeId: projectId * 10 + 2,
      assignee: Contact(
        id: projectId * 10 + 2,
        name: assigneeName,
        phoneNumber: normalizedPhone,
        createdAt: DateTime.now(),
      ),
      overallStatus: 'pending',
      createdAt: DateTime.now(),
      checklistItems: items,
    );

    // Save project in mock local state
    _mockProjects.insert(0, newProject);
    updateMockProjects();
  }

  /// Screenshot-matching demo projects for the Demo Mode dashboard.
  List<Project> _predefinedProjects() {
    return [
      Project(
        id: 1,
        title: 'tasks for you',
        description: 'Assigned to you by Hank. Please review and complete.',
        ownerId: 11,
        owner: Contact(
          id: 11,
          name: 'Hank M. Zakroff',
          phoneNumber: '+(simulated)12309346',
          createdAt: DateTime.now(),
        ),
        assigneeId: 12,
        assignee: Contact(
          id: 12,
          name: 'myself',
          phoneNumber: '+(simulated)12309344',
          createdAt: DateTime.now(),
        ),
        overallStatus: 'pending',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        checklistItems: [
          ChecklistItem(
            id: 1,
            projectId: 1,
            title: 'Review project requirements',
            isCompleted: false,
          ),
          ChecklistItem(
            id: 2,
            projectId: 1,
            title: 'Design splash screen layout',
            isCompleted: false,
          ),
          ChecklistItem(
            id: 3,
            projectId: 1,
            title: 'Coordinate with database admin',
            isCompleted: false,
          ),
        ],
      ),
      Project(
        id: 2,
        title: 'shopping list',
        description: 'Groceries for the weekend dinner.',
        ownerId: 21,
        owner: Contact(
          id: 21,
          name: 'David Taylor',
          phoneNumber: '+(simulated)15556108',
          createdAt: DateTime.now(),
        ),
        assigneeId: 22,
        assignee: Contact(
          id: 22,
          name: 'myself',
          phoneNumber: '+(simulated)12309344',
          createdAt: DateTime.now(),
        ),
        overallStatus: 'pending',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        checklistItems: [
          ChecklistItem(
            id: 4,
            projectId: 2,
            title: 'Tomatoes & Basil',
            isCompleted: false,
          ),
          ChecklistItem(
            id: 5,
            projectId: 2,
            title: 'Mozzarella cheese',
            isCompleted: false,
          ),
          ChecklistItem(
            id: 6,
            projectId: 2,
            title: 'Olive oil (extra virgin)',
            isCompleted: false,
          ),
          ChecklistItem(
            id: 7,
            projectId: 2,
            title: 'Pasta/Spaghetti',
            isCompleted: false,
          ),
        ],
      ),
      Project(
        id: 3,
        title: 'project "my company logo"',
        description: 'Design mockups and details.',
        ownerId: 31,
        owner: Contact(
          id: 31,
          name: 'myself',
          phoneNumber: '+(simulated)12309344',
          createdAt: DateTime.now(),
        ),
        assigneeId: 32,
        assignee: Contact(
          id: 32,
          name: 'Anna Haro',
          phoneNumber: '+(simulated)15555228',
          createdAt: DateTime.now(),
        ),
        overallStatus: 'completed',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        checklistItems: [
          ChecklistItem(
            id: 8,
            projectId: 3,
            title: 'Research reference brand assets',
            isCompleted: true,
          ),
          ChecklistItem(
            id: 9,
            projectId: 3,
            title: 'Draw 3 vector variations',
            isCompleted: true,
          ),
          ChecklistItem(
            id: 10,
            projectId: 3,
            title: 'Select typography settings',
            isCompleted: true,
          ),
        ],
      ),
      Project(
        id: 4,
        title: 'your task for today',
        description: 'Urgent maintenance checks.',
        ownerId: 41,
        owner: Contact(
          id: 41,
          name: 'myself',
          phoneNumber: '+(simulated)12309344',
          createdAt: DateTime.now(),
        ),
        assigneeId: 42,
        assignee: Contact(
          id: 42,
          name: 'Michael Appleseed',
          phoneNumber: '+(simulated)15556106',
          createdAt: DateTime.now(),
        ),
        overallStatus: 'in_progress',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        checklistItems: [
          ChecklistItem(
            id: 11,
            projectId: 4,
            title: 'Check server performance',
            isCompleted: true,
          ),
          ChecklistItem(
            id: 12,
            projectId: 4,
            title: 'Backup transaction logs',
            isCompleted: false,
          ),
        ],
      ),
    ];
  }

  /// High-fidelity simulated contacts used when running in Demo Mode.
  List<Contact> _buildSimulatedContacts() {
    Contact simulated(String name, String phone) => Contact(
      name: name,
      phoneNumber: phone,
      createdAt: DateTime.now(),
    );

    return [
      simulated('Hank M. Zakroff', '+(simulated)12309346'),
      simulated('Michael Appleseed', '+(simulated)15556106'),
      simulated('Anna Haro', '+(simulated)15555228'),
      simulated('David Taylor', '+(simulated)15556108'),
      // Contacts not used in any initial task, available to create new tasks:
      simulated('Sarah Connor', '+(simulated)57890123'),
      simulated('John Doe', '+(simulated)85098760'),
    ];
  }

  Future<void> toggleTask(
    Project project,
    int itemIndex,
    bool isCompleted,
  ) async {
    final items = project.checklistItems;
    if (items != null && itemIndex < items.length) {
      items[itemIndex].isCompleted = isCompleted;
      if (isCompleted) {
        items[itemIndex].completedAt = DateTime.now();
      }
    }

    // Recalculate status
    double completion = project.completionPercentage;
    String newStatus = 'pending';
    if (completion == 1.0) {
      newStatus = 'completed';
    } else if (completion > 0.0) {
      newStatus = 'in_progress';
    }

    project.overallStatus = newStatus;

    int idx = _mockProjects.indexWhere((p) => p.id == project.id);
    if (idx != -1) {
      _mockProjects[idx] = project;
    }
    updateMockProjects();
  }
}
