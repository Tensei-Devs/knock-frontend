import 'dart:io';

import 'package:app/core/preferencias/almacen_borrador_solicitud.dart';
import 'package:app/features/actividad/domain/borrador_solicitud.dart';

/// Borrador de «Pedir cotización» y sus fotos (spec 015, R-07, CA-14 y CA-19).
///
/// El texto y las rutas van al almacén de `core/preferencias/`; las copias de
/// las fotos viven en un directorio privado de la app que solo esta clase
/// administra. Al enviar, descartar o cerrar sesión se borran las dos cosas.
class BorradorRepository {
  BorradorRepository({required this._almacen, required this._directorioFotos});

  final AlmacenBorradorSolicitud _almacen;
  final Future<Directory> Function() _directorioFotos;

  /// El borrador guardado, o `null` si no hay, está dañado o está vacío.
  ///
  /// Quita las rutas de fotos que ya no existen (el sistema pudo borrarlas) y
  /// las que no están en el directorio privado.
  Future<BorradorSolicitud?> leer() async {
    final mapa = _almacen.leerBorrador();
    if (mapa == null) return null;
    final borrador = BorradorSolicitud.desdeMapa(mapa);
    if (borrador == null) {
      await _almacen.borrarBorrador();
      return null;
    }
    final directorio = await _directorioFotos();
    final vigentes = [
      for (final ruta in borrador.rutasDeFotos)
        if (_estaDentro(ruta, directorio) && File(ruta).existsSync()) ruta,
    ];
    final limpio = BorradorSolicitud(
      oficioClave: borrador.oficioClave,
      descripcion: borrador.descripcion,
      rutasDeFotos: vigentes,
      dia: borrador.dia,
      franja: borrador.franja,
      actualizadoEn: borrador.actualizadoEn,
    );
    return limpio.estaVacio ? null : limpio;
  }

  /// Guarda el borrador. Uno vacío equivale a no tener borrador.
  Future<void> guardar(BorradorSolicitud borrador) => borrador.estaVacio
      ? _almacen.borrarBorrador()
      : _almacen.guardarBorrador(borrador.aMapa());

  /// Borra el borrador y **todas** las fotos del directorio privado: al
  /// enviar, al descartar y al cerrar sesión (CA-19).
  Future<void> borrarTodo() async {
    await _almacen.borrarBorrador();
    final directorio = await _directorioFotos();
    if (directorio.existsSync()) {
      for (final entrada in directorio.listSync()) {
        entrada.deleteSync(recursive: true);
      }
    }
  }

  static bool _estaDentro(String ruta, Directory directorio) {
    final base = _normalizada(directorio.absolute.path);
    final archivo = _normalizada(File(ruta).absolute.path);
    return archivo.startsWith(base.endsWith('/') ? base : '$base/');
  }

  static String _normalizada(String ruta) => ruta.replaceAll(r'\', '/');
}
