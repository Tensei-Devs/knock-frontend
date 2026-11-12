import 'package:app/core/tema/tema.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/data/solicitud_repository_simulado.dart';
import 'package:app/features/actividad/domain/selector_de_fotos.dart';
import 'package:app/features/actividad/domain/solicitud_repository.dart';
import 'package:app/features/actividad/presentation/solicitud_detalle_screen.dart';
import 'package:app/features/actividad/presentation/solicitud_nueva_screen.dart';
import 'package:app/features/oficios/oficios.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

const oficioElectricidad = Oficio(
  clave: 'ele',
  nombre: 'Electricidad',
  modalidad: Modalidad.domicilio,
);
const oficioMecanica = Oficio(
  clave: 'mec',
  nombre: 'Mecánica',
  modalidad: Modalidad.taller,
);

class OficiosFalsos implements OficiosRepository {
  @override
  Future<List<Oficio>> listar() async => [oficioElectricidad, oficioMecanica];
}

class SelectorFalso implements SelectorDeFotos {
  int n = 0;

  @override
  Future<String?> elegir() async => 'foto-${++n}.jpg';
}

/// Monta el formulario dentro de un router con el detalle como destino.
Future<void> montarFormulario(
  WidgetTester tester, {
  String? oficioClave,
  SolicitudRepository? repositorio,
  double escalaDeTexto = 1,
  String? colonia = 'col-1',
}) async {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = GoRouter(
    initialLocation: '/nueva',
    routes: [
      GoRoute(
        path: '/nueva',
        builder: (context, state) =>
            SolicitudNuevaScreen(oficioClave: oficioClave),
      ),
      GoRoute(
        path: '/actividad/solicitud/:id',
        builder: (context, state) =>
            SolicitudDetalleScreen(id: state.pathParameters['id']!),
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        oficiosRepositoryProvider.overrideWithValue(OficiosFalsos()),
        selectorDeFotosProvider.overrideWithValue(SelectorFalso()),
        solicitudRepositoryProvider.overrideWithValue(
          repositorio ?? SolicitudRepositorySimulado(),
        ),
        coloniaIdSolicitudProvider.overrideWithValue(colonia),
        hoyProvider.overrideWithValue(DateTime(2026, 11, 11)),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        theme: temaClaro,
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(escalaDeTexto)),
          child: child!,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
