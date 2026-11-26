// Spec 037 y 045: los servicios del técnico con datos reales. Solo datos
// ficticios.
import 'package:app/features/actividad/presentation/solicitudes_reales_controller.dart';
import 'package:app/features/maqueta/estado.dart' show maq;
import 'package:app/features/maqueta/servicios_reales.dart';
import 'package:app/features/tecnico/data/servicios_repository_api.dart';
import 'package:app/features/tecnico/tecnico.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/preparar_maqueta.dart';
import '../../soporte/servicios_json.dart';

Future<void> _montar(
  WidgetTester tester,
  ApiFalsa api,
  Widget hijo, {
  bool real = true,
  Locale locale = const Locale('es'),
  double texto = 1,
}) async {
  fijarPantalla(tester, tamano: tamanoMovil);
  maq.fijarOficios(['plo'], error: false);
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => Scaffold(body: SingleChildScrollView(child: hijo)),
      ),
      GoRoute(
        path: '/m/tecnico/registro',
        builder: (_, _) => const Text('alta de técnico'),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        conSesion(),
        solicitudesRealesActivasProvider.overrideWithValue(real),
        serviciosRepositoryProvider.overrideWithValue(
          ServiciosRepositoryApi(transporte: api.cliente, url: urlApiPrueba),
        ),
      ],
      child: MaterialApp.router(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(texto)),
          child: child!,
        ),
      ),
    ),
  );
  await asentarMaqueta(tester);
}

Future<void> _tocar(WidgetTester tester, String texto) async {
  await tester.ensureVisible(find.text(texto));
  await asentarMaqueta(tester);
  await tester.tap(find.text(texto));
  await asentarMaqueta(tester);
}

