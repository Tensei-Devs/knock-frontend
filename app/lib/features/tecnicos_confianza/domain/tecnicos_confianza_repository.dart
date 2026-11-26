import 'package:app/features/tecnicos_confianza/domain/tecnico_confianza.dart';

/// Técnicos de confianza (spec 032, TCO-01 a TCO-03). Falla con un `Failure`
/// de `core/errores`: 401 `NoAutorizadoFailure`, 404 `NoEncontradoFailure`,
/// 400, 413 y 422 `DatosRechazadosFailure`, 429 `DemasiadosIntentosFailure`.
abstract interface class TecnicosConfianzaRepository {
  /// `GET /me/tecnicos-confianza`, con cursor opaco.
  Future<PaginaTecnicosConfianza> listar({String? cursor, int? limite});

  /// `PUT /me/tecnicos-confianza/{tecnicoId}` (idempotente: 201 o 200).
  Future<ResultadoGuardado> guardar(String tecnicoId);

  /// `DELETE /me/tecnicos-confianza/{tecnicoId}` (204).
  Future<void> quitar(String tecnicoId);
}
