// Perfil propio ficticio de la spec 036 (`GET /api/v1/tecnicos/me`).
Map<String, Object?> miPerfilJson({
  String atencion = 'domicilio',
  int? radioKm = 8,
  String? direccionTaller,
}) => {
  'id': '64b7f0c2a1b2c3d4e5f60718',
  'nombre': 'Ana Ficticia Pérez',
  'oficios': ['plomeria'],
  'otroOficio': null,
  'atencion': atencion,
  'radioKm': radioKm,
  'coloniaId': '64b7f0c2a1b2c3d4e5f60719',
  'nombreNegocio': 'Plomería Ficticia',
  'descripcion': 'Reparo fugas y calentadores.',
  'anios': 6,
  'estado': 'activo',
  'verificacion': 'ninguno',
  'disponibleHoy': false,
  'creadoEn': '2026-11-01T10:00:00Z',
  'fotoUrl': null,
  'direccionTaller': direccionTaller,
};
