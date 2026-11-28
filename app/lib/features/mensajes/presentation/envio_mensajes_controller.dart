import 'package:app/core/errores/failure.dart';
import 'package:flutter/foundation.dart';

import '../domain/envio_de_mensajes.dart';
import '../domain/mensaje.dart';

/// Estado de un mensaje propio en la pantalla.
enum EstadoDeEnvio { pendiente, fallido, enviado }

/// Mensaje propio: se muestra en cuanto se envía (optimista) y se sustituye
/// por el que guardó el servidor al recibir el `201`.
class MensajePropio {
  const MensajePropio({
    required this.idLocal,
    required this.texto,
    required this.estado,
    this.guardado,
    this.falla,
    this.salio = true,
  });

  final int idLocal;

  /// Lo que escribió la persona; se conserva si el envío falla.
  final String texto;
  final EstadoDeEnvio estado;

  /// El mensaje del servidor (con el contacto oculto si lo traía).
  final Mensaje? guardado;
  final Failure? falla;

  /// `false` si la petición nunca llegó a salir: no puede estar en el
  /// historial, así que nunca se busca ahí.
  final bool salio;

  /// Texto que se muestra: el del servidor en cuanto existe.
  String get textoVisible => guardado?.texto ?? texto;
  bool get contactoOculto => guardado?.contactoOculto ?? false;
}

class EstadoEnvioMensajes {
  const EstadoEnvioMensajes({
    this.mensajes = const [],
    this.cerrada = false,
    this.enviando = false,
  });

  final List<MensajePropio> mensajes;

  /// La conversación está cerrada (por su estado o por un `409
  /// conversation_closed`): se puede leer, pero no escribir.
  final bool cerrada;

  /// Hay un envío esperando respuesta: no se manda otro a la vez.
  final bool enviando;

  /// La última falla, para mostrar su texto junto al campo.
  Failure? get ultimaFalla {
    for (final m in mensajes.reversed) {
      if (m.estado == EstadoDeEnvio.fallido) return m.falla;
    }
    return null;
  }
}

/// Envía mensajes de una conversación (spec 020, enmienda 2026-11-26).
///
/// El envío no es idempotente: una falla deja el mensaje como fallido con su
/// texto y **solo** se vuelve a intentar con [reintentar] (CA-E02). Los
/// mensajes viven en memoria y nunca se registran (CA-E03).
class EnvioMensajesController extends ChangeNotifier {
  EnvioMensajesController(
    this._envio,
    this.conversacionId, {
    bool cerrada = false,
    this.alGuardar,
    this.yaLlego,
  }) : estado = EstadoEnvioMensajes(cerrada: cerrada);

  /// Se llama con cada mensaje que el servidor confirmó con `201`.
  final void Function(Mensaje guardado)? alGuardar;

  /// Se pregunta antes de reenviar un mensaje del que no se supo si llegó
  /// (spec 047, CA-07): `true` si el servidor ya lo tiene, `false` si no y
  /// `null` si todavía no responde.
  final Future<bool?> Function(String texto)? yaLlego;

  final EnvioDeMensajes _envio;
  final String conversacionId;
  EstadoEnvioMensajes estado;
  int _siguienteId = 0;
  bool _disposed = false;

  /// Revisa [texto] y, si se puede, lo envía. Devuelve el motivo si no cumple
  /// la regla del servidor (no sale a la red), o `null` si se aceptó o si la
  /// conversación está cerrada u ocupada (en ese caso no hace nada).
  Future<MotivoTextoInvalido?> enviar(String texto) async {
    final motivo = TextoDeMensaje.validar(texto);
    if (motivo != null) return motivo;
    if (estado.cerrada || estado.enviando) return null;
    final preparado = TextoDeMensaje.preparar(texto);
    if (yaLlego != null && estado.mensajes.any(_sinRespuesta)) {
      _publicar(enviando: true);
      final limpiezas = _limpiezas;
      final conciliado = await _conciliar();
      // Una limpieza mientras se esperaba descarta también lo escrito.
      if (_disposed || limpiezas != _limpiezas) return null;
      if (conciliado == null) {
        // Sin saber qué llegó no sale nada; lo escrito se conserva.
        _publicar(
          mensajes: [
            ...estado.mensajes,
            MensajePropio(
              idLocal: _siguienteId++,
              texto: preparado,
              estado: EstadoDeEnvio.fallido,
              falla: const ServicioNoDisponibleFailure(),
              salio: false,
            ),
          ],
          enviando: false,
        );
        return null;
      }
      // Era el mismo texto que sí había llegado: no se manda otra vez.
      if (conciliado.contains(preparado)) {
        _publicar(enviando: false);
        return null;
      }
    }
    final propio = MensajePropio(
      idLocal: _siguienteId++,
      texto: preparado,
      estado: EstadoDeEnvio.pendiente,
    );
    _publicar(mensajes: [...estado.mensajes, propio], enviando: true);
    await _mandar(propio);
    return null;
  }

