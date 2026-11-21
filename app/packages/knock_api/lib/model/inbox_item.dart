//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;

class InboxItem {
  /// Returns a new [InboxItem] instance.
  InboxItem({
    required this.solicitudId,
    required this.oficio,
    required this.colonia,
    required this.descripcion,
    this.fotos = const [],
    required this.dia,
    required this.franja,
    required this.modalidad,
    required this.venceEn,
    required this.oleada,
    required this.recibidaEn,
    required this.yaCotizo,
  });

  String solicitudId;

  RequestTrade oficio;

  InboxNeighborhood colonia;

  String descripcion;

  List<RequestPhoto> fotos;

  String dia;

  String franja;

  String modalidad;

  DateTime venceEn;

  int oleada;

  DateTime recibidaEn;

  bool yaCotizo;

  @override
  bool operator ==(Object other) => identical(this, other) || other is InboxItem &&
    other.solicitudId == solicitudId &&
    other.oficio == oficio &&
    other.colonia == colonia &&
    other.descripcion == descripcion &&
    _deepEquality.equals(other.fotos, fotos) &&
    other.dia == dia &&
    other.franja == franja &&
    other.modalidad == modalidad &&
    other.venceEn == venceEn &&
    other.oleada == oleada &&
    other.recibidaEn == recibidaEn &&
    other.yaCotizo == yaCotizo;

  @override
  int get hashCode =>
    (solicitudId.hashCode) +
    (oficio.hashCode) +
    (colonia.hashCode) +
    (descripcion.hashCode) +
    (fotos.hashCode) +
    (dia.hashCode) +
    (franja.hashCode) +
    (modalidad.hashCode) +
    (venceEn.hashCode) +
    (oleada.hashCode) +
    (recibidaEn.hashCode) +
    (yaCotizo.hashCode);

  @override
  String toString() => 'InboxItem[solicitudId=$solicitudId, oficio=$oficio, colonia=$colonia, descripcion=$descripcion, fotos=$fotos, dia=$dia, franja=$franja, modalidad=$modalidad, venceEn=$venceEn, oleada=$oleada, recibidaEn=$recibidaEn, yaCotizo=$yaCotizo]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'solicitudId'] = this.solicitudId;
      json[r'oficio'] = this.oficio;
      json[r'colonia'] = this.colonia;
      json[r'descripcion'] = this.descripcion;
      json[r'fotos'] = this.fotos;
      json[r'dia'] = this.dia;
      json[r'franja'] = this.franja;
      json[r'modalidad'] = this.modalidad;
      json[r'venceEn'] = this.venceEn.toUtc().toIso8601String();
      json[r'oleada'] = this.oleada;
      json[r'recibidaEn'] = this.recibidaEn.toUtc().toIso8601String();
      json[r'yaCotizo'] = this.yaCotizo;
    return json;
  }

  /// Returns a new [InboxItem] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static InboxItem? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'solicitudId'), 'Required key "InboxItem[solicitudId]" is missing from JSON.');
        assert(json[r'solicitudId'] != null, 'Required key "InboxItem[solicitudId]" has a null value in JSON.');
        assert(json.containsKey(r'oficio'), 'Required key "InboxItem[oficio]" is missing from JSON.');
        assert(json[r'oficio'] != null, 'Required key "InboxItem[oficio]" has a null value in JSON.');
        assert(json.containsKey(r'colonia'), 'Required key "InboxItem[colonia]" is missing from JSON.');
        assert(json[r'colonia'] != null, 'Required key "InboxItem[colonia]" has a null value in JSON.');
        assert(json.containsKey(r'descripcion'), 'Required key "InboxItem[descripcion]" is missing from JSON.');
        assert(json[r'descripcion'] != null, 'Required key "InboxItem[descripcion]" has a null value in JSON.');
        assert(json.containsKey(r'fotos'), 'Required key "InboxItem[fotos]" is missing from JSON.');
        assert(json[r'fotos'] != null, 'Required key "InboxItem[fotos]" has a null value in JSON.');
        assert(json.containsKey(r'dia'), 'Required key "InboxItem[dia]" is missing from JSON.');
        assert(json[r'dia'] != null, 'Required key "InboxItem[dia]" has a null value in JSON.');
        assert(json.containsKey(r'franja'), 'Required key "InboxItem[franja]" is missing from JSON.');
        assert(json[r'franja'] != null, 'Required key "InboxItem[franja]" has a null value in JSON.');
        assert(json.containsKey(r'modalidad'), 'Required key "InboxItem[modalidad]" is missing from JSON.');
        assert(json[r'modalidad'] != null, 'Required key "InboxItem[modalidad]" has a null value in JSON.');
        assert(json.containsKey(r'venceEn'), 'Required key "InboxItem[venceEn]" is missing from JSON.');
        assert(json[r'venceEn'] != null, 'Required key "InboxItem[venceEn]" has a null value in JSON.');
        assert(json.containsKey(r'oleada'), 'Required key "InboxItem[oleada]" is missing from JSON.');
        assert(json[r'oleada'] != null, 'Required key "InboxItem[oleada]" has a null value in JSON.');
        assert(json.containsKey(r'recibidaEn'), 'Required key "InboxItem[recibidaEn]" is missing from JSON.');
        assert(json[r'recibidaEn'] != null, 'Required key "InboxItem[recibidaEn]" has a null value in JSON.');
        assert(json.containsKey(r'yaCotizo'), 'Required key "InboxItem[yaCotizo]" is missing from JSON.');
        assert(json[r'yaCotizo'] != null, 'Required key "InboxItem[yaCotizo]" has a null value in JSON.');
        return true;
      }());

      return InboxItem(
        solicitudId: mapValueOfType<String>(json, r'solicitudId')!,
        oficio: RequestTrade.fromJson(json[r'oficio'])!,
        colonia: InboxNeighborhood.fromJson(json[r'colonia'])!,
        descripcion: mapValueOfType<String>(json, r'descripcion')!,
        fotos: RequestPhoto.listFromJson(json[r'fotos']),
        dia: mapValueOfType<String>(json, r'dia')!,
        franja: mapValueOfType<String>(json, r'franja')!,
        modalidad: mapValueOfType<String>(json, r'modalidad')!,
        venceEn: mapDateTime(json, r'venceEn', r'')!,
        oleada: mapValueOfType<int>(json, r'oleada')!,
        recibidaEn: mapDateTime(json, r'recibidaEn', r'')!,
        yaCotizo: mapValueOfType<bool>(json, r'yaCotizo')!,
      );
    }
    return null;
  }

  static List<InboxItem> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <InboxItem>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = InboxItem.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, InboxItem> mapFromJson(dynamic json) {
    final map = <String, InboxItem>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        final value = InboxItem.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of InboxItem-objects as value to a dart map
  static Map<String, List<InboxItem>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<InboxItem>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = InboxItem.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'solicitudId',
    'oficio',
    'colonia',
    'descripcion',
    'fotos',
    'dia',
    'franja',
    'modalidad',
    'venceEn',
    'oleada',
    'recibidaEn',
    'yaCotizo',
  };
}

