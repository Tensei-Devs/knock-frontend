import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';

/// Globo flotante de conversaciones con contador (spec 020, CA-08 y CA-17).
class GloboConversaciones extends StatelessWidget {
  const GloboConversaciones({
    required this.total,
    required this.alTocar,
    required this.fondo,
    required this.insignia,
    required this.borde,
    required this.trazo,
    super.key,
  });

  /// Total de no leídos del servidor; `null` o cero no muestra insignia.
  final int? total;
  final VoidCallback alTocar;

  /// Colores del botón, la insignia, su borde y el trazo (icono y número).
  final Color fondo, insignia, borde, trazo;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final n = total ?? 0;
    return Semantics(
      container: true,
      excludeSemantics: true,
      button: true,
      onTap: alTocar,
      label: n > 0
          ? textos.conversacionesGloboConTotal(textos.conversacionesNoLeidos(n))
          : textos.conversacionesGlobo,
      child: GestureDetector(
        onTap: alTocar,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Material(
              color: fondo,
              elevation: 6,
              shape: const CircleBorder(),
              child: SizedBox(
                width: 58,
                height: 58,
                child: Icon(Icons.chat_bubble_outline, color: trazo, size: 26),
              ),
            ),
            if (n > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 22),
                  height: 22,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: insignia,
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: borde, width: 2),
                  ),
                  child: Text(
                    n > 9 ? '9+' : '$n',
                    // La insignia no crece con el texto: el lector de pantalla
                    // ya dice el número completo.
                    textScaler: TextScaler.noScaling,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: trazo,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
