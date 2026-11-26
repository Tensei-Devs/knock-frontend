import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:app/features/asistente/asistente_providers.dart';
import 'package:app/features/asistente/domain/asistente.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Al abrir o cerrar una sesión se descarta lo anterior.
void _porSesion(Ref ref) =>
    ref.watch(sesionProvider.select((tokens) => tokens != null));

/// Un turno con el asistente Knock; `null` antes del primer mensaje.
class TurnoController extends AsyncNotifier<TurnoAsistente?> {
  @override
  Future<TurnoAsistente?> build() async {
    _porSesion(ref);
    return null;
  }

  Future<void> enviar(String mensaje) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(asistenteRepositoryProvider).turno(mensaje),
    );
  }
}

final turnoControllerProvider =
    AsyncNotifierProvider.autoDispose<TurnoController, TurnoAsistente?>(
      TurnoController.new,
      retry: (_, _) => null,
    );

class ResumenController extends AsyncNotifier<ResumenChat> {
  ResumenController(this.conversacionId);

  final String conversacionId;

  @override
  Future<ResumenChat> build() {
    _porSesion(ref);
    return ref.watch(asistenteRepositoryProvider).resumir(conversacionId);
  }
}

final resumenControllerProvider = AsyncNotifierProvider.autoDispose
    .family<ResumenController, ResumenChat, String>(
      ResumenController.new,
      retry: (_, _) => null,
    );

class BorradorController extends AsyncNotifier<BorradorCotizacionIa> {
  BorradorController(this.conversacionId);

  final String conversacionId;

  @override
  Future<BorradorCotizacionIa> build() {
    _porSesion(ref);
    return ref.watch(asistenteRepositoryProvider).borrador(conversacionId);
  }
}

final borradorControllerProvider = AsyncNotifierProvider.autoDispose
    .family<BorradorController, BorradorCotizacionIa, String>(
      BorradorController.new,
      retry: (_, _) => null,
    );

typedef ConsultaDeRango = ({String oficio, String tipoTrabajo});

class RangoController extends AsyncNotifier<RangoPrecio?> {
  RangoController(this.consulta);

  final ConsultaDeRango consulta;

  @override
  Future<RangoPrecio?> build() {
    _porSesion(ref);
    return ref
        .watch(asistenteRepositoryProvider)
        .rango(consulta.oficio, consulta.tipoTrabajo);
  }
}

final rangoControllerProvider = AsyncNotifierProvider.autoDispose
    .family<RangoController, RangoPrecio?, ConsultaDeRango>(
      RangoController.new,
      retry: (_, _) => null,
    );

class BitacoraController extends AsyncNotifier<Bitacora?> {
  BitacoraController(this.solicitudId);

  final String solicitudId;

  @override
  Future<Bitacora?> build() {
    _porSesion(ref);
    return ref.watch(asistenteRepositoryProvider).bitacora(solicitudId);
  }

  /// El error se devuelve sin tocar el estado: lo escrito se conserva.
  Future<Failure?> guardar(Bitacora bitacora) async {
    try {
      state = AsyncData(
        await ref
            .read(asistenteRepositoryProvider)
            .guardarBitacora(solicitudId, bitacora),
      );
      return null;
    } on Failure catch (falla) {
      return falla;
    }
  }
}

final bitacoraControllerProvider = AsyncNotifierProvider.autoDispose
    .family<BitacoraController, Bitacora?, String>(
      BitacoraController.new,
      retry: (_, _) => null,
    );
