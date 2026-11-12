import 'dart:async';

import 'package:app/core/notificaciones/navegacion_notificaciones.dart';
import 'package:app/core/router/app_shell.dart';
import 'package:app/core/router/destino_de_regreso_provider.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/sesion/es_tecnico_provider.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:app/features/actividad/presentation/actividad_screen.dart';
import 'package:app/features/actividad/presentation/cotizaciones_screen.dart';
import 'package:app/features/actividad/presentation/solicitud_detalle_screen.dart';
import 'package:app/features/actividad/presentation/solicitud_nueva_screen.dart';
import 'package:app/features/actividad/presentation/visita_screen.dart';
import 'package:app/features/cuenta/presentation/completar_perfil_screen.dart';
import 'package:app/features/cuenta/presentation/configuracion_screen.dart';
import 'package:app/features/cuenta/presentation/contactos_confianza_screen.dart';
import 'package:app/features/cuenta/presentation/perfil_controller.dart';
import 'package:app/features/cuenta/presentation/cuenta_screen.dart';
import 'package:app/features/entrada/presentation/celular_screen.dart';
import 'package:app/features/entrada/presentation/codigo_screen.dart';
import 'package:app/features/explorar/presentation/explorar_screen.dart';
import 'package:app/features/inicio/presentation/inicio_screen.dart';
import 'package:app/features/oficios/presentation/oficios_screen.dart';
import 'package:app/features/previa/presentation/previa_oficios_screen.dart';
import 'package:app/features/previa/presentation/previa_screen.dart';
import 'package:app/features/trabajo/presentation/trabajo_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Router de la app: `StatefulShellRoute` con una rama por pestaña.
///
/// Las 5 ramas existen siempre (el orden coincide con la barra); la barra
/// oculta Trabajo y el `redirect` manda `/trabajo` a `/inicio` si el usuario
/// no es técnico. Sin sesión todo lleva a `/entrar` (HU-001), que queda
/// fuera del shell (sin barra inferior). El router se refresca cuando cambia
/// cualquiera de los dos indicadores.
final appRouterProvider = Provider<GoRouter>((ref) {
  final esTecnico = ValueNotifier<bool>(ref.read(esTecnicoProvider));
  ref.listen<bool>(esTecnicoProvider, (_, valor) => esTecnico.value = valor);
  final sesion = ValueNotifier<bool>(ref.read(sesionIniciadaProvider));
  ref.listen<bool>(sesionIniciadaProvider, (_, valor) => sesion.value = valor);

  // Perfil incompleto (cuenta nueva) => completar perfil. Mientras carga no se
  // redirige. El perfil es SIMULADO hasta que exista GET /me.
  final perfilPendiente = ValueNotifier<bool>(
    ref.read(perfilPendienteProvider),
  );
  ref.listen<bool>(
    perfilPendienteProvider,
    (_, valor) => perfilPendiente.value = valor,
  );

  final router = GoRouter(
    // Sin sesión se abre la previa (spec 027, R-01).
    initialLocation: sesion.value ? Rutas.inicio : Rutas.previa,
    refreshListenable: Listenable.merge([esTecnico, sesion, perfilPendiente]),
    redirect: (context, state) =>
        _redireccionDeSesion(ref, state, sesion.value, perfilPendiente.value) ??
        redireccionPorPerfil(
          // Sin sesión manda `/entrar`, aunque el último perfil fuera nuevo.
          perfilPendiente: perfilPendiente.value && sesion.value,
          ubicacion: state.matchedLocation,
        ) ??
        redireccionPorRol(
          esTecnico: esTecnico.value,
          ubicacion: state.matchedLocation,
        ),
    routes: [
      GoRoute(
        path: Rutas.previa,
        builder: (context, state) => const PreviaScreen(),
        routes: [
          GoRoute(
            path: 'oficios',
            builder: (context, state) => const PreviaOficiosScreen(),
          ),
        ],
      ),
      GoRoute(
        path: Rutas.entrar,
        builder: (context, state) => const CelularScreen(),
        routes: [
          GoRoute(
            path: 'codigo',
            // El celular viaja en memoria como `extra`; sin él (enlace
            // directo) se regresa a escribirlo.
            redirect: (context, state) =>
                _celularDe(state) == null ? Rutas.entrar : null,
            builder: (context, state) =>
                CodigoScreen(celular: _celularDe(state)!),
          ),
        ],
      ),
      GoRoute(
        path: Rutas.completarPerfil,
        builder: (context, state) => const CompletarPerfilScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          _rama(Rutas.inicio, const InicioScreen()),
          _rama(
            Rutas.explorar,
            const ExplorarScreen(),
            subrutas: [
              GoRoute(
                path: 'oficios',
                builder: (context, state) => const OficiosScreen(),
              ),
            ],
          ),
          _rama(
            Rutas.actividad,
            const ActividadScreen(),
            subrutas: [
              GoRoute(
                path: 'solicitud/nueva',
                builder: (context, state) => SolicitudNuevaScreen(
                  oficioClave: state.uri.queryParameters[Rutas.parametroOficio],
                ),
              ),
              GoRoute(
                path: 'visita/:id',
                builder: (context, state) =>
                    VisitaScreen(id: state.pathParameters['id']!),
              ),
              GoRoute(
                path: 'solicitud/:id',
                builder: (context, state) =>
                    SolicitudDetalleScreen(id: state.pathParameters['id']!),
                routes: [
                  GoRoute(
                    path: 'cotizaciones',
                    builder: (context, state) => CotizacionesScreen(
                      solicitudId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          _rama(Rutas.trabajo, const TrabajoScreen()),
          _rama(
            Rutas.cuenta,
            const CuentaScreen(),
            subrutas: [
              GoRoute(
                path: 'configuracion',
                builder: (context, state) => const ConfiguracionScreen(),
              ),
              GoRoute(
                path: 'contactos',
                builder: (context, state) => const ContactosConfianzaScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  abrirPantallaDesdeNotificaciones(ref, router);

  ref.onDispose(() {
    router.dispose();
    esTecnico.dispose();
    sesion.dispose();
    perfilPendiente.dispose();
  });
  return router;
});

/// Redirección por sesión con el destino de regreso (spec 027, R-08 y R-09).
///
/// Sin sesión, `/entrar?volver=…` recuerda el destino (validado). Con sesión,
/// `/entrar` lleva a ese destino o a Inicio; el destino se conserva hasta
/// llegar, para que completar el perfil (cuenta nueva) no lo pierda.
String? _redireccionDeSesion(
  Ref ref,
  GoRouterState state,
  bool sesionIniciada,
  bool perfilPendiente,
) {
  final destino = ref.read(destinoDeRegresoProvider.notifier);
  final ubicacion = state.matchedLocation;
  if (!sesionIniciada) {
    final volver = state.uri.queryParameters[Rutas.parametroVolver];
    if (volver != null) destino.recordar(volver);
    return redireccionPorSesion(sesionIniciada: false, ubicacion: ubicacion);
  }
  final pendiente = ref.read(destinoDeRegresoProvider);
  final redireccion = redireccionPorSesion(
    sesionIniciada: true,
    ubicacion: ubicacion,
    volver: pendiente,
  );
  final llego =
      redireccion == null &&
      !perfilPendiente &&
      ubicacion != Rutas.completarPerfil;
  if (llego && pendiente != null) {
    unawaited(Future.microtask(destino.olvidar));
  }
  return redireccion;
}

String? _celularDe(GoRouterState state) {
  final extra = state.extra;
  return extra is String ? extra : null;
}

StatefulShellBranch _rama(
  String ruta,
  Widget pantalla, {
  List<RouteBase> subrutas = const [],
}) => StatefulShellBranch(
  routes: [
    GoRoute(
      path: ruta,
      builder: (context, state) => pantalla,
      routes: subrutas,
    ),
  ],
);
