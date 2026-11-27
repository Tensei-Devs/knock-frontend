import 'package:app/features/explorar/domain/explorar.dart';

/// SIMULADO para desarrollo sin `KNOCK_API_URL` (spec 036, D-01): la misma
/// forma que el contrato, con nombres de demostración y sin datos reales.
class ExplorarRepositorySimulado implements ExplorarRepository {
  const ExplorarRepositorySimulado();

  static const _servicios = [
    ServicioPopular(clave: 'mec', nombre: 'Mecánica', tecnicos: 3),
    ServicioPopular(clave: 'plo', nombre: 'Plomería', tecnicos: 2),
  ];

  /// Como en el servidor: los oficios que no están entre los populares.
  static const _ideas = [IdeaExplorar(clave: 'ele', nombre: 'Electricidad')];

  static const _tecnicos = [
    TecnicoDestacado(
      id: 'demo-1',
      nombre: 'Taller Demo',
      verificacion: 'completa',
      oficios: ['mec'],
      calificacion: 4.8,
      anios: 12,
    ),
    TecnicoDestacado(
      id: 'demo-2',
      nombre: 'Plomería Demo',
      verificacion: 'basica',
      oficios: ['plo'],
      calificacion: 4.6,
      anios: 8,
    ),
    TecnicoDestacado(
      id: 'demo-3',
      nombre: 'Electricidad Demo',
      verificacion: 'ninguno',
      oficios: ['ele'],
    ),
  ];

  @override
  Future<Explorar> cargar(FiltroExplorar filtro) async {
    bool entra(String oficio) =>
        filtro.oficio == null || filtro.oficio == oficio;
    return Explorar(
      filtro: filtro,
      serviciosPopulares: [
        for (final s in _servicios)
          if (entra(s.clave)) s,
      ],
      mejorCalificados: [
        for (final t in _tecnicos)
          if (t.oficios.any(entra)) t,
      ],
      ideas: [
        for (final i in _ideas)
          if (entra(i.clave)) i,
      ],
    );
  }
}
