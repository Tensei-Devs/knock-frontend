import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/borrador_solicitud.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/features/actividad/domain/validacion_solicitud.dart';
import 'package:app/features/oficios/oficios.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _sin = Object();

/// Estado del formulario de tres pasos (spec 015, R-01). Inmutable.
final class EstadoSolicitudForm {
  const EstadoSolicitudForm({
    this.paso = 0,
    this.oficio,
    this.descripcion = '',
    this.rutasDeFotos = const [],
    this.dia,
    this.franja,
    this.direccion = '',
    this.mostrarErrores = false,
    this.errorFotos,
    this.enviando = false,
    this.espera,
    this.error,
    this.sinZona = false,
    this.creada,
  });

  /// Paso actual: 0 oficio, 1 descripción y fotos, 2 cuándo y dónde.
  final int paso;
  final Oficio? oficio;
  final String descripcion;
  final List<String> rutasDeFotos;
  final DateTime? dia;
  final Franja? franja;
  final String direccion;

  /// Se activa al intentar avanzar con algo inválido: muestra los errores.
  final bool mostrarErrores;
  final ErrorFotos? errorFotos;
  final bool enviando;

  /// Tiempo que la API pidió esperar tras un 429; mientras exista, no se envía.
  final Duration? espera;
  final Failure? error;
  final bool sinZona;
  final Solicitud? creada;

  bool get esDomicilio => oficio?.modalidad.esDomicilio ?? false;

  EstadoSolicitudForm copyWith({
    int? paso,
    Object? oficio = _sin,
    String? descripcion,
    List<String>? rutasDeFotos,
    Object? dia = _sin,
    Object? franja = _sin,
    String? direccion,
    bool? mostrarErrores,
    Object? errorFotos = _sin,
    bool? enviando,
    Object? espera = _sin,
    Object? error = _sin,
    bool? sinZona,
    Object? creada = _sin,
  }) => EstadoSolicitudForm(
    paso: paso ?? this.paso,
    oficio: identical(oficio, _sin) ? this.oficio : oficio as Oficio?,
    descripcion: descripcion ?? this.descripcion,
    rutasDeFotos: rutasDeFotos ?? this.rutasDeFotos,
    dia: identical(dia, _sin) ? this.dia : dia as DateTime?,
    franja: identical(franja, _sin) ? this.franja : franja as Franja?,
    direccion: direccion ?? this.direccion,
    mostrarErrores: mostrarErrores ?? this.mostrarErrores,
    errorFotos: identical(errorFotos, _sin)
        ? this.errorFotos
        : errorFotos as ErrorFotos?,
    enviando: enviando ?? this.enviando,
    espera: identical(espera, _sin) ? this.espera : espera as Duration?,
    error: identical(error, _sin) ? this.error : error as Failure?,
    sinZona: sinZona ?? this.sinZona,
    creada: identical(creada, _sin) ? this.creada : creada as Solicitud?,
  );
}

/// Controla el formulario: validación por paso, borrador local, envío sin
/// reintentos automáticos y espera del 429 (spec 015, R-01, R-06, R-07).
class SolicitudController extends Notifier<EstadoSolicitudForm> {
  Timer? _temporizador;

  @override
  EstadoSolicitudForm build() {
    ref.onDispose(() => _temporizador?.cancel());
    return const EstadoSolicitudForm();
  }

  /// Abre el formulario: recupera el borrador y, si llega un [oficioClave],
  /// deja el oficio elegido y salta el paso 1 (CA-24).
  Future<void> iniciar({String? oficioClave}) async {
    final borrador = ref.read(borradorRepositoryProvider).leer();
    List<Oficio> oficios = const [];
    try {
      oficios = await ref.read(oficiosParaSolicitudProvider.future);
    } on Object {
      // El paso 1 muestra el error de carga; aquí solo no hay oficio que fijar.
    }
    Oficio? buscar(String? clave) {
      for (final oficio in oficios) {
        if (oficio.clave == clave) return oficio;
      }
      return null;
    }

    final elegido = buscar(oficioClave) ?? buscar(borrador?.oficioClave);
    state = state.copyWith(
      oficio: elegido,
      paso: elegido == null ? 0 : 1,
      descripcion: borrador?.descripcion,
      rutasDeFotos: borrador?.rutasDeFotos,
      dia: borrador?.dia,
      franja: borrador?.franja,
    );
  }

  /// Vuelve el formulario a cero (al salir o tras enviar).
  void reiniciar() {
    _temporizador?.cancel();
    state = const EstadoSolicitudForm();
  }

  void elegirOficio(Oficio oficio) {
    state = state.copyWith(oficio: oficio, paso: 1, error: null);
    _guardarBorrador();
  }

  void cambiarDescripcion(String texto) {
    state = state.copyWith(descripcion: texto, error: null);
    _guardarBorrador();
  }

  void cambiarDireccion(String texto) {
    // La dirección no entra en el borrador (spec 015, D-06).
    state = state.copyWith(direccion: texto);
  }

  void elegirDia(DateTime dia) {
    if (!diaPermitido(dia, ref.read(hoyProvider))) return;
    state = state.copyWith(dia: DateTime(dia.year, dia.month, dia.day));
    _guardarBorrador();
  }

