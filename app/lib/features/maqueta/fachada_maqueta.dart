import 'dart:async';

import 'package:app/core/router/app_shell.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/features/actividad/actividad.dart' as act;
import 'package:app/features/maqueta/anim_k.dart';
import 'package:app/features/maqueta/asistente_real.dart';
import 'package:app/features/maqueta/cotizar_real.dart';
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/entrada_maqueta.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/features/maqueta/explorar_maqueta.dart';
import 'package:app/features/maqueta/globo_real.dart';
import 'package:app/features/maqueta/inicio_maqueta.dart';
import 'package:app/features/maqueta/llegada_real.dart';
import 'package:app/features/maqueta/mi_perfil_real.dart';
import 'package:app/features/maqueta/nav.dart';
import 'package:app/features/maqueta/pantalla_segun_sesion.dart';
import 'package:app/features/maqueta/pantallas_actividad.dart';
import 'package:app/features/maqueta/pantallas_buscar.dart';
import 'package:app/features/maqueta/pantallas_cuenta.dart';
import 'package:app/features/maqueta/pantallas_solicitud.dart';
import 'package:app/features/maqueta/pantallas_tecnico.dart';
import 'package:app/features/maqueta/pantallas_tecnico2.dart';
import 'package:app/features/maqueta/solicitudes_reales.dart';
import 'package:app/features/maqueta/terminar_servicio_real.dart';
import 'package:app/features/maqueta/trabajo_real.dart';
import 'package:app/features/maqueta/ui.dart';
import 'package:app/features/maqueta/verificacion_real.dart';
import 'package:app/features/oficios/oficios.dart';
import 'package:app/features/oficios/presentation/oficios_controller.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  static Widget trabajo() => const TrabajoSegunSesion();
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
        final dato = e is Map ? e['texto'] : e;
        final texto = dato is String ? dato : null;
        return Consumer(
          builder: (c, ref, _) => ref.watch(asistenteDisponibleProvider)
              ? AsistenteChatReal(texto: texto)
              : AsistenteScreen(
                  texto: texto,
                  cat: e is Map ? e['cat'] as String? : null,
                ),
        );
      },
    ),
    ...rutasAsistente(),
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
    GoRoute(
      path: 'bloquear/:id',
      builder: (c, s) => BloquearScreen(id: s.pathParameters['id']!),
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
        GoRoute(
          path: 'verificacion',
          builder: (c, s) => PantallaSegunSesion(
            titulo: 'Verificación',
            real: const EstadoDeVerificacionReal(),
            ejemplo: (_) => const VerifScreen(),
          ),
        ),
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
          builder: (c, s) => PantallaSegunSesion(
            titulo: AppLocalizations.of(c).cotizarTitulo,
            real: CotizarReal(solicitudId: s.pathParameters['rid']!),
            ejemplo: (_) => CotizarScreen(rid: s.pathParameters['rid']!),
          ),
        ),
        GoRoute(
          path: 'iniciar/:vid',
          builder: (c, s) => PantallaSegunSesion(
            titulo: AppLocalizations.of(c).llegadaTitulo,
            real: LlegadaReal(visitaId: s.pathParameters['vid']!),
            ejemplo: (_) => IniciarScreen(vid: s.pathParameters['vid']!),
          ),
        ),
        GoRoute(
          path: 'cerrar/:vid',
          builder: (c, s) => PantallaSegunSesion(
            titulo: AppLocalizations.of(c).visitaTerminarBoton,
            real: TerminarServicioReal(visitaId: s.pathParameters['vid']!),
            ejemplo: (_) => CerrarScreen(vid: s.pathParameters['vid']!),
          ),
        ),
        GoRoute(
          path: 'perfil',
          builder: (c, s) => PantallaSegunSesion(
            titulo: 'Tu perfil público',
            real: const MiPerfilReal(),
            ejemplo: (_) => const PerfilEditarScreen(),
          ),
        ),
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
    builder: (context, _) => AppShell(
      navigationShell: navigationShell,
      iconoDe: _icono,
      globo: GloboReal(tecnico: navigationShell.currentIndex == ramaTrabajo),
    ),
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

  /// Envuelve la app: avisos de la maqueta y el puente con los datos reales.
  ///
  /// Ya no lleva la franja fija «Datos de ejemplo» (spec 045, enmienda 2): la
  /// maqueta es la interfaz de la app y lo que aún no tiene endpoint se queda
  /// simulado sin rótulo.
  static Widget envolver(BuildContext context, Widget? child) => AvisosHost(
    messengerKey: mensajeroMaqueta,
    child: _PuenteDeDatos(child: child ?? const SizedBox.shrink()),
  );
}

