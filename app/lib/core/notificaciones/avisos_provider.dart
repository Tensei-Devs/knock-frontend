import 'package:app/core/notificaciones/carga_notificacion.dart';
import 'package:app/core/preferencias/almacen_avisos.dart';
import 'package:app/core/preferencias/almacen_preferencias.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Almacén de los avisos elegidos. Es el mismo objeto que el de las
/// preferencias (lo implementan ambos almacenes); si fuera otro, memoria.
final almacenAvisosProvider = Provider<AlmacenAvisos>((ref) {
  final almacen = ref.watch(almacenPreferenciasProvider);
  final Object candidato = almacen;
  if (candidato is AlmacenAvisos) return candidato;
  return AlmacenPreferenciasEnMemoria();
});

/// Qué tipos de aviso recibe la persona (spec 012, R-05).
///
/// Por defecto se reciben todos. [TipoAviso.sistema] siempre se recibe.
@immutable
class PreferenciasAvisos {
  const PreferenciasAvisos(this.apagados);

  static const todos = PreferenciasAvisos({});

  /// Tipos que la persona apagó.
  final Set<TipoAviso> apagados;

  bool recibe(TipoAviso tipo) => !tipo.seElige || !apagados.contains(tipo);
}

class AvisosNotifier extends Notifier<PreferenciasAvisos> {
  @override
  PreferenciasAvisos build() {
    final almacen = ref.read(almacenAvisosProvider);
    return PreferenciasAvisos({
      for (final tipo in TipoAviso.values)
        if (tipo.seElige && almacen.leerAviso(tipo) == false) tipo,
    });
  }

  /// Enciende o apaga un tipo. [TipoAviso.sistema] no se puede apagar.
  void elegir(TipoAviso tipo, {required bool recibir}) {
    if (!tipo.seElige) return;
    final apagados = {...state.apagados};
    if (recibir) {
      apagados.remove(tipo);
    } else {
      apagados.add(tipo);
    }
    state = PreferenciasAvisos(apagados);
    // Un fallo al guardar se ignora: lo que se ve no depende del guardado.
    ref
        .read(almacenAvisosProvider)
        .guardarAviso(tipo, recibir: recibir)
        .ignore();
  }
}

final avisosProvider = NotifierProvider<AvisosNotifier, PreferenciasAvisos>(
  AvisosNotifier.new,
);

/// Conversación que la persona tiene abierta ahora, o `null` (spec 012, R-04).
/// El chat la fija al entrar y la limpia al salir.
class ConversacionAbiertaNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void abrir(String? conversacion) => state = conversacion;
}

final conversacionAbiertaProvider =
    NotifierProvider<ConversacionAbiertaNotifier, String?>(
      ConversacionAbiertaNotifier.new,
    );

/// Si una notificación recibida con la app abierta debe mostrarse.
///
/// No se muestra si la persona apagó ese tipo (R-05) ni si es un mensaje de
/// la conversación que tiene abierta: llega en vivo (R-04).
final debeMostrarNotificacionProvider =
    Provider.family<bool, CargaNotificacion>((ref, carga) {
      if (!ref.watch(avisosProvider).recibe(carga.tipo)) return false;
      final abierta = ref.watch(conversacionAbiertaProvider);
      final enVivo =
          carga.tipo == TipoAviso.mensajes &&
          abierta != null &&
          abierta == carga.conversacion;
      return !enVivo;
    });
