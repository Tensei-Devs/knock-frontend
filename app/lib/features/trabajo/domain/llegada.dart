/// La vista del técnico de su visita y la confirmación de la llegada con el
/// código (spec 016, R-08, R-09 y R-15). El código que escribe el técnico no se
/// guarda ni se registra.
library;

/// Lo que la pantalla de llegada usa de `GET /visitas/{id}` en la vista del
/// técnico. Nunca lleva el código de la visita.
final class VisitaDelTecnico {
  const VisitaDelTecnico({
    required this.id,
    required this.estado,
    required this.esTaller,
    required this.dia,
    required this.hora,
    required this.puedeLlegar,
    this.colonia,
    this.direccion,
    this.llegadaEn,
  });

  final String id;

  /// El estado tal como lo manda el servidor (`confirmada`, `en_curso`, etc.).
  final String estado;
  final bool esTaller;
  final String dia;
  final String hora;

  /// Lo decide el servidor: la app no calcula la ventana de la cita (R-15).
  final bool puedeLlegar;
  final String? colonia;
  final String? direccion;
  final DateTime? llegadaEn;

  bool get enCurso => estado == 'en_curso';
}

/// Por qué el servidor (o el teléfono, en [formato]) no aceptó la llegada.
enum MotivoLlegada {
  formato,
  codigoIncorrecto,
  visitaBloqueada,
  codigoUsado,
  codigoVencido,
  visitaCancelada,
  visitaNoVigente,
  visitaSinCodigo,
  fueraDeVentana,
  noEsTecnico;

  /// La persona puede corregir el código y volver a enviarlo.
  bool get permiteOtroIntento => this == formato || this == codigoIncorrecto;
}

sealed class ResultadoLlegada {
  const ResultadoLlegada();
}

final class LlegadaConfirmada extends ResultadoLlegada {
  const LlegadaConfirmada(this.visita);

  final VisitaDelTecnico visita;
}

final class LlegadaRechazada extends ResultadoLlegada {
  const LlegadaRechazada(this.motivo, {this.intentosRestantes});

  final MotivoLlegada motivo;

  /// Solo con [MotivoLlegada.codigoIncorrecto]; la app no lleva la cuenta.
  final int? intentosRestantes;
}

abstract final class ReglasDeLlegada {
  static const digitos = 4;

  static final _codigo = RegExp(r'^\d{4}$');

  static bool codigoValido(String codigo) => _codigo.hasMatch(codigo);
}

/// Falla con un `Failure`; un 404 es `NoEncontradoFailure`.
abstract interface class LlegadaRepository {
  Future<VisitaDelTecnico> obtener(String visitaId);

  /// Nunca se reintenta sola (R-08).
  Future<ResultadoLlegada> confirmar(String visitaId, String codigo);
}
