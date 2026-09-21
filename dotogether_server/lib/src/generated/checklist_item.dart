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
import 'project.dart' as _ifiazq2p;

abstract class ChecklistItem
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ChecklistItem._({
    this.id,
    required this.projectId,
    this.project,
    required this.title,
    bool? isCompleted,
    int? sortOrder,
    this.completedAt,
  }) : isCompleted = isCompleted ?? false,
       sortOrder = sortOrder ?? 0,
       _projectChecklistitemsProjectId = null;

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
    return ChecklistItemImplicit._(
      id: jsonSerialization['id'] as int?,
      projectId: jsonSerialization['projectId'] as int,
      project: jsonSerialization['project'] == null
          ? null
          : _iv4cxlhu.Protocol().deserialize<_ifiazq2p.Project>(
              jsonSerialization['project'],
            ),
      title: jsonSerialization['title'] as String,
      isCompleted: jsonSerialization['isCompleted'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isCompleted']),
      sortOrder: jsonSerialization['sortOrder'] as int?,
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
      $_projectChecklistitemsProjectId:
          jsonSerialization['_projectChecklistitemsProjectId'] as int?,
    );
  }

  static final t = ChecklistItemTable();

  static const db = ChecklistItemRepository._();

  @override
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

  final int? _projectChecklistitemsProjectId;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ChecklistItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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
      if (_projectChecklistitemsProjectId != null)
        '_projectChecklistitemsProjectId': _projectChecklistitemsProjectId,
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

  static ChecklistItemInclude include({_ifiazq2p.ProjectInclude? project}) {
    return ChecklistItemInclude._(project: project);
  }

  static ChecklistItemIncludeList includeList({
    _is.WhereExpressionBuilder<ChecklistItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChecklistItemTable>? orderBy,
    _is.OrderByListBuilder<ChecklistItemTable>? orderByList,
    ChecklistItemInclude? include,
  }) {
    return ChecklistItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChecklistItem.t),
      orderByList: orderByList?.call(ChecklistItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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
    return ChecklistItemImplicit._(
      id: id is int? ? id : this.id,
      projectId: projectId ?? this.projectId,
      project: project is _ifiazq2p.Project?
          ? project
          : this.project?.copyWith(),
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      sortOrder: sortOrder ?? this.sortOrder,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
      $_projectChecklistitemsProjectId: this._projectChecklistitemsProjectId,
    );
  }
}

class ChecklistItemImplicit extends _ChecklistItemImpl {
  ChecklistItemImplicit._({
    int? id,
    required int projectId,
    _ifiazq2p.Project? project,
    required String title,
    bool? isCompleted,
    int? sortOrder,
    DateTime? completedAt,
    int? $_projectChecklistitemsProjectId,
  }) : _projectChecklistitemsProjectId = $_projectChecklistitemsProjectId,
       super(
         id: id,
         projectId: projectId,
         project: project,
         title: title,
         isCompleted: isCompleted,
         sortOrder: sortOrder,
         completedAt: completedAt,
       );

  factory ChecklistItemImplicit(
    ChecklistItem checklistItem, {
    int? $_projectChecklistitemsProjectId,
  }) {
    return ChecklistItemImplicit._(
      id: checklistItem.id,
      projectId: checklistItem.projectId,
      project: checklistItem.project,
      title: checklistItem.title,
      isCompleted: checklistItem.isCompleted,
      sortOrder: checklistItem.sortOrder,
      completedAt: checklistItem.completedAt,
      $_projectChecklistitemsProjectId: $_projectChecklistitemsProjectId,
    );
  }

  @override
  final int? _projectChecklistitemsProjectId;
}

class ChecklistItemUpdateTable extends _is.UpdateTable<ChecklistItemTable> {
  ChecklistItemUpdateTable(super.table);

