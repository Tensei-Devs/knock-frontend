//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ConversacionView {
  /// Returns a new [ConversacionView] instance.
  ConversacionView({
    required this.conversacionId,
    required this.solicitudId,
    this.visitaId,
    required this.rol,
    required this.contraparte,
    required this.servicio,
    required this.estado,
    this.motivoCierre,
    required this.contactoVisible,
    required this.avisoSeguridad,
    required this.noLeidos,
  });

  String conversacionId;

  String solicitudId;

  String? visitaId;

  String rol;

  Contraparte contraparte;

  String servicio;

  /// Estado de la conversación: abierta o cerrada.
  ConversacionViewEstadoEnum estado;

  /// Solo con estado cerrada: request_cancelled, request_expired, other_quote_chosen, dismissed o service_finished.
  ConversacionViewMotivoCierreEnum? motivoCierre;

  bool contactoVisible;

  /// Texto fijo de seguridad que la app muestra tal cual (cadena no vacía, nunca null).
  String avisoSeguridad;

  int noLeidos;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConversacionView &&
    other.conversacionId == conversacionId &&
    other.solicitudId == solicitudId &&
    other.visitaId == visitaId &&
    other.rol == rol &&
    other.contraparte == contraparte &&
    other.servicio == servicio &&
    other.estado == estado &&
    other.motivoCierre == motivoCierre &&
    other.contactoVisible == contactoVisible &&
    other.avisoSeguridad == avisoSeguridad &&
    other.noLeidos == noLeidos;

  @override
  int get hashCode =>
    (conversacionId.hashCode) +
    (solicitudId.hashCode) +
    (visitaId == null ? 0 : visitaId!.hashCode) +
    (rol.hashCode) +
    (contraparte.hashCode) +
    (servicio.hashCode) +
    (estado.hashCode) +
    (motivoCierre == null ? 0 : motivoCierre!.hashCode) +
    (contactoVisible.hashCode) +
    (avisoSeguridad.hashCode) +
    (noLeidos.hashCode);

  @override
  String toString() => 'ConversacionView[conversacionId=$conversacionId, solicitudId=$solicitudId, visitaId=$visitaId, rol=$rol, contraparte=$contraparte, servicio=$servicio, estado=$estado, motivoCierre=$motivoCierre, contactoVisible=$contactoVisible, avisoSeguridad=$avisoSeguridad, noLeidos=$noLeidos]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'conversacionId'] = this.conversacionId;
      json[r'solicitudId'] = this.solicitudId;
    if (this.visitaId != null) {
      json[r'visitaId'] = this.visitaId;
    } else {
      json[r'visitaId'] = null;
    }
      json[r'rol'] = this.rol;
      json[r'contraparte'] = this.contraparte;
      json[r'servicio'] = this.servicio;
      json[r'estado'] = this.estado;
    if (this.motivoCierre != null) {
      json[r'motivoCierre'] = this.motivoCierre;
    } else {
      json[r'motivoCierre'] = null;
    }
      json[r'contactoVisible'] = this.contactoVisible;
      json[r'avisoSeguridad'] = this.avisoSeguridad;
      json[r'noLeidos'] = this.noLeidos;
    return json;
  }

  /// Returns a new [ConversacionView] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ConversacionView? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'conversacionId'), 'Required key "ConversacionView[conversacionId]" is missing from JSON.');
        assert(json[r'conversacionId'] != null, 'Required key "ConversacionView[conversacionId]" has a null value in JSON.');
        assert(json.containsKey(r'solicitudId'), 'Required key "ConversacionView[solicitudId]" is missing from JSON.');
        assert(json[r'solicitudId'] != null, 'Required key "ConversacionView[solicitudId]" has a null value in JSON.');
        assert(json.containsKey(r'rol'), 'Required key "ConversacionView[rol]" is missing from JSON.');
        assert(json[r'rol'] != null, 'Required key "ConversacionView[rol]" has a null value in JSON.');
        assert(json.containsKey(r'contraparte'), 'Required key "ConversacionView[contraparte]" is missing from JSON.');
        assert(json[r'contraparte'] != null, 'Required key "ConversacionView[contraparte]" has a null value in JSON.');
        assert(json.containsKey(r'servicio'), 'Required key "ConversacionView[servicio]" is missing from JSON.');
        assert(json[r'servicio'] != null, 'Required key "ConversacionView[servicio]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "ConversacionView[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "ConversacionView[estado]" has a null value in JSON.');
        assert(json.containsKey(r'contactoVisible'), 'Required key "ConversacionView[contactoVisible]" is missing from JSON.');
        assert(json[r'contactoVisible'] != null, 'Required key "ConversacionView[contactoVisible]" has a null value in JSON.');
        assert(json.containsKey(r'avisoSeguridad'), 'Required key "ConversacionView[avisoSeguridad]" is missing from JSON.');
        assert(json[r'avisoSeguridad'] != null, 'Required key "ConversacionView[avisoSeguridad]" has a null value in JSON.');
        assert(json.containsKey(r'noLeidos'), 'Required key "ConversacionView[noLeidos]" is missing from JSON.');
        assert(json[r'noLeidos'] != null, 'Required key "ConversacionView[noLeidos]" has a null value in JSON.');
        return true;
      }());

      return ConversacionView(
        conversacionId: mapValueOfType<String>(json, r'conversacionId')!,
        solicitudId: mapValueOfType<String>(json, r'solicitudId')!,
        visitaId: mapValueOfType<String>(json, r'visitaId'),
        rol: mapValueOfType<String>(json, r'rol')!,
        contraparte: Contraparte.fromJson(json[r'contraparte'])!,
        servicio: mapValueOfType<String>(json, r'servicio')!,
        estado: ConversacionViewEstadoEnum.fromJson(json[r'estado'])!,
        motivoCierre: ConversacionViewMotivoCierreEnum.fromJson(json[r'motivoCierre']),
        contactoVisible: mapValueOfType<bool>(json, r'contactoVisible')!,
        avisoSeguridad: mapValueOfType<String>(json, r'avisoSeguridad')!,
        noLeidos: mapValueOfType<int>(json, r'noLeidos')!,
      );
    }
    return null;
  }

  static List<ConversacionView> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConversacionView>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConversacionView.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConversacionView> mapFromJson(dynamic json) {
    final map = <String, ConversacionView>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ConversacionView.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConversacionView-objects as value to a dart map
  static Map<String, List<ConversacionView>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConversacionView>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConversacionView.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'conversacionId',
    'solicitudId',
    'rol',
    'contraparte',
    'servicio',
    'estado',
    'contactoVisible',
    'avisoSeguridad',
    'noLeidos',
  };
}

