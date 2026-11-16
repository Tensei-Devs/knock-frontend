// Spec 045 (KNOCK-273): la maqueta solo existe con `MODO_MAQUETA`. Los dos
// modos se verifican por separado: encendido muestra las pantallas de
// demostración con el rótulo de datos de ejemplo; apagado, nada de eso.
import 'package:app/core/config/modo_maqueta.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/mapa_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../soporte/fuente_nunito.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';

/// Ruta de la maqueta y un texto que identifica su contenido.
const _pantallas = <(String, String)>[
  ('/inicio', '7 expertos cerca de ti'),
  ('/explorar', 'Busca un experto cerca de ti'),
  ('/actividad', 'El boiler no enciende'),
  ('/trabajo', 'Estás disponible hoy'),
  ('/cuenta', 'Mi casa y mi auto'),
  ('/cuenta/configuracion', 'Preferencias'),
  ('/m/buscar', 'Plomería'),
  ('/m/experto/rm', 'Ricardo Mendoza'),
  ('/m/experto/rm/opiniones', '87 opiniones'),
  ('/m/asistente', 'Asistente Knock'),
  ('/m/solicitar', '¿Qué necesitas arreglar?'),
  ('/m/enviada/j1', 'Tu solicitud va en camino'),
  ('/m/comparar/j1', 'Cotizaciones'),
  ('/m/visita/j3', 'Tu código para cuando llegue'),
  ('/m/cita/j2', 'Cita en taller'),
  ('/m/calificar/j4', 'Califica el servicio'),
  ('/m/reportar/j4', 'Reportar un problema'),
  ('/m/compartir/j3', 'Avisar a alguien'),
  ('/m/mensajes', 'Mensajes'),
  ('/m/chat/rm', 'En línea · responde en ~12 min'),
  ('/m/mi-casa', 'Mi casa y mi auto'),
  ('/m/confianza', 'Mis técnicos de confianza'),
  ('/m/avisos', 'Sin avisos por ahora'),
  ('/m/avisos-config', 'Qué avisos recibir'),
  ('/m/aviso-privacidad', 'Aviso de privacidad'),
  ('/m/terminos', 'Términos y condiciones'),
  ('/m/privacidad', 'Descargar mis datos'),
  ('/m/eliminar/1', 'Antes de irte, esto es lo que pasa'),
  ('/m/eliminar/2', '¿Seguro que quieres eliminar tu cuenta?'),
  ('/m/eliminado', 'Tu cuenta fue eliminada'),
  ('/m/ayuda?t=1', '¿Sobre qué tienes dudas?'),
  ('/m/sin-conexion', 'No hay internet'),
  ('/m/tecnico/registro', 'Crea tu cuenta de técnico'),
  ('/m/tecnico/verificacion', 'Verifica tu identidad'),
  ('/m/tecnico/pendiente', 'Estamos revisando tus documentos'),
  ('/m/tecnico/verificado', 'Ya estás verificado'),
  ('/m/tecnico/rechazada', 'No pudimos verificarte'),
  ('/m/tecnico/mensajes', 'Mensajes de clientes'),
  ('/m/tecnico/chat/ml/r1', 'Mariana L.'),
  ('/m/tecnico/cotizar/r1', 'Cotización'),
  ('/m/tecnico/iniciar/vr1', 'Iniciar trabajo'),
  ('/m/tecnico/cerrar/vr1', 'Terminar servicio'),
  ('/m/tecnico/perfil', 'Tu perfil público'),
  ('/m/tecnico/reputacion', 'Mi reputación'),
];

const _tamano = Size(412, 892);

/// Una ruta raíz del router con ese `path` (p. ej. `/m`).
bool _tieneRutaRaiz(GoRouter router, String ruta) =>
    router.configuration.routes.whereType<GoRoute>().any((r) => r.path == ruta);

Future<void> _asentar(WidgetTester tester) => tester.pumpAndSettle(
  const Duration(milliseconds: 100),
  EnginePhase.sendSemanticsUpdate,
  const Duration(seconds: 3),
);