  _is.ColumnValue<int, int> projectId(int value) => _is.ColumnValue(
    table.projectId,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<bool, bool> isCompleted(bool value) => _is.ColumnValue(
    table.isCompleted,
    value,
  );

  _is.ColumnValue<int, int> sortOrder(int value) => _is.ColumnValue(
    table.sortOrder,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> completedAt(DateTime? value) =>
      _is.ColumnValue(
        table.completedAt,
        value,
      );

  _is.ColumnValue<int, int> $_projectChecklistitemsProjectId(int? value) =>
      _is.ColumnValue(
        table.$_projectChecklistitemsProjectId,
        value,
      );
}

class ChecklistItemTable extends _is.Table<int?> {
  ChecklistItemTable({super.tableRelation})
    : super(tableName: 'checklist_item') {
    updateTable = ChecklistItemUpdateTable(this);
    projectId = _is.ColumnInt(
      'projectId',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    isCompleted = _is.ColumnBool(
      'isCompleted',
      this,
      hasDefault: true,
    );
    sortOrder = _is.ColumnInt(
      'sortOrder',
      this,
      hasDefault: true,
    );
    completedAt = _is.ColumnDateTime(
      'completedAt',
      this,
    );
    $_projectChecklistitemsProjectId = _is.ColumnInt(
      '_projectChecklistitemsProjectId',
      this,
    );
  }

  late final ChecklistItemUpdateTable updateTable;

  late final _is.ColumnInt projectId;

  /// The project this item belongs to
  _ifiazq2p.ProjectTable? _project;

  /// Task / item description
  late final _is.ColumnString title;

  /// Completion status
  late final _is.ColumnBool isCompleted;

  /// Ordering index of the checklist item
  late final _is.ColumnInt sortOrder;

  /// Timestamp when the item was checked off
  late final _is.ColumnDateTime completedAt;

  late final _is.ColumnInt $_projectChecklistitemsProjectId;

  _ifiazq2p.ProjectTable get project {
    if (_project != null) return _project!;
    _project = _is.createRelationTable(
      relationFieldName: 'project',
      field: ChecklistItem.t.projectId,
      foreignField: _ifiazq2p.Project.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ifiazq2p.ProjectTable(tableRelation: foreignTableRelation),
    );
    return _project!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    projectId,
    title,
    isCompleted,
    sortOrder,
    completedAt,
    $_projectChecklistitemsProjectId,
  ];

  @override
  List<_is.Column> get managedColumns => [
    id,
    projectId,
    title,
    isCompleted,
    sortOrder,
    completedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'project') {
      return project;
    }
    return null;
  }
}

class ChecklistItemInclude extends _is.IncludeObject {
  ChecklistItemInclude._({_ifiazq2p.ProjectInclude? project}) {
    _project = project;
  }

  _ifiazq2p.ProjectInclude? _project;

  @override
  Map<String, _is.Include?> get includes => {'project': _project};

  @override
  _is.Table<int?> get table => ChecklistItem.t;
}

class ChecklistItemIncludeList extends _is.IncludeList {
  ChecklistItemIncludeList._({
    _is.WhereExpressionBuilder<ChecklistItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ChecklistItem.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ChecklistItem.t;
}

class ChecklistItemRepository {
  const ChecklistItemRepository._();

  final attachRow = const ChecklistItemAttachRowRepository._();

  /// Returns a list of [ChecklistItem]s matching the given query parameters.
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
  Future<List<ChecklistItem>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChecklistItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChecklistItemTable>? orderBy,
    _is.OrderByListBuilder<ChecklistItemTable>? orderByList,
    _is.Transaction? transaction,
    ChecklistItemInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ChecklistItem>(
      where: where?.call(ChecklistItem.t),
      orderBy: orderBy?.call(ChecklistItem.t),
      orderByList: orderByList?.call(ChecklistItem.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ChecklistItem] matching the given query parameters.
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
  Future<ChecklistItem?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChecklistItemTable>? where,
    int? offset,
    _is.OrderByBuilder<ChecklistItemTable>? orderBy,
    _is.OrderByListBuilder<ChecklistItemTable>? orderByList,
    _is.Transaction? transaction,
    ChecklistItemInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ChecklistItem>(
      where: where?.call(ChecklistItem.t),
      orderBy: orderBy?.call(ChecklistItem.t),
      orderByList: orderByList?.call(ChecklistItem.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ChecklistItem] by its [id] or null if no such row exists.
  Future<ChecklistItem?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    ChecklistItemInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ChecklistItem>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ChecklistItem]s in the list and returns the inserted rows.
  ///
  /// The returned [ChecklistItem]s will have their `id` fields set.
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
  Future<List<ChecklistItem>> insert(
    _is.DatabaseSession session,
    List<ChecklistItem> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ChecklistItem>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ChecklistItem] and returns the inserted row.
  ///
  /// The returned [ChecklistItem] will have its `id` field set.
  Future<ChecklistItem> insertRow(
    _is.DatabaseSession session,
    ChecklistItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ChecklistItem>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ChecklistItem]s in the list and returns the resulting rows.
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
  /// The returned [ChecklistItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChecklistItem>> upsert(
    _is.DatabaseSession session,
    List<ChecklistItem> rows, {
    required _is.ColumnSelections<ChecklistItemTable> conflictColumns,
    _is.ColumnSelections<ChecklistItemTable>? updateColumns,
    _is.WhereExpressionBuilder<ChecklistItemTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ChecklistItem>(
      rows,
      conflictColumns: conflictColumns(ChecklistItem.t),
      updateColumns: updateColumns?.call(ChecklistItem.t),
      updateWhere: updateWhere?.call(ChecklistItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ChecklistItem] and returns the resulting row.
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
  /// The returned [ChecklistItem] will have its `id` field set.
  Future<ChecklistItem?> upsertRow(
    _is.DatabaseSession session,
    ChecklistItem row, {
    required _is.ColumnSelections<ChecklistItemTable> conflictColumns,
    _is.ColumnSelections<ChecklistItemTable>? updateColumns,
    _is.WhereExpressionBuilder<ChecklistItemTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ChecklistItem>(
      row,
      conflictColumns: conflictColumns(ChecklistItem.t),
      updateColumns: updateColumns?.call(ChecklistItem.t),
      updateWhere: updateWhere?.call(ChecklistItem.t),
      transaction: transaction,
    );
  }

  /// Updates all [ChecklistItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChecklistItem>> update(
    _is.DatabaseSession session,
    List<ChecklistItem> rows, {
    _is.ColumnSelections<ChecklistItemTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ChecklistItem>(
      rows,
      columns: columns?.call(ChecklistItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ChecklistItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ChecklistItem> updateRow(
    _is.DatabaseSession session,
    ChecklistItem row, {
    _is.ColumnSelections<ChecklistItemTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ChecklistItem>(
      row,
      columns: columns?.call(ChecklistItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChecklistItem] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ChecklistItem?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ChecklistItemUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ChecklistItem>(
      id,
      columnValues: columnValues(ChecklistItem.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ChecklistItem]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChecklistItem>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ChecklistItemUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ChecklistItemTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChecklistItemTable>? orderBy,
    _is.OrderByListBuilder<ChecklistItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ChecklistItem>(
      columnValues: columnValues(ChecklistItem.t.updateTable),
      where: where(ChecklistItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChecklistItem.t),
      orderByList: orderByList?.call(ChecklistItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ChecklistItem]s in the list and returns the deleted rows.
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
  Future<List<ChecklistItem>> delete(
    _is.DatabaseSession session,
    List<ChecklistItem> rows, {
    _is.OrderByBuilder<ChecklistItemTable>? orderBy,
    _is.OrderByListBuilder<ChecklistItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ChecklistItem>(
      rows,
      orderBy: orderBy?.call(ChecklistItem.t),
      orderByList: orderByList?.call(ChecklistItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ChecklistItem].
  Future<ChecklistItem> deleteRow(
    _is.DatabaseSession session,
    ChecklistItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ChecklistItem>(
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
  Future<List<ChecklistItem>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ChecklistItemTable> where,
    _is.OrderByBuilder<ChecklistItemTable>? orderBy,
    _is.OrderByListBuilder<ChecklistItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ChecklistItem>(
      where: where(ChecklistItem.t),
      orderBy: orderBy?.call(ChecklistItem.t),
      orderByList: orderByList?.call(ChecklistItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChecklistItemTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ChecklistItem>(
      where: where?.call(ChecklistItem.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ChecklistItem] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ChecklistItemTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ChecklistItem>(
      where: where(ChecklistItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ChecklistItemAttachRowRepository {
  const ChecklistItemAttachRowRepository._();

  /// Creates a relation between the given [ChecklistItem] and [Project]
  /// by setting the [ChecklistItem]'s foreign key `projectId` to refer to the [Project].
  Future<void> project(
    _is.DatabaseSession session,
    ChecklistItem checklistItem,
    _ifiazq2p.Project project, {
    _is.Transaction? transaction,
  }) async {
    if (checklistItem.id == null) {
      throw ArgumentError.notNull('checklistItem.id');
    }
    if (project.id == null) {
      throw ArgumentError.notNull('project.id');
    }

    var $checklistItem = checklistItem.copyWith(projectId: project.id);
    await session.db.updateRow<ChecklistItem>(
      $checklistItem,
      columns: [ChecklistItem.t.projectId],
      transaction: transaction,
    );
  }
}
