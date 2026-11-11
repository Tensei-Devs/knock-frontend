import 'dart:math' as math;

import 'package:app/core/tema/colores_mapa.dart';
import 'package:app/features/previa/demo/datos_de_ejemplo.dart';
import 'package:app/features/previa/domain/vista_mapa.dart';
import 'package:app/features/previa/presentation/mapa/controlador_mapa.dart';
import 'package:app/features/previa/presentation/mapa/lienzo_mapa.dart';
import 'package:app/features/previa/presentation/mapa/pin_experto.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';

/// Mapa de la previa a pantalla completa (spec 027, R-12 y R-18, decisión
/// D-12): el mundo de la maqueta dibujado por la app (sin SDK de mapas, sin
/// ubicación y sin permisos), que se arrastra y se acerca con los dedos, con
/// el punto «Tú estás aquí» y los pines de ejemplo.
///
/// Los pines y el punto viven en coordenadas del mundo pero se dibujan como
/// widgets encima, así mantienen su tamaño al hacer zoom.
class MapaPrevia extends StatefulWidget {
  const MapaPrevia({
    required this.controlador,
    required this.expertos,
    required this.alTocarExperto,
    super.key,
  });

  final ControladorMapa controlador;
  final List<ExpertoDeEjemplo> expertos;
  final ValueChanged<ExpertoDeEjemplo> alTocarExperto;

  @override
  State<MapaPrevia> createState() => _MapaPreviaState();
}

class _MapaPreviaState extends State<MapaPrevia> {
  double _escalaAnterior = 1;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final paleta = Theme.of(context).brightness == Brightness.dark
        ? PaletaMapa.oscuro
        : PaletaMapa.claro;
    final controlador = widget.controlador;
    return LayoutBuilder(
      builder: (context, restricciones) {
        controlador.ajustarCaja(restricciones.biggest);
        return GestureDetector(
          onScaleStart: (_) => _escalaAnterior = 1,
          onScaleUpdate: (d) {
            final pinza = d.pointerCount >= 2;
            controlador.gesto(
              dx: d.focalPointDelta.dx,
              dy: d.focalPointDelta.dy,
              factor: pinza ? d.scale / _escalaAnterior : 1,
              fx: d.localFocalPoint.dx,
              fy: d.localFocalPoint.dy,
            );
            if (pinza) _escalaAnterior = d.scale;
          },
          child: ClipRect(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Semantics(
                    container: true,
                    label: textos.previaMapaSemantica,
                    child: ExcludeSemantics(
                      child: CustomPaint(
                        painter: LienzoMapa(
                          vista: controlador.vista,
                          paleta: paleta,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: ValueListenableBuilder<VistaMapa?>(
                    valueListenable: controlador.vista,
                    builder: (context, vista, _) => vista == null
                        ? const SizedBox.shrink()
                        : _Capas(
                            vista: vista,
                            caja: restricciones.biggest,
                            expertos: widget.expertos,
                            alTocarExperto: widget.alTocarExperto,
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Capas extends StatelessWidget {
  const _Capas({
    required this.vista,
    required this.caja,
    required this.expertos,
    required this.alTocarExperto,
  });

  final VistaMapa vista;
  final Size caja;
  final List<ExpertoDeEjemplo> expertos;
  final ValueChanged<ExpertoDeEjemplo> alTocarExperto;

  static const _margen = 80.0;

  bool _visible(math.Point<double> p) =>
      p.x > -_margen &&
      p.x < caja.width + _margen &&
      p.y > -_margen &&
      p.y < caja.height + _margen;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final yo = vista.pantallaDe(VistaMapa.yo.x, VistaMapa.yo.y);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (_visible(yo))
          Positioned(
            left: yo.x - 10,
            top: yo.y - 10,
            child: Semantics(
              label: textos.previaYoAqui,
              child: const ExcludeSemantics(child: _PuntoYo()),
            ),
          ),
        for (final experto in expertos)
          if (_visible(vista.pantallaDe(experto.x, experto.y)))
            Positioned(
              left:
                  vista.pantallaDe(experto.x, experto.y).x -
                  PinExperto.ancho / 2,
              top: vista.pantallaDe(experto.x, experto.y).y - PinExperto.alto,
              child: PinExperto(
                experto: experto,
                alTocar: () => alTocarExperto(experto),
              ),
            ),
      ],
    );
  }
}

/// «Tú estás aquí»: punto azul con halo (`.medot` de la maqueta).
class _PuntoYo extends StatelessWidget {
  const _PuntoYo();

  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: ColoresMapa.punto,
      border: Border.fromBorderSide(
        BorderSide(color: ColoresMapa.puntoBorde, width: 4),
      ),
      boxShadow: [BoxShadow(color: ColoresMapa.puntoHalo, spreadRadius: 8)],
    ),
    child: SizedBox(width: 20, height: 20),
  );
}

/// Botones del mapa: acercar, alejar y «volver a mi ubicación» (`.mctl`).
class ControlesMapa extends StatelessWidget {
  const ControlesMapa({required this.controlador, super.key});

  final ControladorMapa controlador;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        _Boton(
          icono: Icons.add,
          etiqueta: textos.previaMapaAcercar,
          alTocar: controlador.acercar,
        ),
        _Boton(
          icono: Icons.remove,
          etiqueta: textos.previaMapaAlejar,
          alTocar: controlador.alejar,
        ),
        _Boton(
          icono: Icons.my_location,
          etiqueta: textos.previaMapaMiUbicacion,
          alTocar: controlador.ubicarme,
        ),
      ],
    );
  }
}

class _Boton extends StatelessWidget {
  const _Boton({
    required this.icono,
    required this.etiqueta,
    required this.alTocar,
  });

  final IconData icono;
  final String etiqueta;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Material(
      color: esquema.surface,
      elevation: 4,
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: etiqueta,
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
        onPressed: alTocar,
        icon: Icon(icono, color: esquema.primary),
      ),
    );
  }
}
