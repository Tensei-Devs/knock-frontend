// Respuestas de ejemplo (ficticias) de las specs 046, 019 y 038.
Map<String, Object?> detalleJson() => {
  'id': 's1',
  'oficio': {'clave': 'plomeria', 'nombre': 'Plomería'},
  'colonia': {'id': 'co1', 'nombre': 'Centro', 'cp': '42800'},
  'descripcion': 'Gotea la llave',
  'fotos': [
    {'id': 'f1', 'url': 'https://fotos.knock.test/f1', 'venceEn': 'x'},
  ],
  'dia': '2026-11-27',
  'franja': 'manana',
  'creadoEn': '2026-11-26T12:00:00',
};

Map<String, Object?> cotizacionJson({
  String id = 'c1',
  String solicitudId = 's1',
}) => {
  'id': id,
  'solicitudId': solicitudId,
  'estado': 'enviada',
  'tipoPrecio': 'fijo',
  'precio': 350,
  'tope': 400,
  'requiereAprobacion': true,
  'dia': '2026-11-27',
  'hora': '09:30',
  'creadoEn': '2026-11-26T13:00:00Z',
};

Map<String, Object?> recibidaJson({bool yaCotizo = false}) => {
  'solicitudId': 's1',
  'oficio': {'clave': 'plomeria', 'nombre': 'Plomería'},
  'colonia': {'id': 'co1', 'nombre': 'Centro', 'cp': '42800'},
  'descripcion': 'Gotea la llave',
  'fotos': <Object?>[],
  'dia': '2026-11-27',
  'franja': 'tarde',
  'yaCotizo': yaCotizo,
};

/// Referencia de mercado ficticia (spec 038, enmienda 2026-11-27).
Map<String, Object?> referenciaJson({
  String origen = 'mercado',
  int? p25 = 300,
  int? mediana = 450,
  int? p75 = 600,
}) => {'origen': origen, 'p25': p25, 'mediana': mediana, 'p75': p75};
