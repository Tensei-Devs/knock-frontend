import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/features/tecnico/domain/mi_perfil.dart';
import 'package:http/http.dart' as http;

/// REAL: `GET` y `PUT /api/v1/tecnicos/me` (backend 046, TEC-15 y TEC-08).
/// Va por el transporte con sesión (spec 026). No guarda nada en el teléfono y
/// no registra nada: ni el nombre ni la dirección del taller.
class MiPerfilRepositoryApi implements MiPerfilRepository {
  const MiPerfilRepositoryApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  static const _ruta = 'tecnicos/me';

  @override
  Future<MiPerfilTecnico> leer() async => miPerfilDesdeJson(
    (await enviarJsonONoEncontrado(transporte, url, 'GET', _ruta)).json,
  );

  @override
  Future<void> guardar(Map<String, Object?> cambios) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'PUT',
      _ruta,
      cuerpo: cambios,
      aceptar: const {422},
    );
    if (r.estado == 422) throw _rechazo(r.json);
  }

  /// Un oficio que el servidor ya no ofrece se distingue del resto.
  static Failure _rechazo(Object? json) {
    final code = json is Map<Object?, Object?> ? json['code'] : null;
    return code == 'trade_invalid'
        ? const OpcionNoDisponibleFailure()
        : const DatosRechazadosFailure();
  }
}

/// El perfil del contrato, solo con lo que la app usa.
MiPerfilTecnico miPerfilDesdeJson(Object? json) {
  final m = objetoDelContrato(json);
  final radio = m['radioKm'];
  final anios = m['anios'];
  return MiPerfilTecnico(
    id: textoObligatorio(m['id']),
    nombre: textoObligatorio(m['nombre']),
    oficios: [
      for (final o in listaDelContrato(m['oficios'])) textoObligatorio(o),
    ],
    atencion: textoObligatorio(m['atencion']),
    estado: textoObligatorio(m['estado']),
    verificacion: textoObligatorio(m['verificacion']),
    radioKm: radio == null ? null : enteroObligatorio(radio),
    nombreNegocio: textoOpcional(m['nombreNegocio']),
    descripcion: textoOpcional(m['descripcion']),
    anios: anios == null ? null : enteroObligatorio(anios),
    direccionTaller: textoOpcional(m['direccionTaller']),
  );
}
