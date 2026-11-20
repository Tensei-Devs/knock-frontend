//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class PermisoConversacion {
  /// Returns a new [PermisoConversacion] instance.
  PermisoConversacion({
    required this.solicitudId,
    required this.tecnicoId,
    required this.clienteId,
    required this.tecnicoUsuarioId,
    required this.rol,
    required this.abierta,
    required this.motivoCierre,
    required this.elegido,
    required this.visitaId,
    required this.servicio,
    required this.coloniaNombre,
    required this.tecnicoPublico,
  });

  String solicitudId;

  String tecnicoId;

  String clienteId;

  String tecnicoUsuarioId;

  String rol;

  bool abierta;

  String? motivoCierre;

  bool elegido;

  String? visitaId;

  String servicio;

  String coloniaNombre;

  TecnicoPublicoConversacion tecnicoPublico;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PermisoConversacion &&
    other.solicitudId == solicitudId &&
    other.tecnicoId == tecnicoId &&
    other.clienteId == clienteId &&
    other.tecnicoUsuarioId == tecnicoUsuarioId &&
    other.rol == rol &&
    other.abierta == abierta &&
    other.motivoCierre == motivoCierre &&
    other.elegido == elegido &&
    other.visitaId == visitaId &&
    other.servicio == servicio &&
    other.coloniaNombre == coloniaNombre &&
    other.tecnicoPublico == tecnicoPublico;

  @override
  int get hashCode =>
    (solicitudId.hashCode) +
    (tecnicoId.hashCode) +
    (clienteId.hashCode) +
    (tecnicoUsuarioId.hashCode) +
    (rol.hashCode) +
    (abierta.hashCode) +
    (motivoCierre == null ? 0 : motivoCierre!.hashCode) +
    (elegido.hashCode) +
    (visitaId == null ? 0 : visitaId!.hashCode) +
    (servicio.hashCode) +
    (coloniaNombre.hashCode) +
    (tecnicoPublico.hashCode);

  @override
  String toString() => 'PermisoConversacion[solicitudId=$solicitudId, tecnicoId=$tecnicoId, clienteId=$clienteId, tecnicoUsuarioId=$tecnicoUsuarioId, rol=$rol, abierta=$abierta, motivoCierre=$motivoCierre, elegido=$elegido, visitaId=$visitaId, servicio=$servicio, coloniaNombre=$coloniaNombre, tecnicoPublico=$tecnicoPublico]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'solicitudId'] = this.solicitudId;
      json[r'tecnicoId'] = this.tecnicoId;
      json[r'clienteId'] = this.clienteId;
      json[r'tecnicoUsuarioId'] = this.tecnicoUsuarioId;
      json[r'rol'] = this.rol;
      json[r'abierta'] = this.abierta;
    if (this.motivoCierre != null) {
      json[r'motivoCierre'] = this.motivoCierre;
    } else {
      json[r'motivoCierre'] = null;
    }
      json[r'elegido'] = this.elegido;
    if (this.visitaId != null) {
      json[r'visitaId'] = this.visitaId;
    } else {
      json[r'visitaId'] = null;
    }
      json[r'servicio'] = this.servicio;
      json[r'coloniaNombre'] = this.coloniaNombre;
      json[r'tecnicoPublico'] = this.tecnicoPublico;
    return json;
  }

  /// Returns a new [PermisoConversacion] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static PermisoConversacion? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'solicitudId'), 'Required key "PermisoConversacion[solicitudId]" is missing from JSON.');
        assert(json[r'solicitudId'] != null, 'Required key "PermisoConversacion[solicitudId]" has a null value in JSON.');
        assert(json.containsKey(r'tecnicoId'), 'Required key "PermisoConversacion[tecnicoId]" is missing from JSON.');
        assert(json[r'tecnicoId'] != null, 'Required key "PermisoConversacion[tecnicoId]" has a null value in JSON.');
        assert(json.containsKey(r'clienteId'), 'Required key "PermisoConversacion[clienteId]" is missing from JSON.');
        assert(json[r'clienteId'] != null, 'Required key "PermisoConversacion[clienteId]" has a null value in JSON.');
        assert(json.containsKey(r'tecnicoUsuarioId'), 'Required key "PermisoConversacion[tecnicoUsuarioId]" is missing from JSON.');
        assert(json[r'tecnicoUsuarioId'] != null, 'Required key "PermisoConversacion[tecnicoUsuarioId]" has a null value in JSON.');
        assert(json.containsKey(r'rol'), 'Required key "PermisoConversacion[rol]" is missing from JSON.');
        assert(json[r'rol'] != null, 'Required key "PermisoConversacion[rol]" has a null value in JSON.');
        assert(json.containsKey(r'abierta'), 'Required key "PermisoConversacion[abierta]" is missing from JSON.');
        assert(json[r'abierta'] != null, 'Required key "PermisoConversacion[abierta]" has a null value in JSON.');
        assert(json.containsKey(r'motivoCierre'), 'Required key "PermisoConversacion[motivoCierre]" is missing from JSON.');
        assert(json.containsKey(r'elegido'), 'Required key "PermisoConversacion[elegido]" is missing from JSON.');
        assert(json[r'elegido'] != null, 'Required key "PermisoConversacion[elegido]" has a null value in JSON.');
        assert(json.containsKey(r'visitaId'), 'Required key "PermisoConversacion[visitaId]" is missing from JSON.');
        assert(json.containsKey(r'servicio'), 'Required key "PermisoConversacion[servicio]" is missing from JSON.');
        assert(json[r'servicio'] != null, 'Required key "PermisoConversacion[servicio]" has a null value in JSON.');
        assert(json.containsKey(r'coloniaNombre'), 'Required key "PermisoConversacion[coloniaNombre]" is missing from JSON.');
        assert(json[r'coloniaNombre'] != null, 'Required key "PermisoConversacion[coloniaNombre]" has a null value in JSON.');
        assert(json.containsKey(r'tecnicoPublico'), 'Required key "PermisoConversacion[tecnicoPublico]" is missing from JSON.');
        assert(json[r'tecnicoPublico'] != null, 'Required key "PermisoConversacion[tecnicoPublico]" has a null value in JSON.');
        return true;
      }());

      return PermisoConversacion(
        solicitudId: mapValueOfType<String>(json, r'solicitudId')!,
        tecnicoId: mapValueOfType<String>(json, r'tecnicoId')!,
        clienteId: mapValueOfType<String>(json, r'clienteId')!,
        tecnicoUsuarioId: mapValueOfType<String>(json, r'tecnicoUsuarioId')!,
        rol: mapValueOfType<String>(json, r'rol')!,
        abierta: mapValueOfType<bool>(json, r'abierta')!,
        motivoCierre: mapValueOfType<String>(json, r'motivoCierre'),
        elegido: mapValueOfType<bool>(json, r'elegido')!,
        visitaId: mapValueOfType<String>(json, r'visitaId'),
        servicio: mapValueOfType<String>(json, r'servicio')!,
        coloniaNombre: mapValueOfType<String>(json, r'coloniaNombre')!,
        tecnicoPublico: TecnicoPublicoConversacion.fromJson(json[r'tecnicoPublico'])!,
      );
    }
    return null;
  }

  static List<PermisoConversacion> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PermisoConversacion>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PermisoConversacion.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PermisoConversacion> mapFromJson(dynamic json) {
    final map = <String, PermisoConversacion>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = PermisoConversacion.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PermisoConversacion-objects as value to a dart map
  static Map<String, List<PermisoConversacion>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PermisoConversacion>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PermisoConversacion.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'solicitudId',
    'tecnicoId',
    'clienteId',
    'tecnicoUsuarioId',
    'rol',
    'abierta',
    'motivoCierre',
    'elegido',
    'visitaId',
    'servicio',
    'coloniaNombre',
    'tecnicoPublico',
  };
}

