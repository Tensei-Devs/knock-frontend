import 'package:app/core/tema/colores_mapa.dart';
import 'package:app/features/previa/demo/datos_de_ejemplo.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';

/// Color del pin por oficio (`MECOLOR` de la maqueta; la electricidad usa el
/// tono más oscuro del par para que el texto blanco se lea).
Color colorDeOficio(String clave) => switch (clave) {
  'mec' => ColoresMapa.pinMecanica,
  'plo' => ColoresMapa.pinPlomeria,
  'ele' => ColoresMapa.pinElectricidad,
  _ => ColoresMapa.pinMecanica,
};

/// Ícono del oficio para el pin y el avatar.
IconData iconoDeOficio(String clave) => switch (clave) {
  'mec' => Icons.directions_car_outlined,
  'plo' => Icons.water_drop_outlined,
  'ele' => Icons.bolt_outlined,
  _ => Icons.handyman_outlined,
};

/// Pin de un experto de ejemplo en el mapa (spec 027, R-12): globo con el
/// ícono del oficio y la calificación, del color del oficio. Mide siempre
/// 72 por 48 dp (área táctil) y no cambia de tamaño con el zoom. Tocarlo
/// pide cuenta; nunca muestra contacto ni dirección.
class PinExperto extends StatelessWidget {
  const PinExperto({required this.experto, required this.alTocar, super.key});

  static const ancho = 72.0;
  static const alto = 48.0;

  final ExpertoDeEjemplo experto;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final color = colorDeOficio(experto.claveOficio);
    return Semantics(
      button: true,
      excludeSemantics: true,
      label: textos.previaPinSemantica(experto.nombre),
      onTap: alTocar,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: alTocar,
        child: SizedBox(
          width: ancho,
          height: alto,
          child: FittedBox(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: ColoresMapa.sombraPin,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          iconoDeOficio(experto.claveOficio),
                          size: 15,
                          color: ColoresMapa.sobrePin,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          experto.calificacion,
                          style: const TextStyle(
                            color: ColoresMapa.sobrePin,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomPaint(size: const Size(14, 6), painter: _Punta(color)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Punta extends CustomPainter {
  const _Punta(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) => canvas.drawPath(
    Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close(),
    Paint()..color = color,
  );

  @override
  bool shouldRepaint(_Punta anterior) => anterior.color != color;
}
