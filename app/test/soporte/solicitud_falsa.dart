// Dobles de prueba de la spec 015: sin red, sin disco y con datos ficticios.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/borrador_solicitud.dart';
import 'package:app/features/actividad/domain/cotizacion.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/features/actividad/domain/solicitud_repository.dart';
import 'package:app/features/oficios/oficios.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

const plomeria = Oficio(
  clave: 'plo',
  nombre: 'Plomería',
  modalidad: Modalidad.domicilio,
);
const mecanica = Oficio(
  clave: 'mec',
  nombre: 'Mecánica',
  modalidad: Modalidad.taller,
);

/// Hoy fijo para las pruebas: martes 10 de noviembre de 2026, 10:00.
final hoyDePrueba = DateTime(2026, 11, 10, 10);

class OficiosFalsos implements OficiosRepository {
  OficiosFalsos([this.oficios = const [plomeria, mecanica]]);

  final List<Oficio> oficios;
  Failure? falla;

  @override
  Future<List<Oficio>> listar() async {
    if (falla != null) throw falla!;
    return oficios;
  }
}

class SolicitudesFalsas implements SolicitudRepository {
  final creaciones = <NuevaSolicitud>[];
  final subidas = <String>[];

  /// Fallas que devuelve `crear`, una por llamada, en orden.
  final fallas = <Failure>[];

  /// Si `crear` se queda esperando (para probar el doble toque).
  Future<void>? retraso;

  @override
  Future<String> subirFoto(String rutaLocal) async {
    subidas.add(rutaLocal);
    return 'a' * 23 + '${subidas.length}';
  }

  @override
  Future<Solicitud> crear(NuevaSolicitud solicitud) async {
    creaciones.add(solicitud);
    if (retraso != null) await retraso;
    if (fallas.isNotEmpty) throw fallas.removeAt(0);
    return Solicitud(
      id: 'b' * 24,
      estado: EstadoSolicitud.enviada,
      oficioNombre: 'Plomería',
      descripcion: solicitud.descripcion,
      totalFotos: solicitud.archivoIds.length,
      dia: solicitud.dia,
      franja: solicitud.franja,
      creadoEn: hoyDePrueba,
    );
  }

  /// Órdenes pedidos a `cotizaciones`, en orden (CA-08).
  final ordenesPedidos = <OrdenCotizaciones>[];

  /// Lo que responde `cotizaciones`; por omisión, sin cotizaciones.
  ResultadoComparacion comparacion = const ResultadoComparacion(
    cotizaciones: [],
    totalCotizaciones: 0,
    tiposMixtos: false,
    puedeElegir: false,
    motivo: MotivoSinEleccion.sinCotizaciones,
  );

  /// Elecciones pedidas (solicitud, cotización).
  final elecciones = <(String, String)>[];

  /// Fallas que devuelve `elegir`, una por llamada, en orden.
  final fallasAlElegir = <Failure>[];

  /// Si `elegir` se queda esperando (para probar la hoja bloqueada, R-18).
  Future<void>? retrasoAlElegir;

  /// La cita que devuelve `elegir`; por omisión, una con teléfono.
  CitaConfirmada? citaAlElegir;

  @override
  Future<CitaConfirmada> elegir(String solicitudId, String cotizacionId) async {
    elecciones.add((solicitudId, cotizacionId));
    if (retrasoAlElegir != null) await retrasoAlElegir;
    if (fallasAlElegir.isNotEmpty) throw fallasAlElegir.removeAt(0);
    return citaAlElegir ?? citaDePrueba(cotizacionId: cotizacionId);
  }

  @override
  Future<ResultadoComparacion> cotizaciones(
    String solicitudId, {
    OrdenCotizaciones orden = OrdenCotizaciones.recomendadas,
  }) async {
    ordenesPedidos.add(orden);
    if (solicitudId != 'b' * 24) throw const NoEncontradoFailure();
    return comparacion;
  }

  @override
  Future<Solicitud> obtener(String id) async {
    if (id != 'b' * 24) throw const NoEncontradoFailure();
    return Solicitud(
      id: id,
      estado: EstadoSolicitud.enviada,
      oficioNombre: 'Plomería',
      descripcion: 'Gotea la llave del baño',
      totalFotos: 2,
      dia: DateTime(2026, 11, 12),
      franja: Franja.tarde,
      creadoEn: hoyDePrueba,
    );
  }
}

