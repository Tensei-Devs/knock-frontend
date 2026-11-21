//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class PanelTotpRequest {
  /// Returns a new [PanelTotpRequest] instance.
  PanelTotpRequest({
    this.desafioId,
    this.codigo,
  });

  String? desafioId;

  String? codigo;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PanelTotpRequest &&
    other.desafioId == desafioId &&
    other.codigo == codigo;

  @override
  int get hashCode =>
    (desafioId == null ? 0 : desafioId!.hashCode) +
    (codigo == null ? 0 : codigo!.hashCode);

  @override
  String toString() => 'PanelTotpRequest[desafioId=$desafioId, codigo=$codigo]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.desafioId != null) {
      json[r'desafioId'] = this.desafioId;
    } else {
      json[r'desafioId'] = null;
    }
    if (this.codigo != null) {
      json[r'codigo'] = this.codigo;
    } else {
      json[r'codigo'] = null;
    }
    return json;
  }

  /// Returns a new [PanelTotpRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static PanelTotpRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return PanelTotpRequest(
        desafioId: mapValueOfType<String>(json, r'desafioId'),
        codigo: mapValueOfType<String>(json, r'codigo'),
      );
    }
    return null;
  }

  static List<PanelTotpRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PanelTotpRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PanelTotpRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PanelTotpRequest> mapFromJson(dynamic json) {
    final map = <String, PanelTotpRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = PanelTotpRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PanelTotpRequest-objects as value to a dart map
  static Map<String, List<PanelTotpRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PanelTotpRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PanelTotpRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

