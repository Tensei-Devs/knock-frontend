/// La zona de la ciudad piloto no usa horario de verano desde octubre de 2022.
/// Si cambia la ley, este desfase debe actualizarse.
abstract final class ZonaMexico {
  static const _desfase = Duration(hours: -6);

  /// Devuelve los componentes civiles de México como DateTime UTC, sin zona
  /// del dispositivo. El resultado representa una hora civil, no un instante.
  static DateTime horaCivil(DateTime instante) =>
      instante.toUtc().add(_desfase);
}

sealed class PresentacionVencimiento {
  const PresentacionVencimiento();
}

final class VencimientoAbsoluto extends PresentacionVencimiento {
  const VencimientoAbsoluto({required this.dia, required this.hora});

  final DateTime dia;
  final String hora;
}

final class VencimientoRelativo extends PresentacionVencimiento {
  const VencimientoRelativo(this.horas);

  final int horas;
}

final class MenosDeUnaHora extends PresentacionVencimiento {
  const MenosDeUnaHora();
}

final class VencimientoCerrando extends PresentacionVencimiento {
  const VencimientoCerrando();
}

class Vencimiento {
  const Vencimiento({required this.venceEn, required this.ahora});

  final DateTime venceEn;
  final DateTime ahora;

  PresentacionVencimiento get presentacion {
    final restante = venceEn.difference(ahora);
    if (restante <= Duration.zero) return const VencimientoCerrando();
    if (restante < const Duration(hours: 1)) return const MenosDeUnaHora();
    if (restante <= const Duration(hours: 24)) {
      return VencimientoRelativo(restante.inHours);
    }
    final civil = ZonaMexico.horaCivil(venceEn);
    final hora = civil.hour.toString().padLeft(2, '0');
    final minuto = civil.minute.toString().padLeft(2, '0');
    return VencimientoAbsoluto(
      dia: DateTime.utc(civil.year, civil.month, civil.day),
      hora: '$hora:$minuto',
    );
  }
}
