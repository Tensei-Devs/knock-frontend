//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class NotFinishedResponse {
  /// Returns a new [NotFinishedResponse] instance.
  NotFinishedResponse({
    required this.visitaId,
    required this.estado,
  });

  String visitaId;

  String estado;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NotFinishedResponse &&
    other.visitaId == visitaId &&
    other.estado == estado;

  @override
  int get hashCode =>
    (visitaId.hashCode) +
    (estado.hashCode);

  @override
  String toString() => 'NotFinishedResponse[visitaId=$visitaId, estado=$estado]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'visitaId'] = this.visitaId;
      json[r'estado'] = this.estado;
    return json;
  }

  /// Returns a new [NotFinishedResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static NotFinishedResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'visitaId'), 'Required key "NotFinishedResponse[visitaId]" is missing from JSON.');
        assert(json[r'visitaId'] != null, 'Required key "NotFinishedResponse[visitaId]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "NotFinishedResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "NotFinishedResponse[estado]" has a null value in JSON.');
        return true;
      }());

      return NotFinishedResponse(
        visitaId: mapValueOfType<String>(json, r'visitaId')!,
        estado: mapValueOfType<String>(json, r'estado')!,
      );
    }
    return null;
  }

  static List<NotFinishedResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NotFinishedResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NotFinishedResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NotFinishedResponse> mapFromJson(dynamic json) {
    final map = <String, NotFinishedResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = NotFinishedResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NotFinishedResponse-objects as value to a dart map
  static Map<String, List<NotFinishedResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NotFinishedResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NotFinishedResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'visitaId',
    'estado',
  };
}

