import 'package:dotogether_client/dotogether_client.dart';

extension ProjectExtension on Project {
  /// Calculate completion status from checklist items
  double get completionPercentage {
    final items = checklistItems;
    if (items == null || items.isEmpty) return 0.0;
    final int completed = items.where((item) => item.isCompleted).length;
    return completed / items.length;
  }
}
