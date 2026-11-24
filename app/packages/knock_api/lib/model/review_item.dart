//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class ReviewItem {
  /// Returns a new [ReviewItem] instance.
  ReviewItem({
    required this.id,
    required this.calificacion,
    required this.partes,
    required this.comentario,
    this.fotos = const [],
    required this.respuesta,
    required this.anonimizada,
    required this.servicioVerificado,
    required this.creadoEn,
  });

  String id;

  int calificacion;

  ReviewParts? partes;

  String? comentario;

  List<String> fotos;

  ReviewAnswer? respuesta;

  bool anonimizada;

  bool servicioVerificado;

  DateTime creadoEn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReviewItem &&
    other.id == id &&
    other.calificacion == calificacion &&
    other.partes == partes &&
    other.comentario == comentario &&
    _deepEquality.equals(other.fotos, fotos) &&
    other.respuesta == respuesta &&
    other.anonimizada == anonimizada &&
    other.servicioVerificado == servicioVerificado &&
    other.creadoEn == creadoEn;

  @override
  int get hashCode =>
    (id.hashCode) +
    (calificacion.hashCode) +
    (partes == null ? 0 : partes!.hashCode) +
    (comentario == null ? 0 : comentario!.hashCode) +
    (fotos.hashCode) +
    (respuesta == null ? 0 : respuesta!.hashCode) +
    (anonimizada.hashCode) +
    (servicioVerificado.hashCode) +
    (creadoEn.hashCode);

  @override
  String toString() => 'ReviewItem[id=$id, calificacion=$calificacion, partes=$partes, comentario=$comentario, fotos=$fotos, respuesta=$respuesta, anonimizada=$anonimizada, servicioVerificado=$servicioVerificado, creadoEn=$creadoEn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'calificacion'] = this.calificacion;
    if (this.partes != null) {
      json[r'partes'] = this.partes;
    } else {
      json[r'partes'] = null;
    }
    if (this.comentario != null) {
      json[r'comentario'] = this.comentario;
    } else {
      json[r'comentario'] = null;
    }
      json[r'fotos'] = this.fotos;
    if (this.respuesta != null) {
      json[r'respuesta'] = this.respuesta;
    } else {
      json[r'respuesta'] = null;
    }
      json[r'anonimizada'] = this.anonimizada;
      json[r'servicioVerificado'] = this.servicioVerificado;
      json[r'creadoEn'] = this.creadoEn.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [ReviewItem] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ReviewItem? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'id'), 'Required key "ReviewItem[id]" is missing from JSON.');
        assert(json[r'id'] != null, 'Required key "ReviewItem[id]" has a null value in JSON.');
        assert(json.containsKey(r'calificacion'), 'Required key "ReviewItem[calificacion]" is missing from JSON.');
        assert(json[r'calificacion'] != null, 'Required key "ReviewItem[calificacion]" has a null value in JSON.');
        assert(json.containsKey(r'partes'), 'Required key "ReviewItem[partes]" is missing from JSON.');
        assert(json.containsKey(r'comentario'), 'Required key "ReviewItem[comentario]" is missing from JSON.');
        assert(json.containsKey(r'fotos'), 'Required key "ReviewItem[fotos]" is missing from JSON.');
        assert(json[r'fotos'] != null, 'Required key "ReviewItem[fotos]" has a null value in JSON.');
        assert(json.containsKey(r'respuesta'), 'Required key "ReviewItem[respuesta]" is missing from JSON.');
        assert(json.containsKey(r'anonimizada'), 'Required key "ReviewItem[anonimizada]" is missing from JSON.');
        assert(json[r'anonimizada'] != null, 'Required key "ReviewItem[anonimizada]" has a null value in JSON.');
        assert(json.containsKey(r'servicioVerificado'), 'Required key "ReviewItem[servicioVerificado]" is missing from JSON.');
        assert(json[r'servicioVerificado'] != null, 'Required key "ReviewItem[servicioVerificado]" has a null value in JSON.');
        assert(json.containsKey(r'creadoEn'), 'Required key "ReviewItem[creadoEn]" is missing from JSON.');
        assert(json[r'creadoEn'] != null, 'Required key "ReviewItem[creadoEn]" has a null value in JSON.');
        return true;
      }());

      return ReviewItem(
        id: mapValueOfType<String>(json, r'id')!,
        calificacion: mapValueOfType<int>(json, r'calificacion')!,
        partes: ReviewParts.fromJson(json[r'partes']),
        comentario: mapValueOfType<String>(json, r'comentario'),
        fotos: json[r'fotos'] is Iterable
            ? (json[r'fotos'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        respuesta: ReviewAnswer.fromJson(json[r'respuesta']),
        anonimizada: mapValueOfType<bool>(json, r'anonimizada')!,
        servicioVerificado: mapValueOfType<bool>(json, r'servicioVerificado')!,
        creadoEn: mapDateTime(json, r'creadoEn', r'')!,
      );
    }
    return null;
  }

  static List<ReviewItem> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReviewItem>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReviewItem.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReviewItem> mapFromJson(dynamic json) {
    final map = <String, ReviewItem>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = ReviewItem.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReviewItem-objects as value to a dart map
  static Map<String, List<ReviewItem>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReviewItem>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReviewItem.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'calificacion',
    'partes',
    'comentario',
    'fotos',
    'respuesta',
    'anonimizada',
    'servicioVerificado',
    'creadoEn',
  };
}

