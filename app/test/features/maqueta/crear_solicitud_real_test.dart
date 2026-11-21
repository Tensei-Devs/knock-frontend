// KNOCK-288: «Enviar solicitud» de la app crea la solicitud en el servidor
// (`POST /solicitudes`, spec 015 y backend 020) cuando hay sesión y API. Las
// fotos no se suben (el módulo de archivos no está desplegado). Sin API sigue
// el flujo de datos de ejemplo.
import 'dart:async';

import 'package:app/core/router/app_router.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/data/solicitud_repository_api.dart';
import 'package:app/features/actividad/presentation/solicitudes_reales_controller.dart';
import 'package:app/features/inicio/data/zonas_repository_http.dart';
import 'package:app/features/inicio/inicio_providers.dart';
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/estado.dart' show maq;
import 'package:app/features/oficios/oficios.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/preparar_maqueta.dart';
import '../../soporte/solicitud_falsa.dart';

const _coloniaId = 'c0c0c0c0c0c0c0c0c0c0c0c0';
const _solicitudId = 'b0b0b0b0b0b0b0b0b0b0b0b0';

Map<String, Object?> _zona() => {
  'enCobertura': true,
  'ciudadPiloto': true,
  'colonias': [
    {
      'id': 'a0a0a0a0a0a0a0a0a0a0a0a0',
      'nombre': 'Col. Otra',
      'cp': '42800',
      'municipio': 'Tula de Allende',
    },
    {
      'id': _coloniaId,
      'nombre': 'Col. Centro',
      'cp': '42800',
      'municipio': 'Tula de Allende',
    },
  ],
};

Map<String, Object?> _creada() => {
  'id': _solicitudId,
  'estado': 'enviada',
  'modalidad': 'domicilio',
  'oficio': {'clave': 'plo', 'nombre': 'Plomería'},
  'colonia': {'id': _coloniaId, 'nombre': 'Col. Centro', 'cp': '42800'},
  'descripcion': 'Gotea la llave del baño',
  'fotos': <Object?>[],
  'dia': '2026-11-20',
  'franja': 'manana',
  'direccion': 'Calle Jacarandas 45',
  'totalCotizaciones': 0,
  'venceEn': '2026-11-22T18:00:00Z',
  'creadoEn': '2026-11-20T18:00:00Z',
};

Map<String, Object?> _fila() => {
  'id': _solicitudId,
  'estado': 'enviada',
  'oficioNombre': 'Plomería',
  'coloniaNombre': 'Col. Centro',
  'dia': '2026-11-20',
  'franja': 'manana',
  'totalFotos': 0,
  'totalCotizaciones': 0,
  'venceEn': '2026-11-22T18:00:00Z',
  'creadoEn': '2026-11-20T18:00:00Z',
};

/// Servidor falso: la zona, la creación y la lista.
ApiFalsa _servidor({FutureOr<http.Response> Function()? alCrear}) {
  var creada = false;
  return ApiFalsa((p) async {
    final ruta = p.llamadaCompleta;
    if (ruta.startsWith('GET /api/v1/zonas/cp/')) return jsonOk(_zona());
    if (ruta == 'POST /api/v1/solicitudes') {
      final r = await (alCrear?.call() ?? jsonOk(_creada(), estado: 201));
      if (r.statusCode == 201) creada = true;
      return r;
    }
    if (ruta == 'GET /api/v1/solicitudes') {
      return jsonOk({
        'items': creada ? [_fila()] : <Object?>[],
        'nextCursor': null,
      });
    }
    return http.Response('', 404);
  });
}

http.Response _problema(int estado, String codigo) => jsonOk({
  'type': 'about:blank',
  'title': 'x',
  'status': estado,
  'code': codigo,
}, estado: estado);

Future<void> _abrir(
  WidgetTester tester,
  ApiFalsa api, {
  bool conApi = true,
}) async {
  fijarPantalla(tester, tamano: tamanoMovil);
  maq.resetAll();
  maq.user
    ..col = 'Col. Centro'
    ..cp = '42800'
    ..addr = 'Calle Jacarandas 45';
  maq.startReq(
    cat: 'plo',
    desc: 'Gotea la llave del baño',
    photos: ['/privado/foto1.jpg'],
    step: 3,
  );
  final container = await montarApp(
    tester,
    esTecnico: false,
    maqueta: true,
    extra: [
      solicitudesRealesRepositoryProvider.overrideWithValue(
        SolicitudRepositoryApi(transporte: api.cliente, url: urlApiPrueba),
      ),
      zonasRepositoryProvider.overrideWithValue(
        ZonasRepositoryHttp(transporte: api.cliente, url: urlApiPrueba),
      ),
      solicitudesRealesActivasProvider.overrideWithValue(conApi),
      oficiosRepositoryProvider.overrideWithValue(OficiosFalsos()),
      intervaloRefrescoSolicitudProvider.overrideWithValue(null),
    ],
  );
  container.read(appRouterProvider).go('/m/solicitar');
  await asentarMaqueta(tester);
}

