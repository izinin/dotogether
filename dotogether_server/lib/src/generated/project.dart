/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dotogether_server/src/generated/protocol.dart' as _iv4cxlhu;
import 'package:serverpod/serverpod.dart' as _is;
import 'checklist_item.dart' as _ifywsnp6;

abstract class Project
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
    required _is.UuidValue ownerId,
    String? ownerPhone,
    _is.UuidValue? executorId,
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
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      ownerPhone: jsonSerialization['ownerPhone'] as String?,
      executorId: jsonSerialization['executorId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['executorId'],
            ),
      assigneePhone: jsonSerialization['assigneePhone'] as String,
      assigneeName: jsonSerialization['assigneeName'] as String,
      overallStatus: jsonSerialization['overallStatus'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      checklistItems: jsonSerialization['checklistItems'] == null
          ? null
          : _iv4cxlhu.Protocol().deserialize<List<_ifywsnp6.ChecklistItem>>(
              jsonSerialization['checklistItems'],
            ),
    );
  }

  static final t = ProjectTable();

  static const db = ProjectRepository._();

  @override
  int? id;

  /// Title of the project or collaborative task
  String title;

  /// Detailed notes or description
  String description;

  /// User ID of the creator / Task Owner
  _is.UuidValue ownerId;

  /// Phone number of the creator
  String? ownerPhone;

  /// User ID of the Task Executor if registered
  _is.UuidValue? executorId;

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

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Project]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Project copyWith({
    int? id,
    String? title,
    String? description,
    _is.UuidValue? ownerId,
    String? ownerPhone,
    _is.UuidValue? executorId,
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

  static ProjectInclude include({
    _ifywsnp6.ChecklistItemIncludeList? checklistItems,
  }) {
    return ProjectInclude._(checklistItems: checklistItems);
  }

  static ProjectIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectTable>? orderBy,
    _is.OrderByListBuilder<ProjectTable>? orderByList,
    ProjectInclude? include,
  }) {
    return ProjectIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Project.t),
      orderByList: orderByList?.call(Project.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectImpl extends Project {
  _ProjectImpl({
    int? id,
    required String title,
    String? description,
    required _is.UuidValue ownerId,
    String? ownerPhone,
    _is.UuidValue? executorId,
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
  @_is.useResult
  @override
  Project copyWith({
    Object? id = _Undefined,
    String? title,
    String? description,
    _is.UuidValue? ownerId,
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
      executorId: executorId is _is.UuidValue? ? executorId : this.executorId,
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

class ProjectUpdateTable extends _is.UpdateTable<ProjectTable> {
  ProjectUpdateTable(super.table);

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> description(String value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<String, String> ownerPhone(String? value) => _is.ColumnValue(
    table.ownerPhone,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> executorId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.executorId,
    value,
  );

  _is.ColumnValue<String, String> assigneePhone(String value) =>
      _is.ColumnValue(
        table.assigneePhone,
        value,
      );

  _is.ColumnValue<String, String> assigneeName(String value) => _is.ColumnValue(
    table.assigneeName,
    value,
  );

  _is.ColumnValue<String, String> overallStatus(String value) =>
      _is.ColumnValue(
        table.overallStatus,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class ProjectTable extends _is.Table<int?> {
  ProjectTable({super.tableRelation}) : super(tableName: 'project') {
    updateTable = ProjectUpdateTable(this);
    title = _is.ColumnString(
      'title',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
      hasDefault: true,
    );
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    ownerPhone = _is.ColumnString(
      'ownerPhone',
      this,
    );
    executorId = _is.ColumnUuid(
      'executorId',
      this,
    );
    assigneePhone = _is.ColumnString(
      'assigneePhone',
      this,
    );
    assigneeName = _is.ColumnString(
      'assigneeName',
      this,
    );
    overallStatus = _is.ColumnString(
      'overallStatus',
      this,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final ProjectUpdateTable updateTable;

  /// Title of the project or collaborative task
  late final _is.ColumnString title;

  /// Detailed notes or description
  late final _is.ColumnString description;

  /// User ID of the creator / Task Owner
  late final _is.ColumnUuid ownerId;

  /// Phone number of the creator
  late final _is.ColumnString ownerPhone;

  /// User ID of the Task Executor if registered
  late final _is.ColumnUuid executorId;

  /// Contact phone number of the assignee
  late final _is.ColumnString assigneePhone;

  /// Display name of the assignee
  late final _is.ColumnString assigneeName;

  /// Overall progress status: 'pending', 'in_progress', 'completed'
  late final _is.ColumnString overallStatus;

  /// When the project was created
  late final _is.ColumnDateTime createdAt;

  /// Interactive checklist items
  _ifywsnp6.ChecklistItemTable? ___checklistItems;

  /// Interactive checklist items
  _is.ManyRelation<_ifywsnp6.ChecklistItemTable>? _checklistItems;

  _ifywsnp6.ChecklistItemTable get __checklistItems {
    if (___checklistItems != null) return ___checklistItems!;
    ___checklistItems = _is.createRelationTable(
      relationFieldName: '__checklistItems',
      field: Project.t.id,
      foreignField: _ifywsnp6.ChecklistItem.t.$_projectChecklistitemsProjectId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ifywsnp6.ChecklistItemTable(tableRelation: foreignTableRelation),
    );
    return ___checklistItems!;
  }

  _is.ManyRelation<_ifywsnp6.ChecklistItemTable> get checklistItems {
    if (_checklistItems != null) return _checklistItems!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'checklistItems',
      field: Project.t.id,
      foreignField: _ifywsnp6.ChecklistItem.t.$_projectChecklistitemsProjectId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ifywsnp6.ChecklistItemTable(tableRelation: foreignTableRelation),
    );
    _checklistItems = _is.ManyRelation<_ifywsnp6.ChecklistItemTable>(
      tableWithRelations: relationTable,
      table: _ifywsnp6.ChecklistItemTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _checklistItems!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    title,
    description,
    ownerId,
    ownerPhone,
    executorId,
    assigneePhone,
    assigneeName,
    overallStatus,
    createdAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'checklistItems') {
      return __checklistItems;
    }
    return null;
  }
}

class ProjectInclude extends _is.IncludeObject {
  ProjectInclude._({_ifywsnp6.ChecklistItemIncludeList? checklistItems}) {
    _checklistItems = checklistItems;
  }

  _ifywsnp6.ChecklistItemIncludeList? _checklistItems;

  @override
  Map<String, _is.Include?> get includes => {'checklistItems': _checklistItems};

  @override
  _is.Table<int?> get table => Project.t;
}

class ProjectIncludeList extends _is.IncludeList {
  ProjectIncludeList._({
    _is.WhereExpressionBuilder<ProjectTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Project.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Project.t;
}

class ProjectRepository {
  const ProjectRepository._();

  final attach = const ProjectAttachRepository._();

  final attachRow = const ProjectAttachRowRepository._();

  final detach = const ProjectDetachRepository._();

  final detachRow = const ProjectDetachRowRepository._();

  /// Returns a list of [Project]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Project>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectTable>? orderBy,
    _is.OrderByListBuilder<ProjectTable>? orderByList,
    _is.Transaction? transaction,
    ProjectInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Project>(
      where: where?.call(Project.t),
      orderBy: orderBy?.call(Project.t),
      orderByList: orderByList?.call(Project.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Project] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Project?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectTable>? orderBy,
    _is.OrderByListBuilder<ProjectTable>? orderByList,
    _is.Transaction? transaction,
    ProjectInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Project>(
      where: where?.call(Project.t),
      orderBy: orderBy?.call(Project.t),
      orderByList: orderByList?.call(Project.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Project] by its [id] or null if no such row exists.
  Future<Project?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    ProjectInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Project>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Project]s in the list and returns the inserted rows.
  ///
  /// The returned [Project]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Project>> insert(
    _is.DatabaseSession session,
    List<Project> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Project>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Project] and returns the inserted row.
  ///
  /// The returned [Project] will have its `id` field set.
  Future<Project> insertRow(
    _is.DatabaseSession session,
    Project row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Project>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Project]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Project]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Project>> upsert(
    _is.DatabaseSession session,
    List<Project> rows, {
    required _is.ColumnSelections<ProjectTable> conflictColumns,
    _is.ColumnSelections<ProjectTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Project>(
      rows,
      conflictColumns: conflictColumns(Project.t),
      updateColumns: updateColumns?.call(Project.t),
      updateWhere: updateWhere?.call(Project.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Project] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Project] will have its `id` field set.
  Future<Project?> upsertRow(
    _is.DatabaseSession session,
    Project row, {
    required _is.ColumnSelections<ProjectTable> conflictColumns,
    _is.ColumnSelections<ProjectTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Project>(
      row,
      conflictColumns: conflictColumns(Project.t),
      updateColumns: updateColumns?.call(Project.t),
      updateWhere: updateWhere?.call(Project.t),
      transaction: transaction,
    );
  }

  /// Updates all [Project]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Project>> update(
    _is.DatabaseSession session,
    List<Project> rows, {
    _is.ColumnSelections<ProjectTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Project>(
      rows,
      columns: columns?.call(Project.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Project]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Project> updateRow(
    _is.DatabaseSession session,
    Project row, {
    _is.ColumnSelections<ProjectTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Project>(
      row,
      columns: columns?.call(Project.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Project] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Project?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ProjectUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Project>(
      id,
      columnValues: columnValues(Project.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Project]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Project>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProjectUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ProjectTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectTable>? orderBy,
    _is.OrderByListBuilder<ProjectTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Project>(
      columnValues: columnValues(Project.t.updateTable),
      where: where(Project.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Project.t),
      orderByList: orderByList?.call(Project.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Project]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Project>> delete(
    _is.DatabaseSession session,
    List<Project> rows, {
    _is.OrderByBuilder<ProjectTable>? orderBy,
    _is.OrderByListBuilder<ProjectTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Project>(
      rows,
      orderBy: orderBy?.call(Project.t),
      orderByList: orderByList?.call(Project.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Project].
  Future<Project> deleteRow(
    _is.DatabaseSession session,
    Project row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Project>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Project>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectTable> where,
    _is.OrderByBuilder<ProjectTable>? orderBy,
    _is.OrderByListBuilder<ProjectTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Project>(
      where: where(Project.t),
      orderBy: orderBy?.call(Project.t),
      orderByList: orderByList?.call(Project.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Project>(
      where: where?.call(Project.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Project] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Project>(
      where: where(Project.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ProjectAttachRepository {
  const ProjectAttachRepository._();

  /// Creates a relation between this [Project] and the given [ChecklistItem]s
  /// by setting each [ChecklistItem]'s foreign key `_projectChecklistitemsProjectId` to refer to this [Project].
  Future<void> checklistItems(
    _is.DatabaseSession session,
    Project project,
    List<_ifywsnp6.ChecklistItem> checklistItem, {
    _is.Transaction? transaction,
  }) async {
    if (checklistItem.any((e) => e.id == null)) {
      throw ArgumentError.notNull('checklistItem.id');
    }
    if (project.id == null) {
      throw ArgumentError.notNull('project.id');
    }

    var $checklistItem = checklistItem
        .map(
          (e) => _ifywsnp6.ChecklistItemImplicit(
            e,
            $_projectChecklistitemsProjectId: project.id,
          ),
        )
        .toList();
    await session.db.update<_ifywsnp6.ChecklistItem>(
      $checklistItem,
      columns: [_ifywsnp6.ChecklistItem.t.$_projectChecklistitemsProjectId],
      transaction: transaction,
    );
  }
}

class ProjectAttachRowRepository {
  const ProjectAttachRowRepository._();

  /// Creates a relation between this [Project] and the given [ChecklistItem]
  /// by setting the [ChecklistItem]'s foreign key `_projectChecklistitemsProjectId` to refer to this [Project].
  Future<void> checklistItems(
    _is.DatabaseSession session,
    Project project,
    _ifywsnp6.ChecklistItem checklistItem, {
    _is.Transaction? transaction,
  }) async {
    if (checklistItem.id == null) {
      throw ArgumentError.notNull('checklistItem.id');
    }
    if (project.id == null) {
      throw ArgumentError.notNull('project.id');
    }

    var $checklistItem = _ifywsnp6.ChecklistItemImplicit(
      checklistItem,
      $_projectChecklistitemsProjectId: project.id,
    );
    await session.db.updateRow<_ifywsnp6.ChecklistItem>(
      $checklistItem,
      columns: [_ifywsnp6.ChecklistItem.t.$_projectChecklistitemsProjectId],
      transaction: transaction,
    );
  }
}

class ProjectDetachRepository {
  const ProjectDetachRepository._();

  /// Detaches the relation between this [Project] and the given [ChecklistItem]
  /// by setting the [ChecklistItem]'s foreign key `_projectChecklistitemsProjectId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> checklistItems(
    _is.DatabaseSession session,
    List<_ifywsnp6.ChecklistItem> checklistItem, {
    _is.Transaction? transaction,
  }) async {
    if (checklistItem.any((e) => e.id == null)) {
      throw ArgumentError.notNull('checklistItem.id');
    }

    var $checklistItem = checklistItem
        .map(
          (e) => _ifywsnp6.ChecklistItemImplicit(
            e,
            $_projectChecklistitemsProjectId: null,
          ),
        )
        .toList();
    await session.db.update<_ifywsnp6.ChecklistItem>(
      $checklistItem,
      columns: [_ifywsnp6.ChecklistItem.t.$_projectChecklistitemsProjectId],
      transaction: transaction,
    );
  }
}

class ProjectDetachRowRepository {
  const ProjectDetachRowRepository._();

  /// Detaches the relation between this [Project] and the given [ChecklistItem]
  /// by setting the [ChecklistItem]'s foreign key `_projectChecklistitemsProjectId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> checklistItems(
    _is.DatabaseSession session,
    _ifywsnp6.ChecklistItem checklistItem, {
    _is.Transaction? transaction,
  }) async {
    if (checklistItem.id == null) {
      throw ArgumentError.notNull('checklistItem.id');
    }

    var $checklistItem = _ifywsnp6.ChecklistItemImplicit(
      checklistItem,
      $_projectChecklistitemsProjectId: null,
    );
    await session.db.updateRow<_ifywsnp6.ChecklistItem>(
      $checklistItem,
      columns: [_ifywsnp6.ChecklistItem.t.$_projectChecklistitemsProjectId],
      transaction: transaction,
    );
  }
}
