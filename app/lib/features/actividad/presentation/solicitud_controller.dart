import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/borrador_solicitud.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/features/actividad/domain/validacion_solicitud.dart';
import 'package:app/features/oficios/oficios.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Pasos del formulario (R-01).
enum PasoSolicitud { oficio, descripcion, cuandoDonde }

/// Estado del formulario «Pedir cotización» (spec 015).
@immutable
final class FormularioSolicitud {
  const FormularioSolicitud({
    this.paso = PasoSolicitud.oficio,
    this.cargando = true,
    this.oficios = const [],
    this.errorOficios,
    this.oficio,
    this.descripcion = '',
    this.fotos = const [],
    this.dia,
    this.franja,
    this.direccion = '',
    this.mostrarErrores = false,
    this.agregandoFoto = false,
    this.errorFoto,
    this.enviando = false,
    this.error,
    this.esperaHasta,
    this.sinZona = false,
    this.creada,
  });

  final PasoSolicitud paso;

  /// Mientras se leen el borrador y el catálogo de oficios.
  final bool cargando;
  final List<Oficio> oficios;
  final Failure? errorOficios;
  final Oficio? oficio;
  final String descripcion;

  /// Rutas de las copias privadas de las fotos.
  final List<String> fotos;
  final DateTime? dia;
  final Franja? franja;

  /// Solo en memoria: nunca va al borrador (D-06).
  final String direccion;

  /// Si la persona ya intentó avanzar y hay que mostrar los errores en línea.
  final bool mostrarErrores;
  final bool agregandoFoto;
  final Failure? errorFoto;
  final bool enviando;

  /// Error del último envío (mensaje de §7).
  final Failure? error;

  /// Hasta cuándo no se puede volver a enviar por un 429 (CA-15).
  final DateTime? esperaHasta;

  /// No hay zona guardada: no se puede enviar (R-05).
  final bool sinZona;

  /// La solicitud creada; la pantalla abre su detalle (CA-01).
  final Solicitud? creada;

  bool get esTaller => oficio?.modalidad.esTaller ?? false;

  ErrorDeLargo? get errorDescripcion => validarDescripcion(descripcion);

  ErrorDeFotos? get errorFotos => validarCantidadDeFotos(fotos.length);

  /// La dirección solo se pide a domicilio (CA-05 y CA-17).
  ErrorDeLargo? get errorDireccion =>
      esTaller ? null : validarDireccion(direccion);

  bool get faltaDiaOFranja => dia == null || franja == null;

  bool get pasoDescripcionValido =>
      errorDescripcion == null && errorFotos == null;

  bool get pasoCuandoDondeValido => !faltaDiaOFranja && errorDireccion == null;

  bool get esperando => esperaHasta != null;

  FormularioSolicitud copiar({
    PasoSolicitud? paso,
    bool? cargando,
    List<Oficio>? oficios,
    Failure? Function()? errorOficios,
    Oficio? Function()? oficio,
    String? descripcion,
    List<String>? fotos,
    DateTime? Function()? dia,
    Franja? Function()? franja,
    String? direccion,
    bool? mostrarErrores,
    bool? agregandoFoto,
    Failure? Function()? errorFoto,
    bool? enviando,
    Failure? Function()? error,
    DateTime? Function()? esperaHasta,
    bool? sinZona,
    Solicitud? Function()? creada,
  }) => FormularioSolicitud(
    paso: paso ?? this.paso,
    cargando: cargando ?? this.cargando,
    oficios: oficios ?? this.oficios,
    errorOficios: errorOficios == null ? this.errorOficios : errorOficios(),
    oficio: oficio == null ? this.oficio : oficio(),
    descripcion: descripcion ?? this.descripcion,
    fotos: fotos ?? this.fotos,
    dia: dia == null ? this.dia : dia(),
    franja: franja == null ? this.franja : franja(),
    direccion: direccion ?? this.direccion,
    mostrarErrores: mostrarErrores ?? this.mostrarErrores,
    agregandoFoto: agregandoFoto ?? this.agregandoFoto,
    errorFoto: errorFoto == null ? this.errorFoto : errorFoto(),
    enviando: enviando ?? this.enviando,
    error: error == null ? this.error : error(),
    esperaHasta: esperaHasta == null ? this.esperaHasta : esperaHasta(),
    sinZona: sinZona ?? this.sinZona,
    creada: creada == null ? this.creada : creada(),
  );
}

/// Espera por omisión si un 429 no trae `Retry-After`.
const esperaPorOmision = Duration(seconds: 30);

/// Controla el formulario: pasos, borrador, fotos y envío (spec 015).
class SolicitudController extends Notifier<FormularioSolicitud> {
  /// `Idempotency-Key` de la operación en curso (R-06). Se conserva mientras
  /// no haya respuesta definitiva y se descarta si cambia el contenido: con
  /// otro cuerpo la misma clave daría `idempotency_key_conflicto`.
  String? _clave;

