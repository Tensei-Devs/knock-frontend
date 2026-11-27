import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/tecnico/domain/reputacion.dart';
import 'package:app/features/tecnico/tecnico_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class VistaReputacion {
  const VistaReputacion(this.reputacion, {this.copiaDel});
  final Reputacion reputacion;
  final DateTime? copiaDel;
}

final _copiaProvider = Provider<_Copia>((ref) {
  ref.watch(sesionProvider.select((tokens) => tokens != null));
  ref.watch(cierresDeSesionProvider);
  return _Copia();
});

final class _Copia {
  (Reputacion, DateTime)? valor;
}

class ReputacionController extends AsyncNotifier<VistaReputacion> {
  @override
  Future<VistaReputacion> build() async {
    final copia = ref.watch(_copiaProvider);
    try {
      final reputacion = await ref
          .watch(reputacionRepositoryProvider)
          .obtener();
      copia.valor = (reputacion, DateTime.now());
      return VistaReputacion(reputacion);
    } on ServicioNoDisponibleFailure {
      final anterior = copia.valor;
      if (anterior == null) rethrow;
      return VistaReputacion(anterior.$1, copiaDel: anterior.$2);
    }
  }

  void reintentar() => ref.invalidateSelf();
}

final reputacionControllerProvider =
    AsyncNotifierProvider.autoDispose<ReputacionController, VistaReputacion>(
      ReputacionController.new,
      retry: (_, _) => null,
    );
