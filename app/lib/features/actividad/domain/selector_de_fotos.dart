/// De dónde sale una foto para la solicitud (cámara o galería del sistema).
///
/// Abre el selector del sistema por intención, sin pedir permisos propios
/// (spec 015, D-12). La implementación real llega con `image_picker` en el
/// siguiente corte.
abstract interface class SelectorDeFotos {
  /// Ruta de la foto elegida, o `null` si la persona canceló.
  Future<String?> elegir();
}

/// Sin selector real todavía: nunca devuelve una foto.
final class SelectorDeFotosAusente implements SelectorDeFotos {
  const SelectorDeFotosAusente();

  @override
  Future<String?> elegir() async => null;
}
