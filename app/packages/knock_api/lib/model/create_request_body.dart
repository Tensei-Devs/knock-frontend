//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class CreateRequestBody {
  /// Returns a new [CreateRequestBody] instance.
  CreateRequestBody({
    required this.oficioClave,
    required this.descripcion,
    this.fotos = const [],
    required this.dia,
    required this.franja,
    required this.coloniaId,
    required this.direccion,
    this.elementoId,
  });

  /// Clave de un oficio activo del catálogo. La modalidad (domicilio o taller) la dicta el oficio.
  String? oficioClave;

  /// De 8 a 500 caracteres; pasa por moderación antes de guardarse.
  String? descripcion;

  /// De 1 a 5 identificadores de archivo (24 hexadecimales), sin repetidos, de archivos ya confirmados del mismo usuario.
  List<String>? fotos;

  /// Fecha `YYYY-MM-DD` en la zona America/Mexico_City, de hoy a hoy + 5 días.
  String? dia;

  /// Una de `manana`, `tarde` o `noche`.
  String? franja;

  /// Identificador (24 hexadecimales) de una colonia del catálogo.
  String? coloniaId;

  /// De 8 a 200 caracteres; obligatoria en modalidad domicilio y no admitida en taller. Se guarda cifrada.
  String? direccion;

  /// Opcional (spec 041, R-19, ampliación aditiva de la spec 020): identificador (24 hexadecimales) de un elemento de «Mi casa y mi auto» al que se liga el trabajo. Solo se valida su formato; nunca se devuelve.
  String? elementoId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateRequestBody &&
    other.oficioClave == oficioClave &&
    other.descripcion == descripcion &&
    _deepEquality.equals(other.fotos, fotos) &&
    other.dia == dia &&
    other.franja == franja &&
    other.coloniaId == coloniaId &&
    other.direccion == direccion &&
    other.elementoId == elementoId;

  @override
  int get hashCode =>
    (oficioClave == null ? 0 : oficioClave!.hashCode) +
    (descripcion == null ? 0 : descripcion!.hashCode) +
    (fotos == null ? 0 : fotos!.hashCode) +
    (dia == null ? 0 : dia!.hashCode) +
    (franja == null ? 0 : franja!.hashCode) +
    (coloniaId == null ? 0 : coloniaId!.hashCode) +
    (direccion == null ? 0 : direccion!.hashCode) +
    (elementoId == null ? 0 : elementoId!.hashCode);

  @override
  String toString() => 'CreateRequestBody[oficioClave=$oficioClave, descripcion=$descripcion, fotos=$fotos, dia=$dia, franja=$franja, coloniaId=$coloniaId, direccion=$direccion, elementoId=$elementoId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.oficioClave != null) {
      json[r'oficioClave'] = this.oficioClave;
    } else {
      json[r'oficioClave'] = null;
    }
    if (this.descripcion != null) {
      json[r'descripcion'] = this.descripcion;
    } else {
      json[r'descripcion'] = null;
    }
    if (this.fotos != null) {
      json[r'fotos'] = this.fotos;
    } else {
      json[r'fotos'] = null;
    }
    if (this.dia != null) {
      json[r'dia'] = this.dia;
    } else {
      json[r'dia'] = null;
    }
    if (this.franja != null) {
      json[r'franja'] = this.franja;
    } else {
      json[r'franja'] = null;
    }
    if (this.coloniaId != null) {
      json[r'coloniaId'] = this.coloniaId;
    } else {
      json[r'coloniaId'] = null;
    }
    if (this.direccion != null) {
      json[r'direccion'] = this.direccion;
    } else {
      json[r'direccion'] = null;
    }
    if (this.elementoId != null) {
      json[r'elementoId'] = this.elementoId;
    } else {
      json[r'elementoId'] = null;
    }
    return json;
  }

  /// Returns a new [CreateRequestBody] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static CreateRequestBody? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'oficioClave'), 'Required key "CreateRequestBody[oficioClave]" is missing from JSON.');
        assert(json.containsKey(r'descripcion'), 'Required key "CreateRequestBody[descripcion]" is missing from JSON.');
        assert(json.containsKey(r'fotos'), 'Required key "CreateRequestBody[fotos]" is missing from JSON.');
        assert(json.containsKey(r'dia'), 'Required key "CreateRequestBody[dia]" is missing from JSON.');
        assert(json.containsKey(r'franja'), 'Required key "CreateRequestBody[franja]" is missing from JSON.');
        assert(json.containsKey(r'coloniaId'), 'Required key "CreateRequestBody[coloniaId]" is missing from JSON.');
        assert(json.containsKey(r'direccion'), 'Required key "CreateRequestBody[direccion]" is missing from JSON.');
        return true;
      }());

      return CreateRequestBody(
        oficioClave: mapValueOfType<String>(json, r'oficioClave'),
        descripcion: mapValueOfType<String>(json, r'descripcion'),
        fotos: json[r'fotos'] is Iterable
            ? (json[r'fotos'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        dia: mapValueOfType<String>(json, r'dia'),
        franja: mapValueOfType<String>(json, r'franja'),
        coloniaId: mapValueOfType<String>(json, r'coloniaId'),
        direccion: mapValueOfType<String>(json, r'direccion'),
        elementoId: mapValueOfType<String>(json, r'elementoId'),
      );
    }
    return null;
  }

  static List<CreateRequestBody> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateRequestBody>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateRequestBody.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateRequestBody> mapFromJson(dynamic json) {
    final map = <String, CreateRequestBody>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = CreateRequestBody.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateRequestBody-objects as value to a dart map
  static Map<String, List<CreateRequestBody>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateRequestBody>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateRequestBody.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'oficioClave',
    'descripcion',
    'fotos',
    'dia',
    'franja',
    'coloniaId',
    'direccion',
  };
}