  /// `archivoId` de cada foto ya subida, para no subirla otra vez al
  /// reintentar.
  final _subidas = <String, String>{};
  Timer? _temporizador;

  @override
  FormularioSolicitud build() {
    ref.onDispose(() => _temporizador?.cancel());
    return const FormularioSolicitud();
  }

  /// Lee el catálogo y el borrador. Con [oficioClave] (se llega desde un
  /// oficio) el paso 1 se salta (CA-24).
  Future<void> iniciar({String? oficioClave}) async {
    final borrador = await ref.read(borradorSolicitudRepositoryProvider).leer();
    List<Oficio> oficios;
    try {
      oficios = await ref.read(oficiosRepositoryProvider).listar();
    } on Failure catch (falla) {
      state = state.copiar(cargando: false, errorOficios: () => falla);
      return;
    }
    final clave = oficioClave ?? borrador?.oficioClave;
    final oficio = oficios.where((o) => o.clave == clave).firstOrNull;
    final hoy = _hoy();
    final dia = borrador?.dia;
    state = state.copiar(
      cargando: false,
      oficios: oficios,
      errorOficios: () => null,
      oficio: () => oficio,
      paso: oficio == null ? PasoSolicitud.oficio : PasoSolicitud.descripcion,
      descripcion: borrador?.descripcion ?? '',
      fotos: borrador?.rutasDeFotos ?? const [],
      // Un día del borrador que ya pasó no se recupera (CA-04).
      dia: () => dia != null && esDiaPermitido(dia, hoy) ? dia : null,
      franja: () => borrador?.franja,
    );
  }

  /// Vuelve a pedir el catálogo tras un error.
  Future<void> reintentarOficios() async {
    state = state.copiar(cargando: true, errorOficios: () => null);
    await iniciar();
  }

  DateTime _hoy() => soloFecha(ref.read(relojSolicitudProvider)());

  /// Los seis días que se ofrecen (CA-04).
  List<DateTime> get diasOfrecidos => diasPermitidos(_hoy());

  void elegirOficio(Oficio oficio) {
    _cambio(
      state.copiar(
        oficio: () => oficio,
        paso: PasoSolicitud.descripcion,
        mostrarErrores: false,
      ),
    );
  }

  void cambiarDescripcion(String texto) =>
      _cambio(state.copiar(descripcion: texto));

  void elegirDia(DateTime dia) {
    if (!esDiaPermitido(dia, _hoy())) return;
    _cambio(state.copiar(dia: () => soloFecha(dia)));
  }

  void elegirFranja(Franja franja) =>
      _cambio(state.copiar(franja: () => franja));

  /// La dirección no se guarda en el borrador (D-06).
  void cambiarDireccion(String texto) {
    _clave = null;
    state = state.copiar(direccion: texto, error: () => null);
  }

  Future<void> tomarFoto() => _agregarFotos(() async {
    final bytes = await ref.read(fuenteDeFotosProvider).tomarConCamara();
    return bytes == null ? const [] : [bytes];
  });

  Future<void> elegirFotos() => _agregarFotos(
    () => ref
        .read(fuenteDeFotosProvider)
        .elegirDeGaleria(maximoFotos - state.fotos.length),
  );

  Future<void> _agregarFotos(Future<List<List<int>>> Function() obtener) async {
    if (!puedeAgregarFoto(state.fotos.length) || state.agregandoFoto) return;
    state = state.copiar(agregandoFoto: true, errorFoto: () => null);
    Failure? falla;
    final nuevas = <String>[];
    try {
      final originales = await obtener();
      final repositorio = ref.read(borradorSolicitudRepositoryProvider);
      for (final bytes in originales) {
        if (!puedeAgregarFoto(state.fotos.length + nuevas.length)) break;
        try {
          nuevas.add(await repositorio.agregarFoto(bytes));
        } on Failure catch (rechazo) {
          falla = rechazo;
        }
      }
    } on Object {
      // La cámara o el selector fallaron: no se agrega nada.
      falla = const FotoNoValidaFailure();
    }
    _cambio(
      state.copiar(
        agregandoFoto: false,
        fotos: [...state.fotos, ...nuevas],
        errorFoto: () => falla,
      ),
    );
  }

  Future<void> quitarFoto(String ruta) async {
    _cambio(
      state.copiar(
        fotos: [...state.fotos]..remove(ruta),
        errorFoto: () => null,
      ),
    );
    _subidas.remove(ruta);
    await ref.read(borradorSolicitudRepositoryProvider).quitarFoto(ruta);
  }

