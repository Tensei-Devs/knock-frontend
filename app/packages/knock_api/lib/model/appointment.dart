//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class Appointment {
  /// Returns a new [Appointment] instance.
  Appointment({
    required this.visitaId,
    required this.solicitudId,
    required this.cotizacionId,
    required this.estado,
    required this.modalidad,
    required this.dia,
    required this.hora,
    required this.precio,
    required this.tope,
    required this.tecnico,
    required this.lugar,
  });

  String visitaId;

  String solicitudId;

  String cotizacionId;

  String estado;

  String modalidad;

  String dia;

  String hora;

  int? precio;

  int tope;

  ChosenTechnician tecnico;

  AppointmentPlace lugar;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Appointment &&
    other.visitaId == visitaId &&
    other.solicitudId == solicitudId &&
    other.cotizacionId == cotizacionId &&
    other.estado == estado &&
    other.modalidad == modalidad &&
    other.dia == dia &&
    other.hora == hora &&
    other.precio == precio &&
    other.tope == tope &&
    other.tecnico == tecnico &&
    other.lugar == lugar;

  @override
  int get hashCode =>
    (visitaId.hashCode) +
    (solicitudId.hashCode) +
    (cotizacionId.hashCode) +
    (estado.hashCode) +
    (modalidad.hashCode) +
    (dia.hashCode) +
    (hora.hashCode) +
    (precio == null ? 0 : precio!.hashCode) +
    (tope.hashCode) +
    (tecnico.hashCode) +
    (lugar.hashCode);

  @override
  String toString() => 'Appointment[visitaId=$visitaId, solicitudId=$solicitudId, cotizacionId=$cotizacionId, estado=$estado, modalidad=$modalidad, dia=$dia, hora=$hora, precio=$precio, tope=$tope, tecnico=$tecnico, lugar=$lugar]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'visitaId'] = this.visitaId;
      json[r'solicitudId'] = this.solicitudId;
      json[r'cotizacionId'] = this.cotizacionId;
      json[r'estado'] = this.estado;
      json[r'modalidad'] = this.modalidad;
      json[r'dia'] = this.dia;
      json[r'hora'] = this.hora;
    if (this.precio != null) {
      json[r'precio'] = this.precio;
    } else {
      json[r'precio'] = null;
    }
      json[r'tope'] = this.tope;
      json[r'tecnico'] = this.tecnico;
      json[r'lugar'] = this.lugar;
    return json;
  }

  /// Returns a new [Appointment] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static Appointment? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'visitaId'), 'Required key "Appointment[visitaId]" is missing from JSON.');
        assert(json[r'visitaId'] != null, 'Required key "Appointment[visitaId]" has a null value in JSON.');
        assert(json.containsKey(r'solicitudId'), 'Required key "Appointment[solicitudId]" is missing from JSON.');
        assert(json[r'solicitudId'] != null, 'Required key "Appointment[solicitudId]" has a null value in JSON.');
        assert(json.containsKey(r'cotizacionId'), 'Required key "Appointment[cotizacionId]" is missing from JSON.');
        assert(json[r'cotizacionId'] != null, 'Required key "Appointment[cotizacionId]" has a null value in JSON.');
        assert(json.containsKey(r'estado'), 'Required key "Appointment[estado]" is missing from JSON.');
        assert(json[r'estado'] != null, 'Required key "Appointment[estado]" has a null value in JSON.');
        assert(json.containsKey(r'modalidad'), 'Required key "Appointment[modalidad]" is missing from JSON.');
        assert(json[r'modalidad'] != null, 'Required key "Appointment[modalidad]" has a null value in JSON.');
        assert(json.containsKey(r'dia'), 'Required key "Appointment[dia]" is missing from JSON.');
        assert(json[r'dia'] != null, 'Required key "Appointment[dia]" has a null value in JSON.');
        assert(json.containsKey(r'hora'), 'Required key "Appointment[hora]" is missing from JSON.');
        assert(json[r'hora'] != null, 'Required key "Appointment[hora]" has a null value in JSON.');
        assert(json.containsKey(r'precio'), 'Required key "Appointment[precio]" is missing from JSON.');
        assert(json.containsKey(r'tope'), 'Required key "Appointment[tope]" is missing from JSON.');
        assert(json[r'tope'] != null, 'Required key "Appointment[tope]" has a null value in JSON.');
        assert(json.containsKey(r'tecnico'), 'Required key "Appointment[tecnico]" is missing from JSON.');
        assert(json[r'tecnico'] != null, 'Required key "Appointment[tecnico]" has a null value in JSON.');
        assert(json.containsKey(r'lugar'), 'Required key "Appointment[lugar]" is missing from JSON.');
        assert(json[r'lugar'] != null, 'Required key "Appointment[lugar]" has a null value in JSON.');
        return true;
      }());

      return Appointment(
        visitaId: mapValueOfType<String>(json, r'visitaId')!,
        solicitudId: mapValueOfType<String>(json, r'solicitudId')!,
        cotizacionId: mapValueOfType<String>(json, r'cotizacionId')!,
        estado: mapValueOfType<String>(json, r'estado')!,
        modalidad: mapValueOfType<String>(json, r'modalidad')!,
        dia: mapValueOfType<String>(json, r'dia')!,
        hora: mapValueOfType<String>(json, r'hora')!,
        precio: mapValueOfType<int>(json, r'precio'),
        tope: mapValueOfType<int>(json, r'tope')!,
        tecnico: ChosenTechnician.fromJson(json[r'tecnico'])!,
        lugar: AppointmentPlace.fromJson(json[r'lugar'])!,
      );
    }
    return null;
  }

  static List<Appointment> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Appointment>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Appointment.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Appointment> mapFromJson(dynamic json) {
    final map = <String, Appointment>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = Appointment.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Appointment-objects as value to a dart map
  static Map<String, List<Appointment>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Appointment>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Appointment.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'visitaId',
    'solicitudId',
    'cotizacionId',
    'estado',
    'modalidad',
    'dia',
    'hora',
    'precio',
    'tope',
    'tecnico',
    'lugar',
  };
}

