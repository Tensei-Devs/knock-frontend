import 'package:app/core/router/rutas.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:flutter/material.dart' show ScaffoldMessengerState;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// Mensajero global para los avisos emergentes de la maqueta.
final mensajeroMaqueta = GlobalKey<ScaffoldMessengerState>();

/// Rutas de las pantallas de la maqueta (fuera de la barra inferior).
abstract final class RM {
  static const base = '/m';
  static const buscar = '/m/buscar';
  static String experto(String id) => '/m/experto/$id';
  static String opiniones(String id) => '/m/experto/$id/opiniones';
  static const asistente = '/m/asistente';
  static const solicitar = '/m/solicitar';
  static String enviada(String job) => '/m/enviada/$job';
  static String comparar(String job) => '/m/comparar/$job';
  static String visita(String job) => '/m/visita/$job';
  static String cita(String job) => '/m/cita/$job';
  static String calificar(String job) => '/m/calificar/$job';
  static String reportar(String job, {String? pid, bool noTermino = false}) =>
      '/m/reportar/$job?pid=${pid ?? ''}&nodone=${noTermino ? 1 : 0}';
  static String compartir(String job) => '/m/compartir/$job';
  static const mensajes = '/m/mensajes';
  static String chat(String id) => '/m/chat/$id';
  static const miCasa = '/m/mi-casa';
  static const confianza = '/m/confianza';
  static const avisos = '/m/avisos';
  static const avisosConfig = '/m/avisos-config';
  static const aviso = '/m/aviso-privacidad';
  static const terminos = '/m/terminos';
  static const privacidad = '/m/privacidad';
  static const sesiones = '/m/privacidad?s=1';
  static const eliminar1 = '/m/eliminar/1';
  static const eliminar2 = '/m/eliminar/2';
  static const eliminado = '/m/eliminado';
  static String ayuda([int t = 1]) => '/m/ayuda?t=$t';
  static const sinConexion = '/m/sin-conexion';
}

bool hayCuenta(BuildContext c) =>
    ProviderScope.containerOf(c, listen: false).read(sesionIniciadaProvider);

/// Si no hay sesión, lleva a entrar y regresa a [destino]; devuelve `true`
/// si ya había sesión y se puede continuar.
bool pedirCuenta(BuildContext c, String destino) {
  if (hayCuenta(c)) return true;
  c.go(
    '${Rutas.entrar}?${Rutas.parametroVolver}=${Uri.encodeQueryComponent(destino)}',
  );
  return false;
}

/// Atajos de navegación de los avisos con acción.
void registrarIrA(GoRouter router) {
  maq.irA = (destino, id) => router.push(switch (destino) {
    'comparar' => RM.comparar(id),
    'visita' => RM.visita(id),
    'cita' => RM.cita(id),
    'calificar' => RM.calificar(id),
    _ => RM.avisos,
  });
}

Future<List<String>> elegirFotos({bool varias = true, int max = 5}) async {
  final p = ImagePicker();
  try {
    // El selector múltiple exige un límite de 2 o más: con un solo hueco libre
    // (la quinta foto) se usa el de una foto, con el mismo tamaño.
    if (varias && max > 1) {
      final l = await p.pickMultiImage(
        limit: max,
        maxWidth: 1600,
        imageQuality: 75,
      );
      return [for (final x in l) x.path];
    }
    final x = await p.pickImage(
      source: ImageSource.gallery,
      maxWidth: varias ? 1600 : 800,
      imageQuality: varias ? 75 : 80,
    );
    return x == null ? [] : [x.path];
  } on Object {
    return [];
  }
}
