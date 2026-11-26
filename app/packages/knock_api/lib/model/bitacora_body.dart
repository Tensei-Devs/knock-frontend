//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class BitacoraBody {
  /// Returns a new [BitacoraBody] instance.
  BitacoraBody({
    this.sabe = const [],
    this.porConfirmar = const [],
    this.queLlevar = const [],
  });

  List<String>? sabe;

  List<String>? porConfirmar;

  List<String>? queLlevar;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BitacoraBody &&
    _deepEquality.equals(other.sabe, sabe) &&
    _deepEquality.equals(other.porConfirmar, porConfirmar) &&
    _deepEquality.equals(other.queLlevar, queLlevar);

  @override
  int get hashCode =>
    (sabe == null ? 0 : sabe!.hashCode) +
    (porConfirmar == null ? 0 : porConfirmar!.hashCode) +
    (queLlevar == null ? 0 : queLlevar!.hashCode);

  @override
  String toString() => 'BitacoraBody[sabe=$sabe, porConfirmar=$porConfirmar, queLlevar=$queLlevar]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.sabe != null) {
      json[r'sabe'] = this.sabe;
    } else {
      json[r'sabe'] = null;
    }
    if (this.porConfirmar != null) {
      json[r'porConfirmar'] = this.porConfirmar;
    } else {
      json[r'porConfirmar'] = null;
    }
    if (this.queLlevar != null) {
      json[r'queLlevar'] = this.queLlevar;
    } else {
      json[r'queLlevar'] = null;
    }
    return json;
  }

  /// Returns a new [BitacoraBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static BitacoraBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'sabe'), 'Required key "BitacoraBody[sabe]" is missing from JSON.');
        assert(json.containsKey(r'porConfirmar'), 'Required key "BitacoraBody[porConfirmar]" is missing from JSON.');
        assert(json.containsKey(r'queLlevar'), 'Required key "BitacoraBody[queLlevar]" is missing from JSON.');
        return true;
      }());

      return BitacoraBody(
        sabe: json[r'sabe'] is Iterable
            ? (json[r'sabe'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        porConfirmar: json[r'porConfirmar'] is Iterable
            ? (json[r'porConfirmar'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        queLlevar: json[r'queLlevar'] is Iterable
            ? (json[r'queLlevar'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<BitacoraBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BitacoraBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BitacoraBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BitacoraBody> mapFromJson(dynamic json) {
    final map = <String, BitacoraBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = BitacoraBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BitacoraBody-objects as value to a dart map
  static Map<String, List<BitacoraBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BitacoraBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BitacoraBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'sabe',
    'porConfirmar',
    'queLlevar',
  };
}