class BorradorFalso implements BorradorSolicitudRepository {
  BorradorFalso([this.guardado]);

  BorradorSolicitud? guardado;
  var borrados = 0;
  var fotosAgregadas = 0;
  final quitadas = <String>[];

  /// Si `agregarFoto` rechaza la foto.
  bool rechazarFotos = false;

  @override
  Future<BorradorSolicitud?> leer() async => guardado;

  @override
  Future<void> guardar(BorradorSolicitud borrador) async => guardado = borrador;

  @override
  Future<String> agregarFoto(List<int> bytesOriginales) async {
    if (rechazarFotos) throw const FotoNoValidaFailure();
    fotosAgregadas++;
    return '/privado/fotos/$fotosAgregadas.jpg';
  }

  @override
  Future<void> quitarFoto(String ruta) async => quitadas.add(ruta);

  @override
  Future<void> borrarTodo() async {
    borrados++;
    guardado = null;
  }
}

class FotosFalsas implements FuenteDeFotos {
  var porCamara = 0;

  @override
  Future<List<int>?> tomarConCamara() async {
    porCamara++;
    return [0xFF, 0xD8, 0xFF];
  }

  @override
  Future<List<List<int>>> elegirDeGaleria(int maximo) async => [
    for (var i = 0; i < maximo; i++) [0xFF, 0xD8, 0xFF],
  ];
}

/// Dobles de la función Actividad para un `ProviderContainer` o un
/// `ProviderScope`.
List<Override> dobles({
  required SolicitudesFalsas solicitudes,
  required BorradorFalso borrador,
  OficiosFalsos? oficios,
  FotosFalsas? fotos,
  String? colonia = 'cccccccccccccccccccccccc',
  DateTime Function()? reloj,
}) {
  return [
    solicitudRepositoryProvider.overrideWithValue(solicitudes),
    borradorSolicitudRepositoryProvider.overrideWithValue(borrador),
    oficiosRepositoryProvider.overrideWithValue(oficios ?? OficiosFalsos()),
    fuenteDeFotosProvider.overrideWithValue(fotos ?? FotosFalsas()),
    coloniaGuardadaProvider.overrideWithValue(colonia),
    relojSolicitudProvider.overrideWithValue(reloj ?? () => hoyDePrueba),
  ];
}

/// Una cotización ficticia para las pruebas de la comparación.
Cotizacion cotizacionDePrueba(
  String id, {
  TipoPrecio tipo = TipoPrecio.fijo,
  int tope = 1100,
  String nombre = 'Técnico de prueba',
  Set<EtiquetaCotizacion> etiquetas = const {},
  double? calificacion = 4.5,
  bool verificado = true,
}) => Cotizacion(
  id: id,
  tipoPrecio: tipo,
  precio: tipo == TipoPrecio.rango ? null : 1000,
  precioMin: tipo == TipoPrecio.rango ? 600 : null,
  precioMax: tipo == TipoPrecio.rango ? 1000 : null,
  tope: tope,
  requiereAprobacion: tipo != TipoPrecio.visita,
  dia: DateTime(2026, 11, 12),
  hora: '10:30',
  nota: 'Nota de prueba',
  cubre: 'Arreglo completo, mano de obra incluida, refacciones aparte',
  etiquetas: etiquetas,
  tecnico: TecnicoResumen(
    id: 't$id',
    nombre: nombre,
    verificado: verificado,
    nivelVerificacion: verificado ? 'basico' : null,
    calificacion: calificacion,
  ),
);

/// Una cita ficticia, con o sin contacto público del técnico.
CitaConfirmada citaDePrueba({
  String cotizacionId = 'c1',
  String? telefono = '5500000001',
  String? whatsapp,
  String modalidad = 'domicilio',
}) => CitaConfirmada(
  visitaId: 'vvvvvvvvvvvvvvvvvvvvvvvv',
  solicitudId: 'bbbbbbbbbbbbbbbbbbbbbbbb',
  cotizacionId: cotizacionId,
  modalidad: modalidad,
  dia: DateTime(2026, 11, 12),
  hora: '10:30',
  precio: 1000,
  tope: 1100,
  direccion: 'Calle de Prueba 123',
  tecnico: TecnicoElegido(
    nombre: 'Técnico de prueba',
    verificado: true,
    nivelVerificacion: 'basico',
    telefono: telefono,
    whatsapp: whatsapp,
  ),
);
