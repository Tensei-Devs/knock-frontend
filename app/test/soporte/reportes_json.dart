// Spec 033: respuestas ficticias de reportes.
Map<String, Object?> visitaParaReportarJson(String? tecnicoUsuarioId) => {
  'id': 'v-1',
  'tecnico': {'nombre': 'Técnico de ejemplo'},
  'tecnicoUsuarioId': tecnicoUsuarioId,
};

Map<String, Object?> paginaDeReportesJson(
  List<String> ids,
  String? cursor, {
  bool puedeApelar = false,
}) => {
  'items': [
    for (final id in ids)
      {
        'reporteId': id,
        'motivo': 'fraude',
        'estado': puedeApelar ? 'decidido' : 'abierto',
        'creadoEn': '2026-11-20T18:00:00Z',
        'puedeApelar': puedeApelar,
      },
  ],
  'nextCursor': cursor,
};

Map<String, Object?> paginaDeBloqueadosJson(List<String> ids, String? cursor) =>
    {
      'items': [
        for (final id in ids)
          {
            'usuarioId': id,
            'nombre': 'Persona $id',
            'bloqueadoEn': '2026-11-20T18:00:00Z',
          },
      ],
      'nextCursor': cursor,
    };
