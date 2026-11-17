import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/red/configuracion_api.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Si la maqueta debe pedir las solicitudes reales (spec 045, enmienda 1):
/// solo con sesión iniciada y con `KNOCK_API_URL` válida. Sin una de las dos
/// la maqueta no cambia.
final solicitudesRealesActivasProvider = Provider<bool>(
  (ref) =>
      ref.watch(sesionIniciadaProvider) &&
      normalizarUrlApi(ref.watch(urlApiProvider)) != null,
);

/// Las solicitudes de la persona (`GET /solicitudes`): cargando, datos o
/// error con Reintentar. No guarda nada en el teléfono.
class SolicitudesRealesController extends AsyncNotifier<List<Solicitud>> {
  @override
  Future<List<Solicitud>> build() =>
      ref.watch(solicitudesRealesRepositoryProvider).listar();

  /// Vuelve a pedir las solicitudes (botón Reintentar).
  void reintentar() => ref.invalidateSelf();
}

/// Se descarta al salir de la pantalla. Sin reintento automático: Riverpod
/// reintenta solo los proveedores que fallan y eso escondería el error; la
/// persona decide con Reintentar.
final solicitudesRealesControllerProvider =
    AsyncNotifierProvider.autoDispose<
      SolicitudesRealesController,
      List<Solicitud>
    >(SolicitudesRealesController.new, retry: (_, _) => null);

/// El detalle de una solicitud (`GET /solicitudes/{id}`): la descripción y la
/// clave del oficio, que la lista no trae. Se pide al abrirla.
final solicitudRealDetalleProvider = FutureProvider.autoDispose
    .family<Solicitud, String>(
      (ref, id) => ref.watch(solicitudesRealesRepositoryProvider).obtener(id),
      retry: (_, _) => null,
    );
