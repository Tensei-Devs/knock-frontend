import 'dart:convert';

import 'package:app/core/cache/almacen_cache.dart';
import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/asistente/domain/asistente.dart';
import 'package:http/http.dart' as http;

/// REAL: `/api/v1/asistente/*` (backend 052). Va por el transporte con sesión
/// (un 401 la cierra). No registra textos de la persona ni de las respuestas.
class AsistenteRepositoryApi implements AsistenteRepository {
  const AsistenteRepositoryApi({
    required this.transporte,
    required this.url,
    required this.cache,
  });

  final http.Client transporte;
  final String url;

  /// Solo para la última copia del rango de precio (CA-13); se borra al cerrar
  /// la sesión.
  final AlmacenCache cache;

  @override
  Future<TurnoAsistente> turno(String mensaje) async {
    final m = await _pedir(
      'POST',
      'conversaciones',
      cuerpo: {'mensaje': mensaje, 'foto': null, 'contexto': null},
    );
    return TurnoAsistente(
      categoria: textoObligatorio(m['categoria']),
      mensaje: textoObligatorio(m['mensaje']),
      pideFoto: booleanoObligatorio(m['pideFoto']),
      seguridad: textoOpcional(m['seguridad']),
      deIa: _deIa(m),
    );
  }

  @override
  Future<ResumenChat> resumir(String conversacionId) async {
    final m = await _pedir(
      'POST',
      'resumen-chat',
      cuerpo: {'conversacionId': conversacionId},
    );
    return ResumenChat(
      sabe: _textos(m['sabe']),
      porConfirmar: _textos(m['porConfirmar']),
      queLlevar: _textos(m['queLlevar']),
      deIa: _deIa(m),
    );
  }

  @override
  Future<BorradorCotizacionIa> borrador(String conversacionId) async {
    final m = await _pedir(
      'POST',
      'borrador-cotizacion',
      cuerpo: {'conversacionId': conversacionId},
    );
    return BorradorCotizacionIa(
      precioSugerido: _numero(m['precioSugerido']),
      tiempoEstimado: textoObligatorio(m['tiempoEstimado']),
      dia: textoObligatorio(m['dia']),
      nota: textoObligatorio(m['nota']),
      explicacion: textoObligatorio(m['explicacion']),
      deIa: _deIa(m),
    );
  }

  @override
  Future<RangoPrecio?> rango(String oficio, String tipoTrabajo) async {
    final clave = 'catalogo/rango-precio/$oficio/$tipoTrabajo';
    try {
      final r = await _enviar(
        'GET',
        'rango-precio',
        consulta: {'oficio': oficio, 'tipoTrabajo': tipoTrabajo},
        aceptar: const {404},
      );
      if (r.estado == 404) return null;
      final rango = _rango(r.json);
      await cache.guardar(
        clave,
        EntradaCache(cuerpo: jsonEncode(r.json), guardadoEn: DateTime.now()),
      );
      return rango;
    } on ServicioNoDisponibleFailure {
      final copia = await cache.leer(clave);
      if (copia == null) rethrow;
      return _rango(jsonDecode(copia.cuerpo), copiaDel: copia.guardadoEn);
    }
  }

  @override
  Future<Bitacora?> bitacora(String solicitudId) async {
    final r = await _enviar(
      'GET',
      'bitacora/${Uri.encodeComponent(solicitudId)}',
      aceptar: const {404},
    );
    return r.estado == 404 ? null : _bitacora(objetoDelContrato(r.json));
  }

  @override
  Future<Bitacora> guardarBitacora(String solicitudId, Bitacora b) async =>
      _bitacora(
        await _pedir(
          'PUT',
          'bitacora/${Uri.encodeComponent(solicitudId)}',
          cuerpo: {
            'sabe': b.sabe,
            'porConfirmar': b.porConfirmar,
            'queLlevar': b.queLlevar,
          },
        ),
      );

  Future<Map<Object?, Object?>> _pedir(
    String metodo,
    String ruta, {
    Object? cuerpo,
  }) async =>
      objetoDelContrato((await _enviar(metodo, ruta, cuerpo: cuerpo)).json);

  /// Un 503 es «sin recurso de IA» (backend 052, CA-29), no falta de conexión.
  Future<RespuestaJson> _enviar(
    String metodo,
    String ruta, {
    Map<String, String>? consulta,
    Object? cuerpo,
    Set<int> aceptar = const {},
  }) async {
    final r = await enviarJson(
      transporte,
      url,
      metodo,
      'asistente/$ruta',
      consulta: consulta,
      cuerpo: cuerpo,
      aceptar: {503, ...aceptar},
    );
    if (r.estado == 503) throw const AsistenteNoDisponibleFailure();
    return r;
  }

  static bool _deIa(Map<Object?, Object?> m) =>
      textoObligatorio(m['origen']) == 'proveedor' &&
      booleanoObligatorio(m['generadoPorIa']);

  static List<String> _textos(Object? valor) => [
    for (final t in listaDelContrato(valor)) textoObligatorio(t),
  ];

  static num _numero(Object? valor) =>
      num.tryParse('$valor') ?? (throw const DatosInvalidosFailure());

  static RangoPrecio _rango(Object? json, {DateTime? copiaDel}) {
    final m = objetoDelContrato(json);
    return RangoPrecio(
      minimo: _numero(m['minimo']),
      maximo: _numero(m['maximo']),
      muestras: _numero(m['muestras']).toInt(),
      fuente: textoObligatorio(m['fuente']),
      copiaDel: copiaDel,
    );
  }

  static Bitacora _bitacora(Map<Object?, Object?> m) => Bitacora(
    sabe: _textos(m['sabe']),
    porConfirmar: _textos(m['porConfirmar']),
    queLlevar: _textos(m['queLlevar']),
    actualizadaEn: fechaHoraObligatoria(m['actualizadaEn']),
  );
}
