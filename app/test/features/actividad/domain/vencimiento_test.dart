import 'package:app/features/actividad/domain/vencimiento.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final ahora = DateTime.utc(2026, 11, 16, 12);

  PresentacionVencimiento presentar(Duration restante) =>
      Vencimiento(venceEn: ahora.add(restante), ahora: ahora).presentacion;

  test('CA_025_09 límites y truncamiento de horas', () {
    expect(presentar(const Duration(minutes: 59)), isA<MenosDeUnaHora>());
    for (final caso in <(Duration, int)>[
      (const Duration(hours: 1), 1),
      (const Duration(hours: 1, minutes: 59), 1),
      (const Duration(hours: 23, minutes: 59), 23),
      (const Duration(hours: 24), 24),
    ]) {
      expect((presentar(caso.$1) as VencimientoRelativo).horas, caso.$2);
    }
    expect(
      presentar(const Duration(hours: 24, minutes: 1)),
      isA<VencimientoAbsoluto>(),
    );
  });

  test('CA_025_09 zona de México y cambio de día, no zona del teléfono', () {
    final instante = DateTime.parse('2026-11-18T05:59:00Z');
    final otraZona = DateTime.parse('2026-11-18T14:59:00+09:00');
    VencimientoAbsoluto absoluto(DateTime vence) =>
        Vencimiento(venceEn: vence, ahora: ahora).presentacion
            as VencimientoAbsoluto;
    final antes = absoluto(instante);
    final equivalente = absoluto(otraZona);
    final zonaDispositivo = absoluto(instante.toLocal());
    expect(antes.dia, DateTime.utc(2026, 11, 17));
    expect(antes.hora, '23:59');
    expect(equivalente.dia, antes.dia);
    expect(equivalente.hora, antes.hora);
    expect(zonaDispositivo.dia, antes.dia);
    expect(zonaDispositivo.hora, antes.hora);
    final despues = absoluto(instante.add(const Duration(minutes: 1)));
    expect(despues.dia, DateTime.utc(2026, 11, 18));
    expect(despues.hora, '00:00');
  });

  test('CA_025_10 al vencer o después solo indica cerrando', () {
    expect(presentar(Duration.zero), isA<VencimientoCerrando>());
    expect(presentar(const Duration(seconds: -1)), isA<VencimientoCerrando>());
    expect(presentar(const Duration(seconds: 1)), isA<MenosDeUnaHora>());
  });
}
