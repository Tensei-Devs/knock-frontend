import 'package:app/core/router/app_shell.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/features/maqueta/anim_k.dart';
import 'package:app/features/maqueta/entrada_maqueta.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/explorar_maqueta.dart';
import 'package:app/features/maqueta/inicio_maqueta.dart';
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/pantallas_actividad.dart';
import 'package:app/features/maqueta/pantallas_buscar.dart';
import 'package:app/features/maqueta/pantallas_cuenta.dart';
import 'package:app/features/maqueta/pantallas_solicitud.dart';
import 'package:app/features/maqueta/pantallas_tecnico.dart';
import 'package:app/features/maqueta/pantallas_tecnico2.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/previa/presentation/rotulo_ejemplo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Fachada del modo maqueta (spec 045). Es lo único de `features/maqueta/` que
// el resto de la app puede importar: el router, el cascarón de la barra y la
// raíz `KnockApp` piden aquí las pantallas y los ganchos, y solo cuando la
// bandera `MODO_MAQUETA` está activa. El estado, los datos y la lógica
// simulada no salen de esta carpeta.

/// Pantallas de la maqueta que sustituyen a las reales en modo maqueta.
abstract final class PantallasMaqueta {
  /// Ruta del registro de técnico de la maqueta.
  static const registroTecnico = RT.registro;

  static Widget previa() => const InicioMaqueta(conCuenta: false);
  static Widget entrada({String paso = 'phone'}) => EntradaMaqueta(paso: paso);
  static Widget inicio() => const InicioMaqueta(conCuenta: true);
  static Widget explorar() => const ExplorarMaqueta();
  static Widget actividad() => const ActividadMaqueta();
  static Widget trabajo() => const TrabajoMaqueta();
  static Widget cuenta() => const CuentaMaqueta();
  static Widget configuracion() => const ConfigMaqueta();
}

/// Rutas `/m/...` de la maqueta (solo se registran en modo maqueta).
GoRoute rutaMaqueta() => GoRoute(
  path: '/m',
  redirect: (context, state) => state.uri.path == '/m' ? Rutas.inicio : null,
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
    GoRoute(path: 'solicitar', builder: (c, s) => const SolicitarScreen()),
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
    GoRoute(path: 'confianza', builder: (c, s) => const ConfianzaScreen()),
    GoRoute(path: 'avisos', builder: (c, s) => const AvisosScreen()),
    GoRoute(
      path: 'avisos-config',
      builder: (c, s) => const AvisosConfigScreen(),
    ),
    GoRoute(path: 'aviso-privacidad', builder: (c, s) => const AvisoScreen()),
    GoRoute(path: 'terminos', builder: (c, s) => const TerminosScreen()),
    GoRoute(
      path: 'privacidad',
      builder: (c, s) =>
          PrivacidadScreen(sesiones: s.uri.queryParameters['s'] == '1'),
    ),
    GoRoute(path: 'eliminar/1', builder: (c, s) => const Eliminar1Screen()),
    GoRoute(path: 'eliminar/2', builder: (c, s) => const Eliminar2Screen()),
    GoRoute(path: 'eliminado', builder: (c, s) => const EliminadoScreen()),
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
    GoRoute(path: 'sin-conexion', builder: (c, s) => const SinConexionScreen()),
    GoRoute(
      path: 'tecnico',
      redirect: (context, state) =>
          state.uri.path == '/m/tecnico' ? Rutas.inicio : null,
      routes: [
        GoRoute(path: 'registro', builder: (c, s) => const TecRegistroScreen()),
        GoRoute(path: 'verificacion', builder: (c, s) => const VerifScreen()),
        GoRoute(path: 'pendiente', builder: (c, s) => const PendienteScreen()),
        GoRoute(
          path: 'verificado',
          builder: (c, s) => const VerificadoScreen(),
        ),
        GoRoute(path: 'rechazada', builder: (c, s) => const RechazadaScreen()),
        GoRoute(path: 'mensajes', builder: (c, s) => const TecMensajesScreen()),
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
        GoRoute(path: 'perfil', builder: (c, s) => const PerfilEditarScreen()),
        GoRoute(
          path: 'reputacion',
          builder: (c, s) => const ReputacionScreen(),
        ),
      ],
    ),
  ],
);

/// Cascarón con la barra inferior de la maqueta: iconos propios e insignias
/// (mensajes sin leer en Actividad, solicitudes nuevas en Trabajo).
class ShellMaqueta extends StatelessWidget {
  const ShellMaqueta({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _iconos = <int, (IconData, IconData)>{
    1: (Icons.auto_awesome_outlined, Icons.auto_awesome),
    2: (Icons.work_outline, Icons.work),
    3: (Icons.handyman_outlined, Icons.handyman),
  };

  Widget? _icono(int rama, {required bool seleccionado}) {
    final par = _iconos[rama];
    final base = par == null ? null : Icon(seleccionado ? par.$2 : par.$1);
    final n = rama == 2
        ? maq.unreadCount
        : rama == ramaTrabajo
        ? maq.pv.nuevasN
        : 0;
    if (n <= 0) return base;
    return PulsoInsignia(
      valor: n,
      child: Badge(label: Text('$n'), child: base ?? const SizedBox.shrink()),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: maq,
    builder: (context, _) =>
        AppShell(navigationShell: navigationShell, iconoDe: _icono),
  );
}

/// Ganchos de la raíz de la app en modo maqueta.
abstract final class RaizMaqueta {
  /// Clave del mensajero que muestra los avisos de la maqueta.
  static final mensajero = mensajeroMaqueta;

  /// Conecta el estado simulado con el router y el idioma.
  static void preparar(GoRouter router, {required bool ingles}) {
    idiomaIngles = ingles;
    registrarIrA(router);
    registrarRutasTecnico(router);
  }

  /// Transiciones de página de la maqueta (desvanecer y deslizar).
  static ThemeData conTransiciones(ThemeData tema) =>
      tema.copyWith(pageTransitionsTheme: pageTransitionsKnock);

  /// Envuelve la app: avisos de la maqueta y el rótulo fijo «Datos de
  /// ejemplo» (spec 027, R-12 y R-17; spec 045, R-02), que no se puede ocultar.
  static Widget envolver(BuildContext context, Widget? child) {
    final arriba = MediaQuery.paddingOf(context).top;
    return Stack(
      children: [
        AvisosHost(
          messengerKey: mensajeroMaqueta,
          child: child ?? const SizedBox.shrink(),
        ),
        Positioned(
          top: arriba + 2,
          right: 8,
          child: const IgnorePointer(child: RotuloDeEjemplo()),
        ),
      ],
    );
  }
}
