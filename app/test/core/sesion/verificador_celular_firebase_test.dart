import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/arranque_sesion.dart';
import 'package:app/core/sesion/verificador_celular_firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('los errores de Firebase se traducen sin detalles', () {
    expect(
      mapearErrorFirebase('invalid-verification-code'),
      isA<CodigoIncorrectoFailure>(),
    );
    expect(mapearErrorFirebase('session-expired'), isA<CodigoVencidoFailure>());
    expect(
      mapearErrorFirebase('invalid-phone-number'),
      isA<CelularRechazadoFailure>(),
    );
    expect(
      mapearErrorFirebase('too-many-requests'),
      isA<DemasiadosIntentosFailure>(),
    );
    expect(
      mapearErrorFirebase('app-not-authorized'),
      isA<VerificacionNoDisponibleFailure>(),
    );
    expect(
      mapearErrorFirebase('network-request-failed'),
      isA<ServicioNoDisponibleFailure>(),
    );
  });

  test('el celular se manda con el prefijo de México', () {
    expect(prefijoMexico, '+52');
  });

  test(
    'fuera de un teléfono no se inicia Firebase ni se lee la sesión',
    () async {
      expect(esTelefono, isFalse);
      expect(await iniciarFirebase(), isFalse);
    },
  );
}
