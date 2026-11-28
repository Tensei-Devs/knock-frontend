import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/tecnico/domain/horarios.dart';
import 'package:app/features/tecnico/tecnico_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Las franjas que la maqueta muestra al abrir un día: se usan solo cuando no
/// hay ninguna del servidor. El domingo no tiene horas en la maqueta.
List<Franja> franjasDeLaMaqueta(DiaSemana dia) => switch (dia) {
  DiaSemana.domingo => const [],
  DiaSemana.sabado => const [(inicio: '09:00', fin: '14:00')],
  _ => const [(inicio: '08:00', fin: '19:00')],
};

/// Los horarios del técnico (spec 036). El interruptor solo cambia cuando el
/// servidor lo confirma. No guarda nada en el teléfono.
class HorariosController extends AsyncNotifier<List<HorarioDelDia>> {
  /// Franjas de los días cerrados en esta visita, para volver a abrirlos con
  /// las mismas horas (el servidor no las conserva).
  final _recordadas = <DiaSemana, List<Franja>>{};
  bool _guardando = false;

  @override
  Future<List<HorarioDelDia>> build() {
    ref.watch(sesionProvider.select((tokens) => tokens != null));
    _recordadas.clear();
    return ref.watch(horariosRepositoryProvider).horarios();
  }

  void reintentar() => ref.invalidateSelf();

  /// Con qué horas se abriría [dia]; vacío si no hay ninguna que usar.
  List<Franja> franjasParaAbrir(DiaSemana dia) =>
      _recordadas[dia] ?? franjasDeLaMaqueta(dia);

  /// Abre o cierra un día y guarda la semana completa. Devuelve el error si
  /// falla; lo que se mostraba sigue igual.
  Future<Failure?> cambiar(DiaSemana dia, {required bool abierto}) async {
    final actual = state.value;
    if (actual == null || _guardando) return null;
    _guardando = true;
    final nueva = [
      for (final d in actual)
        if (d.dia != dia)
          d
        else
          HorarioDelDia(
            dia: dia,
            abierto: abierto,
            franjas: abierto ? franjasParaAbrir(dia) : const [],
          ),
    ];
    try {
      final guardada = await ref
          .read(horariosRepositoryProvider)
          .guardar(nueva);
      if (!abierto) _recordar(actual, dia);
      state = AsyncData(guardada);
      return null;
    } on Failure catch (falla) {
      return falla;
    } finally {
      _guardando = false;
    }
  }

  void _recordar(List<HorarioDelDia> semana, DiaSemana dia) {
    for (final d in semana) {
      if (d.dia == dia && d.franjas.isNotEmpty) _recordadas[dia] = d.franjas;
    }
  }
}

/// Sin reintento automático: la persona decide con Reintentar.
final horariosControllerProvider =
    AsyncNotifierProvider<HorariosController, List<HorarioDelDia>>(
      HorariosController.new,
      retry: (_, _) => null,
    );
