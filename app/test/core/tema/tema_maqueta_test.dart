// Spec 014 (KNOCK-242), CA-01 a CA-03: tipografía, tokens y contraste de la
// maqueta. Sin red ni datos personales.
import 'dart:io';
import 'dart:typed_data';

import 'package:app/core/tema/colores.dart';
import 'package:app/core/tema/contraste.dart';
import 'package:app/core/tema/tema.dart';
import 'package:app/core/tema/tipografia.dart';
import 'package:app/core/tema/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// `usWeightClass` de la tabla OS/2 de un TTF (lo que declara la fuente, no
/// el nombre del archivo).
int _pesoDelTtf(String ruta) {
  final bytes = File(ruta).readAsBytesSync();
  final datos = ByteData.sublistView(bytes);
  expect(datos.getUint32(0), 0x00010000, reason: '$ruta no es un TTF');
  final tablas = datos.getUint16(4);
  for (var i = 0; i < tablas; i++) {
    final registro = 12 + i * 16;
    final etiqueta = String.fromCharCodes(
      bytes.sublist(registro, registro + 4),
    );
    if (etiqueta == 'OS/2') {
      return datos.getUint16(datos.getUint32(registro + 8) + 4);
    }
  }
  fail('$ruta no tiene tabla OS/2');
}

