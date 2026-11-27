/// Puerto del canal en vivo de la mensajería (spec 020, R-03 y R-07).
abstract interface class CanalMensajes {
  /// Abre el canal. Falla si no se pudo conectar. [alCambiarContador] recibe
  /// el total de no leídos que manda el servidor y [alCaerse] avisa que una
  /// conexión abierta se perdió.
  Future<void> abrir({
    required void Function(int total) alCambiarContador,
    required void Function() alCaerse,
  });

  Future<void> cerrar();
}
