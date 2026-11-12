import 'dart:math';

import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/features/actividad/domain/solicitud_repository.dart';

/// Solicitudes en memoria mientras el contrato no publique `/solicitudes` ni
/// `/archivos` (backend 020 y spec 013). Sin red ni datos reales.
///
/// Se comporta como el servidor en lo que la pantalla necesita: responde
/// «no encontrada» para un identificador ajeno (CA-13) y crea la solicitud en
/// estado `enviada`. Se reemplaza en `solicitudRepositoryProvider` por la
/// implementación con el cliente generado sin tocar la pantalla.
class SolicitudRepositoryDePrueba implements SolicitudRepository {
  SolicitudRepositoryDePrueba({DateTime Function()? reloj, Random? azar})
    : _reloj = reloj ?? DateTime.now,
      _azar = azar ?? Random();

  final DateTime Function() _reloj;
  final Random _azar;
  final _solicitudes = <String, Solicitud>{};

  /// Nombres de los oficios piloto, para el detalle.
  static const _nombres = {
    'ele': 'Electricidad',
    'mec': 'Mecánica',
    'plo': 'Plomería',
  };

  String _idHexadecimal() =>
      List.generate(24, (_) => _azar.nextInt(16).toRadixString(16)).join();

  @override
  Future<String> subirFoto(String rutaLocal) async => _idHexadecimal();

  @override
  Future<Solicitud> crear(NuevaSolicitud solicitud) async {
    final ahora = _reloj();
    final creada = Solicitud(
      id: _idHexadecimal(),
      estado: EstadoSolicitud.enviada,
      oficioNombre: _nombres[solicitud.oficioClave] ?? solicitud.oficioClave,
      descripcion: solicitud.descripcion.trim(),
      totalFotos: solicitud.archivoIds.length,
      dia: solicitud.dia,
      franja: solicitud.franja,
      creadoEn: ahora,
      venceEn: ahora.add(const Duration(hours: 48)),
    );
    _solicitudes[creada.id] = creada;
    return creada;
  }

  @override
  Future<Solicitud> obtener(String id) async {
    final solicitud = _solicitudes[id];
    if (solicitud == null) throw const NoEncontradoFailure();
    return solicitud;
  }
}
