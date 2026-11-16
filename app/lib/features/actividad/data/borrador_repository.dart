import 'dart:io';
import 'dart:typed_data';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/preferencias/almacen_borrador_solicitud.dart';
import 'package:app/features/actividad/data/foto_preparada.dart';
import 'package:app/features/actividad/domain/borrador_solicitud.dart';
import 'package:app/features/actividad/domain/solicitud_repository.dart';
import 'package:uuid/uuid.dart';

/// Borrador de «Pedir cotización» y sus fotos (spec 015, R-07, CA-14 y CA-19).
///
/// El texto y las rutas van al almacén de `core/preferencias/`; las copias de
/// las fotos viven en un directorio privado de la app que solo esta clase
/// administra. Al enviar, descartar o cerrar sesión se borran las dos cosas.
class BorradorRepository implements BorradorSolicitudRepository {
  BorradorRepository({required this._almacen, required this._directorioFotos});

  final AlmacenBorradorSolicitud _almacen;
  final Future<Directory> Function() _directorioFotos;

  /// El borrador guardado, o `null` si no hay, está dañado o está vacío.
  ///
  /// Quita las rutas de fotos que ya no existen (el sistema pudo borrarlas) y
  /// las que no están en el directorio privado.
  @override
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
  @override
  Future<void> guardar(BorradorSolicitud borrador) => borrador.estaVacio
      ? _almacen.borrarBorrador()
      : _almacen.guardarBorrador(borrador.aMapa());

  /// Borra el borrador y **todas** las fotos del directorio privado: al
  /// enviar, al descartar y al cerrar sesión (CA-19).
  @override
  Future<void> borrarTodo() async {
    await _almacen.borrarBorrador();
    final directorio = await _directorioFotos();
    if (directorio.existsSync()) {
      for (final entrada in directorio.listSync()) {
        entrada.deleteSync(recursive: true);
      }
    }
  }

  /// Prepara la foto en segundo plano y guarda la copia con un nombre
  /// aleatorio (sin datos de la persona) en la carpeta privada.
  @override
  Future<String> agregarFoto(List<int> bytesOriginales) async {
    final resultado = await prepararFotoEnSegundoPlano(
      Uint8List.fromList(bytesOriginales),
    );
    switch (resultado) {
      case FotoRechazada():
        throw const FotoNoValidaFailure();
      case FotoLista(:final bytes, :final tipoContenido):
        final directorio = await _directorioFotos();
        await directorio.create(recursive: true);
        final extension = tipoContenido == 'image/png' ? 'png' : 'jpg';
        final archivo = File(
          '${directorio.path}/${const Uuid().v4()}.$extension',
        );
        await archivo.writeAsBytes(bytes, flush: true);
        return archivo.path;
    }
  }

  /// Borra la copia de una foto quitada; ignora rutas fuera de la carpeta.
  @override
  Future<void> quitarFoto(String ruta) async {
    final directorio = await _directorioFotos();
    final archivo = File(ruta);
    if (_estaDentro(ruta, directorio) && archivo.existsSync()) {
      await archivo.delete();
    }
  }

  static bool _estaDentro(String ruta, Directory directorio) {
    final base = _normalizada(directorio.absolute.path);
    final archivo = _normalizada(File(ruta).absolute.path);
    return archivo.startsWith(base.endsWith('/') ? base : '$base/');
  }

  static String _normalizada(String ruta) => ruta.replaceAll(r'\', '/');
}
