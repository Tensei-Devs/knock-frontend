import 'package:app/core/errores/failure.dart';
import 'package:app/features/inicio/domain/colonia.dart';
import 'package:app/features/inicio/domain/zona.dart';

/// Convierte las respuestas de zonas en modelos; lanza
/// [DatosInvalidosFailure] si no cumplen el contrato.
abstract final class ZonaMapper {
  static ResultadoZona zonaDesdeContrato(Object? json) {
    if (json is! Map<Object?, Object?>) throw const DatosInvalidosFailure();
    final enCobertura = json['enCobertura'];
    final ciudadPiloto = json['ciudadPiloto'];
    final colonias = json['colonias'];
    if (enCobertura is! bool || ciudadPiloto is! bool) {
      throw const DatosInvalidosFailure();
    }
    if (colonias is! List<Object?>) throw const DatosInvalidosFailure();
    return ResultadoZona(
      enCobertura: enCobertura,
      ciudadPiloto: ciudadPiloto,
      colonias: [for (final c in colonias) _colonia(c)],
    );
  }

  static RegistroListaEspera registroDesdeContrato(Object? json) {
    if (json is! Map<Object?, Object?>) throw const DatosInvalidosFailure();
    final cp = json['cp'];
    final yaRegistrado = json['yaRegistrado'];
    if (cp is! String || yaRegistrado is! bool) {
      throw const DatosInvalidosFailure();
    }
    return RegistroListaEspera(cp: cp, yaRegistrado: yaRegistrado);
  }

  static Colonia _colonia(Object? json) {
    if (json is! Map<Object?, Object?>) throw const DatosInvalidosFailure();
    return Colonia(
      id: _texto(json['id']),
      nombre: _texto(json['nombre']),
      cp: _texto(json['cp']),
      municipio: _texto(json['municipio']),
    );
  }

  static String _texto(Object? valor) {
    if (valor is! String || valor.trim().isEmpty) {
      throw const DatosInvalidosFailure();
    }
    return valor;
  }
}
