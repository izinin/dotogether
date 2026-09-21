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
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;

abstract class AppUserData
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AppUserData._({
    this.id,
    required this.authUserId,
    this.authUser,
    this.phoneNumber,
    this.deviceToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory AppUserData({
    int? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    String? phoneNumber,
    String? deviceToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AppUserDataImpl;

  factory AppUserData.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppUserData(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _iv4cxlhu.Protocol().deserialize<_iacs.AuthUser>(
              jsonSerialization['authUser'],
            ),
      phoneNumber: jsonSerialization['phoneNumber'] as String?,
      deviceToken: jsonSerialization['deviceToken'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = AppUserDataTable();

  static const db = AppUserDataRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  /// The AuthUser this extra profile info belongs to
  _iacs.AuthUser? authUser;

  /// Phone number for SMS and task identification
  String? phoneNumber;

  /// Device push notification token (FCM/APNS)
  String? deviceToken;

  /// Timestamp when this profile was created
  DateTime createdAt;

  /// Timestamp when this profile was last updated
  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AppUserData]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AppUserData copyWith({
    int? id,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
    String? phoneNumber,
    String? deviceToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppUserData',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (deviceToken != null) 'deviceToken': deviceToken,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppUserData',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (deviceToken != null) 'deviceToken': deviceToken,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static AppUserDataInclude include({_iacs.AuthUserInclude? authUser}) {
    return AppUserDataInclude._(authUser: authUser);
  }

  static AppUserDataIncludeList includeList({
    _is.WhereExpressionBuilder<AppUserDataTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AppUserDataTable>? orderBy,
    _is.OrderByListBuilder<AppUserDataTable>? orderByList,
    AppUserDataInclude? include,
  }) {
    return AppUserDataIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppUserData.t),
      orderByList: orderByList?.call(AppUserData.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppUserDataImpl extends AppUserData {
  _AppUserDataImpl({
    int? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    String? phoneNumber,
    String? deviceToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         phoneNumber: phoneNumber,
         deviceToken: deviceToken,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AppUserData]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AppUserData copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    Object? phoneNumber = _Undefined,
    Object? deviceToken = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppUserData(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      phoneNumber: phoneNumber is String? ? phoneNumber : this.phoneNumber,
      deviceToken: deviceToken is String? ? deviceToken : this.deviceToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AppUserDataUpdateTable extends _is.UpdateTable<AppUserDataTable> {
  AppUserDataUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> phoneNumber(String? value) => _is.ColumnValue(
    table.phoneNumber,
    value,
  );

  _is.ColumnValue<String, String> deviceToken(String? value) => _is.ColumnValue(
    table.deviceToken,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class AppUserDataTable extends _is.Table<int?> {
  AppUserDataTable({super.tableRelation}) : super(tableName: 'app_user_data') {
    updateTable = AppUserDataUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    phoneNumber = _is.ColumnString(
      'phoneNumber',
      this,
    );
    deviceToken = _is.ColumnString(
      'deviceToken',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final AppUserDataUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  /// The AuthUser this extra profile info belongs to
  _iacs.AuthUserTable? _authUser;

  /// Phone number for SMS and task identification
  late final _is.ColumnString phoneNumber;

  /// Device push notification token (FCM/APNS)
  late final _is.ColumnString deviceToken;

  /// Timestamp when this profile was created
  late final _is.ColumnDateTime createdAt;

  /// Timestamp when this profile was last updated
  late final _is.ColumnDateTime updatedAt;

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: AppUserData.t.authUserId,
      foreignField: _iacs.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iacs.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    phoneNumber,
    deviceToken,
    createdAt,
    updatedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class AppUserDataInclude extends _is.IncludeObject {
  AppUserDataInclude._({_iacs.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _iacs.AuthUserInclude? _authUser;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<int?> get table => AppUserData.t;
}

class AppUserDataIncludeList extends _is.IncludeList {
  AppUserDataIncludeList._({
    _is.WhereExpressionBuilder<AppUserDataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AppUserData.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AppUserData.t;
}

class AppUserDataRepository {
  const AppUserDataRepository._();

  final attachRow = const AppUserDataAttachRowRepository._();

  /// Returns a list of [AppUserData]s matching the given query parameters.
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
  Future<List<AppUserData>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AppUserDataTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AppUserDataTable>? orderBy,
    _is.OrderByListBuilder<AppUserDataTable>? orderByList,
    _is.Transaction? transaction,
    AppUserDataInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AppUserData>(
      where: where?.call(AppUserData.t),
      orderBy: orderBy?.call(AppUserData.t),
      orderByList: orderByList?.call(AppUserData.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AppUserData] matching the given query parameters.
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
  Future<AppUserData?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AppUserDataTable>? where,
    int? offset,
    _is.OrderByBuilder<AppUserDataTable>? orderBy,
    _is.OrderByListBuilder<AppUserDataTable>? orderByList,
    _is.Transaction? transaction,
    AppUserDataInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AppUserData>(
      where: where?.call(AppUserData.t),
      orderBy: orderBy?.call(AppUserData.t),
      orderByList: orderByList?.call(AppUserData.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AppUserData] by its [id] or null if no such row exists.
  Future<AppUserData?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    AppUserDataInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AppUserData>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AppUserData]s in the list and returns the inserted rows.
  ///
  /// The returned [AppUserData]s will have their `id` fields set.
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
  Future<List<AppUserData>> insert(
    _is.DatabaseSession session,
    List<AppUserData> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AppUserData>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AppUserData] and returns the inserted row.
  ///
  /// The returned [AppUserData] will have its `id` field set.
  Future<AppUserData> insertRow(
    _is.DatabaseSession session,
    AppUserData row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AppUserData>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AppUserData]s in the list and returns the resulting rows.
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
  /// The returned [AppUserData]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AppUserData>> upsert(
    _is.DatabaseSession session,
    List<AppUserData> rows, {
    required _is.ColumnSelections<AppUserDataTable> conflictColumns,
    _is.ColumnSelections<AppUserDataTable>? updateColumns,
    _is.WhereExpressionBuilder<AppUserDataTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AppUserData>(
      rows,
      conflictColumns: conflictColumns(AppUserData.t),
      updateColumns: updateColumns?.call(AppUserData.t),
      updateWhere: updateWhere?.call(AppUserData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AppUserData] and returns the resulting row.
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
  /// The returned [AppUserData] will have its `id` field set.
  Future<AppUserData?> upsertRow(
    _is.DatabaseSession session,
    AppUserData row, {
    required _is.ColumnSelections<AppUserDataTable> conflictColumns,
    _is.ColumnSelections<AppUserDataTable>? updateColumns,
    _is.WhereExpressionBuilder<AppUserDataTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AppUserData>(
      row,
      conflictColumns: conflictColumns(AppUserData.t),
      updateColumns: updateColumns?.call(AppUserData.t),
      updateWhere: updateWhere?.call(AppUserData.t),
      transaction: transaction,
    );
  }

  /// Updates all [AppUserData]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AppUserData>> update(
    _is.DatabaseSession session,
    List<AppUserData> rows, {
    _is.ColumnSelections<AppUserDataTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AppUserData>(
      rows,
      columns: columns?.call(AppUserData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AppUserData]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AppUserData> updateRow(
    _is.DatabaseSession session,
    AppUserData row, {
    _is.ColumnSelections<AppUserDataTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AppUserData>(
      row,
      columns: columns?.call(AppUserData.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppUserData] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AppUserData?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AppUserDataUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AppUserData>(
      id,
      columnValues: columnValues(AppUserData.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AppUserData]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AppUserData>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AppUserDataUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AppUserDataTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AppUserDataTable>? orderBy,
    _is.OrderByListBuilder<AppUserDataTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AppUserData>(
      columnValues: columnValues(AppUserData.t.updateTable),
      where: where(AppUserData.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppUserData.t),
      orderByList: orderByList?.call(AppUserData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AppUserData]s in the list and returns the deleted rows.
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
  Future<List<AppUserData>> delete(
    _is.DatabaseSession session,
    List<AppUserData> rows, {
    _is.OrderByBuilder<AppUserDataTable>? orderBy,
    _is.OrderByListBuilder<AppUserDataTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AppUserData>(
      rows,
      orderBy: orderBy?.call(AppUserData.t),
      orderByList: orderByList?.call(AppUserData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AppUserData].
  Future<AppUserData> deleteRow(
    _is.DatabaseSession session,
    AppUserData row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AppUserData>(
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
  Future<List<AppUserData>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AppUserDataTable> where,
    _is.OrderByBuilder<AppUserDataTable>? orderBy,
    _is.OrderByListBuilder<AppUserDataTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AppUserData>(
      where: where(AppUserData.t),
      orderBy: orderBy?.call(AppUserData.t),
      orderByList: orderByList?.call(AppUserData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AppUserDataTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AppUserData>(
      where: where?.call(AppUserData.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AppUserData] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AppUserDataTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AppUserData>(
      where: where(AppUserData.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class AppUserDataAttachRowRepository {
  const AppUserDataAttachRowRepository._();

  /// Creates a relation between the given [AppUserData] and [AuthUser]
  /// by setting the [AppUserData]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    AppUserData appUserData,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (appUserData.id == null) {
      throw ArgumentError.notNull('appUserData.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $appUserData = appUserData.copyWith(authUserId: authUser.id);
    await session.db.updateRow<AppUserData>(
      $appUserData,
      columns: [AppUserData.t.authUserId],
      transaction: transaction,
    );
  }
}
