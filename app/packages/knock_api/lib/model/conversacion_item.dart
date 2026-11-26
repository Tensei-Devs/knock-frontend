//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ConversacionItem {
  /// Returns a new [ConversacionItem] instance.
  ConversacionItem({
    required this.conversacionId,
    required this.solicitudId,
    this.visitaId,
    required this.rol,
    required this.contraparte,
    required this.servicio,
    required this.estado,
    required this.ultimoMensaje,
    required this.noLeidos,
  });

  String conversacionId;

  String solicitudId;

  String? visitaId;

  String rol;

  Contraparte contraparte;

  String servicio;

  /// Estado de la conversación: abierta o cerrada.
  ConversacionItemEstadoEnum estado;

  UltimoMensajeView? ultimoMensaje;

  int noLeidos;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConversacionItem &&
    other.conversacionId == conversacionId &&
    other.solicitudId == solicitudId &&
    other.visitaId == visitaId &&
    other.rol == rol &&
    other.contraparte == contraparte &&
    other.servicio == servicio &&
    other.estado == estado &&
    other.ultimoMensaje == ultimoMensaje &&
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
    (ultimoMensaje == null ? 0 : ultimoMensaje!.hashCode) +
    (noLeidos.hashCode);

  @override
  String toString() => 'ConversacionItem[conversacionId=$conversacionId, solicitudId=$solicitudId, visitaId=$visitaId, rol=$rol, contraparte=$contraparte, servicio=$servicio, estado=$estado, ultimoMensaje=$ultimoMensaje, noLeidos=$noLeidos]';

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
    if (this.ultimoMensaje != null) {
      json[r'ultimoMensaje'] = this.ultimoMensaje;
    } else {
      json[r'ultimoMensaje'] = null;
    }
      json[r'noLeidos'] = this.noLeidos;
    return json;
  }

  /// Returns a new [ConversacionItem] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ConversacionItem? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'conversacionId'), 'Required key "ConversacionItem[conversacionId]" is missing from JSON.');
        assert(json[r'conversacionId'] != null, 'Required key "ConversacionItem[conversacionId]" has a null value in JSON.');
        assert(json.containsKey(r'solicitudId'), 'Required key "ConversacionItem[solicitudId]" is missing from JSON.');
        assert(json[r'solicitudId'] != null, 'Required key "ConversacionItem[solicitudId]" has a null value in JSON.');
        assert(json.containsKey(r'rol'), 'Required key "ConversacionItem[rol]" is missing from JSON.');
        assert(json[r'rol'] != null, 'Required key "ConversacionItem[rol]" has a null value in JSON.');
        assert(json.containsKey(r'contraparte'), 'Required key "ConversacionItem[contraparte]" is missing from JSON.');
        assert(json[r'contraparte'] != null, 'Required key "ConversacionItem[contraparte]" has a null value in JSON.');
        assert(json.containsKey(r'servicio'), 'Required key "ConversacionItem[servicio]" is missing from JSON.');
        assert(json[r'servicio'] != null, 'Required key "ConversacionItem[servicio]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "ConversacionItem[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "ConversacionItem[estado]" has a null value in JSON.');
        assert(json.containsKey(r'ultimoMensaje'), 'Required key "ConversacionItem[ultimoMensaje]" is missing from JSON.');
        assert(json.containsKey(r'noLeidos'), 'Required key "ConversacionItem[noLeidos]" is missing from JSON.');
        assert(json[r'noLeidos'] != null, 'Required key "ConversacionItem[noLeidos]" has a null value in JSON.');
        return true;
      }());

      return ConversacionItem(
        conversacionId: mapValueOfType<String>(json, r'conversacionId')!,
        solicitudId: mapValueOfType<String>(json, r'solicitudId')!,
        visitaId: mapValueOfType<String>(json, r'visitaId'),
        rol: mapValueOfType<String>(json, r'rol')!,
        contraparte: Contraparte.fromJson(json[r'contraparte'])!,
        servicio: mapValueOfType<String>(json, r'servicio')!,
        estado: ConversacionItemEstadoEnum.fromJson(json[r'estado'])!,
        ultimoMensaje: UltimoMensajeView.fromJson(json[r'ultimoMensaje']),
        noLeidos: mapValueOfType<int>(json, r'noLeidos')!,
      );
    }
    return null;
  }

  static List<ConversacionItem> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConversacionItem>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConversacionItem.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConversacionItem> mapFromJson(dynamic json) {
    final map = <String, ConversacionItem>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ConversacionItem.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConversacionItem-objects as value to a dart map
  static Map<String, List<ConversacionItem>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConversacionItem>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConversacionItem.listFromJson(entry.value, growable: growable,);
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
    'ultimoMensaje',
    'noLeidos',
  };
}

/// Estado de la conversación: abierta o cerrada.
enum ConversacionItemEstadoEnum {
  abierta._(r'abierta'),
  cerrada._(r'cerrada'),
  ;

  /// Instantiate a new enum with the provided value.
  const ConversacionItemEstadoEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ConversacionItemEstadoEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ConversacionItemEstadoEnum? fromJson(dynamic value) => ConversacionItemEstadoEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ConversacionItemEstadoEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ConversacionItemEstadoEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConversacionItemEstadoEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConversacionItemEstadoEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ConversacionItemEstadoEnum] to String,
/// and [decode] dynamic data back to [ConversacionItemEstadoEnum].
class ConversacionItemEstadoEnumTypeTransformer {
  factory ConversacionItemEstadoEnumTypeTransformer() => _instance ??= const ConversacionItemEstadoEnumTypeTransformer._();

  const ConversacionItemEstadoEnumTypeTransformer._();

  String encode(ConversacionItemEstadoEnum data) => data._value;

  /// Returns the instance of [ConversacionItemEstadoEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ConversacionItemEstadoEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ConversacionItemEstadoEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'abierta': return ConversacionItemEstadoEnum.abierta;
        case r'cerrada': return ConversacionItemEstadoEnum.cerrada;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ConversacionItemEstadoEnumTypeTransformer? _instance;
}


