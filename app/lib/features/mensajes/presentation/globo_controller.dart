import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/mensajes/mensajes_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Contador del globo y estado del canal, solo en memoria.
class EstadoGlobo {
  const EstadoGlobo({
    this.total,
    this.conectado = false,
    this.sinConexion = false,
  });

  /// Último total de no leídos que dio el servidor; `null` si no hay ninguno.
  final int? total;
  final bool conectado;

  /// El canal no abrió o se cayó: [total] queda congelado (spec 020, CA-14).
  final bool sinConexion;
}

/// Esperas entre reconexiones. Al agotarse solo queda «Reintentar».
final esperasDeReconexionProvider = Provider<List<Duration>>(
  (ref) => const [
    Duration(seconds: 2),
    Duration(seconds: 10),
    Duration(seconds: 30),
  ],
);

/// Una conexión que dura esto recupera todos sus reintentos; así una que abre
/// y se cae enseguida no se reconecta en bucle.
const Duration conexionEstable = Duration(minutes: 1);

class GloboController extends Notifier<EstadoGlobo> {
  Timer? _reintento;
  Timer? _estable;
  int _intentos = 0;
  int _generacion = 0;

  @override
  EstadoGlobo build() {
    final conSesion = ref.watch(sesionProvider.select((t) => t != null));
    final canal = ref.watch(canalMensajesProvider);
    _intentos = 0;
    ref.onDispose(() {
      _generacion++;
      _cancelarEsperas();
      unawaited(canal.cerrar());
    });
    if (conSesion) unawaited(Future.microtask(_conectar));
    return const EstadoGlobo();
  }

  /// «Reintentar»: vuelve a pedir el contador y a abrir el canal.
  Future<void> reintentar() {
    _intentos = 0;
    return _conectar();
  }

  /// Vuelve a pedir el contador; sin canal, también intenta abrirlo.
  Future<void> actualizar() async {
    if (!state.conectado) return reintentar();
    final generacion = _generacion;
    try {
      final total = await ref.read(conversacionesRepositoryProvider).contador();
      if (generacion == _generacion && state.conectado) {
        state = EstadoGlobo(total: total, conectado: true);
      }
    } on Exception {
      // Se conserva el último valor; el canal avisará el siguiente cambio.
    }
  }

  Future<void> _conectar() async {
    if (!ref.mounted || ref.read(sesionProvider) == null) return;
    final generacion = ++_generacion;
    _cancelarEsperas();
    final repositorio = ref.read(conversacionesRepositoryProvider);
    final canal = ref.read(canalMensajesProvider);
    try {
      // Primero la consulta: renueva el token vencido antes de abrir el canal.
      final antes = await repositorio.contador();
      if (generacion != _generacion) return;
      state = EstadoGlobo(total: antes, sinConexion: state.sinConexion);
      await canal.abrir(
        alCambiarContador: (total) {
          if (generacion != _generacion) return;
          state = EstadoGlobo(total: total, conectado: true);
        },
        alCaerse: () => _perdido(generacion),
      );
      if (generacion != _generacion) return;
      state = EstadoGlobo(total: state.total, conectado: true);
      _estable = Timer(conexionEstable, () => _intentos = 0);
      // Recoge lo que haya cambiado mientras se abría el canal.
      await actualizar();
    } on NoAutorizadoFailure {
      if (generacion == _generacion) state = const EstadoGlobo();
    } on DemasiadosIntentosFailure catch (error) {
      _perdido(generacion, minimo: error.espera);
    } on Object {
      // El paquete del canal también lanza errores que no son `Exception`.
      _perdido(generacion);
    }
  }

  void _perdido(int generacion, {Duration? minimo}) {
    if (generacion != _generacion) return;
    _cancelarEsperas();
    state = EstadoGlobo(total: state.total, sinConexion: true);
    final esperas = ref.read(esperasDeReconexionProvider);
    if (_intentos >= esperas.length) return;
    var espera = esperas[_intentos++];
    if (minimo != null && minimo > espera) espera = minimo;
    _reintento = Timer(espera, () => unawaited(_conectar()));
  }

  void _cancelarEsperas() {
    _reintento?.cancel();
    _estable?.cancel();
  }
}

final globoProvider = NotifierProvider<GloboController, EstadoGlobo>(
  GloboController.new,
);