void main() {
  group('CA_014_01 tipografía Nunito 400 a 900', () {
    test('CA_014_01 los dos temas usan Nunito y la escala de la maqueta', () {
      for (final tema in [temaClaro, temaOscuro]) {
        final t = tema.textTheme;
        expect(t.headlineMedium!.fontFamily, familiaTipografica);
        // (.h1, .h2, .h3, .t, .s) → (tamaño, peso)
        expect(
          [
            (t.headlineMedium!.fontSize, t.headlineMedium!.fontWeight),
            (t.headlineSmall!.fontSize, t.headlineSmall!.fontWeight),
            (t.titleMedium!.fontSize, t.titleMedium!.fontWeight),
          ],
          [
            (26.0, FontWeight.w900),
            (20.0, FontWeight.w900),
            (17.0, FontWeight.w900),
          ],
        );
        expect(t.bodyLarge!.fontSize, 16);
        expect(t.bodyMedium!.fontSize, 14);
        expect(tema.appBarTheme.titleTextStyle!.fontWeight, FontWeight.w900);
        expect(textoDeBoton.fontWeight, FontWeight.w900);
      }
    });

    test('CA_014_01 pubspec declara los seis pesos y cada TTF existe y pesa lo '
        'que dice', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      final declarados = RegExp(
        r'asset: (assets/fonts/nunito/[\w-]+\.ttf)\s+weight: (\d+)',
      ).allMatches(pubspec).map((m) => (m[1]!, int.parse(m[2]!))).toList();

      expect(
        {for (final (_, peso) in declarados) peso},
        {400, 500, 600, 700, 800, 900},
      );
      for (final (ruta, peso) in declarados) {
        expect(File(ruta).existsSync(), isTrue, reason: ruta);
        expect(_pesoDelTtf(ruta), peso, reason: ruta);
      }
      expect(File('assets/fonts/nunito/OFL.txt').existsSync(), isTrue);
    });
  });

  group('CA_014_02 tokens de la maqueta', () {
    test('CA_014_02 los tokens coinciden con la tabla de R-02', () {
      expect(
        [
          Radios.grande,
          Radios.medio,
          Radios.pequeno,
          Radios.boton,
          Radios.botonChico,
          Radios.chip,
          Radios.hoja,
          Radios.iconoFila,
        ],
        [22, 16, 12, 28, 23, 22, 26, 12],
      );
      expect(
        [
          Alturas.boton,
          Alturas.botonChico,
          Alturas.botonGhost,
          Alturas.campo,
          Alturas.fila,
          Alturas.chip,
          Alturas.barraSuperior,
          Alturas.pestana,
        ],
        [56, 46, 48, 56, 62, 44, 60, 54],
      );
      expect(
        [
          Espaciado.cuerpo,
          Espaciado.bloque,
          Espaciado.bloqueChico,
          Espaciado.fila,
          Espaciado.iconoAFila,
          Espaciado.tarjeta,
        ],
        [20, 16, 8, 12, 14, 16],
      );
      expect(Sombras.tarjeta, hasLength(2));
      expect(Sombras.tarjeta[0].offset, const Offset(0, 1));
      expect(Sombras.tarjeta[0].blurRadius, 3);
      expect(Sombras.tarjeta[1].offset, const Offset(0, 4));
      expect(Sombras.tarjeta[1].blurRadius, 14);
      // rgba(30,58,95,.06) y .05 sobre 255.
      expect(Sombras.tarjeta[0].color.a, closeTo(0.06, 0.005));
      expect(Sombras.tarjeta[1].color.a, closeTo(0.05, 0.005));
    });

    test('CA_014_02 el tema aplica los tokens a botones, campos y barras', () {
      for (final tema in [temaClaro, temaOscuro]) {
        final relleno = tema.filledButtonTheme.style!;
        expect(
          relleno.minimumSize!.resolve({})!.height,
          Alturas.boton,
          reason: 'FilledButton',
        );
        expect(
          tema.textButtonTheme.style!.minimumSize!.resolve({})!.height,
          Alturas.botonGhost,
          reason: 'TextButton',
        );
        expect(
          tema.outlinedButtonTheme.style!.minimumSize!.resolve({})!.height,
          Alturas.boton,
          reason: 'OutlinedButton',
        );
        expect(relleno.shape!.resolve({}), isA<StadiumBorder>());
        final borde = tema.inputDecorationTheme.border! as OutlineInputBorder;
        expect(borde.borderRadius, BorderRadius.circular(Radios.pequeno));
        expect(tema.appBarTheme.toolbarHeight, Alturas.barraSuperior);
        expect(
          (tema.cardTheme.shape! as RoundedRectangleBorder).borderRadius,
          BorderRadius.circular(Radios.grande),
        );
      }
    });

    test('CA_014_02 las pantallas migradas no escriben radios, alturas ni '
        'sombras sueltas', () {
      const migradas = [
        'lib/features/entrada/presentation/celular_screen.dart',
        'lib/features/entrada/presentation/codigo_screen.dart',
        'lib/features/entrada/presentation/widgets/marco_de_entrada.dart',
        'lib/features/cuenta/presentation/completar_perfil_screen.dart',
        'lib/features/cuenta/presentation/cuenta_screen.dart',
        'lib/features/inicio/presentation/inicio_screen.dart',
        'lib/features/explorar/presentation/explorar_screen.dart',
        'lib/features/actividad/presentation/actividad_screen.dart',
        'lib/features/oficios/presentation/oficios_screen.dart',
        'lib/core/widgets/tarjeta_knock.dart',
        'lib/core/widgets/fila_knock.dart',
        'lib/core/widgets/estado_knock.dart',
      ];
      final suelto = RegExp(
        r'Radius\.circular\(\s*\d|BoxShadow\(|Size\(\s*\d|Size\.fromHeight\(\s*\d',
      );
      final infractores = <String>[
        for (final ruta in migradas)
          if (suelto.hasMatch(File(ruta).readAsStringSync())) ruta,
      ];
      expect(infractores, isEmpty);
    });
  });

  group('CA_014_03 contraste de los pares de los componentes', () {
    void espera(Color texto, Color fondo, String par, double minimo) {
      expect(
        relacionDeContraste(texto, fondo),
        greaterThanOrEqualTo(minimo),
        reason: par,
      );
    }

    for (final (nombre, tema) in [
      ('claro', temaClaro),
      ('oscuro', temaOscuro),
    ]) {
      test('CA_014_03 en $nombre cada par de texto cumple 4.5:1 y cada borde '
          '3:1', () {
        final e = tema.colorScheme;
        final c = tema.extension<ColoresKnock>()!;
        final fondos = {'superficie': e.surfaceContainer, 'fondo': e.surface};

        for (final MapEntry(key: etiqueta, value: fondo) in fondos.entries) {
          espera(e.onSurface, fondo, 'ink/$etiqueta', contrasteMinimoTexto);
          espera(
            e.onSurfaceVariant,
            fondo,
            'mut/$etiqueta',
            contrasteMinimoTexto,
          );
          // Contorno de los campos (`.inp`): 1.4.11.
          espera(
            e.outline,
            fondo,
            'outline/$etiqueta',
            contrasteMinimoComponente,
          );
          // Pestaña seleccionada y título de la barra.
          espera(
            c.sobreNavySoft,
            fondo,
            'pestaña/$etiqueta',
            contrasteMinimoTexto,
          );
        }
        espera(
          c.sobreNavySoft,
          c.navySoft,
          'ícono de fila',
          contrasteMinimoTexto,
        );
        espera(
          c.sobreAmberSoft,
          c.amberSoft,
          'aviso naranja',
          contrasteMinimoTexto,
        );
        espera(c.sobreNavyBg, c.navyBg, 'botón oscuro', contrasteMinimoTexto);
        espera(e.onPrimary, e.primary, 'botón relleno', contrasteMinimoTexto);
        // Pestaña activa: la etiqueta cae sobre la barra y el ícono sobre la
        // píldora; ambos pares valen.
        espera(c.sobreNavySoft, c.navySoft, 'ícono sobre la píldora', 4.5);
      });
    }

    test(
      'CA_014_03 sobre navybg y navy-soft solo va ink (o blanco en claro)',
      () {
        expect(ColoresKnock.oscuro.sobreNavyBg, ColoresOscuro.ink);
        expect(ColoresKnock.oscuro.sobreNavySoft, ColoresOscuro.ink);
        expect(ColoresKnock.claro.sobreNavyBg, const Color(0xFFFFFFFF));
        // Nunca `mut` ni `navy` sobre navybg en oscuro (3.44:1 y 4.25:1).
        for (final prohibido in [ColoresOscuro.mut, ColoresOscuro.navy]) {
          expect(
            relacionDeContraste(prohibido, ColoresOscuro.navybg),
            lessThan(contrasteMinimoTexto),
          );
          expect(ColoresKnock.oscuro.sobreNavyBg, isNot(prohibido));
        }
      },
    );

    test(
      'CA_014_03 el borde de ink del botón relleno en claro se conserva',
      () {
        final borde = temaClaro.filledButtonTheme.style!.side!.resolve({})!;
        expect(borde.color, ColoresClaro.ink);
        expect(borde.width, greaterThan(0));
        expect(temaOscuro.filledButtonTheme.style!.side, isNull);
      },
    );
  });
}
