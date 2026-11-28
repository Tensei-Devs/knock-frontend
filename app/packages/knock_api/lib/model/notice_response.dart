//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class NoticeResponse {
  /// Returns a new [NoticeResponse] instance.
  NoticeResponse({
    required this.id,
    required this.tipo,
    required this.comoRol,
    required this.titulo,
    required this.texto,
    required this.destino,
    required this.leido,
    required this.creadoEn,
  });

  String id;

  String tipo;

  String? comoRol;

  String titulo;

  String texto;

  Object? destino;

  bool leido;

  DateTime creadoEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NoticeResponse &&
    other.id == id &&
    other.tipo == tipo &&
    other.comoRol == comoRol &&
    other.titulo == titulo &&
    other.texto == texto &&
    other.destino == destino &&
    other.leido == leido &&
    other.creadoEn == creadoEn;

  @override
  int get hashCode =>
    (id.hashCode) +
    (tipo.hashCode) +
    (comoRol == null ? 0 : comoRol!.hashCode) +
    (titulo.hashCode) +
    (texto.hashCode) +
    (destino == null ? 0 : destino!.hashCode) +
    (leido.hashCode) +
    (creadoEn.hashCode);

  @override
  String toString() => 'NoticeResponse[id=$id, tipo=$tipo, comoRol=$comoRol, titulo=$titulo, texto=$texto, destino=$destino, leido=$leido, creadoEn=$creadoEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'tipo'] = this.tipo;
    if (this.comoRol != null) {
      json[r'comoRol'] = this.comoRol;
    } else {
      json[r'comoRol'] = null;
    }
      json[r'titulo'] = this.titulo;
      json[r'texto'] = this.texto;
    if (this.destino != null) {
      json[r'destino'] = this.destino;
    } else {
      json[r'destino'] = null;
    }
      json[r'leido'] = this.leido;
      json[r'creadoEn'] = this.creadoEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [NoticeResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static NoticeResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "NoticeResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "NoticeResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'tipo'), 'Required key "NoticeResponse[tipo]" is missing from JSON.');
        assert(json[r'tipo'] != null, 'Required key "NoticeResponse[tipo]" has a null value in JSON.');
        assert(json.containsKey(r'comoRol'), 'Required key "NoticeResponse[comoRol]" is missing from JSON.');
        assert(json.containsKey(r'titulo'), 'Required key "NoticeResponse[titulo]" is missing from JSON.');
        assert(json[r'titulo'] != null, 'Required key "NoticeResponse[titulo]" has a null value in JSON.');
        assert(json.containsKey(r'texto'), 'Required key "NoticeResponse[texto]" is missing from JSON.');
        assert(json[r'texto'] != null, 'Required key "NoticeResponse[texto]" has a null value in JSON.');
        assert(json.containsKey(r'destino'), 'Required key "NoticeResponse[destino]" is missing from JSON.');
        assert(json.containsKey(r'leido'), 'Required key "NoticeResponse[leido]" is missing from JSON.');
        assert(json[r'leido'] != null, 'Required key "NoticeResponse[leido]" has a null value in JSON.');
        assert(json.containsKey(r'creadoEn'), 'Required key "NoticeResponse[creadoEn]" is missing from JSON.');
        assert(json[r'creadoEn'] != null, 'Required key "NoticeResponse[creadoEn]" has a null value in JSON.');
        return true;
      }());

      return NoticeResponse(
        id: mapValueOfType<String>(json, r'id')!,
        tipo: mapValueOfType<String>(json, r'tipo')!,
        comoRol: mapValueOfType<String>(json, r'comoRol'),
        titulo: mapValueOfType<String>(json, r'titulo')!,
        texto: mapValueOfType<String>(json, r'texto')!,
        destino: mapValueOfType<Object>(json, r'destino'),
        leido: mapValueOfType<bool>(json, r'leido')!,
        creadoEn: mapDateTime(json, r'creadoEn', r'')!,
      );
    }
    return null;
  }

  static List<NoticeResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NoticeResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NoticeResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NoticeResponse> mapFromJson(dynamic json) {
    final map = <String, NoticeResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = NoticeResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NoticeResponse-objects as value to a dart map
  static Map<String, List<NoticeResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NoticeResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NoticeResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'tipo',
    'comoRol',
    'titulo',
    'texto',
    'destino',
    'leido',
    'creadoEn',
  };
}

