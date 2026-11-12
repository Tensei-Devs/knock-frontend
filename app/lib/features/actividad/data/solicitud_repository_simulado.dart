import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/features/actividad/domain/solicitud_repository.dart';
import 'package:app/features/oficios/oficios.dart';

/// Repositorio simulado en memoria para pruebas y desarrollo, mientras el
/// contrato de backend 020 no esté vendorizado (spec 015, T-03 diferida).
///
/// No guarda nada en disco: lo que crea vive solo en esta instancia.
class SolicitudRepositorySimulado implements SolicitudRepository {
  final Map<String, Solicitud> _solicitudes = {};
  int _siguienteFoto = 0;
  int _siguienteSolicitud = 0;

  static const _nombres = {
    'ele': 'Electricidad',
    'plo': 'Plomería',
    'mec': 'Mecánica',
  };

  @override
  Future<String> subirFoto(String ruta) async => 'archivo-${++_siguienteFoto}';

  @override
  Future<Solicitud> crear(SolicitudNueva nueva) async {
    final id = 'sol-${++_siguienteSolicitud}';
    final solicitud = Solicitud(
      id: id,
      estado: EstadoSolicitud.enviada,
      oficioClave: nueva.oficioClave,
      oficioNombre: _nombres[nueva.oficioClave] ?? nueva.oficioClave,
      modalidad: nueva.direccion == null
          ? Modalidad.taller
          : Modalidad.domicilio,
      descripcion: nueva.descripcion,
      fotos: const [],
      dia: nueva.dia,
      franja: nueva.franja,
      direccion: nueva.direccion,
      creadoEn: DateTime.now(),
    );
    _solicitudes[id] = solicitud;
    return solicitud;
  }

  @override
  Future<Solicitud> obtener(String id) async {
    final solicitud = _solicitudes[id];
    if (solicitud == null) throw const NoEncontradoFailure();
    return solicitud;
  }
}
