import 'package:app/core/router/rutas.dart';
import 'package:app/core/tema/colores.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:app/core/widgets/tarjeta_knock.dart';
import 'package:app/features/oficios/oficios.dart';
import 'package:app/features/oficios/presentation/oficios_controller.dart';
import 'package:app/features/previa/presentation/barra_marca.dart';
import 'package:app/features/previa/presentation/buscador_previa.dart';
import 'package:app/features/previa/presentation/catalogo_previa.dart';
import 'package:app/features/previa/presentation/chips_oficio.dart';
import 'package:app/features/previa/presentation/hoja_invitacion.dart';
import 'package:app/features/previa/presentation/panel_expertos.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Previa sin sesión (`/previa`, spec 027): la pantalla de inicio de la
/// maqueta antes de entrar. Barra de marca con «Entrar» y «Registrarme»,
/// buscador que invita a entrar, chips y catálogo de oficios reales,
/// tarjeta «Explorar servicios y trabajos» y el panel de expertos (vacío
/// honesto en tienda; datos de ejemplo solo en demostración).
///
/// Se desplaza completa: con texto al 200 % nada se corta (CA-31). No pide
/// ubicación ni permisos y no hace ninguna petición protegida (CA-14, CA-30).
class PreviaScreen extends ConsumerStatefulWidget {
  /// [panel] solo lo usan las pruebas para montar el panel de demostración;
  /// la app real lo deja vacío y se elige según `demoDatosActivo`.
  const PreviaScreen({this.panel, super.key});

  final Widget? panel;

  @override
  ConsumerState<PreviaScreen> createState() => _PreviaScreenState();
}

class _PreviaScreenState extends ConsumerState<PreviaScreen> {
  /// Clave del oficio elegido en los chips; `null` es «Todos».
  String? _clave;

  void _invitar() => mostrarHojaInvitacion(context);

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final oficios =
        ref.watch(oficiosControllerProvider).asData?.value ?? const <Oficio>[];
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Espaciado.cuerpo),
          children: [
            const BarraMarca(),
            const SizedBox(height: Espaciado.bloque),
            BuscadorPrevia(alTocar: _invitar),
            const SizedBox(height: Espaciado.bloque),
            ChipsOficio(
              oficios: oficios,
              seleccionado: _clave,
              alElegir: (clave) => setState(() => _clave = clave),
              alNoSeCual: _invitar,
            ),
            const SizedBox(height: Espaciado.bloque),
            const _TarjetaExplorar(),
            const SizedBox(height: Espaciado.bloque),
            widget.panel ?? panelDeExpertos(),
            const SizedBox(height: Espaciado.bloque),
            Semantics(
              header: true,
              child: Text(
                textos.previaCatalogoTitulo,
                style: tema.textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: Espaciado.bloqueChico),
            CatalogoPrevia(clave: _clave),
          ],
        ),
      ),
    );
  }
}

/// «Explorar servicios y trabajos»: abre el catálogo sin pedir sesión
/// (spec 027, R-07). Es subruta de la previa: «atrás» regresa a ella.
class _TarjetaExplorar extends StatelessWidget {
  const _TarjetaExplorar();

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final c = context.colores;
    void abrir() => context.go(Rutas.previaOficios);
    return Semantics(
      button: true,
      excludeSemantics: true,
      label: '${textos.previaExplorarTitulo}. ${textos.previaExplorarDetalle}',
      onTap: abrir,
      child: InkWell(
        borderRadius: BorderRadius.circular(Radios.grande),
        onTap: abrir,
        child: TarjetaKnock(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: Alturas.areaTactil),
            child: Row(
              children: [
                Container(
                  width: Alturas.iconoFila,
                  height: Alturas.iconoFila,
                  decoration: BoxDecoration(
                    color: c.navySoft,
                    borderRadius: BorderRadius.circular(Radios.iconoFila),
                  ),
                  child: Icon(Icons.handyman_outlined, color: c.sobreNavySoft),
                ),
                const SizedBox(width: Espaciado.iconoAFila),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        textos.previaExplorarTitulo,
                        style: tema.textTheme.titleMedium,
                      ),
                      Text(
                        textos.previaExplorarDetalle,
                        style: tema.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