/// Lleva a la maqueta los datos reales que ya tiene la app: el catálogo de
/// oficios (`GET /oficios`, spec 035) y, con sesión iniciada, las solicitudes
/// de la persona (`GET /solicitudes`, spec 015), cada una con su Reintentar.
class _PuenteDeDatos extends ConsumerStatefulWidget {
  const _PuenteDeDatos({required this.child});

  final Widget child;

  @override
  ConsumerState<_PuenteDeDatos> createState() => _PuenteDeDatosState();
}

class _PuenteDeDatosState extends ConsumerState<_PuenteDeDatos> {
  /// Escucha de las solicitudes reales; solo existe con sesión y API.
  ProviderSubscription<AsyncValue<List<act.Solicitud>>>? _solicitudes;

  @override
  void initState() {
    super.initState();
    maq.reintentarOficios = () =>
        ref.read(oficiosControllerProvider.notifier).reintentar();
    maq.reintentarSolicitudes = () {
      if (_solicitudes == null) return;
      ref.read(act.solicitudesRealesControllerProvider.notifier).reintentar();
    };
    ref.listenManual(oficiosControllerProvider, (_, estado) {
      _aplicar(estado);
      // El catálogo ayuda a reconocer el oficio de cada solicitud.
      final s = _solicitudes;
      if (s != null) _aplicarSolicitudes(s.read());
    }, fireImmediately: true);
    ref.listenManual(
      act.solicitudesRealesActivasProvider,
      (_, activo) => _alternarSolicitudes(activo),
      fireImmediately: true,
    );
  }

  /// Empieza o deja de pedir las solicitudes según haya sesión y API. Sin
  /// ellas no se pide nada y la maqueta queda como estaba.
  void _alternarSolicitudes(bool activo) {
    if (!activo) {
      _solicitudes?.close();
      _solicitudes = null;
      scheduleMicrotask(
        () => maq.fijarSolicitudesReales(null, estado: CargaReal.inactiva),
      );
      return;
    }
    _solicitudes ??= ref.listenManual(
      act.solicitudesRealesControllerProvider,
      (_, estado) => _aplicarSolicitudes(estado),
      fireImmediately: true,
    );
  }

  /// Convierte las solicitudes en [Job] reales; las de un oficio que la
  /// maqueta no sabe dibujar se omiten.
  void _aplicarSolicitudes(AsyncValue<List<act.Solicitud>> estado) {
    final catalogo = {
      for (final o
          in ref.read(oficiosControllerProvider).value ?? const <Oficio>[])
        o.nombre.trim().toLowerCase(): o.clave,
    };
    final List<Job>? reales = estado.hasValue
        ? [
            for (final s in estado.requireValue)
              ?jobDeSolicitud(s, catalogo: catalogo),
          ]
        : null;
    final error = estado.hasError && !estado.hasValue;
    final carga = reales != null
        ? CargaReal.lista
        : error
        ? CargaReal.error
        : CargaReal.cargando;
    scheduleMicrotask(() => maq.fijarSolicitudesReales(reales, estado: carga));
  }

  /// Se difiere un instante: avisar a las pantallas durante el montaje o la
  /// construcción las haría reconstruirse a media construcción.
  void _aplicar(AsyncValue<List<Oficio>> estado) {
    final ids = estado.hasValue
        ? [
            for (final o in estado.requireValue)
              if (cats.containsKey(o.clave)) o.clave,
          ]
        : null;
    final error = estado.hasError && !estado.hasValue;
    scheduleMicrotask(
      () => maq.fijarOficios(error ? const [] : ids, error: error),
    );
  }

  @override
  void dispose() {
    _solicitudes?.close();
    maq.reintentarOficios = null;
    maq.reintentarSolicitudes = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
