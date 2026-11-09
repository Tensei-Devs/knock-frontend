import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/sesion/es_tecnico_provider.dart';
import 'package:app/core/widgets/pantalla_titulada.dart';
import 'package:app/features/cuenta/presentation/avatar_iniciales.dart';
import 'package:app/features/cuenta/presentation/perfil_controller.dart';
import 'package:app/features/cuenta/presentation/widgets/menu_de_prueba.dart';
import 'package:app/l10n/generado/app_localizations.dart';

/// Pestaña Mi cuenta: el perfil (HU-002), la entrada a Configuración
/// (HU-052), Cerrar sesión (HU-004, simulado) y, solo fuera de release, el
/// interruptor de prueba del modo técnico.
class CuentaScreen extends ConsumerWidget {
  const CuentaScreen({super.key});

  Future<void> _cerrarSesion(BuildContext context, WidgetRef ref) async {
    final textos = AppLocalizations.of(context);
    final confirmo = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: Text(textos.cuentaCerrarSesionTitulo),
        content: Text(textos.cuentaCerrarSesionCuerpo),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(false),
            child: Text(textos.cuentaCancelar),
          ),
          FilledButton(
            onPressed: () => Navigator.of(contexto).pop(true),
            child: Text(textos.cuentaCerrarSesion),
          ),
        ],
      ),
    );
    if (confirmo ?? false) {
      await ref.read(perfilControllerProvider.notifier).cerrarSesion();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = AppLocalizations.of(context);
    final perfil = ref.watch(perfilControllerProvider).value;
    return PantallaTitulada(
      titulo: textos.tabCuenta,
      cuerpo: ListView(
        children: [
          if (perfil != null && perfil.completo)
            ListTile(
              leading: AvatarIniciales(perfil: perfil),
              title: Text(perfil.nombre),
              subtitle: Text(textos.cuentaEditarPerfil),
              trailing: const ExcludeSemantics(
                child: Icon(Icons.chevron_right),
              ),
              onTap: () => context.push(Rutas.completarPerfil),
            ),
          ListTile(
            leading: const ExcludeSemantics(
              child: Icon(Icons.settings_outlined),
            ),
            title: Text(textos.configuracionTitulo),
            trailing: const ExcludeSemantics(child: Icon(Icons.chevron_right)),
            onTap: () => context.go(Rutas.configuracion),
          ),
          ListTile(
            leading: const ExcludeSemantics(child: Icon(Icons.logout)),
            title: Text(textos.cuentaCerrarSesion),
            onTap: () => _cerrarSesion(context, ref),
          ),
          // Se retira cuando la sesión real dé el rol (TT-MOB-01).
          if (ref.watch(interruptorDePruebaProvider)) const MenuDePrueba(),
        ],
      ),
    );
  }
}
