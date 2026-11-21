//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class BusquedaResponse {
  /// Returns a new [BusquedaResponse] instance.
  BusquedaResponse({
    required this.interpretacion,
    this.items = const [],
    required this.nextCursor,
  });

  BusquedaInterpretacion interpretacion;

  List<BusquedaItem> items;

  String? nextCursor;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BusquedaResponse &&
    other.interpretacion == interpretacion &&
    _deepEquality.equals(other.items, items) &&
    other.nextCursor == nextCursor;

  @override
  int get hashCode =>
    (interpretacion.hashCode) +
    (items.hashCode) +
    (nextCursor == null ? 0 : nextCursor!.hashCode);

  @override
  String toString() => 'BusquedaResponse[interpretacion=$interpretacion, items=$items, nextCursor=$nextCursor]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'interpretacion'] = this.interpretacion;
      json[r'items'] = this.items;
    if (this.nextCursor != null) {
      json[r'nextCursor'] = this.nextCursor;
    } else {
      json[r'nextCursor'] = null;
    }
    return json;
  }

  /// Returns a new [BusquedaResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static BusquedaResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'interpretacion'), 'Required key "BusquedaResponse[interpretacion]" is missing from JSON.');
        assert(json[r'interpretacion'] != null, 'Required key "BusquedaResponse[interpretacion]" has a null value in JSON.');
        assert(json.containsKey(r'items'), 'Required key "BusquedaResponse[items]" is missing from JSON.');
        assert(json[r'items'] != null, 'Required key "BusquedaResponse[items]" has a null value in JSON.');
        assert(json.containsKey(r'nextCursor'), 'Required key "BusquedaResponse[nextCursor]" is missing from JSON.');
        return true;
      }());

      return BusquedaResponse(
        interpretacion: BusquedaInterpretacion.fromJson(json[r'interpretacion'])!,
        items: BusquedaItem.listFromJson(json[r'items']),
        nextCursor: mapValueOfType<String>(json, r'nextCursor'),
      );
    }
    return null;
  }

  static List<BusquedaResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BusquedaResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BusquedaResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BusquedaResponse> mapFromJson(dynamic json) {
    final map = <String, BusquedaResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = BusquedaResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BusquedaResponse-objects as value to a dart map
  static Map<String, List<BusquedaResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BusquedaResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BusquedaResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'interpretacion',
    'items',
    'nextCursor',
  };
}

