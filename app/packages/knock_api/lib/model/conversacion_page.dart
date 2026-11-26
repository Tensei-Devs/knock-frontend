//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ConversacionPage {
  /// Returns a new [ConversacionPage] instance.
  ConversacionPage({
    this.items = const [],
    required this.totalNoLeidos,
    required this.nextCursor,
  });

  List<ConversacionItem> items;

  int totalNoLeidos;

  String? nextCursor;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConversacionPage &&
    _deepEquality.equals(other.items, items) &&
    other.totalNoLeidos == totalNoLeidos &&
    other.nextCursor == nextCursor;

  @override
  int get hashCode =>
    (items.hashCode) +
    (totalNoLeidos.hashCode) +
    (nextCursor == null ? 0 : nextCursor!.hashCode);

  @override
  String toString() => 'ConversacionPage[items=$items, totalNoLeidos=$totalNoLeidos, nextCursor=$nextCursor]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'items'] = this.items;
      json[r'totalNoLeidos'] = this.totalNoLeidos;
    if (this.nextCursor != null) {
      json[r'nextCursor'] = this.nextCursor;
    } else {
      json[r'nextCursor'] = null;
    }
    return json;
  }

  /// Returns a new [ConversacionPage] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ConversacionPage? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'items'), 'Required key "ConversacionPage[items]" is missing from JSON.');
        assert(json[r'items'] != null, 'Required key "ConversacionPage[items]" has a null value in JSON.');
        assert(json.containsKey(r'totalNoLeidos'), 'Required key "ConversacionPage[totalNoLeidos]" is missing from JSON.');
        assert(json[r'totalNoLeidos'] != null, 'Required key "ConversacionPage[totalNoLeidos]" has a null value in JSON.');
        assert(json.containsKey(r'nextCursor'), 'Required key "ConversacionPage[nextCursor]" is missing from JSON.');
        return true;
      }());

      return ConversacionPage(
        items: ConversacionItem.listFromJson(json[r'items']),
        totalNoLeidos: mapValueOfType<int>(json, r'totalNoLeidos')!,
        nextCursor: mapValueOfType<String>(json, r'nextCursor'),
      );
    }
    return null;
  }

  static List<ConversacionPage> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConversacionPage>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConversacionPage.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConversacionPage> mapFromJson(dynamic json) {
    final map = <String, ConversacionPage>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ConversacionPage.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConversacionPage-objects as value to a dart map
  static Map<String, List<ConversacionPage>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConversacionPage>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConversacionPage.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'items',
    'totalNoLeidos',
    'nextCursor',
  };
}

