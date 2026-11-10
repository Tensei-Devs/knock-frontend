import 'package:app/core/errores/failure.dart';
import 'package:app/core/errores/mensajes_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'CA-002-02 cada error tiene un mensaje en español sin datos técnicos',
    () {
      const fallas = <Failure>[
        DatosInvalidosFailure(),
        ServicioNoDisponibleFailure(),
        ApiNoConfiguradaFailure(),
        NoAutorizadoFailure(),
        CuentaSuspendidaFailure(),
        AccesoDenegadoFailure(),
        ConflictoFailure(),
        DatosRechazadosFailure(),
        DemasiadosIntentosFailure(),
      ];
      final vistos = <String>{};
      for (final falla in fallas) {
        final mensaje = mensajeDeFailure(falla);
        expect(mensaje, isNotEmpty);
        expect(mensaje, isNot(contains('Failure')));
        expect(
          mensaje,
          isNot(matches(RegExp(r'\b[1-5]\d\d\b|http|Exception'))),
        );
        vistos.add(mensaje);
      }
      expect(vistos.length, fallas.length, reason: 'cada error dice algo');
    },
  );
}