void main() {
  setUpAll(cargarNunito);

  setUp(() {
    usarMapaReal = false;
    maq.resetAll();
    maq.loadDemo();
    maq.pv.seedDemo();
  });
  tearDown(() {
    usarMapaReal = true;
    maq.resetAll();
  });

  final rotulo = leerArb('es')['previaDatosDeEjemplo']!;

  group('CA_045_01 modo maqueta encendido', () {
    for (final (ruta, texto) in _pantallas) {
      testWidgets('CA_045_01 $ruta abre con su contenido y el rótulo', (
        tester,
      ) async {
        fijarPantalla(tester, tamano: _tamano);
        final container = await montarApp(
          tester,
          esTecnico: true,
          extra: [modoMaquetaProvider.overrideWithValue(true)],
        );
        container.read(appRouterProvider).go(ruta);
        await _asentar(tester);
        expect(find.textContaining(texto), findsWidgets, reason: ruta);
        // CA_045_03: el rótulo fijo de datos de ejemplo no se oculta.
        expect(find.text(rotulo), findsOneWidget, reason: ruta);
      });
    }

    testWidgets('CA_045_01 la barra inferior lleva a Mi cuenta de la maqueta', (
      tester,
    ) async {
      fijarPantalla(tester, tamano: _tamano);
      await montarApp(
        tester,
        esTecnico: false,
        extra: [modoMaquetaProvider.overrideWithValue(true)],
      );
      await tester.tap(find.text(leerArb('es')['tabCuenta']!));
      await _asentar(tester);
      expect(find.text('Mi casa y mi auto'), findsOneWidget);
    });
  });

  group('CA_045_02 modo maqueta apagado (por defecto)', () {
    test('CA_045_02 la bandera viene apagada de compilación', () {
      expect(modoMaquetaDeCompilacion, isFalse);
    });

    testWidgets('CA_045_02 no hay rutas de la maqueta ni rótulo de ejemplo', (
      tester,
    ) async {
      fijarPantalla(tester, tamano: _tamano);
      final container = await montarApp(tester, esTecnico: false);
      final router = container.read(appRouterProvider);
      expect(_tieneRutaRaiz(router, '/m'), isFalse);
      expect(find.text(rotulo), findsNothing);
      router.go('/m/buscar');
      await tester.pumpAndSettle();
      expect(find.textContaining('Ej.: boiler'), findsNothing);
    });

    testWidgets('CA_045_02 Inicio y Mi cuenta son los de siempre', (
      tester,
    ) async {
      fijarPantalla(tester, tamano: _tamano);
      final container = await montarApp(tester, esTecnico: false);
      expect(find.text('7 expertos cerca de ti'), findsNothing);
      container.read(appRouterProvider).go(Rutas.cuenta);
      await tester.pumpAndSettle();
      expect(find.text('Mi casa y mi auto'), findsNothing);
    });
  });

  group('CA_045_05 sesión y rutas protegidas en modo maqueta', () {
    testWidgets(
      'CA_045_05 sin sesión, una ruta que pide cuenta lleva a la previa y las '
      'públicas se ven',
      (tester) async {
        fijarPantalla(tester, tamano: _tamano);
        final container = await montarApp(
          tester,
          esTecnico: false,
          sesionIniciada: false,
          abrirEnEntrada: false,
          extra: [modoMaquetaProvider.overrideWithValue(true)],
        );
        final router = container.read(appRouterProvider);
        router.go('/m/solicitar');
        await _asentar(tester);
        expect(
          router.state.matchedLocation,
          Rutas.previa,
          reason: 'pedir cotización exige cuenta',
        );
        router.go('/m/buscar');
        await _asentar(tester);
        expect(router.state.matchedLocation, '/m/buscar');
      },
    );
  });

  group('CA_045_05 rutas de la maqueta en las reglas de rutas', () {
    test(
      'CA_045_05 sin la bandera, /m/... no es pública ni destino válido',
      () {
        expect(esRutaPublica('/m/buscar'), isFalse);
        expect(destinoValidoODescartar('/m/buscar'), isNull);
        expect(destinoDeRegreso('/m/buscar'), Rutas.inicio);
        expect(
          redireccionPorSesion(sesionIniciada: false, ubicacion: '/m/buscar'),
          Rutas.previa,
        );
      },
    );

    test('CA_045_05 con la bandera, solo las públicas y los destinos /m/', () {
      expect(esRutaPublica('/m/buscar', maqueta: true), isTrue);
      expect(esRutaPublica('/m/solicitar', maqueta: true), isFalse);
      expect(
        destinoValidoODescartar('/m/chat/rm', maqueta: true),
        '/m/chat/rm',
      );
      // La validación de siempre sigue: nada de `//`, `..` ni otros sitios.
      expect(destinoValidoODescartar('//otro.com', maqueta: true), isNull);
      expect(destinoValidoODescartar('/m/../x', maqueta: true), isNull);
      expect(destinoValidoODescartar('https://x.com', maqueta: true), isNull);
    });
  });
}