  void elegirFranja(Franja franja) {
    state = state.copyWith(franja: franja);
    _guardarBorrador();
  }

  /// Abre el selector y agrega la foto elegida; la sexta se rechaza (CA-03).
  Future<void> agregarFoto() async {
    if (!puedeAgregarFoto(state.rutasDeFotos.length)) {
      state = state.copyWith(errorFotos: ErrorFotos.maximo);
      return;
    }
    final ruta = await ref.read(selectorDeFotosProvider).elegir();
    if (ruta == null) return;
    state = state.copyWith(
      rutasDeFotos: [...state.rutasDeFotos, ruta],
      errorFotos: null,
    );
    _guardarBorrador();
  }

  void quitarFoto(int indice) {
    final fotos = [...state.rutasDeFotos]..removeAt(indice);
    state = state.copyWith(rutasDeFotos: fotos, errorFotos: null);
    _guardarBorrador();
  }

  void atras() {
    if (state.paso > 0) state = state.copyWith(paso: state.paso - 1);
  }

  /// Avanza si el paso actual es válido; si no, muestra sus errores.
  void siguiente() {
    final valido = switch (state.paso) {
      0 => state.oficio != null,
      1 => _paso2Valido(),
      _ => true,
    };
    if (!valido) {
      state = state.copyWith(mostrarErrores: true);
      return;
    }
    if (state.paso < 2) {
      state = state.copyWith(paso: state.paso + 1, mostrarErrores: false);
    }
  }

  bool _paso2Valido() =>
      validarDescripcion(state.descripcion) == null &&
      validarCantidadDeFotos(state.rutasDeFotos.length) == null;

  bool _paso3Valido() =>
      state.dia != null &&
      state.franja != null &&
      (!state.esDomicilio || validarDireccion(state.direccion) == null);

  /// Sube las fotos y crea la solicitud. Una sola operación a la vez y sin
  /// reintento automático (R-06, CA-06, CA-15, CA-22).
  Future<void> enviar() async {
    if (state.enviando || state.espera != null || state.creada != null) return;
    final oficio = state.oficio;
    if (oficio == null) {
      state = state.copyWith(paso: 0, mostrarErrores: true);
      return;
    }
    if (!_paso2Valido()) {
      state = state.copyWith(paso: 1, mostrarErrores: true);
      return;
    }
    if (!_paso3Valido()) {
      state = state.copyWith(paso: 2, mostrarErrores: true);
      return;
    }
    final colonia = ref.read(coloniaIdSolicitudProvider);
    if (colonia == null) {
      state = state.copyWith(sinZona: true);
      return;
    }

    state = state.copyWith(enviando: true, error: null, sinZona: false);
    final repositorio = ref.read(solicitudRepositoryProvider);
    try {
      final fotos = <String>[];
      for (final ruta in state.rutasDeFotos) {
        fotos.add(await repositorio.subirFoto(ruta));
      }
      final creada = await repositorio.crear(
        SolicitudNueva(
          oficioClave: oficio.clave,
          descripcion: state.descripcion.trim(),
          fotos: fotos,
          dia: state.dia!,
          franja: state.franja!,
          coloniaId: colonia,
          direccion: oficio.modalidad.esDomicilio
              ? state.direccion.trim()
              : null,
        ),
      );
      await _descartarBorrador();
      state = state.copyWith(enviando: false, creada: creada);
    } on DemasiadosIntentosFailure catch (falla) {
      final espera = falla.espera ?? const Duration(seconds: 30);
      state = state.copyWith(enviando: false, espera: espera, error: falla);
      _temporizador?.cancel();
      _temporizador = Timer(espera, () {
        state = state.copyWith(espera: null, error: null);
      });
    } on SolicitudRechazadaFailure catch (falla) {
      state = state.copyWith(
        enviando: false,
        error: falla,
        paso:
            falla.motivo == MotivoSolicitudRechazada.oficioOColoniaNoDisponible
            ? 0
            : 1,
      );
    } on Failure catch (falla) {
      state = state.copyWith(enviando: false, error: falla);
    } on Object {
      state = state.copyWith(
        enviando: false,
        error: const ServicioNoDisponibleFailure(),
      );
    }
  }

  void _guardarBorrador() {
    final s = state;
    unawaited(() async {
      try {
        await ref
            .read(borradorRepositoryProvider)
            .guardar(
              BorradorSolicitud(
                oficioClave: s.oficio?.clave,
                descripcion: s.descripcion,
                rutasDeFotos: s.rutasDeFotos,
                dia: s.dia,
                franja: s.franja,
                actualizadoEn: DateTime.now().toUtc(),
              ),
            );
      } on Object {
        return; // Un fallo al guardar el borrador no frena al formulario.
      }
    }());
  }

  Future<void> _descartarBorrador() async {
    try {
      await ref.read(borradorRepositoryProvider).descartar();
    } on Object {
      return;
    }
  }
}

final solicitudControllerProvider =
    NotifierProvider<SolicitudController, EstadoSolicitudForm>(
      SolicitudController.new,
    );