/// Estado de la conversación: abierta o cerrada.
enum ConversacionViewEstadoEnum {
  abierta._(r'abierta'),
  cerrada._(r'cerrada'),
  ;

  /// Instantiate a new enum with the provided value.
  const ConversacionViewEstadoEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ConversacionViewEstadoEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ConversacionViewEstadoEnum? fromJson(dynamic value) => ConversacionViewEstadoEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ConversacionViewEstadoEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ConversacionViewEstadoEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConversacionViewEstadoEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConversacionViewEstadoEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ConversacionViewEstadoEnum] to String,
/// and [decode] dynamic data back to [ConversacionViewEstadoEnum].
class ConversacionViewEstadoEnumTypeTransformer {
  factory ConversacionViewEstadoEnumTypeTransformer() => _instance ??= const ConversacionViewEstadoEnumTypeTransformer._();

  const ConversacionViewEstadoEnumTypeTransformer._();

  String encode(ConversacionViewEstadoEnum data) => data._value;

  /// Returns the instance of [ConversacionViewEstadoEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ConversacionViewEstadoEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ConversacionViewEstadoEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'abierta': return ConversacionViewEstadoEnum.abierta;
        case r'cerrada': return ConversacionViewEstadoEnum.cerrada;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ConversacionViewEstadoEnumTypeTransformer? _instance;
}


/// Solo con estado cerrada: request_cancelled, request_expired, other_quote_chosen, dismissed o service_finished.
enum ConversacionViewMotivoCierreEnum {
  requestCancelled._(r'request_cancelled'),
  requestExpired._(r'request_expired'),
  otherQuoteChosen._(r'other_quote_chosen'),
  dismissed._(r'dismissed'),
  serviceFinished._(r'service_finished'),
  ;

  /// Instantiate a new enum with the provided value.
  const ConversacionViewMotivoCierreEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ConversacionViewMotivoCierreEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ConversacionViewMotivoCierreEnum? fromJson(dynamic value) => ConversacionViewMotivoCierreEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ConversacionViewMotivoCierreEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ConversacionViewMotivoCierreEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConversacionViewMotivoCierreEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConversacionViewMotivoCierreEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ConversacionViewMotivoCierreEnum] to String,
/// and [decode] dynamic data back to [ConversacionViewMotivoCierreEnum].
class ConversacionViewMotivoCierreEnumTypeTransformer {
  factory ConversacionViewMotivoCierreEnumTypeTransformer() => _instance ??= const ConversacionViewMotivoCierreEnumTypeTransformer._();

  const ConversacionViewMotivoCierreEnumTypeTransformer._();

  String encode(ConversacionViewMotivoCierreEnum data) => data._value;

  /// Returns the instance of [ConversacionViewMotivoCierreEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ConversacionViewMotivoCierreEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ConversacionViewMotivoCierreEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'request_cancelled': return ConversacionViewMotivoCierreEnum.requestCancelled;
        case r'request_expired': return ConversacionViewMotivoCierreEnum.requestExpired;
        case r'other_quote_chosen': return ConversacionViewMotivoCierreEnum.otherQuoteChosen;
        case r'dismissed': return ConversacionViewMotivoCierreEnum.dismissed;
        case r'service_finished': return ConversacionViewMotivoCierreEnum.serviceFinished;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ConversacionViewMotivoCierreEnumTypeTransformer? _instance;
}


