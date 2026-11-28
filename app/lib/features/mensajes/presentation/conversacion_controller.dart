import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:flutter/foundation.dart';

import '../domain/canal_mensajes.dart';
import '../domain/conversacion_abierta.dart';
import '../domain/envio_de_mensajes.dart';
import '../domain/mensaje.dart';
import 'envio_mensajes_controller.dart';

class EstadoDeConversacion {
  const EstadoDeConversacion({
    this.detalle,
    this.mensajes = const [],
    this.siguiente,
    this.cargando = false,
    this.cargandoAnteriores = false,
    this.falla,
    this.fallaDeAnteriores,
    this.enVivo = false,
    this.sinCanal = false,
  });

  final DetalleDeConversacion? detalle;

  /// Del más antiguo (primero) al más reciente (último), sin repetidos.
  final List<Mensaje> mensajes;
  final String? siguiente;
  final bool cargando;
  final bool cargandoAnteriores;

  /// Por qué no se pudo cargar la conversación.
  final Failure? falla;
  final Failure? fallaDeAnteriores;
  final bool enVivo;

  /// El canal no está disponible: se ofrece «Actualizar» (CA-12).
  final bool sinCanal;

  EstadoDeConversacion copia({
    DetalleDeConversacion? detalle,
    List<Mensaje>? mensajes,
    String? Function()? siguiente,
    bool? cargando,
    bool? cargandoAnteriores,
    Failure? Function()? falla,
    Failure? Function()? fallaDeAnteriores,
    bool? enVivo,
    bool? sinCanal,
  }) => EstadoDeConversacion(
    detalle: detalle ?? this.detalle,
    mensajes: mensajes ?? this.mensajes,
    siguiente: siguiente == null ? this.siguiente : siguiente(),
    cargando: cargando ?? this.cargando,
    cargandoAnteriores: cargandoAnteriores ?? this.cargandoAnteriores,
    falla: falla == null ? this.falla : falla(),
    fallaDeAnteriores: fallaDeAnteriores == null
        ? this.fallaDeAnteriores
        : fallaDeAnteriores(),
    enVivo: enVivo ?? this.enVivo,
    sinCanal: sinCanal ?? this.sinCanal,
  );
}

/// Avisa qué texto se va a enviar antes de mandarlo.
class _EnvioConHuella implements EnvioDeMensajes {
  const _EnvioConHuella(this._interno, this._antesDeEnviar);

  final EnvioDeMensajes _interno;
  final void Function(String texto) _antesDeEnviar;

  @override
  Future<Mensaje> enviar(String conversacionId, String texto) {
    _antesDeEnviar(texto);
    return _interno.enviar(conversacionId, texto);
  }
}

/// Una conversación abierta (spec 047). Todo vive en memoria: nada se guarda ni
/// se registra (CA-16).
class ConversacionController extends ChangeNotifier {
  ConversacionController({
    required this.conversacionId,
    required this._lectura,
    required EnvioDeMensajes envio,
    required this._canal,
    this.alMarcarLeido,
  }) {
    this.envio = EnvioMensajesController(
      _EnvioConHuella(envio, _recordarPropios),
      conversacionId,
      alGuardar: _agregar,
      yaLlego: _yaLlego,
    )..addListener(_alCambiarEnvio);
    _suscripcion = _canal.mensajesEnVivo.listen((evento) {
      if (evento.conversacionId == conversacionId) _agregar(evento.mensaje);
    });
  }

  final String conversacionId;
  final LecturaDeConversacion _lectura;
  final CanalMensajes _canal;

  /// El servidor aceptó la marca de leído: el globo debe volver a preguntar.
  final VoidCallback? alMarcarLeido;

  late final EnvioMensajesController envio;
  late final StreamSubscription<MensajeEnVivo> _suscripcion;
  EstadoDeConversacion estado = const EstadoDeConversacion(cargando: true);
  DateTime? _leidoHasta;
  bool _marcando = false;
  bool _estuvoEnVivo = false;
  int _generacion = 0;
  bool _disposed = false;

