//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TradeChangedEventBody {
  /// Returns a new [TradeChangedEventBody] instance.
  TradeChangedEventBody({
    required this.eventoId,
    required this.tipo,
    required this.oficioClave,
    required this.accion,
    required this.porId,
  });

  String? eventoId;

  String? tipo;

  String? oficioClave;

  String? accion;

  String? porId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TradeChangedEventBody &&
    other.eventoId == eventoId &&
    other.tipo == tipo &&
    other.oficioClave == oficioClave &&
    other.accion == accion &&
    other.porId == porId;

  @override
  int get hashCode =>
    (eventoId == null ? 0 : eventoId!.hashCode) +
    (tipo == null ? 0 : tipo!.hashCode) +
    (oficioClave == null ? 0 : oficioClave!.hashCode) +
    (accion == null ? 0 : accion!.hashCode) +
    (porId == null ? 0 : porId!.hashCode);

  @override
  String toString() => 'TradeChangedEventBody[eventoId=$eventoId, tipo=$tipo, oficioClave=$oficioClave, accion=$accion, porId=$porId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.eventoId != null) {
      json[r'eventoId'] = this.eventoId;
    } else {
      json[r'eventoId'] = null;
    }
    if (this.tipo != null) {
      json[r'tipo'] = this.tipo;
    } else {
      json[r'tipo'] = null;
    }
    if (this.oficioClave != null) {
      json[r'oficioClave'] = this.oficioClave;
    } else {
      json[r'oficioClave'] = null;
    }
    if (this.accion != null) {
      json[r'accion'] = this.accion;
    } else {
      json[r'accion'] = null;
    }
    if (this.porId != null) {
      json[r'porId'] = this.porId;
    } else {
      json[r'porId'] = null;
    }
    return json;
  }

  /// Returns a new [TradeChangedEventBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TradeChangedEventBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'eventoId'), 'Required key "TradeChangedEventBody[eventoId]" is missing from JSON.');
        assert(json.containsKey(r'tipo'), 'Required key "TradeChangedEventBody[tipo]" is missing from JSON.');
        assert(json.containsKey(r'oficioClave'), 'Required key "TradeChangedEventBody[oficioClave]" is missing from JSON.');
        assert(json.containsKey(r'accion'), 'Required key "TradeChangedEventBody[accion]" is missing from JSON.');
        assert(json.containsKey(r'porId'), 'Required key "TradeChangedEventBody[porId]" is missing from JSON.');
        return true;
      }());

      return TradeChangedEventBody(
        eventoId: mapValueOfType<String>(json, r'eventoId'),
        tipo: mapValueOfType<String>(json, r'tipo'),
        oficioClave: mapValueOfType<String>(json, r'oficioClave'),
        accion: mapValueOfType<String>(json, r'accion'),
        porId: mapValueOfType<String>(json, r'porId'),
      );
    }
    return null;
  }

  static List<TradeChangedEventBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TradeChangedEventBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TradeChangedEventBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TradeChangedEventBody> mapFromJson(dynamic json) {
    final map = <String, TradeChangedEventBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TradeChangedEventBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TradeChangedEventBody-objects as value to a dart map
  static Map<String, List<TradeChangedEventBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TradeChangedEventBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TradeChangedEventBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'eventoId',
    'tipo',
    'oficioClave',
    'accion',
    'porId',
  };
}

