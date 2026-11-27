import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/trabajo/domain/llegada.dart';
import 'package:app/features/trabajo/llegada_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// La visita del técnico. Se vuelve a pedir al abrirla y al volver a la app.
final visitaDelTecnicoProvider = FutureProvider.autoDispose
    .family<VisitaDelTecnico, String>(_pedirVisita, retry: (_, _) => null);

Future<VisitaDelTecnico> _pedirVisita(Ref ref, String visitaId) {
  ref.watch(sesionProvider.select((t) => t != null));
  return ref.watch(llegadaRepositoryProvider).obtener(visitaId);
}

/// Cómo va el envío del código.
final class EstadoLlegada {
  const EstadoLlegada({
    this.enviando = false,
    this.confirmada,
    this.motivo,
    this.intentosRestantes,
    this.falla,
  });

  final bool enviando;
  final VisitaDelTecnico? confirmada;
  final MotivoLlegada? motivo;
  final int? intentosRestantes;
  final Failure? falla;

  /// El servidor ya no aceptará otro código desde esta pantalla.
  bool get cerrada => !(motivo?.permiteOtroIntento ?? true);

  /// No se supo si el envío llegó: un reintento puede contar como intento.
  bool get respuestaPerdida => falla is ServicioNoDisponibleFailure;
}

/// Un envío a la vez y sin reintentos automáticos (spec 016, R-08 y R-09).
class LlegadaController extends Notifier<EstadoLlegada> {
  LlegadaController(this.visitaId);

  final String visitaId;

  @override
  EstadoLlegada build() {
    ref.watch(sesionProvider.select((t) => t != null));
    return const EstadoLlegada();
  }

  Future<void> confirmar(String codigo) async {
    if (state.enviando || state.cerrada || state.confirmada != null) return;
    if (!ReglasDeLlegada.codigoValido(codigo)) {
      state = const EstadoLlegada(motivo: MotivoLlegada.formato);
      return;
    }
    state = const EstadoLlegada(enviando: true);
    try {
      final resultado = await ref
          .read(llegadaRepositoryProvider)
          .confirmar(visitaId, codigo);
      if (!ref.mounted) return;
      state = switch (resultado) {
        LlegadaConfirmada(:final visita) => EstadoLlegada(confirmada: visita),
        LlegadaRechazada(:final motivo, :final intentosRestantes) =>
          EstadoLlegada(motivo: motivo, intentosRestantes: intentosRestantes),
      };
    } on Failure catch (falla) {
      if (!ref.mounted) return;
      state = EstadoLlegada(falla: falla);
    }
  }
}

final llegadaControllerProvider = NotifierProvider.autoDispose
    .family<LlegadaController, EstadoLlegada, String>(LlegadaController.new);
