import 'package:app/core/sesion/es_tecnico_provider.dart';
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
  _Destino(_tabExplorar, Icons.explore_outlined, Icons.explore),
  _Destino(_tabActividad, Icons.receipt_long_outlined, Icons.receipt_long),
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
                icon: Icon(_destinos[rama].icono),
                selectedIcon: Icon(_destinos[rama].iconoSeleccionado),
                label: _destinos[rama].etiqueta(textos),
              ),
          ],
        ),
      ),
    );
  }
}
