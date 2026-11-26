//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ExploreResponse {
  /// Returns a new [ExploreResponse] instance.
  ExploreResponse({
    required this.filtro,
    this.serviciosPopulares = const [],
    this.mejorCalificados = const [],
    this.ideas = const [],
    this.trabajosReales = const [],
    this.cercaDeTi = const [],
  });

  String filtro;

  List<ExploreService> serviciosPopulares;

  List<TechnicianProfileResponse> mejorCalificados;

  List<ExploreIdea> ideas;

  List<WorkPhotoResponse>? trabajosReales;

  List<TechnicianProfileResponse>? cercaDeTi;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ExploreResponse &&
    other.filtro == filtro &&
    _deepEquality.equals(other.serviciosPopulares, serviciosPopulares) &&
    _deepEquality.equals(other.mejorCalificados, mejorCalificados) &&
    _deepEquality.equals(other.ideas, ideas) &&
    _deepEquality.equals(other.trabajosReales, trabajosReales) &&
    _deepEquality.equals(other.cercaDeTi, cercaDeTi);

  @override
  int get hashCode =>
    (filtro.hashCode) +
    (serviciosPopulares.hashCode) +
    (mejorCalificados.hashCode) +
    (ideas.hashCode) +
    (trabajosReales == null ? 0 : trabajosReales!.hashCode) +
    (cercaDeTi == null ? 0 : cercaDeTi!.hashCode);

  @override
  String toString() => 'ExploreResponse[filtro=$filtro, serviciosPopulares=$serviciosPopulares, mejorCalificados=$mejorCalificados, ideas=$ideas, trabajosReales=$trabajosReales, cercaDeTi=$cercaDeTi]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'filtro'] = this.filtro;
      json[r'serviciosPopulares'] = this.serviciosPopulares;
      json[r'mejorCalificados'] = this.mejorCalificados;
      json[r'ideas'] = this.ideas;
    if (this.trabajosReales != null) {
      json[r'trabajosReales'] = this.trabajosReales;
    } else {
      json[r'trabajosReales'] = null;
    }
    if (this.cercaDeTi != null) {
      json[r'cercaDeTi'] = this.cercaDeTi;
    } else {
      json[r'cercaDeTi'] = null;
    }
    return json;
  }

  /// Returns a new [ExploreResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ExploreResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'filtro'), 'Required key "ExploreResponse[filtro]" is missing from JSON.');
        assert(json[r'filtro'] != null, 'Required key "ExploreResponse[filtro]" has a null value in JSON.');
        assert(json.containsKey(r'serviciosPopulares'), 'Required key "ExploreResponse[serviciosPopulares]" is missing from JSON.');
        assert(json[r'serviciosPopulares'] != null, 'Required key "ExploreResponse[serviciosPopulares]" has a null value in JSON.');
        assert(json.containsKey(r'mejorCalificados'), 'Required key "ExploreResponse[mejorCalificados]" is missing from JSON.');
        assert(json[r'mejorCalificados'] != null, 'Required key "ExploreResponse[mejorCalificados]" has a null value in JSON.');
        assert(json.containsKey(r'ideas'), 'Required key "ExploreResponse[ideas]" is missing from JSON.');
        assert(json[r'ideas'] != null, 'Required key "ExploreResponse[ideas]" has a null value in JSON.');
        assert(json.containsKey(r'trabajosReales'), 'Required key "ExploreResponse[trabajosReales]" is missing from JSON.');
        assert(json.containsKey(r'cercaDeTi'), 'Required key "ExploreResponse[cercaDeTi]" is missing from JSON.');
        return true;
      }());

      return ExploreResponse(
        filtro: mapValueOfType<String>(json, r'filtro')!,
        serviciosPopulares: ExploreService.listFromJson(json[r'serviciosPopulares']),
        mejorCalificados: TechnicianProfileResponse.listFromJson(json[r'mejorCalificados']),
        ideas: ExploreIdea.listFromJson(json[r'ideas']),
        trabajosReales: WorkPhotoResponse.listFromJson(json[r'trabajosReales']),
        cercaDeTi: TechnicianProfileResponse.listFromJson(json[r'cercaDeTi']),
      );
    }
    return null;
  }

  static List<ExploreResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ExploreResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ExploreResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ExploreResponse> mapFromJson(dynamic json) {
    final map = <String, ExploreResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ExploreResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ExploreResponse-objects as value to a dart map
  static Map<String, List<ExploreResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ExploreResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ExploreResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'filtro',
    'serviciosPopulares',
    'mejorCalificados',
    'ideas',
    'trabajosReales',
    'cercaDeTi',
  };
}

