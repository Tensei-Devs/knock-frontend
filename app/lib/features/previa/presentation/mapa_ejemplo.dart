import 'package:app/core/tema/colores.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:app/features/previa/demo/datos_de_ejemplo.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';

/// Rótulo fijo «Datos de ejemplo» (spec 027, R-12 y R-17): no se puede
/// ocultar y se lee en voz alta.
class RotuloDeEjemplo extends StatelessWidget {
  const RotuloDeEjemplo({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colores;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.amberSoft,
        borderRadius: BorderRadius.circular(Radios.chip),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          AppLocalizations.of(context).previaDatosDeEjemplo,
          style: Theme.of(context).textTheme.labelLarge
              ?.copyWith(color: c.sobreAmberSoft, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

/// Mapa de ejemplo (spec 027, R-12, decisión D-06): un lienzo dibujado por la
/// app, sin SDK de mapas, sin ubicación y sin permisos. Los pines son
/// fracciones del lienzo, no coordenadas. Tocar un pin pide cuenta.
class MapaDeEjemplo extends StatelessWidget {
  const MapaDeEjemplo({
    required this.expertos,
    required this.alTocarExperto,
    super.key,
  });

  final List<ExpertoDeEjemplo> expertos;
  final ValueChanged<ExpertoDeEjemplo> alTocarExperto;

  static const _pin = Alturas.areaTactil;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final c = context.colores;
    final esquema = Theme.of(context).colorScheme;
    return Semantics(
      container: true,
      label: textos.previaMapaSemantica,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radios.grande),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: LayoutBuilder(
            builder: (context, caja) => Stack(
              children: [
                Positioned.fill(
                  child: ExcludeSemantics(
                    child: CustomPaint(
                      painter: _LienzoDeMapa(
                        fondo: c.navySoft,
                        manzana: esquema.surfaceContainer,
                        calle: c.linea,
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  left: Espaciado.fila,
                  top: Espaciado.fila,
                  child: RotuloDeEjemplo(),
                ),
                for (final experto in expertos)
                  Positioned(
                    left: experto.x * caja.maxWidth - _pin / 2,
                    top: experto.y * caja.maxHeight - _pin,
                    width: _pin,
                    height: _pin,
                    child: Semantics(
                      button: true,
                      excludeSemantics: true,
                      label: textos.previaPinSemantica(experto.nombre),
                      onTap: () => alTocarExperto(experto),
                      child: InkResponse(
                        onTap: () => alTocarExperto(experto),
                        child: Icon(
                          Icons.location_on,
                          size: 40,
                          color: esquema.primary,
                        ),
                      ),
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

class _LienzoDeMapa extends CustomPainter {
  const _LienzoDeMapa({
    required this.fondo,
    required this.manzana,
    required this.calle,
  });

  final Color fondo;
  final Color manzana;
  final Color calle;

  @override
  void paint(Canvas canvas, Size tamano) {
    canvas.drawRect(Offset.zero & tamano, Paint()..color = fondo);
    final relleno = Paint()..color = manzana;
    // Manzanas: una cuadrícula irregular dibujada a mano.
    const columnas = [0.04, 0.34, 0.66];
    const filas = [0.06, 0.38, 0.70];
    for (final x in columnas) {
      for (final y in filas) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              x * tamano.width,
              y * tamano.height,
              0.28 * tamano.width,
              0.26 * tamano.height,
            ),
            const Radius.circular(10),
          ),
          relleno,
        );
      }
    }
    final trazo = Paint()
      ..color = calle
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawLine(
      Offset(0, 0.34 * tamano.height),
      Offset(tamano.width, 0.34 * tamano.height),
      trazo,
    );
    canvas.drawLine(
      Offset(0.32 * tamano.width, 0),
      Offset(0.32 * tamano.width, tamano.height),
      trazo,
    );
  }

  @override
  bool shouldRepaint(_LienzoDeMapa anterior) =>
      anterior.fondo != fondo ||
      anterior.manzana != manzana ||
      anterior.calle != calle;
}
