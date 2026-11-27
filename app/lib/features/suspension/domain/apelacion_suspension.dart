/// La apelación de una cuenta suspendida (spec 033, enmienda del 2026-11-26;
/// backend 060). Dart puro.
library;

/// `{ estado, presentadaEn, resueltaEn? }`.
final class ApelacionDeSuspension {
  const ApelacionDeSuspension({
    required this.estado,
    required this.presentadaEn,
    this.resueltaEn,
  });

  /// `pendiente`, `aceptada` o `rechazada`.
  final String estado;
  final DateTime presentadaEn;
  final DateTime? resueltaEn;
}

const apelacionMinima = 8;
const apelacionMaxima = 500;

bool textoDeApelacionValido(String texto) {
  final largo = texto.trim().length;
  return largo >= apelacionMinima && largo <= apelacionMaxima;
}

/// Las dos rutas no usan la sesión de Knock: llevan el `idToken` de Firebase de
/// un SMS reciente. Ni el token ni el texto se guardan ni se registran.
abstract interface class ApelacionSuspensionRepository {
  Future<ApelacionDeSuspension> consultar(String idToken);

  Future<ApelacionDeSuspension> presentar(String idToken, String texto);
}
