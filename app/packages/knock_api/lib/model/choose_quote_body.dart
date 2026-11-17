//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ChooseQuoteBody {
  /// Returns a new [ChooseQuoteBody] instance.
  ChooseQuoteBody({
    required this.cotizacionId,
  });

  /// Identificador (24 hexadecimales) de la cotización que se elige.
  String? cotizacionId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ChooseQuoteBody &&
    other.cotizacionId == cotizacionId;

  @override
  int get hashCode =>
    (cotizacionId == null ? 0 : cotizacionId!.hashCode);

  @override
  String toString() => 'ChooseQuoteBody[cotizacionId=$cotizacionId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.cotizacionId != null) {
      json[r'cotizacionId'] = this.cotizacionId;
    } else {
      json[r'cotizacionId'] = null;
    }
    return json;
  }

  /// Returns a new [ChooseQuoteBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ChooseQuoteBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'cotizacionId'), 'Required key "ChooseQuoteBody[cotizacionId]" is missing from JSON.');
        return true;
      }());

      return ChooseQuoteBody(
        cotizacionId: mapValueOfType<String>(json, r'cotizacionId'),
      );
    }
    return null;
  }

  static List<ChooseQuoteBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChooseQuoteBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChooseQuoteBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ChooseQuoteBody> mapFromJson(dynamic json) {
    final map = <String, ChooseQuoteBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ChooseQuoteBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ChooseQuoteBody-objects as value to a dart map
  static Map<String, List<ChooseQuoteBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ChooseQuoteBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ChooseQuoteBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'cotizacionId',
  };
}

