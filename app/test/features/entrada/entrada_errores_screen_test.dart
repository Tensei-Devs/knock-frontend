// KNOCK-228: las pantallas de entrada con un servicio de entrada falso
// muestran el mensaje en español del ARB para cada respuesta de la API.
import 'package:app/core/errores/failure.dart';
import 'package:app/core/preferencias/preferencias_provider.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/entrada_falsa.dart';
import '../../soporte/montar_app.dart';

Future<void> _escribirCelular(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField), '5512345678');
  await tester.tap(find.byType(Checkbox));
  await tester.pumpAndSettle();
  await tocarTexto(tester, 'Continuar');
}

Future<void> _desmontar(WidgetTester tester, ProviderContainer c) async {
  await tester.pumpWidget(const SizedBox.shrink());
  c.dispose();
}

void main() {
  testWidgets('al pedir el SMS sin conexión se queda en el celular con el '
      'mensaje y se puede reintentar', (tester) async {
    final servicio = ServicioEntradaFalso()
      ..errorAlEnviar = const ServicioNoDisponibleFailure();
    final c = await montarApp(
      tester,
      esTecnico: false,
      sesionIniciada: false,
      servicioEntrada: servicio,
    );

    await _escribirCelular(tester);

    expect(ubicacion(c), Rutas.entrar);
    expect(
      find.text(
        'No pudimos conectarnos. Revisa tu internet e inténtalo otra vez.',
      ),
      findsOneWidget,
    );

    servicio.errorAlEnviar = null;
    await tocarTexto(tester, 'Continuar');
    expect(ubicacion(c), Rutas.codigo);
    expect(servicio.celularesEnviados, ['5512345678']);
    await _desmontar(tester, c);
  });

  testWidgets('sin google-services.json avisa que el SMS no está disponible', (
    tester,
  ) async {
    final c = await montarApp(
      tester,
      esTecnico: false,
      sesionIniciada: false,
      servicioEntrada: ServicioEntradaFalso()
        ..errorAlEnviar = const VerificacionNoDisponibleFailure(),
    );

    await _escribirCelular(tester);

    expect(
      find.text(
        'La verificación por SMS no está disponible en esta versión de la app.',
      ),
      findsOneWidget,
    );
    await _desmontar(tester, c);
  });

  final casos = <(Failure, String)>[
    (
      const CuentaSuspendidaFailure(),
      'Tu cuenta está suspendida. Si crees que es un error, escríbenos.',
    ),
    (
      const ConflictoFailure(),
      'Este número ya está ligado a otra cuenta. Escríbenos para revisarlo.',
    ),
    (
      const DatosRechazadosFailure(),
      'No pudimos procesar la entrada. Inténtalo otra vez.',
    ),
    (
      const DemasiadosIntentosFailure(),
      'Hiciste muchos intentos. Espera un momento y vuelve a intentarlo.',
    ),
    (
      const CodigoIncorrectoFailure(),
      'El código no es correcto. Revísalo e inténtalo otra vez.',
    ),
  ];
  for (final (error, mensaje) in casos) {
    testWidgets('al entrar con $error muestra «$mensaje» y no inicia sesión', (
      tester,
    ) async {
      final servicio = ServicioEntradaFalso()..errorAlVerificar = error;
      final c = await montarApp(
        tester,
        esTecnico: false,
        sesionIniciada: false,
        servicioEntrada: servicio,
      );
      await _escribirCelular(tester);
      await tester.enterText(find.byType(TextField), '123456');
      await tocarTexto(tester, 'Entrar');

      expect(find.text(mensaje), findsOneWidget);
      expect(ubicacion(c), Rutas.codigo);
      expect(c.read(sesionIniciadaProvider), isFalse);

      // Al volver a escribir, el mensaje se quita.
      await tester.enterText(find.byType(TextField), '12345');
      await tester.pump();
      expect(find.text(mensaje), findsNothing);
      await _desmontar(tester, c);
    });
  }

  testWidgets('con el canje correcto (201) entra a Inicio', (tester) async {
    final servicio = ServicioEntradaFalso();
    final c = await montarApp(
      tester,
      esTecnico: false,
      sesionIniciada: false,
      servicioEntrada: servicio,
    );
    await _escribirCelular(tester);
    await tester.enterText(find.byType(TextField), '123456');
    await tocarTexto(tester, 'Entrar');

    expect(servicio.codigosVerificados, ['123456']);
    expect(c.read(sesionIniciadaProvider), isTrue);
    expect(ubicacion(c), Rutas.inicio);
    await _desmontar(tester, c);
  });

  testWidgets('en inglés el error sale del ARB en inglés', (tester) async {
    final c = await montarApp(
      tester,
      esTecnico: false,
      sesionIniciada: false,
      servicioEntrada: ServicioEntradaFalso()
        ..errorAlEnviar = const DemasiadosIntentosFailure(),
    );
    c.read(preferenciasProvider.notifier).cambiarIdioma(const Locale('en'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '5512345678');
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tocarTexto(tester, 'Continue');

    expect(
      find.text(leerArb('en')['entradaErrorDemasiadosIntentos']!),
      findsOneWidget,
    );
    await _desmontar(tester, c);
  });
}
