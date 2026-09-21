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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class Contact
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Contact._({
    this.id,
    required this.ownerId,
    required this.name,
    required this.phoneNumber,
    bool? isRegistered,
    this.registeredUserId,
    DateTime? createdAt,
  }) : isRegistered = isRegistered ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory Contact({
    int? id,
    required _isc.UuidValue ownerId,
    required String name,
    required String phoneNumber,
    bool? isRegistered,
    _isc.UuidValue? registeredUserId,
    DateTime? createdAt,
  }) = _ContactImpl;

  factory Contact.fromJson(Map<String, dynamic> jsonSerialization) {
    return Contact(
      id: jsonSerialization['id'] as int?,
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      name: jsonSerialization['name'] as String,
      phoneNumber: jsonSerialization['phoneNumber'] as String,
      isRegistered: jsonSerialization['isRegistered'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isRegistered']),
      registeredUserId: jsonSerialization['registeredUserId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['registeredUserId'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// User ID of the contact owner
  _isc.UuidValue ownerId;

  /// Contact name from phone book
  String name;

  /// Contact normalized phone number
  String phoneNumber;

  /// Whether this contact matches a registered user in DoTogether
  bool isRegistered;

  /// Registered AuthUser ID if matched
  _isc.UuidValue? registeredUserId;

  /// When this contact was synced
  DateTime createdAt;

  /// Returns a shallow copy of this [Contact]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Contact copyWith({
    int? id,
    _isc.UuidValue? ownerId,
    String? name,
    String? phoneNumber,
    bool? isRegistered,
    _isc.UuidValue? registeredUserId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Contact',
      if (id != null) 'id': id,
      'ownerId': ownerId.toJson(),
      'name': name,
      'phoneNumber': phoneNumber,
      'isRegistered': isRegistered,
      if (registeredUserId != null)
        'registeredUserId': registeredUserId?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Contact',
      if (id != null) 'id': id,
      'ownerId': ownerId.toJson(),
      'name': name,
      'phoneNumber': phoneNumber,
      'isRegistered': isRegistered,
      if (registeredUserId != null)
        'registeredUserId': registeredUserId?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ContactImpl extends Contact {
  _ContactImpl({
    int? id,
    required _isc.UuidValue ownerId,
    required String name,
    required String phoneNumber,
    bool? isRegistered,
    _isc.UuidValue? registeredUserId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         ownerId: ownerId,
         name: name,
         phoneNumber: phoneNumber,
         isRegistered: isRegistered,
         registeredUserId: registeredUserId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Contact]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Contact copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ownerId,
    String? name,
    String? phoneNumber,
    bool? isRegistered,
    Object? registeredUserId = _Undefined,
    DateTime? createdAt,
  }) {
    return Contact(
      id: id is int? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isRegistered: isRegistered ?? this.isRegistered,
      registeredUserId: registeredUserId is _isc.UuidValue?
          ? registeredUserId
          : this.registeredUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
