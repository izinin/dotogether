/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dotogether_client/src/protocol/protocol.dart' as _ifrsmxp8;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'project.dart' as _ifiazq2p;

abstract class ChecklistItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ChecklistItem._({
    this.id,
    required this.projectId,
    this.project,
    required this.title,
    bool? isCompleted,
    int? sortOrder,
    this.completedAt,
  }) : isCompleted = isCompleted ?? false,
       sortOrder = sortOrder ?? 0;

  factory ChecklistItem({
    int? id,
    required int projectId,
    _ifiazq2p.Project? project,
    required String title,
    bool? isCompleted,
    int? sortOrder,
    DateTime? completedAt,
  }) = _ChecklistItemImpl;

  factory ChecklistItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChecklistItem(
      id: jsonSerialization['id'] as int?,
      projectId: jsonSerialization['projectId'] as int,
      project: jsonSerialization['project'] == null
          ? null
          : _ifrsmxp8.Protocol().deserialize<_ifiazq2p.Project>(
              jsonSerialization['project'],
            ),
      title: jsonSerialization['title'] as String,
      isCompleted: jsonSerialization['isCompleted'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isCompleted']),
      sortOrder: jsonSerialization['sortOrder'] as int?,
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int projectId;

  /// The project this item belongs to
  _ifiazq2p.Project? project;

  /// Task / item description
  String title;

  /// Completion status
  bool isCompleted;

  /// Ordering index of the checklist item
  int sortOrder;

  /// Timestamp when the item was checked off
  DateTime? completedAt;

  /// Returns a shallow copy of this [ChecklistItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ChecklistItem copyWith({
    int? id,
    int? projectId,
    _ifiazq2p.Project? project,
    String? title,
    bool? isCompleted,
    int? sortOrder,
    DateTime? completedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChecklistItem',
      if (id != null) 'id': id,
      'projectId': projectId,
      if (project != null) 'project': project?.toJson(),
      'title': title,
      'isCompleted': isCompleted,
      'sortOrder': sortOrder,
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChecklistItem',
      if (id != null) 'id': id,
      'projectId': projectId,
      if (project != null) 'project': project?.toJsonForProtocol(),
      'title': title,
      'isCompleted': isCompleted,
      'sortOrder': sortOrder,
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChecklistItemImpl extends ChecklistItem {
  _ChecklistItemImpl({
    int? id,
    required int projectId,
    _ifiazq2p.Project? project,
    required String title,
    bool? isCompleted,
    int? sortOrder,
    DateTime? completedAt,
  }) : super._(
         id: id,
         projectId: projectId,
         project: project,
         title: title,
         isCompleted: isCompleted,
         sortOrder: sortOrder,
         completedAt: completedAt,
       );

  /// Returns a shallow copy of this [ChecklistItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ChecklistItem copyWith({
    Object? id = _Undefined,
    int? projectId,
    Object? project = _Undefined,
    String? title,
    bool? isCompleted,
    int? sortOrder,
    Object? completedAt = _Undefined,
  }) {
    return ChecklistItem(
      id: id is int? ? id : this.id,
      projectId: projectId ?? this.projectId,
      project: project is _ifiazq2p.Project?
          ? project
          : this.project?.copyWith(),
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      sortOrder: sortOrder ?? this.sortOrder,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
    );
  }
}
