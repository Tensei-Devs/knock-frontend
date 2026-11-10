import 'package:app/core/errores/failure.dart';
import 'package:app/features/cuenta/domain/perfil.dart';

/// Convierte el JSON de `GET/PUT /api/v1/me` en un [Perfil]; lanza
/// [DatosInvalidosFailure] si falta un campo o trae otro tipo. Nunca copia el
/// cuerpo a un mensaje de error.
abstract final class PerfilMapper {
  static Perfil desdeContrato(Object? json) {
    if (json is! Map<Object?, Object?>) throw const DatosInvalidosFailure();
    return Perfil(
      nombre: _textoOpcional(json['nombre']) ?? '',
      fotoUrl: _textoOpcional(json['fotoUrl']),
      colonia: _textoOpcional(json['colonia']),
      codigoPostal: _textoOpcional(json['codigoPostal']),
      esTecnico: _booleano(json['esTecnico']),
      estado: _texto(json['estado']),
      perfilCompleto: _booleano(json['perfilCompleto']),
    );
  }

  static String? _textoOpcional(Object? valor) {
    if (valor == null) return null;
    if (valor is! String) throw const DatosInvalidosFailure();
    return valor;
  }

  static String _texto(Object? valor) {
    if (valor is! String || valor.trim().isEmpty) {
      throw const DatosInvalidosFailure();
    }
    return valor;
  }

  static bool _booleano(Object? valor) {
    if (valor is! bool) throw const DatosInvalidosFailure();
    return valor;
  }
}
