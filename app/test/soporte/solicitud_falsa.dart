// Dobles de prueba de la spec 015: sin red, sin disco y con datos ficticios.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/borrador_solicitud.dart';
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
  final creaciones = <(NuevaSolicitud, String)>[];
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
  Future<Solicitud> crear(
    NuevaSolicitud solicitud, {
    required String claveIdempotencia,
  }) async {
    creaciones.add((solicitud, claveIdempotencia));
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
  var clave = 0;
  return [
    solicitudRepositoryProvider.overrideWithValue(solicitudes),
    borradorSolicitudRepositoryProvider.overrideWithValue(borrador),
    oficiosRepositoryProvider.overrideWithValue(oficios ?? OficiosFalsos()),
    fuenteDeFotosProvider.overrideWithValue(fotos ?? FotosFalsas()),
    coloniaGuardadaProvider.overrideWithValue(colonia),
    relojSolicitudProvider.overrideWithValue(reloj ?? () => hoyDePrueba),
    generadorDeClaveProvider.overrideWithValue(() => 'clave-${++clave}'),
  ];
}
