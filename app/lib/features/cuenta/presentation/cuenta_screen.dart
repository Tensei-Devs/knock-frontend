import 'package:app/core/router/rutas.dart';
import 'package:app/core/sesion/es_tecnico_provider.dart';
import 'package:app/core/tema/colores.dart';
import 'package:app/core/tema/tema.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:app/core/widgets/fila_knock.dart';
import 'package:app/core/widgets/pantalla_titulada.dart';
import 'package:app/core/widgets/tarjeta_knock.dart';
import 'package:app/features/cuenta/domain/perfil.dart';
import 'package:app/features/cuenta/presentation/avatar_iniciales.dart';
import 'package:app/features/cuenta/presentation/perfil_controller.dart';
import 'package:app/features/cuenta/presentation/widgets/menu_de_prueba.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Pestaña Mi cuenta: el perfil (HU-002), la entrada a Configuración
/// (HU-052), Cerrar sesión (HU-004, simulado) y, solo fuera de release, el
/// interruptor de prueba del modo técnico.
class CuentaScreen extends ConsumerWidget {
  const CuentaScreen({super.key});

  Future<void> _cerrarSesion(BuildContext context, WidgetRef ref) async {
    final confirmo = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _ConfirmarCierreDeSesion(),
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
        padding: const EdgeInsets.all(Espaciado.cuerpo),
        children: [
          if (perfil != null && perfil.completo) ...[
            _TarjetaDePerfil(perfil: perfil),
            const SizedBox(height: Espaciado.bloque),
          ],
          GrupoDeFilas(
            filas: [
              FilaKnock(
                icono: Icons.settings_outlined,
                titulo: textos.configuracionTitulo,
                alTocar: () => context.go(Rutas.configuracion),
              ),
            ],
          ),
          const SizedBox(height: Espaciado.bloque),
          // `.btn.ghost`: Cerrar sesión sin relleno.
          TextButton.icon(
            icon: const ExcludeSemantics(child: Icon(Icons.logout)),
            label: Text(textos.cuentaCerrarSesion),
            onPressed: () => _cerrarSesion(context, ref),
          ),
          // Se retira cuando la sesión real dé el rol (TT-MOB-01).
          if (ref.watch(interruptorDePruebaProvider)) const MenuDePrueba(),
        ],
      ),
    );
  }
}

/// Tarjeta del perfil (`S.cuenta`, P20): avatar, nombre y «Editar perfil».
/// Solo muestra lo que tiene `Perfil`; el teléfono de la maqueta queda fuera.
class _TarjetaDePerfil extends StatelessWidget {
  const _TarjetaDePerfil({required this.perfil});

  final Perfil perfil;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final textos = AppLocalizations.of(context);
    return Semantics(
      button: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radios.grande),
        child: InkWell(
          onTap: () => context.push(Rutas.completarPerfil),
          child: TarjetaKnock(
            child: Row(
              children: [
                AvatarIniciales(perfil: perfil, radio: 32),
                const SizedBox(width: Espaciado.fila),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(perfil.nombre, style: tema.textTheme.titleMedium),
                      Text(
                        textos.cuentaEditarPerfil,
                        style: tema.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: tema.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                ExcludeSemantics(
                  child: Icon(
                    Icons.chevron_right,
                    color: tema.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Hoja inferior de la maqueta (`.sheet`) que pide confirmar el cierre de
/// sesión. Devuelve `true` al confirmar y `false` al cancelar.
class _ConfirmarCierreDeSesion extends StatelessWidget {
  const _ConfirmarCierreDeSesion();

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        Espaciado.cuerpo,
        10,
        Espaciado.cuerpo,
        22,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // `.grab`
          Center(
            child: ExcludeSemantics(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: context.colores.linea,
                  borderRadius: BorderRadius.circular(Radios.asa),
                ),
              ),
            ),
          ),
          const SizedBox(height: Espaciado.bloque),
          Text(
            textos.cuentaCerrarSesionTitulo,
            style: tema.textTheme.headlineSmall,
          ),
          const SizedBox(height: Espaciado.bloque),
          Text(
            textos.cuentaCerrarSesionCuerpo,
            style: tema.textTheme.bodyLarge?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Espaciado.bloque),
          FilledButton(
            style: estiloBotonOscuro(context),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(textos.cuentaCerrarSesion),
          ),
          const SizedBox(height: Espaciado.bloqueChico),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(textos.cuentaCancelar),
          ),
        ],
      ),
    );
  }
}
