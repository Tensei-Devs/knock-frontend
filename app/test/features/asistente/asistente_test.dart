// Spec 042: asistente de IA. Solo datos ficticios.
import 'package:app/core/cache/almacen_cache.dart';
import 'package:app/core/config/asistente_ia.dart';
import 'package:app/core/errores/failure.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/features/actividad/actividad.dart'
    show solicitudesRealesActivasProvider;
import 'package:app/features/asistente/asistente.dart';
import 'package:app/features/asistente/data/asistente_repository_api.dart';
import 'package:app/features/maqueta/asistente_real.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/accesibilidad.dart';
import '../../soporte/api_falsa.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/preparar_maqueta.dart';

Map<String, Object?> _turno({String origen = 'proveedor'}) => {
  'categoria': 'plomeria',
  'mensaje': 'Respuesta ficticia',
  'pideFoto': true,
  'seguridad': 'Cierra la llave',
  'origen': origen,
  'generadoPorIa': true,
};

const _resumen = {
  'sabe': ['Gotea'],
  'porConfirmar': <String>[],
  'queLlevar': ['Cinta'],
  'origen': 'proveedor',
  'generadoPorIa': true,
};

const _borrador = {
  'precioSugerido': 350,
  'tiempoEstimado': '1 hora',
  'dia': 'Lunes',
  'nota': 'Nota ficticia',
  'explicacion': 'Según la conversación',
  'origen': 'plantilla',
  'generadoPorIa': true,
};

const _rango = {
  'minimo': 200,
  'maximo': '400',
  'muestras': 8,
  'fuente': 'mercado',
};

const _bitacora = {
  'solicitudId': 's-1',
  'sabe': ['Gotea'],
  'porConfirmar': <String>[],
  'queLlevar': <String>[],
  'actualizadaEn': '2026-11-26T10:00:00Z',
};

AsistenteRepositoryApi _repo(ApiFalsa api, [AlmacenCache? cache]) =>
    AsistenteRepositoryApi(
      transporte: api.transporte,
      url: urlApiPrueba,
      cache: cache ?? AlmacenCacheEnMemoria(),
    );

Future<void> _montar(
  WidgetTester tester,
  ApiFalsa api,
  Widget hijo, {
  String idioma = 'es',
  List<Override> extra = const [],
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        conSesion(),
        asistenteRepositoryProvider.overrideWithValue(_repo(api)),
        ...extra,
      ],
      child: MaterialApp(
        locale: Locale(idioma),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: SingleChildScrollView(child: hijo)),
      ),
    ),
  );
  await asentarMaqueta(tester);
}

