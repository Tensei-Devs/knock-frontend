// Spec 047: la pantalla de la conversación. Solo datos ficticios.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/maqueta/boton_conversacion.dart';
import 'package:app/features/maqueta/conversacion_real.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/mensajes/mensajes.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../soporte/conversacion_falsa.dart';
import '../../../soporte/mensajes_falsos.dart';
import '../../../soporte/pantalla_maqueta.dart';

class _GloboCaido extends GloboController {
  @override
  EstadoGlobo build() => const EstadoGlobo(sinConexion: true);

  @override
  Future<void> reintentar() async {}
}

Future<void> _montar(
  WidgetTester tester,
  ConversacionFalsa api, {
  String? tecnicoId,
  Locale idioma = const Locale('es'),
  Widget? inicio,
  GloboController Function()? globo,
}) async {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) =>
            inicio ??
            ConversacionReal(conversacionId: 'c1', tecnicoId: tecnicoId),
      ),
      GoRoute(
        path: '/conversaciones/:id',
        builder: (_, s) => Scaffold(body: Text('abierta ${s.uri}')),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        lecturaDeConversacionProvider.overrideWithValue(api),
        envioDeMensajesProvider.overrideWithValue(api),
        conversacionesRepositoryProvider.overrideWithValue(
          ConversacionesDePrueba(),
        ),
        canalMensajesProvider.overrideWithValue(CanalDePrueba()),
        if (globo != null) globoProvider.overrideWith(globo),
      ],
      child: MaterialApp.router(
        locale: idioma,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  late ConversacionFalsa api;

  setUp(() {
    api = ConversacionFalsa()
      ..primera = [
        mensajeFalso(2, autorRol: 'cliente', texto: 'Mañana a las diez'),
        mensajeFalso(1, texto: '¿Qué día le acomoda?'),
      ];
  });

  testWidgets('CA_047_03 muestra contraparte, servicio, aviso y los mensajes '
      'en orden, con el autor escrito', (tester) async {
    await _montar(tester, api);
    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('Plomería'), findsOneWidget);
    expect(find.text('No pagues por adelantado.'), findsOneWidget);
    final antiguo = find.text('¿Qué día le acomoda?');
    final reciente = find.text('Mañana a las diez');
    expect(
      tester.getTopLeft(antiguo).dy,
      lessThan(tester.getTopLeft(reciente).dy),
    );
    expect(find.textContaining('Tú · '), findsOneWidget);
    expect(find.textContaining('Ana · '), findsOneWidget);
  });

  testWidgets('CA_047_04 al pedir anteriores usa el cursor sin '
      'duplicar', (tester) async {
    api.siguiente = 'p2';
    api.anteriores['p2'] = PaginaDeMensajes(
      items: [
        mensajeFalso(1),
        mensajeFalso(0, texto: 'El primero'),
      ],
    );
    await _montar(tester, api);
    await tester.tap(find.text('Ver mensajes anteriores'));
    await tester.pumpAndSettle();
    expect(find.text('El primero'), findsOneWidget);
    expect(api.cursores, [null, 'p2']);
  });

  testWidgets('CA_047_05 envía lo escrito y vacía el campo', (tester) async {
    await _montar(tester, api);
    await tester.enterText(find.byType(TextField), 'Sí, está bien');
    await tester.pump();
    await tester.tap(find.byTooltip('Enviar'));
    await tester.pumpAndSettle();
    expect(api.enviados, ['Sí, está bien']);
    expect(find.text('Sí, está bien'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      isEmpty,
    );
  });

  testWidgets('CA_047_06 una falla conserva lo escrito y no reintenta '
      'sola', (tester) async {
    api.errorAlEnviar = const ModeracionNoDisponibleFailure();
    await _montar(tester, api);
    await tester.enterText(find.byType(TextField), 'Hola');
    await tester.pump();
    await tester.tap(find.byTooltip('Enviar'));
    await tester.pumpAndSettle();
    expect(find.text('Hola'), findsOneWidget);
    expect(
      find.text(
        'No pudimos enviar el mensaje. Intenta de nuevo en un momento.',
      ),
      findsOneWidget,
    );
    expect(api.enviados, ['Hola']);
  });

  testWidgets('CA_047_08 avisa cuando el servidor ocultó un '
      'contacto', (tester) async {
    api.primera = [mensajeFalso(1, contactoOculto: true)];
    await _montar(tester, api);
    expect(
      find.text(
        'El número se comparte al elegir una cotización; te sugerimos no '
        'compartirlo antes.',
      ),
      findsOneWidget,
    );
  });

  const cierres = {
    'request_cancelled':
        'La solicitud se canceló; la conversación está '
        'cerrada.',
    'request_expired': 'La solicitud venció; la conversación está cerrada.',
    'other_quote_chosen':
        'Se eligió otra cotización; la conversación está '
        'cerrada.',
    'dismissed': 'La solicitud se descartó; la conversación está cerrada.',
    'service_finished': 'La conversación está cerrada.',
  };
  for (final MapEntry(key: motivo, value: texto) in cierres.entries) {
    testWidgets('CA_047_09 cerrada por $motivo: se lee, sin campo ni '
        'respuestas rápidas', (tester) async {
      api.actual = detalleFalso(estado: 'cerrada', motivoCierre: motivo);
      await _montar(tester, api);
      expect(find.text(texto), findsOneWidget);
      expect(find.text('Mañana a las diez'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
      expect(find.byType(ActionChip), findsNothing);
    });
  }

  testWidgets('CA_047_12 con el canal caído lo dice, «Actualizar» relee y se '
      'puede enviar', (tester) async {
    await _montar(tester, api, globo: _GloboCaido.new);
    expect(find.text('Sin conexión en vivo'), findsOneWidget);
    final antes = api.cursores.length;
    await tester.tap(find.text('Actualizar'));
    await tester.pumpAndSettle();
    expect(api.cursores.length, antes + 1);
    await tester.enterText(find.byType(TextField), 'Sigo aquí');
    await tester.pump();
    await tester.tap(find.byTooltip('Enviar'));
    await tester.pumpAndSettle();
    expect(api.enviados, ['Sigo aquí']);
  });

  testWidgets('CA_047_13 una ajena o inexistente solo dice que no está '
      'disponible', (tester) async {
    api.errorDeLectura = const NoEncontradoFailure();
    await _montar(tester, api);
    expect(find.text('Esta conversación ya no está disponible.'), findsOne);
    expect(find.byType(TextField), findsNothing);
  });

  final porRol = {
    'técnico': (detalleFalso(rol: 'tecnico'), 'Llevo los materiales'),
    'cliente sin visita': (detalleFalso(), '¿Cuándo puede venir?'),
    'cliente con visita': (
      detalleFalso(visitaId: 'v1'),
      '¿Ya viene en camino?',
    ),
  };
  for (final MapEntry(key: caso, value: (detalle, rapida)) in porRol.entries) {
    testWidgets('CA_047_14 respuestas rápidas de $caso se envían como un '
        'mensaje', (tester) async {
      api.actual = detalle;
      await _montar(tester, api);
      await tester.ensureVisible(find.text(rapida));
      await tester.pumpAndSettle();
      await tester.tap(find.text(rapida));
      await tester.pumpAndSettle();
      expect(api.enviados, [rapida]);
    });
  }

  testWidgets('CA_047_15 sin técnico conocido ni visita no hay menú', (
    tester,
  ) async {
    await _montar(tester, api);
    expect(find.byTooltip('Más opciones'), findsNothing);
  });

  testWidgets('CA_047_15 el cliente con visita puede reportar y bloquear; el '
      'perfil solo con técnico conocido', (tester) async {
    api.actual = detalleFalso(visitaId: 'v1');
    await _montar(tester, api);
    await tester.tap(find.byTooltip('Más opciones'));
    await tester.pumpAndSettle();
    expect(find.text('Reportar'), findsOneWidget);
    expect(find.text('Bloquear'), findsOneWidget);
    expect(find.text('Ver su perfil'), findsNothing);
  });

  testWidgets('CA_047_15 el técnico no tiene menú', (tester) async {
    api.actual = detalleFalso(rol: 'tecnico', visitaId: 'v1');
    await _montar(tester, api, tecnicoId: 't1');
    expect(find.byTooltip('Más opciones'), findsNothing);
  });

  testWidgets('CA_047_17 cabe al 200 % en 320 × 640, con controles de 48 dp '
      'y cada mensaje leído junto', (tester) async {
    fijarPantalla(tester, escalaDeTexto: 2);
    final semantica = tester.ensureSemantics();
    api.actual = detalleFalso(visitaId: 'v1');
    await _montar(tester, api);
    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    expect(
      find.bySemanticsLabel(RegExp(r'Tú · .+\s+Mañana a las diez')),
      findsOneWidget,
    );
    semantica.dispose();
  });

  testWidgets('CA_047_17 en inglés los textos salen del ARB', (tester) async {
    api.primera = [];
    await _montar(tester, api, idioma: const Locale('en'));
    expect(find.text('Write the first message.'), findsOneWidget);
    expect(find.text('How long does it take?'), findsOneWidget);
  });

  testWidgets('CA_047_01 «Preguntar» abre la conversación del técnico y entra '
      'en ella', (tester) async {
    await _montar(
      tester,
      api,
      inicio: const Scaffold(
        body: BotonConversacion(
          etiqueta: 'Preguntar',
          solicitudId: 's1',
          tecnicoId: 't1',
          kind: Bk.ghost,
        ),
      ),
    );
    await tester.tap(find.text('Preguntar'));
    await tester.pumpAndSettle();
    expect(api.aperturas, [(solicitudId: 's1', tecnicoId: 't1')]);
    expect(find.text('abierta /conversaciones/c1?tecnico=t1'), findsOneWidget);
  });

  testWidgets('CA_047_01 si no se puede abrir, lo dice y no '
      'navega', (tester) async {
    api.errorAlAbrir = const ConflictoFailure();
    await _montar(
      tester,
      api,
      inicio: const Scaffold(
        body: BotonConversacion(etiqueta: 'Chatear', solicitudId: 's1'),
      ),
    );
    await tester.tap(find.text('Chatear'));
    await tester.pump();
    expect(find.text('La conversación está cerrada.'), findsOneWidget);
    expect(find.textContaining('abierta /'), findsNothing);
  });
}
