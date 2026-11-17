//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ValidationProblemDetails {
  /// Returns a new [ValidationProblemDetails] instance.
  ValidationProblemDetails({
    this.type,
    this.title,
    this.status,
    this.detail,
    this.instance,
    this.errors = const {},
  });

  String? type;

  String? title;

  int? status;

  String? detail;

  String? instance;

  Map<String, List<String>> errors;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ValidationProblemDetails &&
    other.type == type &&
    other.title == title &&
    other.status == status &&
    other.detail == detail &&
    other.instance == instance &&
    _deepEquality.equals(other.errors, errors);

  @override
  int get hashCode =>
    (type == null ? 0 : type!.hashCode) +
    (title == null ? 0 : title!.hashCode) +
    (status == null ? 0 : status!.hashCode) +
    (detail == null ? 0 : detail!.hashCode) +
    (instance == null ? 0 : instance!.hashCode) +
    (errors.hashCode);

  @override
  String toString() => 'ValidationProblemDetails[type=$type, title=$title, status=$status, detail=$detail, instance=$instance, errors=$errors]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.type != null) {
      json[r'type'] = this.type;
    } else {
      json[r'type'] = null;
    }
    if (this.title != null) {
      json[r'title'] = this.title;
    } else {
      json[r'title'] = null;
    }
    if (this.status != null) {
      json[r'status'] = this.status;
    } else {
      json[r'status'] = null;
    }
    if (this.detail != null) {
      json[r'detail'] = this.detail;
    } else {
      json[r'detail'] = null;
    }
    if (this.instance != null) {
      json[r'instance'] = this.instance;
    } else {
      json[r'instance'] = null;
    }
      json[r'errors'] = this.errors;
    return json;
  }

  /// Returns a new [ValidationProblemDetails] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ValidationProblemDetails? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return ValidationProblemDetails(
        type: mapValueOfType<String>(json, r'type'),
        title: mapValueOfType<String>(json, r'title'),
        status: mapValueOfType<int>(json, r'status'),
        detail: mapValueOfType<String>(json, r'detail'),
        instance: mapValueOfType<String>(json, r'instance'),
        errors: json[r'errors'] == null
          ? const {}
            : (json[r'errors'] as Map<String, dynamic>).map((k, v) => MapEntry(k, v == null ? const <String>[] : (v as List).map((value) => value as String).toList(growable: false))),
      );
    }
    return null;
  }

  static List<ValidationProblemDetails> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ValidationProblemDetails>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ValidationProblemDetails.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ValidationProblemDetails> mapFromJson(dynamic json) {
    final map = <String, ValidationProblemDetails>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ValidationProblemDetails.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ValidationProblemDetails-objects as value to a dart map
  static Map<String, List<ValidationProblemDetails>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ValidationProblemDetails>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ValidationProblemDetails.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

