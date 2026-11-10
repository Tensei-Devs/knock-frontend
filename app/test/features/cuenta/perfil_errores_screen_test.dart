// Spec 026 (KNOCK-248), P-6: «Mi cuenta» y «Completar perfil» ante cada error
// del perfil, con Reintentar, y el cierre de sesión real hasta `/entrar`.
import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/features/cuenta/cuenta_providers.dart';
import 'package:app/features/cuenta/domain/perfil.dart';
import 'package:app/features/cuenta/domain/perfil_repository.dart';
import 'package:app/l10n/generado/app_localizations_es.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/montar_app.dart';

class _RepoFalso implements PerfilRepository {
  _RepoFalso(this.perfil);

  Perfil perfil;
  Failure? falla;
  var lecturas = 0;
  var guardados = 0;

  @override
  Future<Perfil> obtener() async {
    lecturas++;
    final f = falla;
    if (f != null) throw f;
    return perfil;
  }

  @override
  Future<Perfil> guardarNombre(String nombre) async {
    guardados++;
    final f = falla;
    if (f != null) throw f;
    return perfil = Perfil(nombre: nombre.trim());
  }

  @override
  Future<void> cerrarSesion() async {}
}

void main() {
  final es = AppLocalizationsEs();

  group('Mi cuenta', () {
    final casos = <(Failure, String)>[
      (const ServicioNoDisponibleFailure(), es.errorSinConexion),
      (const NoAutorizadoFailure(), es.errorSesionVencida),
      (const DemasiadosIntentosFailure(), es.errorDemasiadosIntentos),
      (const DatosInvalidosFailure(), es.errorDatosInvalidos),
    ];
    for (final (falla, texto) in casos) {
      testWidgets(
        'CA_026_19 un error al cargar el perfil (${falla.runtimeType}) se ve con su mensaje y Reintentar lo recupera',
        (tester) async {
          final repo = _RepoFalso(const Perfil(nombre: 'Ana López'))
            ..falla = falla;
          await montarApp(
            tester,
            esTecnico: false,
            extra: [perfilRepositoryProvider.overrideWithValue(repo)],
          );
          await tester.tap(enLaBarra('Mi cuenta'));
          await tester.pumpAndSettle();

          expect(find.text(texto), findsOneWidget);
          expect(find.text('Ana López'), findsNothing);
          expect(find.text('Reintentar'), findsOneWidget);

          repo.falla = null;
          await tester.tap(find.text('Reintentar'));
          await tester.pumpAndSettle();

          expect(find.text(texto), findsNothing);
          expect(find.text('Ana López'), findsOneWidget);
          expect(repo.lecturas, 2);
        },
      );
    }
  });

  group('Completar perfil', () {
    final casos = <(Failure, String)>[
      (const DatosRechazadosFailure(), es.errorDatosRechazados),
      (const ConflictoFailure(), es.errorConflicto),
      (const ServicioNoDisponibleFailure(), es.errorSinConexion),
      (const DemasiadosIntentosFailure(), es.errorDemasiadosIntentos),
    ];
    for (final (falla, texto) in casos) {
      testWidgets(
        'CA_026_19 un error al guardar el nombre (${falla.runtimeType}) se ve con su mensaje y Reintentar guarda',
        (tester) async {
          final repo = _RepoFalso(Perfil.nuevo);
          final container = await montarApp(
            tester,
            esTecnico: false,
            extra: [perfilRepositoryProvider.overrideWithValue(repo)],
          );
          expect(ubicacion(container), Rutas.completarPerfil);
          repo.falla = falla;

          await tester.enterText(find.byType(TextFormField), 'Ana López');
          await tester.tap(find.text('Continuar'));
          await tester.pumpAndSettle();

          expect(find.text(texto), findsOneWidget);
          expect(find.text('¡Listo, ya entraste!'), findsNothing);
          expect(ubicacion(container), Rutas.completarPerfil);

          repo.falla = null;
          await tester.tap(find.text('Reintentar'));
          await tester.pumpAndSettle();

          expect(find.text('¡Listo, ya entraste!'), findsOneWidget);
          expect(repo.guardados, 2);
        },
      );
    }
  });

  testWidgets(
    'CA_026_06 cerrar sesión hace POST /auth/logout y lleva a /entrar sin tokens ni caché',
    (tester) async {
      final api = ApiFalsa((p) {
        if (p.ruta == 'auth/logout') return http.Response('', 204);
        return jsonOk(perfilJson());
      });
      final almacen = AlmacenSeguroEnMemoria();
      final container = await montarApp(
        tester,
        esTecnico: false,
        extra: [
          urlApiProvider.overrideWithValue(urlApiPrueba),
          transporteHttpProvider.overrideWithValue(api.transporte),
          almacenSeguroProvider.overrideWithValue(almacen),
          tokensInicialesProvider.overrideWithValue(tokensA),
        ],
      );
      await tester.tap(enLaBarra('Mi cuenta'));
      await tester.pumpAndSettle();
      expect(find.text('Ana López'), findsOneWidget);

      await tester.tap(find.text('Cerrar sesión'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Cerrar sesión'));
      await tester.pumpAndSettle();

      final logout = api.peticiones.last;
      expect(logout.llamadaCompleta, 'POST /api/v1/auth/logout');
      expect(logout.autorizacion, 'Bearer acc-A');
      expect(almacen.contenido, isEmpty);
      expect(container.read(sesionProvider), isNull);
      expect(ubicacion(container), Rutas.entrar);
      expect(find.text('Ana López'), findsNothing);
    },
  );

  testWidgets(
    'CA_026_07 cerrar sesión sin red igual vuelve al login y no muestra error',
    (tester) async {
      final api = ApiFalsa((p) {
        if (p.ruta == 'auth/logout') throw http.ClientException('sin red');
        return jsonOk(perfilJson());
      });
      final container = await montarApp(
        tester,
        esTecnico: false,
        extra: [
          urlApiProvider.overrideWithValue(urlApiPrueba),
          transporteHttpProvider.overrideWithValue(api.transporte),
          almacenSeguroProvider.overrideWithValue(AlmacenSeguroEnMemoria()),
          tokensInicialesProvider.overrideWithValue(tokensA),
        ],
      );
      await tester.tap(enLaBarra('Mi cuenta'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cerrar sesión'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Cerrar sesión'));
      await tester.pumpAndSettle();

      expect(ubicacion(container), Rutas.entrar);
      expect(find.text(es.errorSinConexion), findsNothing);
      expect(container.read(sesionProvider), isNull);
    },
  );
}
