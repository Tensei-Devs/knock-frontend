//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class TrabajoVisitResponse {
  /// Returns a new [TrabajoVisitResponse] instance.
  TrabajoVisitResponse({
    required this.visitaId,
    required this.solicitudId,
    required this.dia,
    required this.hora,
    required this.modalidad,
    required this.cliente,
    required this.lugar,
    required this.precio,
    required this.tope,
    required this.estado,
    required this.puedeLlegar,
  });

  String visitaId;

  String solicitudId;

  String dia;

  String hora;

  String modalidad;

  TrabajoClient cliente;

  TrabajoPlace lugar;

  int? precio;

  int tope;

  String estado;

  bool puedeLlegar;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TrabajoVisitResponse &&
    other.visitaId == visitaId &&
    other.solicitudId == solicitudId &&
    other.dia == dia &&
    other.hora == hora &&
    other.modalidad == modalidad &&
    other.cliente == cliente &&
    other.lugar == lugar &&
    other.precio == precio &&
    other.tope == tope &&
    other.estado == estado &&
    other.puedeLlegar == puedeLlegar;

  @override
  int get hashCode =>
    (visitaId.hashCode) +
    (solicitudId.hashCode) +
    (dia.hashCode) +
    (hora.hashCode) +
    (modalidad.hashCode) +
    (cliente.hashCode) +
    (lugar.hashCode) +
    (precio == null ? 0 : precio!.hashCode) +
    (tope.hashCode) +
    (estado.hashCode) +
    (puedeLlegar.hashCode);

  @override
  String toString() => 'TrabajoVisitResponse[visitaId=$visitaId, solicitudId=$solicitudId, dia=$dia, hora=$hora, modalidad=$modalidad, cliente=$cliente, lugar=$lugar, precio=$precio, tope=$tope, estado=$estado, puedeLlegar=$puedeLlegar]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'visitaId'] = this.visitaId;
      json[r'solicitudId'] = this.solicitudId;
      json[r'dia'] = this.dia;
      json[r'hora'] = this.hora;
      json[r'modalidad'] = this.modalidad;
      json[r'cliente'] = this.cliente;
      json[r'lugar'] = this.lugar;
    if (this.precio != null) {
      json[r'precio'] = this.precio;
    } else {
      json[r'precio'] = null;
    }
      json[r'tope'] = this.tope;
      json[r'estado'] = this.estado;
      json[r'puedeLlegar'] = this.puedeLlegar;
    return json;
  }

  /// Returns a new [TrabajoVisitResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static TrabajoVisitResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'visitaId'), 'Required key "TrabajoVisitResponse[visitaId]" is missing from JSON.');
        assert(json[r'visitaId'] != null, 'Required key "TrabajoVisitResponse[visitaId]" has a null value in JSON.');
        assert(json.containsKey(r'solicitudId'), 'Required key "TrabajoVisitResponse[solicitudId]" is missing from JSON.');
        assert(json[r'solicitudId'] != null, 'Required key "TrabajoVisitResponse[solicitudId]" has a null value in JSON.');
        assert(json.containsKey(r'dia'), 'Required key "TrabajoVisitResponse[dia]" is missing from JSON.');
        assert(json[r'dia'] != null, 'Required key "TrabajoVisitResponse[dia]" has a null value in JSON.');
        assert(json.containsKey(r'hora'), 'Required key "TrabajoVisitResponse[hora]" is missing from JSON.');
        assert(json[r'hora'] != null, 'Required key "TrabajoVisitResponse[hora]" has a null value in JSON.');
        assert(json.containsKey(r'modalidad'), 'Required key "TrabajoVisitResponse[modalidad]" is missing from JSON.');
        assert(json[r'modalidad'] != null, 'Required key "TrabajoVisitResponse[modalidad]" has a null value in JSON.');
        assert(json.containsKey(r'cliente'), 'Required key "TrabajoVisitResponse[cliente]" is missing from JSON.');
        assert(json[r'cliente'] != null, 'Required key "TrabajoVisitResponse[cliente]" has a null value in JSON.');
        assert(json.containsKey(r'lugar'), 'Required key "TrabajoVisitResponse[lugar]" is missing from JSON.');
        assert(json[r'lugar'] != null, 'Required key "TrabajoVisitResponse[lugar]" has a null value in JSON.');
        assert(json.containsKey(r'precio'), 'Required key "TrabajoVisitResponse[precio]" is missing from JSON.');
        assert(json.containsKey(r'tope'), 'Required key "TrabajoVisitResponse[tope]" is missing from JSON.');
        assert(json[r'tope'] != null, 'Required key "TrabajoVisitResponse[tope]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "TrabajoVisitResponse[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "TrabajoVisitResponse[estado]" has a null value in JSON.');
        assert(json.containsKey(r'puedeLlegar'), 'Required key "TrabajoVisitResponse[puedeLlegar]" is missing from JSON.');
        assert(json[r'puedeLlegar'] != null, 'Required key "TrabajoVisitResponse[puedeLlegar]" has a null value in JSON.');
        return true;
      }());

      return TrabajoVisitResponse(
        visitaId: mapValueOfType<String>(json, r'visitaId')!,
        solicitudId: mapValueOfType<String>(json, r'solicitudId')!,
        dia: mapValueOfType<String>(json, r'dia')!,
        hora: mapValueOfType<String>(json, r'hora')!,
        modalidad: mapValueOfType<String>(json, r'modalidad')!,
        cliente: TrabajoClient.fromJson(json[r'cliente'])!,
        lugar: TrabajoPlace.fromJson(json[r'lugar'])!,
        precio: mapValueOfType<int>(json, r'precio'),
        tope: mapValueOfType<int>(json, r'tope')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        puedeLlegar: mapValueOfType<bool>(json, r'puedeLlegar')!,
      );
    }
    return null;
  }

  static List<TrabajoVisitResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TrabajoVisitResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TrabajoVisitResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TrabajoVisitResponse> mapFromJson(dynamic json) {
    final map = <String, TrabajoVisitResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = TrabajoVisitResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TrabajoVisitResponse-objects as value to a dart map
  static Map<String, List<TrabajoVisitResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TrabajoVisitResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TrabajoVisitResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'visitaId',
    'solicitudId',
    'dia',
    'hora',
    'modalidad',
    'cliente',
    'lugar',
    'precio',
    'tope',
    'estado',
    'puedeLlegar',
  };
}

