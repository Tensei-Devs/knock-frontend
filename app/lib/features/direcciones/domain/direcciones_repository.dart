import 'package:app/features/direcciones/domain/direccion.dart';

/// Direcciones de la persona (spec 030, DIR-01 a DIR-04). Falla con un
/// `Failure` de `core/errores`: 401 `NoAutorizadoFailure`, 403
/// `AccesoDenegadoFailure`, 404 `NoEncontradoFailure`, 400 y 422
/// `DatosRechazadosFailure`.
abstract interface class DireccionesRepository {
  /// `GET /me/direcciones`, en el orden del servidor.
  Future<List<Direccion>> listar();

  /// `POST /me/direcciones` (201).
  Future<Direccion> crear(DireccionNueva nueva);

  /// `PUT /me/direcciones/{id}` (200).
  Future<Direccion> editar(String id, CambiosDireccion cambios);

  /// `DELETE /me/direcciones/{id}` (204).
  Future<void> eliminar(String id);
}
