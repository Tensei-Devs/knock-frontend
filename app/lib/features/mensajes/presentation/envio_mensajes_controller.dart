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
  });

  final int idLocal;

  /// Lo que escribió la persona; se conserva si el envío falla.
  final String texto;
  final EstadoDeEnvio estado;

  /// El mensaje del servidor (con el contacto oculto si lo traía).
  final Mensaje? guardado;
  final Failure? falla;

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
  }) : estado = EstadoEnvioMensajes(cerrada: cerrada);

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
    final propio = MensajePropio(
      idLocal: _siguienteId++,
      texto: TextoDeMensaje.preparar(texto),
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
