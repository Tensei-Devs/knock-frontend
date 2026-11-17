//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class QuoteComparison {
  /// Returns a new [QuoteComparison] instance.
  QuoteComparison({
    required this.solicitudId,
    this.cotizaciones = const [],
    required this.totalCotizaciones,
    required this.tiposMixtos,
    required this.puedeElegir,
    required this.motivo,
    required this.visitaId,
  });

  String solicitudId;

  List<QuoteComparisonItem> cotizaciones;

  int totalCotizaciones;

  bool tiposMixtos;

  bool puedeElegir;

  String? motivo;

  String? visitaId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is QuoteComparison &&
    other.solicitudId == solicitudId &&
    _deepEquality.equals(other.cotizaciones, cotizaciones) &&
    other.totalCotizaciones == totalCotizaciones &&
    other.tiposMixtos == tiposMixtos &&
    other.puedeElegir == puedeElegir &&
    other.motivo == motivo &&
    other.visitaId == visitaId;

  @override
  int get hashCode =>
    (solicitudId.hashCode) +
    (cotizaciones.hashCode) +
    (totalCotizaciones.hashCode) +
    (tiposMixtos.hashCode) +
    (puedeElegir.hashCode) +
    (motivo == null ? 0 : motivo!.hashCode) +
    (visitaId == null ? 0 : visitaId!.hashCode);

  @override
  String toString() => 'QuoteComparison[solicitudId=$solicitudId, cotizaciones=$cotizaciones, totalCotizaciones=$totalCotizaciones, tiposMixtos=$tiposMixtos, puedeElegir=$puedeElegir, motivo=$motivo, visitaId=$visitaId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'solicitudId'] = this.solicitudId;
      json[r'cotizaciones'] = this.cotizaciones;
      json[r'totalCotizaciones'] = this.totalCotizaciones;
      json[r'tiposMixtos'] = this.tiposMixtos;
      json[r'puedeElegir'] = this.puedeElegir;
    if (this.motivo != null) {
      json[r'motivo'] = this.motivo;
    } else {
      json[r'motivo'] = null;
    }
    if (this.visitaId != null) {
      json[r'visitaId'] = this.visitaId;
    } else {
      json[r'visitaId'] = null;
    }
    return json;
  }

  /// Returns a new [QuoteComparison] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static QuoteComparison? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'solicitudId'), 'Required key "QuoteComparison[solicitudId]" is missing from JSON.');
        assert(json[r'solicitudId'] != null, 'Required key "QuoteComparison[solicitudId]" has a null value in JSON.');
        assert(json.containsKey(r'cotizaciones'), 'Required key "QuoteComparison[cotizaciones]" is missing from JSON.');
        assert(json[r'cotizaciones'] != null, 'Required key "QuoteComparison[cotizaciones]" has a null value in JSON.');
        assert(json.containsKey(r'totalCotizaciones'), 'Required key "QuoteComparison[totalCotizaciones]" is missing from JSON.');
        assert(json[r'totalCotizaciones'] != null, 'Required key "QuoteComparison[totalCotizaciones]" has a null value in JSON.');
        assert(json.containsKey(r'tiposMixtos'), 'Required key "QuoteComparison[tiposMixtos]" is missing from JSON.');
        assert(json[r'tiposMixtos'] != null, 'Required key "QuoteComparison[tiposMixtos]" has a null value in JSON.');
        assert(json.containsKey(r'puedeElegir'), 'Required key "QuoteComparison[puedeElegir]" is missing from JSON.');
        assert(json[r'puedeElegir'] != null, 'Required key "QuoteComparison[puedeElegir]" has a null value in JSON.');
        assert(json.containsKey(r'motivo'), 'Required key "QuoteComparison[motivo]" is missing from JSON.');
        assert(json.containsKey(r'visitaId'), 'Required key "QuoteComparison[visitaId]" is missing from JSON.');
        return true;
      }());

      return QuoteComparison(
        solicitudId: mapValueOfType<String>(json, r'solicitudId')!,
        cotizaciones: QuoteComparisonItem.listFromJson(json[r'cotizaciones']),
        totalCotizaciones: mapValueOfType<int>(json, r'totalCotizaciones')!,
        tiposMixtos: mapValueOfType<bool>(json, r'tiposMixtos')!,
        puedeElegir: mapValueOfType<bool>(json, r'puedeElegir')!,
        motivo: mapValueOfType<String>(json, r'motivo'),
        visitaId: mapValueOfType<String>(json, r'visitaId'),
      );
    }
    return null;
  }

  static List<QuoteComparison> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <QuoteComparison>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QuoteComparison.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QuoteComparison> mapFromJson(dynamic json) {
    final map = <String, QuoteComparison>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = QuoteComparison.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QuoteComparison-objects as value to a dart map
  static Map<String, List<QuoteComparison>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<QuoteComparison>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = QuoteComparison.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'solicitudId',
    'cotizaciones',
    'totalCotizaciones',
    'tiposMixtos',
    'puedeElegir',
    'motivo',
    'visitaId',
  };
}

