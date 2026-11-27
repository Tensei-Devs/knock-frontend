import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/features/trabajo/domain/llegada.dart';
import 'package:http/http.dart' as http;

/// REAL: `GET /api/v1/visitas/{id}` (vista del técnico) y
/// `POST /api/v1/visitas/{id}/llegada` (backend 022). Escrito a mano por
/// ADR-007. Sin `Idempotency-Key` (spec 016, R-16) y sin registrar el código.
class LlegadaRepositoryApi implements LlegadaRepository {
  const LlegadaRepositoryApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  static const _conflictos = {
    'visit_locked': MotivoLlegada.visitaBloqueada,
    'code_used': MotivoLlegada.codigoUsado,
    'code_expired': MotivoLlegada.codigoVencido,
    'visit_cancelled': MotivoLlegada.visitaCancelada,
    'visit_not_active': MotivoLlegada.visitaNoVigente,
    'visit_without_code': MotivoLlegada.visitaSinCodigo,
    'outside_window': MotivoLlegada.fueraDeVentana,
  };

  @override
  Future<VisitaDelTecnico> obtener(String visitaId) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'GET',
      'visitas/${Uri.encodeComponent(visitaId)}',
    );
    return _visita(r.json, visitaId);
  }

  @override
  Future<ResultadoLlegada> confirmar(String visitaId, String codigo) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'POST',
      'visitas/${Uri.encodeComponent(visitaId)}/llegada',
      cuerpo: {'codigo': codigo},
      aceptar: const {400, 403, 409, 422},
    );
    final cuerpo = r.json;
    final problema = cuerpo is Map<Object?, Object?>
        ? cuerpo
        : const <Object?, Object?>{};
    switch (r.estado) {
      case 400:
        return const LlegadaRechazada(MotivoLlegada.formato);
      case 403:
        return _prohibido(problema['code']);
      case 409:
        return _conflicto(visitaId, problema['code']);
      case 422:
        return _rechazado(problema);
      default:
        return LlegadaConfirmada(_visita(cuerpo, visitaId));
    }
  }

  static ResultadoLlegada _prohibido(Object? codigo) {
    if (codigo == 'not_a_technician') {
      return const LlegadaRechazada(MotivoLlegada.noEsTecnico);
    }
    if (codigo == 'account_suspended') throw const CuentaSuspendidaFailure();
    throw const AccesoDenegadoFailure();
  }

  /// La respuesta de una llegada que sí se aceptó pudo perderse: con
  /// `code_used` y la visita ya en curso no es un error (CA-17).
  Future<ResultadoLlegada> _conflicto(String visitaId, Object? codigo) async {
    final motivo = _conflictos[codigo];
    if (motivo == null) throw const ConflictoFailure();
    if (motivo == MotivoLlegada.codigoUsado) {
      final actual = await obtener(visitaId);
      if (actual.enCurso) return LlegadaConfirmada(actual);
    }
    return LlegadaRechazada(motivo);
  }

  static ResultadoLlegada _rechazado(Map<Object?, Object?> problema) {
    if (problema['code'] == 'wrong_code') {
      final restantes = problema['intentosRestantes'];
      return LlegadaRechazada(
        MotivoLlegada.codigoIncorrecto,
        intentosRestantes: restantes is int ? restantes : null,
      );
    }
    final errores = problema['errors'];
    if (errores is Map<Object?, Object?> && errores['codigo'] != null) {
      return const LlegadaRechazada(MotivoLlegada.formato);
    }
    throw const DatosRechazadosFailure();
  }

  static VisitaDelTecnico _visita(Object? json, String visitaId) {
    final m = objetoDelContrato(json);
    if (m['rol'] != 'tecnico' || textoObligatorio(m['id']) != visitaId) {
      throw const DatosInvalidosFailure();
    }
    final cliente = m['cliente'];
    final lugar = objetoDelContrato(m['lugar']);
    final llegada = m['llegadaEn'];
    return VisitaDelTecnico(
      id: visitaId,
      estado: textoObligatorio(m['estado']),
      esTaller: textoObligatorio(m['modalidad']) == 'taller',
      dia: textoObligatorio(m['dia']),
      hora: textoObligatorio(m['hora']),
      puedeLlegar: booleanoObligatorio(m['puedeLlegar']),
      colonia: cliente == null
          ? null
          : textoOpcional(objetoDelContrato(cliente)['colonia']),
      direccion: textoOpcional(lugar['direccion']),
      llegadaEn: llegada == null ? null : fechaHoraObligatoria(llegada),
    );
  }
}
