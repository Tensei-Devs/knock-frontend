//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TechnicianProfileDetail {
  /// Returns a new [TechnicianProfileDetail] instance.
  TechnicianProfileDetail({
    required this.descripcion,
    required this.atencion,
    required this.radioKm,
    required this.coloniaId,
    required this.disponibleHoy,
  });

  String? descripcion;

  String? atencion;

  int? radioKm;

  String? coloniaId;

  bool disponibleHoy;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TechnicianProfileDetail &&
    other.descripcion == descripcion &&
    other.atencion == atencion &&
    other.radioKm == radioKm &&
    other.coloniaId == coloniaId &&
    other.disponibleHoy == disponibleHoy;

  @override
  int get hashCode =>
    (descripcion == null ? 0 : descripcion!.hashCode) +
    (atencion == null ? 0 : atencion!.hashCode) +
    (radioKm == null ? 0 : radioKm!.hashCode) +
    (coloniaId == null ? 0 : coloniaId!.hashCode) +
    (disponibleHoy.hashCode);

  @override
  String toString() => 'TechnicianProfileDetail[descripcion=$descripcion, atencion=$atencion, radioKm=$radioKm, coloniaId=$coloniaId, disponibleHoy=$disponibleHoy]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.descripcion != null) {
      json[r'descripcion'] = this.descripcion;
    } else {
      json[r'descripcion'] = null;
    }
    if (this.atencion != null) {
      json[r'atencion'] = this.atencion;
    } else {
      json[r'atencion'] = null;
    }
    if (this.radioKm != null) {
      json[r'radioKm'] = this.radioKm;
    } else {
      json[r'radioKm'] = null;
    }
    if (this.coloniaId != null) {
      json[r'coloniaId'] = this.coloniaId;
    } else {
      json[r'coloniaId'] = null;
    }
      json[r'disponibleHoy'] = this.disponibleHoy;
    return json;
  }

  /// Returns a new [TechnicianProfileDetail] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TechnicianProfileDetail? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'descripcion'), 'Required key "TechnicianProfileDetail[descripcion]" is missing from JSON.');
        assert(json.containsKey(r'atencion'), 'Required key "TechnicianProfileDetail[atencion]" is missing from JSON.');
        assert(json.containsKey(r'radioKm'), 'Required key "TechnicianProfileDetail[radioKm]" is missing from JSON.');
        assert(json.containsKey(r'coloniaId'), 'Required key "TechnicianProfileDetail[coloniaId]" is missing from JSON.');
        assert(json.containsKey(r'disponibleHoy'), 'Required key "TechnicianProfileDetail[disponibleHoy]" is missing from JSON.');
        assert(json[r'disponibleHoy'] != null, 'Required key "TechnicianProfileDetail[disponibleHoy]" has a null value in JSON.');
        return true;
      }());

      return TechnicianProfileDetail(
        descripcion: mapValueOfType<String>(json, r'descripcion'),
        atencion: mapValueOfType<String>(json, r'atencion'),
        radioKm: mapValueOfType<int>(json, r'radioKm'),
        coloniaId: mapValueOfType<String>(json, r'coloniaId'),
        disponibleHoy: mapValueOfType<bool>(json, r'disponibleHoy')!,
      );
    }
    return null;
  }

  static List<TechnicianProfileDetail> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TechnicianProfileDetail>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TechnicianProfileDetail.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TechnicianProfileDetail> mapFromJson(dynamic json) {
    final map = <String, TechnicianProfileDetail>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TechnicianProfileDetail.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TechnicianProfileDetail-objects as value to a dart map
  static Map<String, List<TechnicianProfileDetail>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TechnicianProfileDetail>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TechnicianProfileDetail.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'descripcion',
    'atencion',
    'radioKm',
    'coloniaId',
    'disponibleHoy',
  };
}

