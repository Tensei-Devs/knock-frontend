//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class FinalQuoteBody {
  /// Returns a new [FinalQuoteBody] instance.
  FinalQuoteBody({
    required this.precio,
    required this.descripcion,
  });

  int? precio;

  String? descripcion;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FinalQuoteBody &&
    other.precio == precio &&
    other.descripcion == descripcion;

  @override
  int get hashCode =>
    (precio == null ? 0 : precio!.hashCode) +
    (descripcion == null ? 0 : descripcion!.hashCode);

  @override
  String toString() => 'FinalQuoteBody[precio=$precio, descripcion=$descripcion]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.precio != null) {
      json[r'precio'] = this.precio;
    } else {
      json[r'precio'] = null;
    }
    if (this.descripcion != null) {
      json[r'descripcion'] = this.descripcion;
    } else {
      json[r'descripcion'] = null;
    }
    return json;
  }

  /// Returns a new [FinalQuoteBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static FinalQuoteBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'precio'), 'Required key "FinalQuoteBody[precio]" is missing from JSON.');
        assert(json.containsKey(r'descripcion'), 'Required key "FinalQuoteBody[descripcion]" is missing from JSON.');
        return true;
      }());

      return FinalQuoteBody(
        precio: mapValueOfType<int>(json, r'precio'),
        descripcion: mapValueOfType<String>(json, r'descripcion'),
      );
    }
    return null;
  }

  static List<FinalQuoteBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FinalQuoteBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FinalQuoteBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FinalQuoteBody> mapFromJson(dynamic json) {
    final map = <String, FinalQuoteBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = FinalQuoteBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FinalQuoteBody-objects as value to a dart map
  static Map<String, List<FinalQuoteBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FinalQuoteBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FinalQuoteBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'precio',
    'descripcion',
  };
}

