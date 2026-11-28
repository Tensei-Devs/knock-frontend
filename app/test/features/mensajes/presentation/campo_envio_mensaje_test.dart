import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/features/mensajes/domain/envio_de_mensajes.dart';
import 'package:app/features/mensajes/domain/mensaje.dart';
import 'package:app/features/mensajes/presentation/campo_envio_mensaje.dart';
import 'package:app/features/mensajes/presentation/envio_mensajes_controller.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _Envio implements EnvioDeMensajes {
  _Envio(this.responder);

  Future<Mensaje> Function(String texto) responder;
  final textos = <String>[];

  @override
  Future<Mensaje> enviar(String conversacionId, String texto) {
    textos.add(texto);
    return responder(texto);
  }
}

Mensaje _guardado(String texto, {bool contactoOculto = false}) => Mensaje(
  id: 'm-1',
  autorRol: 'cliente',
  texto: texto,
  contactoOculto: contactoOculto,
  enviadoEn: DateTime.utc(2026, 11, 27, 12),
);

Future<EnvioMensajesController> _montar(
  WidgetTester tester,
  _Envio envio, {
  bool cerrada = false,
}) async {
  final controller = EnvioMensajesController(envio, 'c1', cerrada: cerrada);
  addTearDown(controller.dispose);
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: CampoEnvioMensaje(controller: controller)),
    ),
  );
  return controller;
}

Future<void> _escribirYEnviar(WidgetTester tester, String texto) async {
  await tester.enterText(find.byType(TextField), texto);
  await tester.pump();
  await tester.tap(find.byTooltip('Enviar'));
  await tester.pump();
}

void main() {
  testWidgets('CA_020_E02 envía, muestra pendiente y luego el '
      'mensaje con contacto oculto', (tester) async {
    final respuesta = Completer<Mensaje>();
    final envio = _Envio((_) => respuesta.future);
    await _montar(tester, envio);
    await _escribirYEnviar(tester, 'Mi número es 5550000000');
    expect(find.text('Enviando…'), findsOneWidget);
    respuesta.complete(_guardado('Mi número es ***', contactoOculto: true));
    await tester.pump();
    expect(find.text('Mi número es ***'), findsOneWidget);
    expect(find.text('Mi número es 5550000000'), findsNothing);
    expect(
      find.text(
        'El número se comparte al elegir una cotización; te sugerimos no '
        'compartirlo antes.',
      ),
      findsOneWidget,
    );
    expect(envio.textos, ['Mi número es 5550000000']);
  });

  final casos = <String, (Failure, String)>{
    'content_rejected': (
      const ContenidoRechazadoFailure(),
      'No pudimos enviar ese mensaje. Revisa lo que escribiste.',
    ),
    'message_limit': (
      const DemasiadosIntentosFailure(espera: Duration(seconds: 42)),
      'Enviaste muchos mensajes. Espera 42 segundos.',
    ),
    'moderation_unavailable': (
      const ModeracionNoDisponibleFailure(),
      'No pudimos enviar el mensaje. Intenta de nuevo en un momento.',
    ),
    'market_unavailable': (
      const ServicioNoDisponibleFailure(),
      'No pudimos enviar el mensaje. Intenta de nuevo en un momento.',
    ),
  };
  for (final MapEntry(key: code, value: (falla, texto)) in casos.entries) {
    testWidgets('CA_020_E02 $code conserva el texto, muestra el error y no '
        'reintenta sola', (tester) async {
      final envio = _Envio((_) => Future.error(falla));
      await _montar(tester, envio);
      await _escribirYEnviar(tester, 'Hola técnico');
      await tester.pump();
      expect(find.text(texto), findsOneWidget);
      expect(find.text('Hola técnico'), findsOneWidget);
      expect(find.text('No se envió'), findsOneWidget);
      await tester.pump(const Duration(minutes: 1));
      expect(envio.textos, hasLength(1));

      envio.responder = (t) async => _guardado(t);
      await tester.tap(find.text('Reintentar'));
      await tester.pump();
      expect(envio.textos, ['Hola técnico', 'Hola técnico']);
      expect(find.text('No se envió'), findsNothing);
    });
  }

  testWidgets('CA_020_E02 409 conversation_closed quita el campo', (
    tester,
  ) async {
    final envio = _Envio((_) => Future.error(const ConflictoFailure()));
    await _montar(tester, envio);
    await _escribirYEnviar(tester, 'Hola');
    await tester.pump();
    expect(find.text('La conversación está cerrada.'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(find.text('Reintentar'), findsNothing);
  });

  testWidgets('CA_020_E02 conversación cerrada no tiene campo', (tester) async {
    await _montar(tester, _Envio((t) async => _guardado(t)), cerrada: true);
    expect(find.byType(TextField), findsNothing);
    expect(find.text('La conversación está cerrada.'), findsOneWidget);
  });

  testWidgets('CA_020_E02 vacío o demasiado largo no se puede enviar', (
    tester,
  ) async {
    final envio = _Envio((t) async => _guardado(t));
    await _montar(tester, envio);
    IconButton boton() => tester.widget(find.byType(IconButton));
    expect(boton().onPressed, isNull);
    await tester.enterText(find.byType(TextField), 'a' * 1001);
    await tester.pump();
    expect(boton().onPressed, isNull);
    expect(
      find.text('El mensaje admite hasta 1000 caracteres.'),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextField), 'a\tb');
    await tester.pump();
    expect(boton().onPressed, isNull);
    expect(envio.textos, isEmpty);
  });
}
