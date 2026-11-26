// Horarios y «Disponible hoy» (spec 036, TEC-09 a TEC-11; backend 046).

/// Los días que acepta el contrato, de lunes a domingo.
enum DiaSemana {
  lunes('lunes'),
  martes('martes'),
  miercoles('miercoles'),
  jueves('jueves'),
  viernes('viernes'),
  sabado('sabado'),
  domingo('domingo');

  const DiaSemana(this.valor);
  final String valor;
}

/// Franja `HH:mm` en la hora de la ciudad.
typedef Franja = ({String inicio, String fin});

/// El horario de un día: abierto con una o dos franjas, o cerrado sin ellas.
final class HorarioDelDia {
  const HorarioDelDia({
    required this.dia,
    required this.abierto,
    this.franjas = const [],
  });

  final DiaSemana dia;
  final bool abierto;
  final List<Franja> franjas;
}

/// Lo que responde «Disponible hoy»: hasta cuándo queda encendido.
final class Disponibilidad {
  const Disponibilidad({required this.disponibleHoy, required this.hasta});

  final bool disponibleHoy;
  final DateTime hasta;
}

abstract interface class HorariosRepository {
  /// Falla con `NoEncontradoFailure` si la cuenta no tiene perfil de técnico.
  Future<List<HorarioDelDia>> horarios();

  /// Reemplaza la semana completa.
  Future<List<HorarioDelDia>> guardar(List<HorarioDelDia> semana);

  Future<Disponibilidad> cambiarDisponibilidad({required bool disponibleHoy});
}
