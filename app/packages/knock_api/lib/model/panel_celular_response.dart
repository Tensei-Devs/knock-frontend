//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class PanelCelularResponse {
  /// Returns a new [PanelCelularResponse] instance.
  PanelCelularResponse({
    required this.desafioId,
    required this.requiereTotp,
    required this.venceEn,
  });

  String desafioId;

  bool requiereTotp;

  DateTime venceEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PanelCelularResponse &&
    other.desafioId == desafioId &&
    other.requiereTotp == requiereTotp &&
    other.venceEn == venceEn;

  @override
  int get hashCode =>
    (desafioId.hashCode) +
    (requiereTotp.hashCode) +
    (venceEn.hashCode);

  @override
  String toString() => 'PanelCelularResponse[desafioId=$desafioId, requiereTotp=$requiereTotp, venceEn=$venceEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'desafioId'] = this.desafioId;
      json[r'requiereTotp'] = this.requiereTotp;
      json[r'venceEn'] = this.venceEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [PanelCelularResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static PanelCelularResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'desafioId'), 'Required key "PanelCelularResponse[desafioId]" is missing from JSON.');
        assert(json[r'desafioId'] != null, 'Required key "PanelCelularResponse[desafioId]" has a null value in JSON.');
        assert(json.containsKey(r'requiereTotp'), 'Required key "PanelCelularResponse[requiereTotp]" is missing from JSON.');
        assert(json[r'requiereTotp'] != null, 'Required key "PanelCelularResponse[requiereTotp]" has a null value in JSON.');
        assert(json.containsKey(r'venceEn'), 'Required key "PanelCelularResponse[venceEn]" is missing from JSON.');
        assert(json[r'venceEn'] != null, 'Required key "PanelCelularResponse[venceEn]" has a null value in JSON.');
        return true;
      }());

      return PanelCelularResponse(
        desafioId: mapValueOfType<String>(json, r'desafioId')!,
        requiereTotp: mapValueOfType<bool>(json, r'requiereTotp')!,
        venceEn: mapDateTime(json, r'venceEn', r'')!,
      );
    }
    return null;
  }

  static List<PanelCelularResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PanelCelularResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PanelCelularResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PanelCelularResponse> mapFromJson(dynamic json) {
    final map = <String, PanelCelularResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = PanelCelularResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PanelCelularResponse-objects as value to a dart map
  static Map<String, List<PanelCelularResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PanelCelularResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PanelCelularResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'desafioId',
    'requiereTotp',
    'venceEn',
  };
}

