//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class BitacoraResponse {
  /// Returns a new [BitacoraResponse] instance.
  BitacoraResponse({
    required this.solicitudId,
    this.sabe = const [],
    this.porConfirmar = const [],
    this.queLlevar = const [],
    required this.actualizadaEn,
  });

  String solicitudId;

  List<String> sabe;

  List<String> porConfirmar;

  List<String> queLlevar;

  DateTime actualizadaEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BitacoraResponse &&
    other.solicitudId == solicitudId &&
    _deepEquality.equals(other.sabe, sabe) &&
    _deepEquality.equals(other.porConfirmar, porConfirmar) &&
    _deepEquality.equals(other.queLlevar, queLlevar) &&
    other.actualizadaEn == actualizadaEn;

  @override
  int get hashCode =>
    (solicitudId.hashCode) +
    (sabe.hashCode) +
    (porConfirmar.hashCode) +
    (queLlevar.hashCode) +
    (actualizadaEn.hashCode);

  @override
  String toString() => 'BitacoraResponse[solicitudId=$solicitudId, sabe=$sabe, porConfirmar=$porConfirmar, queLlevar=$queLlevar, actualizadaEn=$actualizadaEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'solicitudId'] = this.solicitudId;
      json[r'sabe'] = this.sabe;
      json[r'porConfirmar'] = this.porConfirmar;
      json[r'queLlevar'] = this.queLlevar;
      json[r'actualizadaEn'] = this.actualizadaEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [BitacoraResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static BitacoraResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'solicitudId'), 'Required key "BitacoraResponse[solicitudId]" is missing from JSON.');
        assert(json[r'solicitudId'] != null, 'Required key "BitacoraResponse[solicitudId]" has a null value in JSON.');
        assert(json.containsKey(r'sabe'), 'Required key "BitacoraResponse[sabe]" is missing from JSON.');
        assert(json[r'sabe'] != null, 'Required key "BitacoraResponse[sabe]" has a null value in JSON.');
        assert(json.containsKey(r'porConfirmar'), 'Required key "BitacoraResponse[porConfirmar]" is missing from JSON.');
        assert(json[r'porConfirmar'] != null, 'Required key "BitacoraResponse[porConfirmar]" has a null value in JSON.');
        assert(json.containsKey(r'queLlevar'), 'Required key "BitacoraResponse[queLlevar]" is missing from JSON.');
        assert(json[r'queLlevar'] != null, 'Required key "BitacoraResponse[queLlevar]" has a null value in JSON.');
        assert(json.containsKey(r'actualizadaEn'), 'Required key "BitacoraResponse[actualizadaEn]" is missing from JSON.');
        assert(json[r'actualizadaEn'] != null, 'Required key "BitacoraResponse[actualizadaEn]" has a null value in JSON.');
        return true;
      }());

      return BitacoraResponse(
        solicitudId: mapValueOfType<String>(json, r'solicitudId')!,
        sabe: json[r'sabe'] is Iterable
            ? (json[r'sabe'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        porConfirmar: json[r'porConfirmar'] is Iterable
            ? (json[r'porConfirmar'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        queLlevar: json[r'queLlevar'] is Iterable
            ? (json[r'queLlevar'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        actualizadaEn: mapDateTime(json, r'actualizadaEn', r'')!,
      );
    }
    return null;
  }

  static List<BitacoraResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BitacoraResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BitacoraResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BitacoraResponse> mapFromJson(dynamic json) {
    final map = <String, BitacoraResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = BitacoraResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BitacoraResponse-objects as value to a dart map
  static Map<String, List<BitacoraResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BitacoraResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BitacoraResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'solicitudId',
    'sabe',
    'porConfirmar',
    'queLlevar',
    'actualizadaEn',
  };
}

