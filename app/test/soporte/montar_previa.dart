// Spec 027: monta la previa con un router mínimo y un catálogo controlable.
import 'dart:async';

import 'package:app/core/preferencias/preferencias_provider.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/tema/tema.dart';
import 'package:app/features/oficios/domain/modalidad.dart';
import 'package:app/features/oficios/domain/oficio.dart';
import 'package:app/features/oficios/domain/oficios_repository.dart';
import 'package:app/features/oficios/domain/resultado_oficios.dart';
import 'package:app/features/oficios/oficios_providers.dart';
import 'package:app/features/previa/presentation/previa_oficios_screen.dart';
import 'package:app/features/previa/presentation/previa_screen.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

const ele = Oficio(
  clave: 'ele',
  nombre: 'Electricidad',
  modalidad: Modalidad.domicilio,
);
const mec = Oficio(
  clave: 'mec',
  nombre: 'Mecánica',
  modalidad: Modalidad.taller,
);
const plo = Oficio(
  clave: 'plo',
  nombre: 'Plomería',
  modalidad: Modalidad.domicilio,
);

/// Catálogo falso: cada consulta toma el siguiente comportamiento.
class CatalogoFalso implements OficiosRepository {
  CatalogoFalso(this._respuestas);

  CatalogoFalso.con(List<Oficio> oficios) : _respuestas = [() async => oficios];

  final List<Future<List<Oficio>> Function()> _respuestas;
  int consultas = 0;

  @override
  Future<List<Oficio>> listar() {
    final i = consultas < _respuestas.length
        ? consultas
        : _respuestas.length - 1;
    consultas++;
    return _respuestas[i]();
  }
}

/// Catálogo con caché falso, para el aviso de sin conexión.
class CatalogoConCacheFalso implements OficiosRepositoryConCache {
  CatalogoConCacheFalso(this._resultado);

  final ResultadoOficios _resultado;
  int consultas = 0;

  @override
  Stream<ResultadoOficios> observar() {
    consultas++;
    return Stream.value(_resultado);
  }

  @override
  Future<List<Oficio>> listar() async => _resultado.oficios;
}

/// Preferencias en español por defecto, o en [idioma].
class _Preferencias extends PreferenciasNotifier {
  _Preferencias(this._idioma);

  final Locale _idioma;

  @override
  Preferencias build() => Preferencias.inicial.copyWith(idioma: _idioma);
}

/// Rutas que el router mínimo registra en lugar de las pantallas reales.
const textoEntrar = 'PANTALLA-ENTRAR';

class PreviaMontada {
  PreviaMontada(this.router, this.container);

  final GoRouter router;
  final ProviderContainer container;

  /// Ruta de arriba de la pila (también cuando se llegó con `push`).
  String get ubicacion =>
      router.routerDelegate.currentConfiguration.last.matchedLocation;

  Map<String, String> get consulta =>
      router.routerDelegate.currentConfiguration.uri.queryParameters;
}

/// Monta `/previa` con un router que solo conoce la previa, su catálogo y un
/// marcador de `/entrar`.
Future<PreviaMontada> montarPrevia(
  WidgetTester tester, {
  required OficiosRepository catalogo,
  Locale idioma = const Locale('es'),
  double escalaDeTexto = 1,
  Size? tamano,
  Brightness brillo = Brightness.light,
}) async {
  // Pantalla alta por defecto: la previa se desplaza y así se ve completa.
  tester.view.physicalSize = tamano ?? const Size(400, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = GoRouter(
    initialLocation: Rutas.previa,
    routes: [
      GoRoute(
        path: Rutas.previa,
        builder: (_, _) => const PreviaScreen(),
        routes: [
          GoRoute(
            path: 'oficios',
            builder: (_, _) => const PreviaOficiosScreen(),
          ),
        ],
      ),
      GoRoute(
        path: Rutas.entrar,
        builder: (_, _) => const Scaffold(body: Text(textoEntrar)),
      ),
    ],
  );
  final container = ProviderContainer(
    overrides: [
      oficiosRepositoryProvider.overrideWithValue(catalogo),
      preferenciasProvider.overrideWith(() => _Preferencias(idioma)),
    ],
  );
  addTearDown(container.dispose);
  addTearDown(router.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: brillo == Brightness.dark ? temaOscuro : temaClaro,
        locale: idioma,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        routerConfig: router,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(escalaDeTexto)),
          child: child!,
        ),
      ),
    ),
  );
  // La hoja del panel arma su contenido un cuadro después del primero.
  await tester.pump();
  await tester.pump();
  await tester.pump();
  return PreviaMontada(router, container);
}
