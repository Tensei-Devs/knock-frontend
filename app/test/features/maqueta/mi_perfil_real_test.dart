// Spec 036, enmienda 2026-11-27: «Tu perfil público» con datos reales
// (`GET` y `PUT /api/v1/tecnicos/me`). Solo datos ficticios.
import 'package:app/features/actividad/presentation/solicitudes_reales_controller.dart';
import 'package:app/features/maqueta/estado.dart' show maq;
import 'package:app/features/maqueta/mi_perfil_real.dart';
import 'package:app/features/tecnico/data/horarios_repository_api.dart';
import 'package:app/features/tecnico/data/mi_perfil_repository_api.dart';
import 'package:app/features/tecnico/data/servicios_repository_api.dart';
import 'package:app/features/tecnico/tecnico.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/horarios_json.dart';
import '../../soporte/mi_perfil_json.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/preparar_maqueta.dart';

/// Responde el perfil, los horarios y una lista de servicios vacía; [perfil]
/// cambia la respuesta de `GET` y `PUT tecnicos/me`.
ApiFalsa _api({http.Response Function(PeticionApi p)? perfil}) => ApiFalsa(
  (p) => switch (p.ruta) {
    'tecnicos/me' => perfil?.call(p) ?? jsonOk(miPerfilJson()),
    'tecnicos/me/horarios' => jsonOk(semanaJson()),
    _ => jsonOk({'items': <Object?>[]}),
  },
);

Future<void> _montar(WidgetTester tester, ApiFalsa api) async {
  fijarPantalla(tester, tamano: tamanoMovil);
  maq.fijarOficios(['plo'], error: false);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        conSesion(),
        solicitudesRealesActivasProvider.overrideWithValue(true),
        miPerfilRepositoryProvider.overrideWithValue(
          MiPerfilRepositoryApi(transporte: api.cliente, url: urlApiPrueba),
        ),
        horariosRepositoryProvider.overrideWithValue(
          HorariosRepositoryApi(transporte: api.cliente, url: urlApiPrueba),
        ),
        serviciosRepositoryProvider.overrideWithValue(
          ServiciosRepositoryApi(transporte: api.cliente, url: urlApiPrueba),
        ),
      ],
      child: const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: SingleChildScrollView(child: MiPerfilReal())),
      ),
    ),
  );
  await asentarMaqueta(tester);
}

Finder _campo(String etiqueta) => find.ancestor(
  of: find.text(etiqueta),
  matching: find.byWidgetPredicate((w) => w.runtimeType.toString() == 'FieldK'),
);

Finder _texto(String etiqueta) =>
    find.descendant(of: _campo(etiqueta), matching: find.byType(TextField));

Future<void> _guardar(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Guardar cambios'));
  await tester.tap(find.text('Guardar cambios'));
  await asentarMaqueta(tester);
}

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('CA_036_G01 abre con los datos guardados y el PUT lleva solo '
      'lo que cambió', (tester) async {
    final api = _api();
    await _montar(tester, api);

    expect(find.text('Ana Ficticia Pérez'), findsOneWidget);
    expect(find.text('Plomería Ficticia'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    expect(find.text('Reparo fugas y calentadores.'), findsOneWidget);
    expect(find.text('Dirección de tu taller'), findsNothing);

    await tester.enterText(_texto('Años de experiencia'), '7');
    await _guardar(tester);

    final puts = api.peticiones.where((p) => p.metodo == 'PUT').toList();
    expect(puts.map((p) => p.ruta), ['tecnicos/me']);
    expect(puts.single.json, {'anios': 7});
    // Después de guardar vuelve a leer el perfil del servidor.
    expect(
      api.llamadas.where((l) => l == 'GET tecnicos/me').length,
      greaterThanOrEqualTo(2),
    );
  });

  testWidgets('CA_036_G01 sin cambios no se envía nada', (tester) async {
    final api = _api();
    await _montar(tester, api);

    await _guardar(tester);

    expect(api.peticiones.where((p) => p.metodo == 'PUT'), isEmpty);
  });

  testWidgets('CA_036_G02 un 404 en la lectura no muestra el formulario', (
    tester,
  ) async {
    final api = _api(perfil: (_) => http.Response('', 404));
    await _montar(tester, api);

    expect(find.text('No encontramos tu perfil de técnico.'), findsOneWidget);
    expect(find.text('Guardar cambios'), findsNothing);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('CA_036_G02 una falla en la lectura no muestra el formulario y '
      'Reintentar lo trae', (tester) async {
    var falla = true;
    final api = _api(
      perfil: (_) => falla ? http.Response('', 503) : jsonOk(miPerfilJson()),
    );
    await _montar(tester, api);
    expect(find.text('Guardar cambios'), findsNothing);

    falla = false;
    await tester.tap(find.text('Reintentar'));
    await asentarMaqueta(tester);

    expect(find.text('Guardar cambios'), findsOneWidget);
  });

  testWidgets('CA_036_32 un 422 del servidor conserva lo escrito', (
    tester,
  ) async {
    final api = _api(
      perfil: (p) => p.metodo == 'PUT'
          ? jsonOk({'code': 'validation_failed'}, estado: 422)
          : jsonOk(miPerfilJson()),
    );
    await _montar(tester, api);

    await tester.enterText(_texto('Nombre de tu negocio'), 'Fugas Ficticias');
    await _guardar(tester);

    expect(api.peticiones.last.metodo, 'PUT');
    expect(find.text('Fugas Ficticias'), findsOneWidget);
  });

  testWidgets('CA_036_32 un dato fuera de las reglas no llega al servidor', (
    tester,
  ) async {
    final api = _api();
    await _montar(tester, api);

    await tester.enterText(_texto('Años de experiencia'), '99');
    await _guardar(tester);

    expect(find.text('Escribe un número de 0 a 60'), findsOneWidget);
    expect(api.peticiones.where((p) => p.metodo == 'PUT'), isEmpty);
  });

  testWidgets('en taller se edita la dirección y no el radio', (tester) async {
    final api = _api(
      perfil: (_) => jsonOk(
        miPerfilJson(
          atencion: 'taller',
          radioKm: null,
          direccionTaller: 'Calle Ficticia 1, Centro',
        ),
      ),
    );
    await _montar(tester, api);

    expect(find.text('Calle Ficticia 1, Centro'), findsOneWidget);
    expect(find.text('Hasta dónde vas'), findsNothing);
  });
}