Future<void> _llenar(WidgetTester tester) async {
  await _tocar(tester, 'Agregar servicio');
  await tester.enterText(find.byType(TextField).at(0), 'Cambio de llave');
  await tester.enterText(find.byType(TextField).at(2), '250');
  await _tocar(tester, 'Plomería');
}

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('sin sesión o sin API se ve el ejemplo y no se llama nada', (
    tester,
  ) async {
    final api = ApiFalsa();
    await _montar(
      tester,
      api,
      const MisServiciosSegunSesion(ejemplo: Text('de ejemplo')),
      real: false,
    );

    expect(find.text('de ejemplo'), findsOneWidget);
    expect(api.peticiones, isEmpty);
  });

  testWidgets('CA_037_07 valida antes de enviar y conserva lo escrito si el '
      'servidor lo rechaza', (tester) async {
    final api = ApiFalsa(
      (_) => jsonOk({'code': 'service_limit_reached'}, estado: 409),
    );
    await _montar(tester, api, const MisServiciosReales());
    await _tocar(tester, 'Agregar servicio');
    await _tocar(tester, 'Guardar servicio');
    expect(find.text('Escribe el nombre del servicio'), findsOneWidget);
    expect(find.text('Elige el oficio'), findsOneWidget);
    expect(api.peticiones, isEmpty);
    await _tocar(tester, 'Cancelar');

    await _llenar(tester);
    await _tocar(tester, 'Guardar servicio');

    expect(find.textContaining('máximo de 50'), findsOneWidget);
    expect(find.text('Cambio de llave'), findsOneWidget);
  });

  testWidgets('CA_037_05 CA_037_11 agrega un servicio y lo quita', (
    tester,
  ) async {
    final api = ApiFalsa(
      (p) => p.metodo == 'POST'
          ? jsonOk(servicioJson('1', nombre: 'Cambio de llave'), estado: 201)
          : http.Response('', 204),
    );
    await _montar(tester, api, const MisServiciosReales());
    expect(find.textContaining('no podemos consultar'), findsOneWidget);

    await _llenar(tester);
    await _tocar(tester, 'Guardar servicio');
    expect(find.text('Desde \$250'), findsOneWidget);

    await _tocar(tester, 'Quitar');
    expect(find.text('Desde \$250'), findsNothing);
    expect(api.llamadas.last, 'DELETE tecnicos/me/servicios/1');
  });

  testWidgets('CA_037_10 ante not_a_technician no muestra datos y ofrece '
      'crear el perfil', (tester) async {
    final api = ApiFalsa(
      (_) => jsonOk({'code': 'not_a_technician'}, estado: 404),
    );
    await _montar(tester, api, const MisServiciosReales());
    await _llenar(tester);
    await _tocar(tester, 'Guardar servicio');

    expect(find.text('Todavía no tienes perfil de técnico.'), findsOneWidget);
    expect(find.text('Cambio de llave'), findsNothing);

    await _tocar(tester, 'Crear mi perfil de técnico');
    expect(find.text('alta de técnico'), findsOneWidget);
  });

  testWidgets('CA_037_15 error al guardar sin conexión conserva lo escrito', (
    tester,
  ) async {
    final api = ApiFalsa((_) => http.Response('', 503));
    await _montar(tester, api, const MisServiciosReales());
    await _llenar(tester);
    await _tocar(tester, 'Guardar servicio');

    expect(find.text('Cambio de llave'), findsOneWidget);
    expect(find.text('Guardar servicio'), findsOneWidget);
  });

  testWidgets('CA_037_14 CA_037_03 CA_037_04 el perfil del técnico: error, '
      'vacío, datos y copia sin conexión', (tester) async {
    var estado = 404;
    var items = <Object?>[];
    final api = ApiFalsa(
      (_) =>
          estado == 200 ? jsonOk({'items': items}) : http.Response('', estado),
    );
    await _montar(tester, api, const ServiciosDeTecnicoReal(tecnicoId: 't1'));
    expect(find.text('Ese técnico ya no está disponible.'), findsOneWidget);

    estado = 503;
    await _tocar(tester, 'Reintentar');
    expect(find.text('No pudimos cargar sus servicios.'), findsOneWidget);

    estado = 200;
    await _tocar(tester, 'Reintentar');
    expect(find.text('Todavía no publica servicios.'), findsOneWidget);

    items = [servicioJson('1')];
    await _tocar(tester, 'Reintentar');
    expect(find.text('Servicio 1'), findsOneWidget);
    expect(find.textContaining('Sin conexión'), findsNothing);
  });

  testWidgets('CA_037_04 sin conexión muestra la copia con su aviso', (
    tester,
  ) async {
    var falla = false;
    final api = ApiFalsa(
      (_) => falla
          ? http.Response('', 503)
          : jsonOk({
              'items': [servicioJson('1')],
            }),
    );
    await _montar(tester, api, const ServiciosDeTecnicoReal(tecnicoId: 't1'));
    final contenedor = ProviderScope.containerOf(
      tester.element(find.byType(ServiciosDeTecnicoReal)),
    );

    falla = true;
    contenedor.invalidate(serviciosDeTecnicoProvider('t1'));
    await asentarMaqueta(tester);

    expect(find.textContaining('puede estar desactualizada'), findsOneWidget);
    expect(find.text('Servicio 1'), findsOneWidget);
  });

  testWidgets('CA_037_17 los textos propios y del formulario salen del ARB en '
      'inglés', (tester) async {
    final api = ApiFalsa();
    await _montar(
      tester,
      api,
      const MisServiciosReales(),
      locale: const Locale('en'),
    );

    expect(find.text('Services and reference prices'), findsOneWidget);
    await _tocar(tester, 'Add service');
    expect(find.text('Service name'), findsOneWidget);
    expect(find.text('Reference price (pesos)'), findsOneWidget);
    expect(find.text('Which trade is it for?'), findsOneWidget);
    expect(find.text('Plumbing'), findsOneWidget);
    expect(find.text('Save service'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('CA_037_18 los controles tienen etiqueta y 48 dp, también con '
      'texto al 200 %', (tester) async {
    final semantica = tester.ensureSemantics();
    await _montar(tester, ApiFalsa(), const MisServiciosReales(), texto: 2);
    await _tocar(tester, 'Agregar servicio');

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    expect(tester.takeException(), isNull);
    semantica.dispose();
  });
}
