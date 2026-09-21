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
import 'checklist_item.dart' as _ifywsnp6;

abstract class Project
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Project._({
    this.id,
    required this.title,
    String? description,
    required this.ownerId,
    this.ownerPhone,
    this.executorId,
    required this.assigneePhone,
    required this.assigneeName,
    String? overallStatus,
    DateTime? createdAt,
    this.checklistItems,
  }) : description = description ?? '',
       overallStatus = overallStatus ?? 'pending',
       createdAt = createdAt ?? DateTime.now();

  factory Project({
    int? id,
    required String title,
    String? description,
    required _isc.UuidValue ownerId,
    String? ownerPhone,
    _isc.UuidValue? executorId,
    required String assigneePhone,
    required String assigneeName,
    String? overallStatus,
    DateTime? createdAt,
    List<_ifywsnp6.ChecklistItem>? checklistItems,
  }) = _ProjectImpl;

  factory Project.fromJson(Map<String, dynamic> jsonSerialization) {
    return Project(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      ownerPhone: jsonSerialization['ownerPhone'] as String?,
      executorId: jsonSerialization['executorId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['executorId'],
            ),
      assigneePhone: jsonSerialization['assigneePhone'] as String,
      assigneeName: jsonSerialization['assigneeName'] as String,
      overallStatus: jsonSerialization['overallStatus'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      checklistItems: jsonSerialization['checklistItems'] == null
          ? null
          : _ifrsmxp8.Protocol().deserialize<List<_ifywsnp6.ChecklistItem>>(
              jsonSerialization['checklistItems'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Title of the project or collaborative task
  String title;

  /// Detailed notes or description
  String description;

  /// User ID of the creator / Task Owner
  _isc.UuidValue ownerId;

  /// Phone number of the creator
  String? ownerPhone;

  /// User ID of the Task Executor if registered
  _isc.UuidValue? executorId;

  /// Contact phone number of the assignee
  String assigneePhone;

  /// Display name of the assignee
  String assigneeName;

  /// Overall progress status: 'pending', 'in_progress', 'completed'
  String overallStatus;

  /// When the project was created
  DateTime createdAt;

  /// Interactive checklist items
  List<_ifywsnp6.ChecklistItem>? checklistItems;

  /// Returns a shallow copy of this [Project]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Project copyWith({
    int? id,
    String? title,
    String? description,
    _isc.UuidValue? ownerId,
    String? ownerPhone,
    _isc.UuidValue? executorId,
    String? assigneePhone,
    String? assigneeName,
    String? overallStatus,
    DateTime? createdAt,
    List<_ifywsnp6.ChecklistItem>? checklistItems,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Project',
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'ownerId': ownerId.toJson(),
      if (ownerPhone != null) 'ownerPhone': ownerPhone,
      if (executorId != null) 'executorId': executorId?.toJson(),
      'assigneePhone': assigneePhone,
      'assigneeName': assigneeName,
      'overallStatus': overallStatus,
      'createdAt': createdAt.toJson(),
      if (checklistItems != null)
        'checklistItems': checklistItems?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Project',
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'ownerId': ownerId.toJson(),
      if (ownerPhone != null) 'ownerPhone': ownerPhone,
      if (executorId != null) 'executorId': executorId?.toJson(),
      'assigneePhone': assigneePhone,
      'assigneeName': assigneeName,
      'overallStatus': overallStatus,
      'createdAt': createdAt.toJson(),
      if (checklistItems != null)
        'checklistItems': checklistItems?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectImpl extends Project {
  _ProjectImpl({
    int? id,
    required String title,
    String? description,
    required _isc.UuidValue ownerId,
    String? ownerPhone,
    _isc.UuidValue? executorId,
    required String assigneePhone,
    required String assigneeName,
    String? overallStatus,
    DateTime? createdAt,
    List<_ifywsnp6.ChecklistItem>? checklistItems,
  }) : super._(
         id: id,
         title: title,
         description: description,
         ownerId: ownerId,
         ownerPhone: ownerPhone,
         executorId: executorId,
         assigneePhone: assigneePhone,
         assigneeName: assigneeName,
         overallStatus: overallStatus,
         createdAt: createdAt,
         checklistItems: checklistItems,
       );

  /// Returns a shallow copy of this [Project]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Project copyWith({
    Object? id = _Undefined,
    String? title,
    String? description,
    _isc.UuidValue? ownerId,
    Object? ownerPhone = _Undefined,
    Object? executorId = _Undefined,
    String? assigneePhone,
    String? assigneeName,
    String? overallStatus,
    DateTime? createdAt,
    Object? checklistItems = _Undefined,
  }) {
    return Project(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      ownerPhone: ownerPhone is String? ? ownerPhone : this.ownerPhone,
      executorId: executorId is _isc.UuidValue? ? executorId : this.executorId,
      assigneePhone: assigneePhone ?? this.assigneePhone,
      assigneeName: assigneeName ?? this.assigneeName,
      overallStatus: overallStatus ?? this.overallStatus,
      createdAt: createdAt ?? this.createdAt,
      checklistItems: checklistItems is List<_ifywsnp6.ChecklistItem>?
          ? checklistItems
          : this.checklistItems?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
