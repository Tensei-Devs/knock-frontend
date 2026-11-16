// Spec 014 (KNOCK-242) R-04 y CA-03, tarea KNOCK-175 (TT-MOB-07): los rótulos
// y pines del mapa dibujado de la previa cumplen 4.5:1 en claro y oscuro.
import 'package:app/core/tema/colores_mapa.dart';
import 'package:app/core/tema/contraste.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

/// Opacidad con la que `lienzo_mapa.dart` pinta los nombres de colonia.
const _opacidadColonia = .85;

/// Cada rótulo contra el color que tiene detrás al pintarse en
/// `lienzo_mapa.dart`: el halo de `_texto` o, para la avenida, su relleno.
Map<String, (Color, Color)> _rotulos(PaletaMapa p) => {
  'avenida/avenida': (p.textoAvenida, p.avenida),
  'colonia/fondo': (
    Color.alphaBlend(
      p.textoColonia.withValues(alpha: _opacidadColonia),
      p.fondo,
    ),
    p.fondo,
  ),
  'parque/parque': (p.textoParque, p.parque),
  'río/borde del río': (p.textoRio, p.rioBorde),
};

void main() {
  group('CA_014_03 contraste del mapa de la previa', () {
    for (final (nombre, paleta) in [
      ('claro', PaletaMapa.claro),
      ('oscuro', PaletaMapa.oscuro),
    ]) {
      test(
        'CA_014_03 en $nombre cada rótulo del mapa cumple 4.5:1 con su halo',
        () {
          for (final MapEntry(key: par, value: (texto, fondo)) in _rotulos(
            paleta,
          ).entries) {
            final relacion = relacionDeContraste(texto, fondo);
            expect(
              relacion,
              greaterThanOrEqualTo(contrasteMinimoTexto),
              reason: '$nombre $par da ${relacion.toStringAsFixed(2)}:1',
            );
          }
        },
      );
    }

    test('CA_014_03 el texto de cada pin de oficio cumple 4.5:1', () {
      for (final MapEntry(key: oficio, value: pin) in {
        'mecánica': ColoresMapa.pinMecanica,
        'plomería': ColoresMapa.pinPlomeria,
        'electricidad': ColoresMapa.pinElectricidad,
      }.entries) {
        final relacion = relacionDeContraste(ColoresMapa.sobrePin, pin);
        expect(
          relacion,
          greaterThanOrEqualTo(contrasteMinimoTexto),
          reason: '$oficio da ${relacion.toStringAsFixed(2)}:1',
        );
      }
    });

    test(
      'CA_014_03 los rótulos de la maqueta original no cumplían (KNOCK-175)',
      () {
        // Valores de `worldSvg` de la maqueta: si alguien los regresa, la
        // prueba de arriba falla; esta documenta por qué se cambiaron.
        const maqueta = {
          'claro colonia': (Color(0xFF8E8776), Color(0xFFF2EFE9), .85),
          'claro avenida': (Color(0xFF7A6B45), Color(0xFFFFE3A8), 1.0),
          'claro parque': (Color(0xFF5F8C48), Color(0xFFCDEBB0), 1.0),
          'claro río': (Color(0xFF4C8FA3), Color(0xFFAAD3DF), 1.0),
          'oscuro río': (Color(0xFF8FC4D6), Color(0xFF2A5568), 1.0),
        };
        for (final MapEntry(key: par, value: (texto, fondo, alfa))
            in maqueta.entries) {
          final mezcla = Color.alphaBlend(texto.withValues(alpha: alfa), fondo);
          expect(
            relacionDeContraste(mezcla, fondo),
            lessThan(contrasteMinimoTexto),
            reason: par,
          );
        }
        expect(PaletaMapa.claro.textoColonia, isNot(const Color(0xFF8E8776)));
        expect(PaletaMapa.oscuro.textoRio, isNot(const Color(0xFF8FC4D6)));
      },
    );
  });
}
