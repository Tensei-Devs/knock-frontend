//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class AccountEventBody {
  /// Returns a new [AccountEventBody] instance.
  AccountEventBody({
    this.eventoId,
    this.tipo,
    this.usuarioId,
    this.reporteId,
    this.desde,
  });

  String? eventoId;

  String? tipo;

  String? usuarioId;

  String? reporteId;

  String? desde;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AccountEventBody &&
    other.eventoId == eventoId &&
    other.tipo == tipo &&
    other.usuarioId == usuarioId &&
    other.reporteId == reporteId &&
    other.desde == desde;

  @override
  int get hashCode =>
    (eventoId == null ? 0 : eventoId!.hashCode) +
    (tipo == null ? 0 : tipo!.hashCode) +
    (usuarioId == null ? 0 : usuarioId!.hashCode) +
    (reporteId == null ? 0 : reporteId!.hashCode) +
    (desde == null ? 0 : desde!.hashCode);

  @override
  String toString() => 'AccountEventBody[eventoId=$eventoId, tipo=$tipo, usuarioId=$usuarioId, reporteId=$reporteId, desde=$desde]';

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
    if (this.usuarioId != null) {
      json[r'usuarioId'] = this.usuarioId;
    } else {
      json[r'usuarioId'] = null;
    }
    if (this.reporteId != null) {
      json[r'reporteId'] = this.reporteId;
    } else {
      json[r'reporteId'] = null;
    }
    if (this.desde != null) {
      json[r'desde'] = this.desde;
    } else {
      json[r'desde'] = null;
    }
    return json;
  }

  /// Returns a new [AccountEventBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static AccountEventBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return AccountEventBody(
        eventoId: mapValueOfType<String>(json, r'eventoId'),
        tipo: mapValueOfType<String>(json, r'tipo'),
        usuarioId: mapValueOfType<String>(json, r'usuarioId'),
        reporteId: mapValueOfType<String>(json, r'reporteId'),
        desde: mapValueOfType<String>(json, r'desde'),
      );
    }
    return null;
  }

  static List<AccountEventBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AccountEventBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AccountEventBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AccountEventBody> mapFromJson(dynamic json) {
    final map = <String, AccountEventBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = AccountEventBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AccountEventBody-objects as value to a dart map
  static Map<String, List<AccountEventBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AccountEventBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AccountEventBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