void main() {
  prepararPruebasDeMaqueta(
    alTerminar: () => provs.removeWhere((k, _) => k.startsWith('api:')),
  );

  testWidgets('CA_288_01 envía POST /solicitudes, sin fotos y sin '
      'Idempotency-Key, y refresca la lista', (tester) async {
    final api = _servidor();
    await _abrir(tester, api);
    api.peticiones.clear();

    await tester.tap(find.text('Enviar solicitud'));
    await asentarMaqueta(tester);

    final posts = api.peticiones.where((p) => p.metodo == 'POST').toList();
    expect(posts, hasLength(1));
    final cuerpo = posts.single.json;
    expect(cuerpo['oficioClave'], 'plo');
    expect(cuerpo['coloniaId'], _coloniaId);
    expect(cuerpo['descripcion'], 'Gotea la llave del baño');
    expect(cuerpo['fotos'], isEmpty, reason: 'las fotos no se suben aún');
    expect(cuerpo['franja'], 'manana');
    expect(cuerpo['direccion'], 'Calle Jacarandas 45');
    expect(cuerpo.containsKey('modalidad'), isFalse);
    expect(posts.single.cabeceras.containsKey('idempotency-key'), isFalse);
    expect(
      api.llamadas.where((l) => l == 'GET solicitudes'),
      isNotEmpty,
      reason: 'tras crear se vuelve a pedir la lista',
    );
    expect(find.textContaining('Tu solicitud va en camino'), findsOneWidget);
    expect(maq.job(_solicitudId)?.real, isTrue);
    expect(maq.req, isNull);
  });

  testWidgets('CA_288_02 error del servidor: muestra el mensaje, no avanza '
      'y deja reintentar', (tester) async {
    final api = _servidor(alCrear: () => _problema(422, 'content_rejected'));
    await _abrir(tester, api);

    await tester.tap(find.text('Enviar solicitud'));
    await asentarMaqueta(tester);

    expect(
      find.textContaining('Tu descripción no se pudo publicar'),
      findsOneWidget,
    );
    expect(find.textContaining('Tu solicitud va en camino'), findsNothing);
    expect(maq.req, isNotNull, reason: 'el borrador sigue intacto');
    expect(maq.jobs.where((j) => j.real), isEmpty);
    // El botón vuelve a estar disponible.
    expect(find.text('Enviar solicitud'), findsOneWidget);
  });

  testWidgets('CA_288_03 sin red: mensaje de conexión y no avanza', (
    tester,
  ) async {
    final api = _servidor(alCrear: () => throw http.ClientException('sin red'));
    await _abrir(tester, api);

    await tester.tap(find.text('Enviar solicitud'));
    await asentarMaqueta(tester);

    expect(
      find.textContaining('No pudimos conectar con Knock'),
      findsOneWidget,
    );
    expect(find.textContaining('Tu solicitud va en camino'), findsNothing);
    expect(maq.jobs.where((j) => j.real), isEmpty);
  });

  testWidgets('CA_288_04 el doble toque no duplica la solicitud', (
    tester,
  ) async {
    final espera = Completer<void>();
    final api = _servidor(
      alCrear: () async {
        await espera.future;
        return jsonOk(_creada(), estado: 201);
      },
    );
    await _abrir(tester, api);

    await tester.tap(find.text('Enviar solicitud'));
    await tester.pump();
    expect(find.text('Enviando…'), findsOneWidget);
    await tester.tap(find.text('Enviando…'), warnIfMissed: false);
    await tester.pump();
    espera.complete();
    await asentarMaqueta(tester);

    expect(api.peticiones.where((p) => p.metodo == 'POST'), hasLength(1));
    expect(find.textContaining('Tu solicitud va en camino'), findsOneWidget);
  });

  testWidgets('CA_288_05 una colonia que el servidor no conoce no envía '
      'nada', (tester) async {
    final api = _servidor();
    await _abrir(tester, api);
    maq.user.col = 'Col. Inventada';

    await tester.tap(find.text('Enviar solicitud'));
    await asentarMaqueta(tester);

    expect(api.peticiones.where((p) => p.metodo == 'POST'), isEmpty);
    expect(find.textContaining('ya no están disponibles'), findsOneWidget);
  });

  testWidgets('CA_288_06 sin API sigue el flujo de datos de ejemplo', (
    tester,
  ) async {
    final api = _servidor();
    await _abrir(tester, api, conApi: false);

    await tester.tap(find.text('Enviar solicitud'));
    await asentarMaqueta(tester);

    expect(api.peticiones, isEmpty);
    expect(find.textContaining('Tu solicitud va en camino'), findsOneWidget);
    expect(maq.jobs.first.real, isFalse);
    // Deja correr los temporizadores de las cotizaciones de ejemplo.
    await tester.pump(const Duration(seconds: 30));
  });
}
