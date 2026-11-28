//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ReviewParts {
  /// Returns a new [ReviewParts] instance.
  ReviewParts({
    required this.puntualidad,
    required this.calidad,
    required this.precioJusto,
    required this.trato,
  });

  int? puntualidad;

  int? calidad;

  int? precioJusto;

  int? trato;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReviewParts &&
    other.puntualidad == puntualidad &&
    other.calidad == calidad &&
    other.precioJusto == precioJusto &&
    other.trato == trato;

  @override
  int get hashCode =>
    (puntualidad == null ? 0 : puntualidad!.hashCode) +
    (calidad == null ? 0 : calidad!.hashCode) +
    (precioJusto == null ? 0 : precioJusto!.hashCode) +
    (trato == null ? 0 : trato!.hashCode);

  @override
  String toString() => 'ReviewParts[puntualidad=$puntualidad, calidad=$calidad, precioJusto=$precioJusto, trato=$trato]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.puntualidad != null) {
      json[r'puntualidad'] = this.puntualidad;
    } else {
      json[r'puntualidad'] = null;
    }
    if (this.calidad != null) {
      json[r'calidad'] = this.calidad;
    } else {
      json[r'calidad'] = null;
    }
    if (this.precioJusto != null) {
      json[r'precioJusto'] = this.precioJusto;
    } else {
      json[r'precioJusto'] = null;
    }
    if (this.trato != null) {
      json[r'trato'] = this.trato;
    } else {
      json[r'trato'] = null;
    }
    return json;
  }

  /// Returns a new [ReviewParts] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ReviewParts? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'puntualidad'), 'Required key "ReviewParts[puntualidad]" is missing from JSON.');
        assert(json.containsKey(r'calidad'), 'Required key "ReviewParts[calidad]" is missing from JSON.');
        assert(json.containsKey(r'precioJusto'), 'Required key "ReviewParts[precioJusto]" is missing from JSON.');
        assert(json.containsKey(r'trato'), 'Required key "ReviewParts[trato]" is missing from JSON.');
        return true;
      }());

      return ReviewParts(
        puntualidad: mapValueOfType<int>(json, r'puntualidad'),
        calidad: mapValueOfType<int>(json, r'calidad'),
        precioJusto: mapValueOfType<int>(json, r'precioJusto'),
        trato: mapValueOfType<int>(json, r'trato'),
      );
    }
    return null;
  }

  static List<ReviewParts> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReviewParts>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReviewParts.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReviewParts> mapFromJson(dynamic json) {
    final map = <String, ReviewParts>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ReviewParts.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReviewParts-objects as value to a dart map
  static Map<String, List<ReviewParts>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReviewParts>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReviewParts.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'puntualidad',
    'calidad',
    'precioJusto',
    'trato',
  };
}

