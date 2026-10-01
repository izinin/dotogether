/// Represents a single checkbox item within a taskList
class TodoItem {
  String text;
  bool isCompleted;

  TodoItem({required this.text, this.isCompleted = false});

  Map<String, dynamic> toMap() {
    return {'text': text, 'isCompleted': isCompleted};
  }

  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      text: map['text'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}

/// Represents a collaborative taskList project assigned to another person
class Project {
  String id;
  String title;
  String description;
  String creatorUid;
  String creatorPhone;
  String assigneePhone;
  String assigneeName;
  String status; // 'pending' | 'in_progress' | 'completed'
  DateTime createdAt;
  List<TodoItem> todos;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.creatorUid,
    required this.creatorPhone,
    required this.assigneePhone,
    required this.assigneeName,
    required this.status,
    required this.createdAt,
    required this.todos,
  });

  /// Calculate completion status
  double get completionPercentage {
    if (todos.isEmpty) return 0.0;
    int completed = todos.where((item) => item.isCompleted).length;
    return completed / todos.length;
  }

  /// Convert to document data map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'creatorUid': creatorUid,
      'creatorPhone': creatorPhone,
      'assigneePhone': assigneePhone,
      'assigneeName': assigneeName,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'todos': todos.map((e) => e.toMap()).toList(),
    };
  }

  /// Create a Project model from map
  factory Project.fromMap(Map<String, dynamic> map, String docId) {
    var rawTodos = map['todos'] as List? ?? [];
    List<TodoItem> parsedTodos = rawTodos
        .map((e) => TodoItem.fromMap(Map<String, dynamic>.from(e)))
        .toList();

    DateTime parsedDate;
    if (map['createdAt'] is DateTime) {
      parsedDate = map['createdAt'] as DateTime;
    } else if (map['createdAt'] is String) {
      parsedDate = DateTime.tryParse(map['createdAt']) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return Project(
      id: docId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      creatorUid: map['creatorUid'] ?? '',
      creatorPhone: map['creatorPhone'] ?? '',
      assigneePhone: map['assigneePhone'] ?? '',
      assigneeName: map['assigneeName'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: parsedDate,
      todos: parsedTodos,
    );
  }
}
