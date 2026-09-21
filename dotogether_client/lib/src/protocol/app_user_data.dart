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
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class AppUserData
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    String? phoneNumber,
    String? deviceToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AppUserDataImpl;

  factory AppUserData.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppUserData(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _ifrsmxp8.Protocol().deserialize<_iacc.AuthUser>(
              jsonSerialization['authUser'],
            ),
      phoneNumber: jsonSerialization['phoneNumber'] as String?,
      deviceToken: jsonSerialization['deviceToken'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  /// The AuthUser this extra profile info belongs to
  _iacc.AuthUser? authUser;

  /// Phone number for SMS and task identification
  String? phoneNumber;

  /// Device push notification token (FCM/APNS)
  String? deviceToken;

  /// Timestamp when this profile was created
  DateTime createdAt;

  /// Timestamp when this profile was last updated
  DateTime updatedAt;

  /// Returns a shallow copy of this [AppUserData]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AppUserData copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    _iacc.AuthUser? authUser,
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppUserDataImpl extends AppUserData {
  _AppUserDataImpl({
    int? id,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
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
  @_isc.useResult
  @override
  AppUserData copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    Object? authUser = _Undefined,
    Object? phoneNumber = _Undefined,
    Object? deviceToken = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppUserData(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacc.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      phoneNumber: phoneNumber is String? ? phoneNumber : this.phoneNumber,
      deviceToken: deviceToken is String? ? deviceToken : this.deviceToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
