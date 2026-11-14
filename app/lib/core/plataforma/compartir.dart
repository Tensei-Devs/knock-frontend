import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

/// Hoja de compartir del sistema (spec 022, CA-10 y CA-12): la persona elige
/// la app y envía; la app no guarda nada.
abstract interface class CompartidorDeTexto {
  Future<void> compartir(String texto);
}

class CompartidorDelSistema implements CompartidorDeTexto {
  const CompartidorDelSistema();

  @override
  Future<void> compartir(String texto) =>
      SharePlus.instance.share(ShareParams(text: texto));
}

final compartidorDeTextoProvider = Provider<CompartidorDeTexto>(
  (ref) => const CompartidorDelSistema(),
);
