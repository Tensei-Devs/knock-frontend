import 'package:app/core/sesion/sesion.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Las visitas en las que la persona registró que el técnico no llegó: el
/// detalle de la visita no dice quién faltó. Solo vive en memoria y se borra al
/// cambiar la sesión.
class TecnicoAusenteController extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    ref.watch(sesionProvider.select((t) => t != null));
    return const {};
  }

  void anotar(String visitaId) => state = {...state, visitaId};
}

final tecnicoAusenteProvider =
    NotifierProvider<TecnicoAusenteController, Set<String>>(
      TecnicoAusenteController.new,
    );