  /// Pasa al siguiente paso si el actual es válido; si no, muestra los
  /// errores en línea (CA-02, CA-03).
  void avanzar() {
    final valido = switch (state.paso) {
      PasoSolicitud.oficio => state.oficio != null,
      PasoSolicitud.descripcion => state.pasoDescripcionValido,
      PasoSolicitud.cuandoDonde => state.pasoCuandoDondeValido,
    };
    if (!valido) {
      state = state.copiar(mostrarErrores: true);
      return;
    }
    if (state.paso == PasoSolicitud.cuandoDonde) return;
    state = state.copiar(
      paso: PasoSolicitud.values[state.paso.index + 1],
      mostrarErrores: false,
    );
  }

  void retroceder() {
    if (state.paso == PasoSolicitud.oficio) return;
    state = state.copiar(
      paso: PasoSolicitud.values[state.paso.index - 1],
      mostrarErrores: false,
    );
  }

  /// Envía la solicitud (CA-01). Un segundo toque mientras se envía no hace
  /// nada (CA-06); tras un 429 no se puede enviar hasta que pase la espera
  /// (CA-15); un error nunca se reintenta solo (CA-22).
  Future<void> enviar() async {
    if (state.enviando || state.esperando) return;
    if (state.oficio == null ||
        !state.pasoDescripcionValido ||
        !state.pasoCuandoDondeValido) {
      state = state.copiar(mostrarErrores: true);
      return;
    }
    final coloniaId = ref.read(coloniaGuardadaProvider);
    if (coloniaId == null) {
      state = state.copiar(sinZona: true);
      return;
    }
    final clave = _clave ??= ref.read(generadorDeClaveProvider)();
    state = state.copiar(enviando: true, error: () => null, sinZona: false);
    final repositorio = ref.read(solicitudRepositoryProvider);
    try {
      final archivoIds = <String>[];
      for (final ruta in state.fotos) {
        archivoIds.add(_subidas[ruta] ??= await repositorio.subirFoto(ruta));
      }
      final creada = await repositorio.crear(
        NuevaSolicitud(
          oficioClave: state.oficio!.clave,
          descripcion: state.descripcion.trim(),
          archivoIds: archivoIds,
          dia: state.dia!,
          franja: state.franja!,
          coloniaId: coloniaId,
          direccion: state.esTaller ? null : state.direccion.trim(),
        ),
        claveIdempotencia: clave,
      );
      _clave = null;
      _subidas.clear();
      await ref.read(borradorSolicitudRepositoryProvider).borrarTodo();
      state = state.copiar(enviando: false, creada: () => creada);
    } on Failure catch (falla) {
      _trasError(falla);
    }
  }

  void _trasError(Failure falla) {
    switch (falla) {
      case DemasiadosIntentosFailure(:final espera):
        final duracion = espera ?? esperaPorOmision;
        final hasta = ref.read(relojSolicitudProvider)().add(duracion);
        _temporizador?.cancel();
        _temporizador = Timer(duracion, () {
          state = state.copiar(esperaHasta: () => null);
        });
        state = state.copiar(
          enviando: false,
          error: () => falla,
          esperaHasta: () => hasta,
        );
      case ContenidoRechazadoFailure():
        // El texto se corrige en el paso 2; el borrador queda intacto.
        _clave = null;
        state = state.copiar(
          enviando: false,
          error: () => falla,
          paso: PasoSolicitud.descripcion,
        );
      case ServicioNoDisponibleFailure() || ModeracionNoDisponibleFailure():
        // Sin respuesta definitiva: un reintento manual repite la clave.
        state = state.copiar(enviando: false, error: () => falla);
      default:
        _clave = null;
        state = state.copiar(enviando: false, error: () => falla);
    }
  }

  /// Borra el borrador y sus fotos y deja el formulario vacío (CA-19).
  Future<void> descartar() async {
    _clave = null;
    _subidas.clear();
    await ref.read(borradorSolicitudRepositoryProvider).borrarTodo();
    state = FormularioSolicitud(
      cargando: false,
      oficios: state.oficios,
      errorOficios: state.errorOficios,
    );
  }

  /// Aplica un cambio del contenido: invalida la clave y guarda el borrador.
  void _cambio(FormularioSolicitud nuevo) {
    _clave = null;
    state = nuevo.copiar(error: () => null);
    unawaited(
      ref
          .read(borradorSolicitudRepositoryProvider)
          .guardar(
            BorradorSolicitud(
              oficioClave: nuevo.oficio?.clave,
              descripcion: nuevo.descripcion,
              rutasDeFotos: nuevo.fotos,
              dia: nuevo.dia,
              franja: nuevo.franja,
              actualizadoEn: ref.read(relojSolicitudProvider)().toUtc(),
            ),
          )
          .catchError((Object _) {}),
    );
  }
}

final solicitudControllerProvider =
    NotifierProvider.autoDispose<SolicitudController, FormularioSolicitud>(
      SolicitudController.new,
    );
