import 'dart:async';

import 'package:app/core/notificaciones/navegacion_notificaciones.dart';
import 'package:app/core/router/app_shell.dart';
import 'package:app/core/router/destino_de_regreso_provider.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/sesion/es_tecnico_provider.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:app/features/actividad/presentation/cotizaciones_screen.dart';
import 'package:app/features/actividad/presentation/solicitud_detalle_screen.dart';
import 'package:app/features/actividad/presentation/solicitud_nueva_screen.dart';
import 'package:app/features/actividad/presentation/visita_screen.dart';
import 'package:app/features/cuenta/presentation/contactos_confianza_screen.dart';
import 'package:app/features/cuenta/presentation/perfil_controller.dart';
import 'package:app/features/oficios/presentation/oficios_screen.dart';
import 'package:app/features/previa/presentation/previa_oficios_screen.dart';
import 'package:app/features/maqueta/entrada_maqueta.dart';
import 'package:app/features/maqueta/explorar_maqueta.dart';
import 'package:app/features/maqueta/inicio_maqueta.dart';
import 'package:app/features/maqueta/pantallas_actividad.dart';
import 'package:app/features/maqueta/pantallas_buscar.dart';
import 'package:app/features/maqueta/pantallas_cuenta.dart';
import 'package:app/features/maqueta/pantallas_solicitud.dart';
import 'package:app/features/maqueta/pantallas_tecnico.dart';
import 'package:app/features/maqueta/pantallas_tecnico2.dart';
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
          // El registro de técnico crea el perfil al terminar sus pasos.
          perfilPendiente:
              perfilPendiente.value &&
              sesion.value &&
              !state.matchedLocation.startsWith(RT.registro),
          ubicacion: state.matchedLocation,
        ) ??
        redireccionPorRol(
          esTecnico: esTecnico.value,
          ubicacion: state.matchedLocation,
        ),
    routes: [
      GoRoute(
        path: Rutas.previa,
        builder: (context, state) => const InicioMaqueta(conCuenta: false),
        routes: [
          GoRoute(
            path: 'oficios',
            builder: (context, state) => const PreviaOficiosScreen(),
          ),
        ],
      ),
      GoRoute(
        path: Rutas.entrar,
        builder: (context, state) => const EntradaMaqueta(),
        routes: [
          GoRoute(
            path: 'codigo',
            // El celular viaja en memoria como `extra`; sin él (enlace
            // directo) se regresa a escribirlo.
            redirect: (context, state) => Rutas.entrar,
            builder: (context, state) => const EntradaMaqueta(),
          ),
        ],
      ),
      GoRoute(
        path: Rutas.completarPerfil,
        builder: (context, state) => const EntradaMaqueta(paso: 'name'),
      ),
      GoRoute(
        path: '/m',
        redirect: (context, state) =>
            state.uri.path == '/m' ? Rutas.inicio : null,
        routes: [
          GoRoute(
            path: 'buscar',
            builder: (c, s) => BuscarScreen(focus: s.extra == 'focus'),
          ),
          GoRoute(
            path: 'experto/:id',
            builder: (c, s) => PerfilScreen(id: s.pathParameters['id']!),
            routes: [
              GoRoute(
                path: 'opiniones',
                builder: (c, s) => OpinionesScreen(id: s.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: 'asistente',
            builder: (c, s) {
              final e = s.extra;
              if (e is Map) {
                return AsistenteScreen(
                  texto: e['texto'] as String?,
                  cat: e['cat'] as String?,
                );
              }
              return AsistenteScreen(texto: e is String ? e : null);
            },
          ),
          GoRoute(
            path: 'solicitar',
            builder: (c, s) => const SolicitarScreen(),
          ),
          GoRoute(
            path: 'enviada/:id',
            builder: (c, s) => EnviadaScreen(id: s.pathParameters['id']!),
          ),
          GoRoute(
            path: 'comparar/:id',
            builder: (c, s) => CompararScreen(id: s.pathParameters['id']!),
          ),
          GoRoute(
            path: 'visita/:id',
            builder: (c, s) => VisitaMaqueta(id: s.pathParameters['id']!),
          ),
          GoRoute(
            path: 'cita/:id',
            builder: (c, s) => CitaScreen(id: s.pathParameters['id']!),
          ),
          GoRoute(
            path: 'calificar/:id',
            builder: (c, s) => CalificarScreen(id: s.pathParameters['id']!),
          ),
          GoRoute(
            path: 'reportar/:id',
            builder: (c, s) => ReportarScreen(
              id: s.pathParameters['id']!,
              pid: s.uri.queryParameters['pid'],
              noTermino: s.uri.queryParameters['nodone'] == '1',
            ),
          ),
          GoRoute(
            path: 'compartir/:id',
            builder: (c, s) => CompartirScreen(id: s.pathParameters['id']!),
          ),
          GoRoute(path: 'mensajes', builder: (c, s) => const MensajesScreen()),
          GoRoute(
            path: 'chat/:id',
            builder: (c, s) => ChatScreen(id: s.pathParameters['id']!),
          ),
          GoRoute(path: 'mi-casa', builder: (c, s) => const MiCasaScreen()),
          GoRoute(
            path: 'confianza',
            builder: (c, s) => const ConfianzaScreen(),
          ),
          GoRoute(path: 'avisos', builder: (c, s) => const AvisosScreen()),
          GoRoute(
            path: 'avisos-config',
            builder: (c, s) => const AvisosConfigScreen(),
          ),
          GoRoute(
            path: 'aviso-privacidad',
            builder: (c, s) => const AvisoScreen(),
          ),
          GoRoute(path: 'terminos', builder: (c, s) => const TerminosScreen()),
          GoRoute(
            path: 'privacidad',
            builder: (c, s) =>
                PrivacidadScreen(sesiones: s.uri.queryParameters['s'] == '1'),
          ),
          GoRoute(
            path: 'eliminar/1',
            builder: (c, s) => const Eliminar1Screen(),
          ),
          GoRoute(
            path: 'eliminar/2',
            builder: (c, s) => const Eliminar2Screen(),
          ),
          GoRoute(
            path: 'eliminado',
            builder: (c, s) => const EliminadoScreen(),
          ),
          GoRoute(
            path: 'ayuda',
            builder: (c, s) => AyudaScreen(
              tema: int.tryParse(s.uri.queryParameters['t'] ?? '') ?? 1,
            ),
          ),
          // Solo para revisar la entrada en debug: pasos nombre, zona y foto.
          GoRoute(
            path: 'entrada-prueba',
            builder: (c, s) => const EntradaMaqueta(paso: 'name'),
          ),
          GoRoute(
            path: 'sin-conexion',
            builder: (c, s) => const SinConexionScreen(),
          ),
          GoRoute(
            path: 'tecnico',
            redirect: (context, state) =>
                state.uri.path == '/m/tecnico' ? Rutas.inicio : null,
            routes: [
              GoRoute(
                path: 'registro',
                builder: (c, s) => const TecRegistroScreen(),
              ),
              GoRoute(
                path: 'verificacion',
                builder: (c, s) => const VerifScreen(),
              ),
              GoRoute(
                path: 'pendiente',
                builder: (c, s) => const PendienteScreen(),
              ),
              GoRoute(
                path: 'verificado',
                builder: (c, s) => const VerificadoScreen(),
              ),
              GoRoute(
                path: 'rechazada',
                builder: (c, s) => const RechazadaScreen(),
              ),
              GoRoute(
                path: 'mensajes',
                builder: (c, s) => const TecMensajesScreen(),
              ),
              GoRoute(
                path: 'chat/:cid/:rid',
                builder: (c, s) => TecChatScreen(
                  cid: s.pathParameters['cid']!,
                  rid: s.pathParameters['rid']!,
                ),
              ),
              GoRoute(
                path: 'cotizar/:rid',
                builder: (c, s) => CotizarScreen(rid: s.pathParameters['rid']!),
              ),
              GoRoute(
                path: 'iniciar/:vid',
                builder: (c, s) => IniciarScreen(vid: s.pathParameters['vid']!),
              ),
              GoRoute(
                path: 'cerrar/:vid',
                builder: (c, s) => CerrarScreen(vid: s.pathParameters['vid']!),
              ),
              GoRoute(
                path: 'perfil',
                builder: (c, s) => const PerfilEditarScreen(),
              ),
              GoRoute(
                path: 'reputacion',
                builder: (c, s) => const ReputacionScreen(),
              ),
            ],
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          _rama(Rutas.inicio, const InicioMaqueta(conCuenta: true)),
          _rama(
            Rutas.explorar,
            const ExplorarMaqueta(),
            subrutas: [
              GoRoute(
                path: 'oficios',
                builder: (context, state) => const OficiosScreen(),
              ),
            ],
          ),
          _rama(
            Rutas.actividad,
            const ActividadMaqueta(),
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
          _rama(Rutas.trabajo, const TrabajoMaqueta()),
          _rama(
            Rutas.cuenta,
            const CuentaMaqueta(),
            subrutas: [
              GoRoute(
                path: 'configuracion',
                builder: (context, state) => const ConfigMaqueta(),
              ),
              GoRoute(
                path: 'contactos-de-confianza',
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
