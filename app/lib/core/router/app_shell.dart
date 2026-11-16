import 'package:app/core/sesion/es_tecnico_provider.dart';
import 'package:app/features/maqueta/anim_k.dart';
import 'package:app/features/maqueta/estado.dart';
import 'package:app/core/tema/colores.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Índice de la rama Trabajo dentro del `StatefulShellRoute`.
const int ramaTrabajo = 3;

/// Destino de la barra inferior, en el mismo orden que las ramas del router.
class _Destino {
  const _Destino(this.etiqueta, this.icono, this.iconoSeleccionado);

  /// Texto de la etiqueta en el idioma activo (ARB).
  final String Function(AppLocalizations textos) etiqueta;
  final IconData icono;
  final IconData iconoSeleccionado;
}

String _tabInicio(AppLocalizations t) => t.tabInicio;
String _tabExplorar(AppLocalizations t) => t.tabExplorar;
String _tabActividad(AppLocalizations t) => t.tabActividad;
String _tabTrabajo(AppLocalizations t) => t.tabTrabajo;
String _tabCuenta(AppLocalizations t) => t.tabCuenta;

const List<_Destino> _destinos = [
  _Destino(_tabInicio, Icons.home_outlined, Icons.home),
  _Destino(_tabExplorar, Icons.auto_awesome_outlined, Icons.auto_awesome),
  _Destino(_tabActividad, Icons.work_outline, Icons.work),
  _Destino(_tabTrabajo, Icons.handyman_outlined, Icons.handyman),
  _Destino(_tabCuenta, Icons.person_outline, Icons.person),
];

/// Ramas visibles en la barra según el rol: sin técnico no hay Trabajo.
List<int> ramasVisibles({required bool esTecnico}) => [
  for (var i = 0; i < _destinos.length; i++)
    if (esTecnico || i != ramaTrabajo) i,
];

/// Estructura con la barra inferior Inicio · Explorar · Actividad · Trabajo ·
/// Mi cuenta (Trabajo solo si el usuario es técnico).
class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ramas = ramasVisibles(esTecnico: ref.watch(esTecnicoProvider));
    final seleccionado = ramas.indexOf(navigationShell.currentIndex);
    final textos = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: maq,
      builder: (context, _) => _construir(context, ramas, seleccionado, textos),
    );
  }

  /// Insignia de la maqueta: mensajes sin leer en Actividad y solicitudes
  /// nuevas en Trabajo.
  Widget _conInsignia(int rama, Widget icono) {
    final n = rama == 2 ? maq.unreadCount : rama == ramaTrabajo ? maq.pv.nuevasN : 0;
    if (n <= 0) return icono;
    return PulsoInsignia(valor: n, child: Badge(label: Text('$n'), child: icono));
  }

  Widget _construir(
    BuildContext context,
    List<int> ramas,
    int seleccionado,
    AppLocalizations textos,
  ) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: context.colores.linea)),
        ),
        child: NavigationBar(
          selectedIndex: seleccionado < 0 ? 0 : seleccionado,
          onDestinationSelected: (indice) {
            final rama = ramas[indice];
            navigationShell.goBranch(
              rama,
              initialLocation: rama == navigationShell.currentIndex,
            );
          },
          destinations: [
            for (final rama in ramas)
              NavigationDestination(
                icon: _conInsignia(rama, Icon(_destinos[rama].icono)),
                selectedIcon: _conInsignia(
                  rama,
                  Icon(_destinos[rama].iconoSeleccionado),
                ),
                label: _destinos[rama].etiqueta(textos),
              ),
          ],
        ),
      ),
    );
  }
}