  /// Por cada texto enviado, los mensajes propios que ya existían al enviarlo:
  /// así uno anterior con el mismo texto no cuenta como entregado (CA-07).
  final _propiosAlEnviar = <String, Set<String>>{};

  Future<void> cargar() async {
    final generacion = ++_generacion;
    _publicar(estado.copia(cargando: true, falla: () => null));
    try {
      final detalle = await _lectura.detalle(conversacionId);
      final pagina = await _lectura.mensajes(conversacionId);
      if (!_vigente(generacion)) return;
      _publicar(
        estado.copia(
          detalle: detalle,
          mensajes: _unir(const [], pagina.items),
          siguiente: () => pagina.siguiente,
          cargando: false,
        ),
      );
      if (detalle.cerrada) envio.marcarCerrada();
      unawaited(_marcarLeido());
    } on NoAutorizadoFailure {
      if (_vigente(generacion)) limpiar();
    } on Failure catch (falla) {
      if (_vigente(generacion)) {
        _publicar(estado.copia(cargando: false, falla: () => falla));
      }
    }
  }

  /// Relee el estado y la primera página («Actualizar», reconexión y CA-07).
  /// Devuelve la primera página, o `null` si el servidor no respondió.
  Future<List<Mensaje>?> releer() async {
    final generacion = _generacion;
    try {
      final detalle = await _lectura.detalle(conversacionId);
      final pagina = await _lectura.mensajes(conversacionId);
      if (!_vigente(generacion)) return null;
      final conocidos = {for (final m in estado.mensajes) m.id};
      final enlaza = pagina.items.any((m) => conocidos.contains(m.id));
      // Si la página no toca lo que había y quedan más, hay mensajes en medio:
      // se empieza de nuevo desde ella para no dejar un hueco.
      final hueco = !enlaza && pagina.siguiente != null;
      _publicar(
        estado.copia(
          detalle: detalle,
          mensajes: _unir(hueco ? const [] : estado.mensajes, pagina.items),
          // Si enlaza con lo anterior, se conserva el cursor que ya había.
          siguiente: hueco || conocidos.isEmpty ? () => pagina.siguiente : null,
          falla: () => null,
        ),
      );
      if (detalle.cerrada) envio.marcarCerrada();
      unawaited(_marcarLeido());
      return pagina.items;
    } on NoAutorizadoFailure {
      if (_vigente(generacion)) limpiar();
    } on NoEncontradoFailure catch (falla) {
      if (_vigente(generacion)) {
        _publicar(estado.copia(falla: () => falla));
      }
    } on Failure {
      // Se conserva lo que hay en pantalla.
    }
    return null;
  }

  void _recordarPropios(String texto) {
    final rol = estado.detalle?.rol;
    _propiosAlEnviar[texto] = {
      for (final m in estado.mensajes)
        if (m.autorRol == rol) m.id,
    };
  }

  Future<bool?> _yaLlego(String texto) async {
    final recientes = await releer();
    if (recientes == null) return null;
    final antes = _propiosAlEnviar[texto] ?? const <String>{};
    // Si el servidor ocultó un contacto, el texto guardado ya no es idéntico.
    return recientes.any(
      (m) =>
          m.autorRol == estado.detalle?.rol &&
          !antes.contains(m.id) &&
          (m.texto == texto || m.contactoOculto),
    );
  }

