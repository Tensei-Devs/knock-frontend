// Spec 041: respuestas ficticias del contrato de opiniones.
Map<String, Object?> opinionJson(String id, {String comentario = 'Muy bien'}) =>
    {
      'id': id,
      'calificacion': 5,
      'partes': {
        'puntualidad': 5,
        'calidad': null,
        'precioJusto': null,
        'trato': null,
      },
      'comentario': comentario,
      'fotos': ['f' * 32],
      'respuesta': {'texto': 'Gracias', 'fecha': '2026-11-21T18:00:00Z'},
      'anonimizada': false,
      'servicioVerificado': true,
      'creadoEn': '2026-11-20T18:00:00Z',
    };

Map<String, Object?> paginaJson(List<Object?> items, {String? cursor}) => {
  'items': items,
  'resumen': {
    'promedio': items.isEmpty ? null : 4.5,
    'total': items.length,
    'distribucion': {'5': 1, '4': 1, '3': 0, '2': 0, '1': 0},
  },
  'nextCursor': cursor,
};

const creadaJson = {
  'id': 'o-9',
  'calificacion': 4,
  'moderacion': 'publicada',
  'creadoEn': '2026-11-22T18:00:00Z',
};
