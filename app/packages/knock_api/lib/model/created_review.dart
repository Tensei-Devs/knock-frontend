//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class CreatedReview {
  /// Returns a new [CreatedReview] instance.
  CreatedReview({
    required this.id,
    required this.calificacion,
    required this.moderacion,
    required this.creadoEn,
  });

  String id;

  int calificacion;

  String moderacion;

  DateTime creadoEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreatedReview &&
    other.id == id &&
    other.calificacion == calificacion &&
    other.moderacion == moderacion &&
    other.creadoEn == creadoEn;

  @override
  int get hashCode =>
    (id.hashCode) +
    (calificacion.hashCode) +
    (moderacion.hashCode) +
    (creadoEn.hashCode);

  @override
  String toString() => 'CreatedReview[id=$id, calificacion=$calificacion, moderacion=$moderacion, creadoEn=$creadoEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'calificacion'] = this.calificacion;
      json[r'moderacion'] = this.moderacion;
      json[r'creadoEn'] = this.creadoEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [CreatedReview] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static CreatedReview? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "CreatedReview[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "CreatedReview[id]" has a null value in JSON.');
        assert(json.containsKey(r'calificacion'), 'Required key "CreatedReview[calificacion]" is missing from JSON.');
        assert(json[r'calificacion'] != null, 'Required key "CreatedReview[calificacion]" has a null value in JSON.');
        assert(json.containsKey(r'moderacion'), 'Required key "CreatedReview[moderacion]" is missing from JSON.');
        assert(json[r'moderacion'] != null, 'Required key "CreatedReview[moderacion]" has a null value in JSON.');
        assert(json.containsKey(r'creadoEn'), 'Required key "CreatedReview[creadoEn]" is missing from JSON.');
        assert(json[r'creadoEn'] != null, 'Required key "CreatedReview[creadoEn]" has a null value in JSON.');
        return true;
      }());

      return CreatedReview(
        id: mapValueOfType<String>(json, r'id')!,
        calificacion: mapValueOfType<int>(json, r'calificacion')!,
        moderacion: mapValueOfType<String>(json, r'moderacion')!,
        creadoEn: mapDateTime(json, r'creadoEn', r'')!,
      );
    }
    return null;
  }

  static List<CreatedReview> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreatedReview>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreatedReview.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreatedReview> mapFromJson(dynamic json) {
    final map = <String, CreatedReview>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = CreatedReview.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreatedReview-objects as value to a dart map
  static Map<String, List<CreatedReview>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreatedReview>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreatedReview.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'calificacion',
    'moderacion',
    'creadoEn',
  };
}

