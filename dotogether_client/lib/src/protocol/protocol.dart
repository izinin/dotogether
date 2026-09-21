/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dotogether_client/src/protocol/contact.dart' as _ilzv33bz;
import 'package:dotogether_client/src/protocol/project.dart' as _ie83d1fr;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'app_user_data.dart' as _ieco5lxt;
import 'checklist_item.dart' as _ifywsnp6;
import 'contact.dart' as _id7ivncr;
import 'greetings/greeting.dart' as _izw8z7ou;
import 'project.dart' as _ifiazq2p;
export 'app_user_data.dart';
export 'checklist_item.dart';
export 'contact.dart';
export 'greetings/greeting.dart';
export 'project.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ieco5lxt.AppUserData) {
      return _ieco5lxt.AppUserData.fromJson(data) as T;
    }
    if (t == _ifywsnp6.ChecklistItem) {
      return _ifywsnp6.ChecklistItem.fromJson(data) as T;
    }
    if (t == _id7ivncr.Contact) {
      return _id7ivncr.Contact.fromJson(data) as T;
    }
    if (t == _izw8z7ou.Greeting) {
      return _izw8z7ou.Greeting.fromJson(data) as T;
    }
    if (t == _ifiazq2p.Project) {
      return _ifiazq2p.Project.fromJson(data) as T;
    }
    if (t == _isc.getType<_ieco5lxt.AppUserData?>()) {
      return (data != null ? _ieco5lxt.AppUserData.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ifywsnp6.ChecklistItem?>()) {
      return (data != null ? _ifywsnp6.ChecklistItem.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_id7ivncr.Contact?>()) {
      return (data != null ? _id7ivncr.Contact.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ifiazq2p.Project?>()) {
      return (data != null ? _ifiazq2p.Project.fromJson(data) : null) as T;
    }
    if (t == List<_ifywsnp6.ChecklistItem>) {
      return (data as List)
              .map((e) => deserialize<_ifywsnp6.ChecklistItem>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_ifywsnp6.ChecklistItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ifywsnp6.ChecklistItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ilzv33bz.Contact>) {
      return (data as List)
              .map((e) => deserialize<_ilzv33bz.Contact>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_ie83d1fr.Project>) {
      return (data as List)
              .map((e) => deserialize<_ie83d1fr.Project>(e))
              .toList()
          as T;
    }
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ieco5lxt.AppUserData => 'AppUserData',
      _ifywsnp6.ChecklistItem => 'ChecklistItem',
      _id7ivncr.Contact => 'Contact',
      _izw8z7ou.Greeting => 'Greeting',
      _ifiazq2p.Project => 'Project',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('dotogether.', '');
    }

    switch (data) {
      case _ieco5lxt.AppUserData():
        return 'AppUserData';
      case _ifywsnp6.ChecklistItem():
        return 'ChecklistItem';
      case _id7ivncr.Contact():
        return 'Contact';
      case _izw8z7ou.Greeting():
        return 'Greeting';
      case _ifiazq2p.Project():
        return 'Project';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AppUserData') {
      return deserialize<_ieco5lxt.AppUserData>(data['data']);
    }
    if (dataClassName == 'ChecklistItem') {
      return deserialize<_ifywsnp6.ChecklistItem>(data['data']);
    }
    if (dataClassName == 'Contact') {
      return deserialize<_id7ivncr.Contact>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_izw8z7ou.Greeting>(data['data']);
    }
    if (dataClassName == 'Project') {
      return deserialize<_ifiazq2p.Project>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iacc.Protocol().registerHostProtocol('dotogether', this);
    _iaic.Protocol().registerHostProtocol('dotogether', this);
  }

  @override
  String getModuleName() => 'dotogether';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