  /// La página anterior del historial (CA-04).
  Future<void> cargarAnteriores() async {
    final cursor = estado.siguiente;
    if (_disposed || cursor == null || estado.cargandoAnteriores) return;
    final generacion = _generacion;
    _publicar(
      estado.copia(cargandoAnteriores: true, fallaDeAnteriores: () => null),
    );
    try {
      final pagina = await _lectura.mensajes(conversacionId, cursor: cursor);
      if (!_vigente(generacion)) return;
      _publicar(
        estado.copia(
          mensajes: _unir(estado.mensajes, pagina.items),
          siguiente: () => pagina.siguiente,
          cargandoAnteriores: false,
        ),
      );
    } on NoAutorizadoFailure {
      if (_vigente(generacion)) limpiar();
    } on Failure catch (falla) {
      if (_vigente(generacion)) {
        _publicar(
          estado.copia(
            cargandoAnteriores: false,
            fallaDeAnteriores: () => falla,
          ),
        );
      }
    }
  }

  /// El canal abrió: se une a la conversación y, si es una reconexión, relee
  /// la primera página (CA-11).
  Future<void> canalConectado() async {
    final unido = await _canal.unirse(conversacionId);
    if (_disposed) return;
    final reconexion = unido && _estuvoEnVivo;
    if (unido) _estuvoEnVivo = true;
    _publicar(estado.copia(enVivo: unido, sinCanal: !unido));
    if (reconexion) await releer();
  }

  void canalCaido() => _publicar(estado.copia(enVivo: false, sinCanal: true));

  /// Al cerrar la sesión no queda nada en memoria (CA-16).
  void limpiar() {
    _generacion++;
    _leidoHasta = null;
    _publicar(const EstadoDeConversacion(falla: NoAutorizadoFailure()));
  }

  bool _vigente(int generacion) => !_disposed && generacion == _generacion;

  void _agregar(Mensaje mensaje) {
    if (_disposed || estado.detalle == null) return;
    if (estado.mensajes.any((m) => m.id == mensaje.id)) return;
    _publicar(estado.copia(mensajes: _unir(estado.mensajes, [mensaje])));
    unawaited(_marcarLeido());
  }

  static List<Mensaje> _unir(List<Mensaje> actuales, List<Mensaje> nuevos) {
    final porId = {for (final m in actuales) m.id: m};
    for (final m in nuevos) {
      porId[m.id] = m;
    }
    return List.unmodifiable(
      porId.values.toList()..sort((a, b) {
        final porFecha = a.enviadoEn.compareTo(b.enviadoEn);
        return porFecha != 0 ? porFecha : a.id.compareTo(b.id);
      }),
    );
  }

  /// Marca leído hasta el último mensaje mostrado (CA-10). Sin mensajes no
  /// llama; si falla, no se inventa el contador y se intenta con el siguiente.
  Future<void> _marcarLeido() async {
    if (_disposed || _marcando || estado.mensajes.isEmpty) return;
    final hasta = estado.mensajes.last.enviadoEn;
    final ya = _leidoHasta;
    if (ya != null && !hasta.isAfter(ya)) return;
    _marcando = true;
    var marcado = false;
    try {
      await _lectura.marcarLeido(conversacionId, hasta);
      marcado = true;
    } on Failure {
      // El globo se queda con lo que diga el servidor.
    } finally {
      _marcando = false;
    }
    if (!marcado || _disposed) return;
    _leidoHasta = hasta;
    alMarcarLeido?.call();
    unawaited(_marcarLeido());
  }

  /// Un `409 conversation_closed` al enviar: se vuelve a leer para mostrar el
  /// motivo del cierre (CA-09).
  void _alCambiarEnvio() {
    final detalle = estado.detalle;
    if (envio.estado.cerrada && detalle != null && !detalle.cerrada) {
      unawaited(releer());
    }
    if (!_disposed) notifyListeners();
  }

  void _publicar(EstadoDeConversacion nuevo) {
    if (_disposed) return;
    estado = nuevo;
    notifyListeners();
  }

  @override
  void dispose() {
    _generacion++;
    _disposed = true;
    unawaited(_suscripcion.cancel());
    unawaited(_canal.salir(conversacionId));
    envio
      ..removeListener(_alCambiarEnvio)
      ..dispose();
    super.dispose();
  }
}
