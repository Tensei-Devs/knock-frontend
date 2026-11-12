import 'dart:io';

import 'package:app/core/preferencias/almacen_borrador_solicitud.dart';
import 'package:app/core/preferencias/almacen_preferencias.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

/// Nombre de la carpeta privada con las copias de las fotos del borrador
/// (spec 015, R-07 y D-05). Vive en el soporte de la app, no en documentos ni
/// en la galería, y queda fuera de la copia de seguridad (`allowBackup`).
const carpetaFotosBorrador = 'fotos_solicitud';

/// La carpeta privada de las fotos del borrador; la crea si no existe.
Future<Directory> directorioFotosBorrador() async {
  final soporte = await getApplicationSupportDirectory();
  return Directory('${soporte.path}/$carpetaFotosBorrador')
      .create(recursive: true);
}

/// Carpeta de las fotos del borrador. Las pruebas la reemplazan con una
/// carpeta temporal.
final directorioFotosBorradorProvider = Provider<Future<Directory> Function()>(
  (ref) => directorioFotosBorrador,
);

/// Borra el borrador de solicitud y todas sus fotos (spec 015, CA-19).
///
/// Lo llama el cierre de sesión: así no quedan textos ni fotos de una cuenta
/// cuando entra otra. Nunca lanza.
Future<void> borrarBorradorDeSolicitud(Ref ref) async {
  try {
    final Object almacen = ref.read(almacenPreferenciasProvider);
    if (almacen is AlmacenBorradorSolicitud) await almacen.borrarBorrador();
    final directorio = await ref.read(directorioFotosBorradorProvider)();
    if (directorio.existsSync()) {
      for (final entrada in directorio.listSync()) {
        entrada.deleteSync(recursive: true);
      }
    }
  } on Object {
    // Sin registro (spec 009, R-11): la ruta podría llevar datos.
  }
}
