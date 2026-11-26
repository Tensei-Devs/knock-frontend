import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/tecnico/domain/alta_tecnico.dart';
import 'package:http/http.dart' as http;

/// REAL: `POST /api/v1/tecnicos` (backend 046, TEC-01). Va por el transporte
/// con sesión (spec 026). Una escritura no se reintenta aquí y no se registra
/// nada: ni el nombre ni la dirección del taller.
class TecnicoRepositoryApi implements TecnicoRepository {
  const TecnicoRepositoryApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  @override
  Future<PerfilTecnico> registrar(AltaTecnico alta) async {
    final r = await enviarJson(
      transporte,
      url,
      'POST',
      'tecnicos',
      cuerpo: cuerpoDeAlta(alta),
      aceptar: const {422},
    );
    if (r.estado == 422) throw _rechazo(r.json);
    return _perfil(r.json);
  }

  /// Un oficio o una colonia que el servidor ya no ofrece se distinguen del
  /// resto para pedir que se elijan de nuevo.
  static Failure _rechazo(Object? json) {
    final errores = json is Map<Object?, Object?> ? json['errors'] : null;
    final campos = errores is Map<Object?, Object?>
        ? errores
        : const <Object?, Object?>{};
    final opcion = [
      ...?_motivos(campos['oficios']),
      ...?_motivos(campos['coloniaId']),
    ].any((m) => m == 'trade_invalid' || m == 'colonia_not_found');
    return opcion
        ? const OpcionNoDisponibleFailure()
        : const DatosRechazadosFailure();
  }

  static List<Object?>? _motivos(Object? valor) => switch (valor) {
    final List<Object?> lista => lista,
    null => null,
    _ => [valor],
  };

  static PerfilTecnico _perfil(Object? json) {
    final m = objetoDelContrato(json);
    return PerfilTecnico(
      id: textoObligatorio(m['id']),
      nombre: textoObligatorio(m['nombre']),
      oficios: [
        for (final o in listaDelContrato(m['oficios'])) textoObligatorio(o),
      ],
      estado: textoObligatorio(m['estado']),
      verificacion: textoObligatorio(m['verificacion']),
      disponibleHoy: booleanoObligatorio(m['disponibleHoy']),
    );
  }
}

/// El cuerpo del contrato: lo que no aplica no se envía (el servidor rechaza
/// una dirección de taller a domicilio y un radio en taller).
Map<String, Object?> cuerpoDeAlta(AltaTecnico alta) {
  final negocio = _lleno(alta.nombreNegocio);
  final descripcion = _lleno(alta.descripcion);
  final perfil = {
    'nombreNegocio': ?negocio,
    'descripcion': ?descripcion,
    'anios': ?alta.anios,
  };
  final otro = _lleno(alta.otroOficio);
  final enTaller = alta.atencion == Atencion.taller;
  return {
    'nombre': alta.nombre.trim(),
    'oficios': alta.oficios,
    'otroOficio': ?otro,
    'atencion': alta.atencion.valor,
    if (enTaller) 'direccionTaller': alta.direccionTaller?.trim(),
    if (!enTaller) 'radioKm': alta.radioKm,
    'coloniaId': alta.coloniaId,
    if (perfil.isNotEmpty) 'perfil': perfil,
    'aceptaTerminos': alta.aceptaTerminos,
  };
}

String? _lleno(String? texto) {
  final limpio = texto?.trim() ?? '';
  return limpio.isEmpty ? null : limpio;
}
