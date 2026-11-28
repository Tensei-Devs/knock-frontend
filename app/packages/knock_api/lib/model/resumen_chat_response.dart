//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ResumenChatResponse {
  /// Returns a new [ResumenChatResponse] instance.
  ResumenChatResponse({
    this.sabe = const [],
    this.porConfirmar = const [],
    this.queLlevar = const [],
    required this.origen,
    required this.generadoPorIa,
  });

  List<String> sabe;

  List<String> porConfirmar;

  List<String> queLlevar;

  String origen;

  bool generadoPorIa;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ResumenChatResponse &&
    _deepEquality.equals(other.sabe, sabe) &&
    _deepEquality.equals(other.porConfirmar, porConfirmar) &&
    _deepEquality.equals(other.queLlevar, queLlevar) &&
    other.origen == origen &&
    other.generadoPorIa == generadoPorIa;

  @override
  int get hashCode =>
    (sabe.hashCode) +
    (porConfirmar.hashCode) +
    (queLlevar.hashCode) +
    (origen.hashCode) +
    (generadoPorIa.hashCode);

  @override
  String toString() => 'ResumenChatResponse[sabe=$sabe, porConfirmar=$porConfirmar, queLlevar=$queLlevar, origen=$origen, generadoPorIa=$generadoPorIa]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'sabe'] = this.sabe;
      json[r'porConfirmar'] = this.porConfirmar;
      json[r'queLlevar'] = this.queLlevar;
      json[r'origen'] = this.origen;
      json[r'generadoPorIa'] = this.generadoPorIa;
    return json;
  }

  /// Returns a new [ResumenChatResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ResumenChatResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'sabe'), 'Required key "ResumenChatResponse[sabe]" is missing from JSON.');
        assert(json[r'sabe'] != null, 'Required key "ResumenChatResponse[sabe]" has a null value in JSON.');
        assert(json.containsKey(r'porConfirmar'), 'Required key "ResumenChatResponse[porConfirmar]" is missing from JSON.');
        assert(json[r'porConfirmar'] != null, 'Required key "ResumenChatResponse[porConfirmar]" has a null value in JSON.');
        assert(json.containsKey(r'queLlevar'), 'Required key "ResumenChatResponse[queLlevar]" is missing from JSON.');
        assert(json[r'queLlevar'] != null, 'Required key "ResumenChatResponse[queLlevar]" has a null value in JSON.');
        assert(json.containsKey(r'origen'), 'Required key "ResumenChatResponse[origen]" is missing from JSON.');
        assert(json[r'origen'] != null, 'Required key "ResumenChatResponse[origen]" has a null value in JSON.');
        assert(json.containsKey(r'generadoPorIa'), 'Required key "ResumenChatResponse[generadoPorIa]" is missing from JSON.');
        assert(json[r'generadoPorIa'] != null, 'Required key "ResumenChatResponse[generadoPorIa]" has a null value in JSON.');
        return true;
      }());

      return ResumenChatResponse(
        sabe: json[r'sabe'] is Iterable
            ? (json[r'sabe'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        porConfirmar: json[r'porConfirmar'] is Iterable
            ? (json[r'porConfirmar'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        queLlevar: json[r'queLlevar'] is Iterable
            ? (json[r'queLlevar'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        origen: mapValueOfType<String>(json, r'origen')!,
        generadoPorIa: mapValueOfType<bool>(json, r'generadoPorIa')!,
      );
    }
    return null;
  }

  static List<ResumenChatResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ResumenChatResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ResumenChatResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ResumenChatResponse> mapFromJson(dynamic json) {
    final map = <String, ResumenChatResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ResumenChatResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ResumenChatResponse-objects as value to a dart map
  static Map<String, List<ResumenChatResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ResumenChatResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ResumenChatResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'sabe',
    'porConfirmar',
    'queLlevar',
    'origen',
    'generadoPorIa',
  };
}

