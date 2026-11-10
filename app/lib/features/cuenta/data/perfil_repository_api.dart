import 'package:app/core/red/enviar_json.dart';
import 'package:app/core/red/obtener_json.dart';
import 'package:app/features/cuenta/data/perfil_mapper.dart';
import 'package:app/features/cuenta/domain/perfil.dart';
import 'package:app/features/cuenta/domain/perfil_repository.dart';
import 'package:http/http.dart' as http;

/// REAL: `GET/PUT /api/v1/me` y `POST /api/v1/auth/logout` (spec 026).
///
/// [transporte] es `transporteApiProvider`: pone el Bearer, revalida con
/// `ETag` (304 entrega lo guardado, D-11) y renueva la sesión ante un 401.
/// Este repositorio no reintenta nada por sí mismo (R-13).
class PerfilRepositoryApi implements PerfilRepository {
  PerfilRepositoryApi({
    required this.transporte,
    required this.url,
    required this.cerrarLocal,
  });

  final http.Client transporte;
  final String url;

  /// Borra tokens y caché y deja la bandera de sesión en falso.
  final Future<void> Function() cerrarLocal;

  /// Último perfil leído o guardado: de ahí salen los opcionales del `PUT`.
  Perfil? _ultimo;

  @override
  Future<Perfil> obtener() async => _ultimo = PerfilMapper.desdeContrato(
    await obtenerJson(transporte, url, 'me'),
  );

  @override
  Future<Perfil> guardarNombre(String nombre) async {
    // El backend borra los opcionales que se omiten: se reenvían los del
    // último perfil leído (D-06).
    final base = _ultimo ?? await obtener();
    final respuesta = await enviarJson(
      transporte,
      url,
      'PUT',
      'me',
      cuerpo: {
        'nombre': nombre.trim(),
        if (base.fotoUrl != null) 'fotoUrl': base.fotoUrl,
        if (base.colonia != null) 'colonia': base.colonia,
        if (base.codigoPostal != null) 'codigoPostal': base.codigoPostal,
      },
    );
    return _ultimo = PerfilMapper.desdeContrato(respuesta.json);
  }

  @override
  Future<void> cerrarSesion() async {
    try {
      // Sin renovación ni reintento (D-05).
      await enviarJson(transporte, url, 'POST', 'auth/logout');
    } on Object {
      // Sin red, 401 o 5xx: la sesión se cierra en el teléfono de todos modos
      // (R-03). Sin registro: no hay nada útil que guardar.
    }
    _ultimo = null;
    await cerrarLocal();
  }
}
