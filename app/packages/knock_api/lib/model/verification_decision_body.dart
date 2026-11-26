//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class VerificationDecisionBody {
  /// Returns a new [VerificationDecisionBody] instance.
  VerificationDecisionBody({
    this.decision,
    this.motivo,
  });

  String? decision;

  String? motivo;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VerificationDecisionBody &&
    other.decision == decision &&
    other.motivo == motivo;

  @override
  int get hashCode =>
    (decision == null ? 0 : decision!.hashCode) +
    (motivo == null ? 0 : motivo!.hashCode);

  @override
  String toString() => 'VerificationDecisionBody[decision=$decision, motivo=$motivo]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.decision != null) {
      json[r'decision'] = this.decision;
    } else {
      json[r'decision'] = null;
    }
    if (this.motivo != null) {
      json[r'motivo'] = this.motivo;
    } else {
      json[r'motivo'] = null;
    }
    return json;
  }

  /// Returns a new [VerificationDecisionBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static VerificationDecisionBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return VerificationDecisionBody(
        decision: mapValueOfType<String>(json, r'decision'),
        motivo: mapValueOfType<String>(json, r'motivo'),
      );
    }
    return null;
  }

  static List<VerificationDecisionBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VerificationDecisionBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VerificationDecisionBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VerificationDecisionBody> mapFromJson(dynamic json) {
    final map = <String, VerificationDecisionBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = VerificationDecisionBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VerificationDecisionBody-objects as value to a dart map
  static Map<String, List<VerificationDecisionBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VerificationDecisionBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VerificationDecisionBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

