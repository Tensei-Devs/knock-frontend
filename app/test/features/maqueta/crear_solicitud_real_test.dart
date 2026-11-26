// KNOCK-288: con sesión, API y la subida de fotos encendida, «Enviar
// solicitud» sube de 1 a 5 fotos (backend 062) y crea la solicitud
// (`POST /solicitudes`, spec 015 y backend 020). Sin API, o con la subida
// apagada, sigue el flujo de datos de ejemplo.
import 'dart:async';
import 'dart:typed_data';

import 'package:app/core/config/subida_de_fotos.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/data/foto_preparada.dart';
import 'package:app/features/actividad/data/solicitud_repository_api.dart';
import 'package:app/features/actividad/data/subida_de_fotos_api.dart';
import 'package:app/features/actividad/presentation/solicitudes_reales_controller.dart';
import 'package:app/features/direcciones/data/direcciones_repository_api.dart';
import 'package:app/features/direcciones/direcciones_providers.dart';
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

String _idDeFoto(int n) => '$n'.padLeft(32, '0');

/// Servidor falso: la zona, la subida de fotos, la creación y la lista.
ApiFalsa _servidor({
  FutureOr<http.Response> Function()? alCrear,
  http.Response? Function(String id)? alConfirmar,
  String coloniaGuardada = 'Col. Centro',
}) {
  var creada = false;
  var enlaces = 0;
  return ApiFalsa((p) async {
    final ruta = p.llamadaCompleta;
    if (ruta == 'POST /api/v1/imagenes/subidas') {
      final id = _idDeFoto(++enlaces);
      return jsonOk({
        'id': id,
        'urlSubida': 'https://almacen.knock.test/$id',
        'metodo': 'PUT',
        'encabezados': <String, String>{},
      }, estado: 201);
    }
    if (ruta.endsWith('/confirmar')) {
      final id = p.url.pathSegments[p.url.pathSegments.length - 2];
      return alConfirmar?.call(id) ?? jsonOk({'id': id});
    }
    if (ruta.startsWith('GET /api/v1/zonas/cp/')) return jsonOk(_zona());
    if (ruta == 'GET /api/v1/me/direcciones') {
      return jsonOk([
        {
          'id': 'dir-1',
          'calleNumero': 'Calle Jacarandas 45',
          'colonia': coloniaGuardada,
          'referencias': null,
          'principal': true,
          'creadoEn': '2026-11-20T18:00:00Z',
        },
      ]);
    }
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
  bool conFotos = true,
  List<String> fotos = const ['/privado/foto1.jpg'],
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
    photos: [...fotos],
    step: 3,
  );
  final container = await montarApp(
    tester,
    esTecnico: false,
    maqueta: true,
    extra: [
      solicitudesRealesRepositoryProvider.overrideWithValue(
        SolicitudRepositoryApi(
          transporte: api.cliente,
          url: urlApiPrueba,
          fotos: SubidaDeFotosApi(
            transporte: api.cliente,
            url: urlApiPrueba,
            almacenamiento: ApiFalsa((_) => http.Response('', 201)).cliente,
            leer: (_) async => Uint8List.fromList([1]),
            preparar: (bytes) async => FotoLista(
              bytes: bytes,
              tipoContenido: 'image/jpeg',
              ancho: 1,
              alto: 1,
            ),
          ),
        ),
      ),
      subidaDeFotosActivaProvider.overrideWithValue(conFotos),
      direccionesRepositoryProvider.overrideWithValue(
        DireccionesRepositoryApi(transporte: api.cliente, url: urlApiPrueba),
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

  testWidgets('CA_288_01 sube la foto, envía POST /solicitudes con su '
      'archivoId y sin Idempotency-Key, y refresca la lista', (tester) async {
    final api = _servidor();
    await _abrir(tester, api);
    api.peticiones.clear();

    await tester.tap(find.text('Enviar solicitud'));
    await asentarMaqueta(tester);

    expect(api.llamadas.where((l) => l.startsWith('POST')), [
      'POST imagenes/subidas',
      'POST imagenes/subidas/${_idDeFoto(1)}/confirmar',
      'POST solicitudes',
    ]);
    final posts = api.peticiones.where((p) => '$p' == 'POST solicitudes');
    final cuerpo = posts.single.json;
    expect(cuerpo['oficioClave'], 'plo');
    expect(cuerpo['coloniaId'], _coloniaId);
    expect(cuerpo['descripcion'], 'Gotea la llave del baño');
    expect(cuerpo['fotos'], [_idDeFoto(1)]);
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

    expect(api.llamadas.where((l) => l == 'POST solicitudes'), hasLength(1));
    expect(
      api.llamadas.where((l) => l == 'POST imagenes/subidas'),
      hasLength(1),
    );
    expect(find.textContaining('Tu solicitud va en camino'), findsOneWidget);
  });

  testWidgets('CA_288_05 una colonia que el servidor no conoce no envía '
      'nada', (tester) async {
    final api = _servidor(coloniaGuardada: 'Col. Inventada');
    await _abrir(tester, api);

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

  testWidgets('CA_288_07 con la subida de fotos apagada no llama a la API y '
      'sigue el flujo de ejemplo', (tester) async {
    final api = _servidor();
    await _abrir(tester, api, conFotos: false);
    api.peticiones.clear();

    await tester.tap(find.text('Enviar solicitud'));
    await asentarMaqueta(tester);

    expect(api.peticiones.where((p) => p.metodo != 'GET'), isEmpty);
    expect(maq.jobs.first.real, isFalse);
    await tester.pump(const Duration(seconds: 30));
  });

  testWidgets('CA_288_08 envía las cinco fotos en orden', (tester) async {
    final api = _servidor();
    await _abrir(
      tester,
      api,
      fotos: [for (var i = 1; i <= 5; i++) '/privado/foto$i.jpg'],
    );

    await tester.tap(find.text('Enviar solicitud'));
    await asentarMaqueta(tester);

    final creada = api.peticiones.singleWhere(
      (p) => '$p' == 'POST solicitudes',
    );
    expect(creada.json['fotos'], [for (var i = 1; i <= 5; i++) _idDeFoto(i)]);
  });

  testWidgets('CA_288_09 sin fotos no sube ni crea nada', (tester) async {
    final api = _servidor();
    await _abrir(tester, api, fotos: const []);
    api.peticiones.clear();

    await tester.tap(find.text('Enviar solicitud'));
    await asentarMaqueta(tester);

    expect(api.peticiones.where((p) => p.metodo == 'POST'), isEmpty);
    expect(maq.jobs.where((j) => j.real), isEmpty);
  });

  testWidgets('CA_288_10 si una foto falla no crea la solicitud, y al '
      'reintentar no repite las que ya subieron', (tester) async {
    var fallar = true;
    final api = _servidor(
      alConfirmar: (id) => fallar && id == _idDeFoto(2)
          ? _problema(503, 'moderation_unavailable')
          : null,
    );
    await _abrir(
      tester,
      api,
      fotos: ['/privado/foto1.jpg', '/privado/foto2.jpg'],
    );

    await tester.tap(find.text('Enviar solicitud'));
    await asentarMaqueta(tester);
    expect(api.llamadas, isNot(contains('POST solicitudes')));
    expect(maq.req, isNotNull);

    fallar = false;
    api.peticiones.clear();
    await tester.tap(find.text('Enviar solicitud'));
    await asentarMaqueta(tester);

    expect(
      api.llamadas.where((l) => l == 'POST imagenes/subidas'),
      hasLength(1),
    );
    final creada = api.peticiones.singleWhere(
      (p) => '$p' == 'POST solicitudes',
    );
    expect(creada.json['fotos'], [_idDeFoto(1), _idDeFoto(3)]);
  });

  testWidgets('CA_288_11 si el servidor rechaza una foto al crear, el '
      'reintento las sube de nuevo', (tester) async {
    var rechazar = true;
    final api = _servidor(
      alCrear: () => rechazar
          ? _problema(422, 'photo_invalid')
          : jsonOk(_creada(), estado: 201),
    );
    await _abrir(tester, api);

    await tester.tap(find.text('Enviar solicitud'));
    await asentarMaqueta(tester);
    rechazar = false;
    api.peticiones.clear();
    await tester.tap(find.text('Enviar solicitud'));
    await asentarMaqueta(tester);

    expect(api.llamadas, contains('POST imagenes/subidas'));
    final creada = api.peticiones.singleWhere(
      (p) => '$p' == 'POST solicitudes',
    );
    expect(creada.json['fotos'], [_idDeFoto(2)]);
  });
}