  /// Vuelve a enviar un mensaje fallido. Solo por acción de la persona.
  Future<void> reintentar(int idLocal) async {
    if (estado.cerrada || estado.enviando) return;
    final actual = _buscar(idLocal);
    if (actual == null || actual.estado != EstadoDeEnvio.fallido) return;
    final pendiente = MensajePropio(
      idLocal: idLocal,
      texto: actual.texto,
      estado: EstadoDeEnvio.pendiente,
    );
    _reemplazar(pendiente, enviando: true);
    final comprobar = yaLlego;
    if (comprobar != null && (_sinRespuesta(actual) || !actual.salio)) {
      final limpiezas = _limpiezas;
      // Del que salió se pregunta si llegó. Del que nunca salió no: se
      // concilian los demás antes de mandarlo.
      final bool? yaEsta = actual.salio
          ? await comprobar(pendiente.texto)
          : (await _conciliar())?.contains(pendiente.texto);
      if (_disposed || limpiezas != _limpiezas) return;
      if (yaEsta == null) {
        // Sin respuesta del servidor no se manda: podría duplicarse.
        _reemplazar(actual, enviando: false);
        return;
      }
      if (yaEsta) {
        _publicar(
          mensajes: [
            for (final m in estado.mensajes)
              if (m.idLocal != idLocal) m,
          ],
          enviando: false,
        );
        return;
      }
    }
    await _mandar(pendiente);
  }

  /// Quita un mensaje fallido que la persona ya no quiere enviar.
  void descartar(int idLocal) {
    final actual = _buscar(idLocal);
    if (actual == null || actual.estado != EstadoDeEnvio.fallido) return;
    _publicar(
      mensajes: [
        for (final m in estado.mensajes)
          if (m.idLocal != idLocal) m,
      ],
    );
  }

  /// No se sabe si el servidor lo guardó: sin respuesta o respuesta ilegible.
  static bool _sinRespuesta(MensajePropio m) =>
      m.salio &&
      m.estado == EstadoDeEnvio.fallido &&
      (m.falla is ServicioNoDisponibleFailure ||
          m.falla is DatosInvalidosFailure);

  /// Pregunta por cada envío sin respuesta y quita los que sí llegaron.
  /// Devuelve sus textos, o `null` si el servidor todavía no responde.
  Future<Set<String>?> _conciliar() async {
    final llegados = <String>{};
    for (final m in estado.mensajes.where(_sinRespuesta).toList()) {
      final llego = await yaLlego!(m.texto);
      if (_disposed || llego == null) return null;
      if (llego) {
        llegados.add(m.texto);
        _publicar(
          mensajes: [
            for (final otro in estado.mensajes)
              if (otro.idLocal != m.idLocal) otro,
          ],
        );
      }
    }
    return llegados;
  }

  int _limpiezas = 0;

  /// Borra todo lo escrito (cierre de sesión, spec 047 CA-16).
  void limpiar() {
    _limpiezas++;
    _publicar(mensajes: const [], enviando: false);
  }

  /// La conversación se cerró (por ejemplo, la pantalla leyó su estado).
  void marcarCerrada() => _publicar(cerrada: true);

  Future<void> _mandar(MensajePropio propio) async {
    try {
      final guardado = await _envio.enviar(conversacionId, propio.texto);
      if (_disposed) return;
      _reemplazar(
        MensajePropio(
          idLocal: propio.idLocal,
          texto: propio.texto,
          estado: EstadoDeEnvio.enviado,
          guardado: guardado,
        ),
        enviando: false,
      );
      alGuardar?.call(guardado);
    } on Failure catch (falla) {
      if (_disposed) return;
      _reemplazar(
        MensajePropio(
          idLocal: propio.idLocal,
          texto: propio.texto,
          estado: EstadoDeEnvio.fallido,
          falla: falla,
        ),
        enviando: false,
        // 409 en esta ruta solo es `conversation_closed`.
        cerrada: falla is ConflictoFailure ? true : null,
      );
    } on Exception {
      if (_disposed) return;
      _reemplazar(
        MensajePropio(
          idLocal: propio.idLocal,
          texto: propio.texto,
          estado: EstadoDeEnvio.fallido,
          falla: const ServicioNoDisponibleFailure(),
        ),
        enviando: false,
      );
    }
  }

  MensajePropio? _buscar(int idLocal) {
    for (final m in estado.mensajes) {
      if (m.idLocal == idLocal) return m;
    }
    return null;
  }

  void _reemplazar(MensajePropio nuevo, {bool? enviando, bool? cerrada}) =>
      _publicar(
        mensajes: [
          for (final m in estado.mensajes)
            m.idLocal == nuevo.idLocal ? nuevo : m,
        ],
        enviando: enviando,
        cerrada: cerrada,
      );

  void _publicar({
    List<MensajePropio>? mensajes,
    bool? enviando,
    bool? cerrada,
  }) {
    if (_disposed) return;
    estado = EstadoEnvioMensajes(
      mensajes: List.unmodifiable(mensajes ?? estado.mensajes),
      enviando: enviando ?? estado.enviando,
      cerrada: cerrada ?? estado.cerrada,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
