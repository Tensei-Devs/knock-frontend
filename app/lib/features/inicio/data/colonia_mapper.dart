import 'package:app/core/errores/failure.dart';
import 'package:app/features/inicio/domain/colonia.dart';

/// Convierte el JSON de `GET /api/v1/colonias/en-punto` en un
/// [ResultadoColonia]; lanza [DatosInvalidosFailure] si no cumple el contrato.
abstract final class ColoniaMapper {
  static ResultadoColonia desdeContrato(Object? json) {
    if (json is! Map<Object?, Object?>) throw const DatosInvalidosFailure();
    final enCobertura = json['enCobertura'];
    if (enCobertura is! bool) throw const DatosInvalidosFailure();
    final colonia = json['colonia'];
    if (!enCobertura || colonia == null) {
      return const ResultadoColonia(enCobertura: false);
    }
    if (colonia is! Map<Object?, Object?>) throw const DatosInvalidosFailure();
    return ResultadoColonia(
      enCobertura: true,
      colonia: Colonia(
        id: _texto(colonia['id']),
        nombre: _texto(colonia['nombre']),
        cp: _texto(colonia['cp']),
        municipio: _texto(colonia['municipio']),
      ),
    );
  }

  static String _texto(Object? valor) {
    if (valor is! String || valor.trim().isEmpty) {
      throw const DatosInvalidosFailure();
    }
    return valor;
  }
}