void main() {
  prepararPruebasDeMaqueta();
  final es = leerArb('es');

  group('repositorio', () {
    test('CA_042_01 turno: cuerpo y campos del contrato', () async {
      final api = ApiFalsa((_) => jsonOk(_turno()));
      final r = await _repo(api).turno('Hay una fuga');
      expect(api.llamadas, ['POST asistente/conversaciones']);
      expect(api.peticiones.single.json, {
        'mensaje': 'Hay una fuga',
        'foto': null,
        'contexto': null,
      });
      expect(r.deIa, isTrue);
      expect(r.pideFoto, isTrue);
    });

    test('CA_042_04 resumen y borrador; la plantilla no es IA', () async {
      final api = ApiFalsa(
        (p) => jsonOk(p.ruta.endsWith('resumen-chat') ? _resumen : _borrador),
      );
      expect((await _repo(api).resumir('c-1')).queLlevar, ['Cinta']);
      final b = await _repo(api).borrador('c-1');
      expect(b.precioSugerido, 350);
      expect(b.deIa, isFalse);
      expect(api.llamadas, [
        'POST asistente/resumen-chat',
        'POST asistente/borrador-cotizacion',
      ]);
    });

    test('CA_042_13 rango: sin conexión entrega la copia con fecha', () async {
      var falla = false;
      final api = ApiFalsa(
        (_) => falla ? http.Response('', 502) : jsonOk(_rango),
      );
      final repo = _repo(api);
      final r = await repo.rango('plomeria', 'fijo');
      expect((r!.minimo, r.maximo, r.copiaDel), (200, 400, null));
      expect(api.peticiones.single.url.queryParameters, {
        'oficio': 'plomeria',
        'tipoTrabajo': 'fijo',
      });
      falla = true;
      expect((await repo.rango('plomeria', 'fijo'))!.copiaDel, isNotNull);
      await expectLater(
        repo.rango('electricidad', 'fijo'),
        throwsA(isA<ServicioNoDisponibleFailure>()),
      );
    });

    test('CA_042_17 bitácora: 404 es vacío y PUT guarda', () async {
      final api = ApiFalsa(
        (p) => p.metodo == 'GET'
            ? http.Response('{"code":"log_not_found"}', 404)
            : jsonOk(_bitacora, estado: 201),
      );
      expect(await _repo(api).bitacora('s-1'), isNull);
      final b = await _repo(api).guardarBitacora(
        's-1',
        const Bitacora(sabe: ['Gotea'], porConfirmar: [], queLlevar: []),
      );
      expect(b.actualizadaEn, isNotNull);
      expect(api.llamadas.last, 'PUT asistente/bitacora/s-1');
    });

    test('CA_042_03 401, 403, 429 y 503 llegan como Failure', () async {
      for (final (estado, tipo) in [
        (401, isA<NoAutorizadoFailure>()),
        (403, isA<AccesoDenegadoFailure>()),
        (429, isA<DemasiadosIntentosFailure>()),
        (503, isA<AsistenteNoDisponibleFailure>()),
      ]) {
        final api = ApiFalsa((_) => http.Response('', estado));
        await expectLater(_repo(api).turno('x'), throwsA(tipo));
      }
    });
  });

  testWidgets('CA_042_03 el controlador conserva lo escrito ante el límite', (
    tester,
  ) async {
    var estado = 429;
    final api = ApiFalsa(
      (_) => estado == 200 ? jsonOk(_turno()) : http.Response('', estado),
    );
    await _montar(
      tester,
      api,
      const SizedBox(height: 700, child: AsistenteChatReal()),
    );
    expect(find.text(es['asistenteSinTurno']!), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Hay una fuga');
    await tester.tap(find.text(es['asistenteEnviar']!));
    await asentarMaqueta(tester);
    expect(find.text(es['asistenteLimite']!), findsOneWidget);
    expect(find.text('Hay una fuga'), findsOneWidget);
  });

  testWidgets('CA_042_20 turno de IA y de plantilla se distinguen', (
    tester,
  ) async {
    var origen = 'proveedor';
    final api = ApiFalsa((_) => jsonOk(_turno(origen: origen)));
    await _montar(
      tester,
      api,
      const SizedBox(height: 700, child: AsistenteChatReal(texto: 'Fuga')),
    );
    await tester.tap(find.text(es['asistenteEnviar']!));
    await asentarMaqueta(tester);
    expect(find.text(es['asistenteGeneradoPorIa']!), findsOneWidget);
    origen = 'plantilla';
    await tester.tap(find.text(es['asistenteEnviar']!));
    await asentarMaqueta(tester);
    expect(find.text(es['asistenteDePlantilla']!), findsOneWidget);
    expect(find.text(es['asistenteGeneradoPorIa']!), findsNothing);
  });

  testWidgets('CA_042_21 resumen: no disponible, reintentar y datos', (
    tester,
  ) async {
    var falla = true;
    final api = ApiFalsa(
      (_) => falla ? http.Response('', 503) : jsonOk(_resumen),
    );
    await _montar(tester, api, const ResumenReal('c-1'));
    expect(find.text(es['asistenteNoDisponible']!), findsOneWidget);
    falla = false;
    await tester.tap(find.text(es['asistenteReintentar']!));
    await asentarMaqueta(tester);
    expect(find.text('• Gotea'), findsOneWidget);
  });

  testWidgets('CA_042_22 borrador editable y rango en inglés', (tester) async {
    final api = ApiFalsa(
      (p) => jsonOk(p.metodo == 'GET' ? _rango : _borrador),
    );
    await _montar(
      tester,
      api,
      const Column(
        children: [
          BorradorReal('c-1'),
          RangoReal((oficio: 'plomeria', tipoTrabajo: 'fijo')),
        ],
      ),
      idioma: 'en',
    );
    expect(find.byType(TextField), findsNWidgets(4));
    expect(find.text('From 200 to 400 MXN'), findsOneWidget);
    expect(find.text(leerArb('en')['asistenteDePlantilla']!), findsOneWidget);
  });

  testWidgets('CA_042_24 bitácora vacía se guarda y cumple accesibilidad', (
    tester,
  ) async {
    fijarPantalla(tester, escalaDeTexto: 2);
    final api = ApiFalsa(
      (p) => p.metodo == 'GET'
          ? http.Response('', 404)
          : jsonOk(_bitacora, estado: 201),
    );
    await _montar(tester, api, const BitacoraReal('s-1'));
    expect(find.text(es['asistenteBitacoraVacia']!), findsOneWidget);
    await cumpleAccesibilidad(tester);
    await tester.enterText(find.byType(TextField).first, 'Gotea\n\n');
    await tester.ensureVisible(find.text(es['asistenteGuardar']!));
    await tester.tap(find.text(es['asistenteGuardar']!));
    await asentarMaqueta(tester);
    expect(api.peticiones.last.json['sabe'], ['Gotea']);
    expect(find.text(es['asistenteGuardada']!), findsOneWidget);
  });

  group('interruptor', () {
    test('CA_042_20 viene apagado de compilación', () {
      expect(asistenteIaDeCompilacion, isFalse);
    });

    for (final encendido in [false, true]) {
      testWidgets('CA_042_20 rutas con el interruptor en $encendido', (
        tester,
      ) async {
        fijarPantalla(tester, tamano: tamanoMovil);
        final api = ApiFalsa((_) => jsonOk(_resumen));
        final container = await montarApp(
          tester,
          esTecnico: true,
          maqueta: true,
          extra: [
            solicitudesRealesActivasProvider.overrideWithValue(true),
            asistenteIaActivoProvider.overrideWithValue(encendido),
            asistenteRepositoryProvider.overrideWithValue(_repo(api)),
          ],
        );
        final router = container.read(appRouterProvider)
          ..go('/m/tecnico/asistente/resumen/c-1');
        await asentarMaqueta(tester);
        expect(
          find.text(es['asistenteNoDisponible']!),
          encendido ? findsNothing : findsOneWidget,
        );
        expect(api.peticiones, hasLength(encendido ? 1 : 0));
        router.go('/m/asistente');
        await asentarMaqueta(tester);
        expect(
          find.byType(AsistenteChatReal),
          encendido ? findsOneWidget : findsNothing,
        );
        expect(
          find.textContaining(es['asistenteEjemplo']!),
          encendido ? findsNothing : findsOneWidget,
        );
      });
    }
  });
}
