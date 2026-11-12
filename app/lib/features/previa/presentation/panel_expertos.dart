import 'package:app/core/router/rutas.dart';
import 'package:app/core/tema/colores.dart';
import 'package:app/core/tema/colores_mapa.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:app/core/widgets/tarjeta_knock.dart';
import 'package:app/features/previa/demo/datos_de_ejemplo.dart';
import 'package:app/features/previa/presentation/mapa/pin_experto.dart';
import 'package:app/features/previa/presentation/rotulo_ejemplo.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Tamaños del panel como fracción de la altura (`bsheet` de la maqueta):
/// asomado, a la mitad y casi completo.
abstract final class TamanosPanel {
  static const asomado = .12;
  static const mitad = .5;
  static const completo = .88;
}

/// Panel inferior plegable «N expertos cerca de ti» de la previa (spec 027,
/// R-10 y R-12): colonia de ejemplo, «Ver lista» / «Ver mapa», «Explorar
/// servicios y trabajos», las tarjetas de los expertos de ejemplo y el
/// catálogo real de oficios ([catalogo]).
///
/// Se arrastra entre asomado, mitad y completo. Los datos de expertos son de
/// ejemplo y llevan siempre el rótulo «Datos de ejemplo». Tocar una tarjeta
/// pide cuenta y nunca muestra contacto ni dirección; no pide ubicación ni
/// permisos.
class PanelExpertos extends StatefulWidget {
  const PanelExpertos({
    required this.expertos,
    required this.catalogo,
    required this.alTocarExperto,
    this.alCambiarExtension,
    super.key,
  });

  final List<ExpertoDeEjemplo> expertos;

  /// Catálogo de oficios (título y lista), debajo de los expertos.
  final Widget catalogo;
  final ValueChanged<ExpertoDeEjemplo> alTocarExperto;

  /// Avisa la fracción de altura que ocupa el panel (para acomodar los
  /// botones del mapa encima).
  final ValueChanged<double>? alCambiarExtension;

  @override
  State<PanelExpertos> createState() => _PanelExpertosState();
}

class _PanelExpertosState extends State<PanelExpertos> {
  final _controlador = DraggableScrollableController();
  bool _completo = false;

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _alternar() => _controlador.animateTo(
    _completo ? TamanosPanel.mitad : TamanosPanel.completo,
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeOut,
  );

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    final esquema = tema.colorScheme;
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (n) {
        widget.alCambiarExtension?.call(n.extent);
        final completo = n.extent > .7;
        if (completo != _completo) setState(() => _completo = completo);
        return false;
      },
      child: DraggableScrollableSheet(
        controller: _controlador,
        initialChildSize: TamanosPanel.mitad,
        minChildSize: TamanosPanel.asomado,
        maxChildSize: TamanosPanel.completo,
        snap: true,
        snapSizes: const [TamanosPanel.mitad],
        builder: (context, scroll) => Semantics(
          container: true,
          explicitChildNodes: true,
          label: textos.previaPanelEtiqueta,
          child: Material(
            color: esquema.surface,
            elevation: 12,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Radios.hoja),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              controller: scroll,
              padding: const EdgeInsets.fromLTRB(
                Espaciado.tarjeta,
                0,
                Espaciado.tarjeta,
                Espaciado.cuerpo,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Asa(),
                  _Encabezado(
                    cantidad: widget.expertos.length,
                    completo: _completo,
                    alAlternar: _alternar,
                  ),
                  const SizedBox(height: Espaciado.fila),
                  const _TarjetaExplorar(),
                  const SizedBox(height: Espaciado.fila),
                  for (final experto in widget.expertos) ...[
                    _TarjetaExperto(
                      experto: experto,
                      alTocar: () => widget.alTocarExperto(experto),
                    ),
                    const SizedBox(height: Espaciado.bloqueChico),
                  ],
                  const SizedBox(height: Espaciado.bloqueChico),
                  Semantics(
                    header: true,
                    child: Text(
                      textos.previaCatalogoTitulo,
                      style: tema.textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: Espaciado.bloqueChico),
                  widget.catalogo,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Asa para arrastrar el panel (`.bs-grab`); es decorativa, el botón «Ver
/// lista» / «Ver mapa» hace lo mismo con un toque.
class _Asa extends StatelessWidget {
  const _Asa();

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          width: 48,
          height: 5,
          decoration: BoxDecoration(
            color: context.colores.linea,
            borderRadius: BorderRadius.circular(Radios.asa),
          ),
        ),
      ),
    ),
  );
}

class _Encabezado extends StatelessWidget {
  const _Encabezado({
    required this.cantidad,
    required this.completo,
    required this.alAlternar,
  });

  final int cantidad;
  final bool completo;
  final VoidCallback alAlternar;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: Espaciado.fila,
      runSpacing: Espaciado.bloqueChico,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(
                textos.previaExpertosCerca(cantidad),
                style: tema.textTheme.titleLarge,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ExcludeSemantics(
                  child: Icon(Icons.place_outlined, size: 16),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    coloniaDeEjemplo,
                    style: tema.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Espaciado.bloqueChico),
            const RotuloDeEjemplo(),
          ],
        ),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(Alturas.areaTactil, Alturas.areaTactil),
          ),
          onPressed: alAlternar,
          icon: Icon(completo ? Icons.map_outlined : Icons.list, size: 18),
          label: Text(completo ? textos.previaVerMapa : textos.previaVerLista),
        ),
      ],
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

/// Tarjeta de un experto de ejemplo (`.lrow` de la maqueta): avatar con
/// iniciales, nombre, oficio y distancia, y calificación.
class _TarjetaExperto extends StatelessWidget {
  const _TarjetaExperto({required this.experto, required this.alTocar});

  final ExpertoDeEjemplo experto;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final tema = Theme.of(context);
    return Semantics(
      button: true,
      excludeSemantics: true,
      label: textos.previaTarjetaSemantica(experto.nombre, experto.oficio),
      onTap: alTocar,
      child: InkWell(
        borderRadius: BorderRadius.circular(Radios.grande),
        onTap: alTocar,
        child: TarjetaKnock(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: Alturas.areaTactil),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundColor: colorDeOficio(experto.claveOficio),
                  child: Text(
                    experto.iniciales,
                    style: const TextStyle(
                      color: ColoresMapa.sobrePin,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: Espaciado.fila),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(experto.nombre, style: tema.textTheme.titleMedium),
                      Text(
                        '${experto.oficio} · '
                        '${textos.previaDistanciaKm(experto.distanciaKm.toStringAsFixed(1))}',
                        style: tema.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.star_rounded, size: 20),
                const SizedBox(width: 4),
                Text(experto.calificacion, style: tema.textTheme.titleSmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
