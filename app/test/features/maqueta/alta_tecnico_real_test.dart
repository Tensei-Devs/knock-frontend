// Spec 036 y 045: «Registrarse como técnico» en la maqueta con sesión y API:
// sin segundo código SMS, envía lo que pide el servidor y conserva lo escrito
// cuando lo rechaza. Solo datos ficticios.
import 'package:app/core/router/app_router.dart';
import 'package:app/core/sesion/es_tecnico_provider.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/presentation/solicitudes_reales_controller.dart';
import 'package:app/features/inicio/data/zonas_repository_http.dart';
import 'package:app/features/inicio/inicio_providers.dart';
import 'package:app/features/maqueta/estado.dart' show maq;
import 'package:app/features/oficios/oficios.dart';
import 'package:app/features/tecnico/data/tecnico_repository_api.dart';
import 'package:app/features/tecnico/tecnico.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/preparar_maqueta.dart';
import '../../soporte/solicitud_falsa.dart';

const _colonia = 'c0c0c0c0c0c0c0c0c0c0c0c0';

ApiFalsa _servidor({http.Response Function()? alRegistrar}) => ApiFalsa((p) {
  if (p.metodo == 'GET' && p.ruta.startsWith('zonas/cp/')) {
    return jsonOk({
      'enCobertura': true,
      'ciudadPiloto': true,
      'colonias': [
        {
          'id': _colonia,
          'nombre': 'Col. Centro',
          'cp': '42800',
          'municipio': 'Tula de Allende',
        },
      ],
    });
  }
  if (p.llamadaCompleta == 'POST /api/v1/tecnicos') {
    return alRegistrar?.call() ??
        jsonOk({
          'id': 'a0a0a0a0a0a0a0a0a0a0a0a0',
          'nombre': 'Ana López',
          'oficios': ['plo'],
          'estado': 'activo',
          'verificacion': 'sin_verificar',
          'disponibleHoy': false,
        }, estado: 201);
  }
  return http.Response('', 404);
});

Future<ProviderContainer> _abrir(WidgetTester tester, ApiFalsa api) async {
  fijarPantalla(tester, tamano: tamanoMovil);
  maq.resetAll();
  // La maqueta de prueba trae un técnico de ejemplo: aquí se parte sin él.
  maq.pv.me.registered = false;
  maq.user
    ..name = 'Ana López'
    ..col = 'Col. Centro'
    ..cp = '42800';
  final container = await montarApp(
    tester,
    esTecnico: false,
    maqueta: true,
    extra: [
      solicitudesRealesActivasProvider.overrideWithValue(true),
      zonasRepositoryProvider.overrideWithValue(
        ZonasRepositoryHttp(transporte: api.cliente, url: urlApiPrueba),
      ),
      tecnicoRepositoryProvider.overrideWithValue(
        TecnicoRepositoryApi(transporte: api.cliente, url: urlApiPrueba),
      ),
      solicitudesRealesRepositoryProvider.overrideWithValue(
        SolicitudesFalsas(),
      ),
      oficiosRepositoryProvider.overrideWithValue(OficiosFalsos()),
    ],
  );
  container.read(appRouterProvider).go('/m/tecnico/registro');
  await asentarMaqueta(tester);
  return container;
}

Future<void> _tocar(WidgetTester tester, Finder donde) async {
  await tester.ensureVisible(donde.first);
  await asentarMaqueta(tester);
  await tester.tap(donde.first);
  await asentarMaqueta(tester);
}

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('CA_036_01 con sesión crea el perfil sin segundo código, sin '
      'pedir el celular, y da acceso a Trabajo', (tester) async {
    final api = _servidor();
    final container = await _abrir(tester, api);
    expect(find.text('Tu celular'), findsNothing);

    await _tocar(tester, find.text('Plomería'));
    await _tocar(tester, find.textContaining('Acepto los Términos'));
    await _tocar(tester, find.text('Continuar'));

    final alta = api.peticiones.singleWhere((p) => '$p' == 'POST tecnicos');
    expect(alta.json, {
      'nombre': 'Ana López',
      'oficios': ['plo'],
      'atencion': 'domicilio',
      'radioKm': 8,
      'coloniaId': _colonia,
      'aceptaTerminos': true,
    });
    expect(find.text('Verifica tu celular'), findsNothing);
    expect(find.textContaining('¡Cuenta creada'), findsOneWidget);
    expect(container.read(esTecnicoProvider), isTrue);
    // La maqueta arranca un reloj de ejemplo al crear la cuenta.
    await tester.pump(const Duration(seconds: 30));
    maq.pv.dispose();
  });

  testWidgets('CA_036_03 si la cuenta ya es técnica lo dice y conserva lo '
      'escrito', (tester) async {
    final api = _servidor(
      alRegistrar: () => jsonOk({'code': 'already_a_technician'}, estado: 409),
    );
    final container = await _abrir(tester, api);

    await _tocar(tester, find.text('Plomería'));
    await _tocar(tester, find.textContaining('Acepto los Términos'));
    await _tocar(tester, find.text('Continuar'));

    expect(
      find.textContaining('Esta cuenta ya tiene perfil de técnico'),
      findsOneWidget,
    );
    expect(find.text('Ana López'), findsWidgets);
    expect(find.text('Continuar'), findsOneWidget);
    expect(container.read(esTecnicoProvider), isFalse);
  });

  testWidgets('sin un oficio del catálogo no envía nada', (tester) async {
    final api = _servidor();
    await _abrir(tester, api);

    await _tocar(tester, find.textContaining('Acepto los Términos'));
    await _tocar(tester, find.text('Continuar'));

    expect(api.peticiones.where((p) => p.metodo == 'POST'), isEmpty);
    expect(find.textContaining('Elige al menos un servicio'), findsOneWidget);
  });
}
