import 'package:app/core/notificaciones/carga_notificacion.dart';
import 'package:app/core/notificaciones/contenido_notificacion.dart';
import 'package:app/core/preferencias/almacen_avisos.dart';
import 'package:app/core/router/rutas.dart';
import 'package:flutter_test/flutter_test.dart';

/// Spec 016, CA-09: el código de la visita no aparece en la notificación ni en
/// su carga; solo en la pantalla de la visita. El servidor arma los avisos
/// sin el código (backend 022) y la app agrega dos barreras: la carga solo
/// conserva tipo, destino y conversación, y el texto con un código se marca
/// como no seguro (spec 012, R-03).
void main() {
  const codigo = '4712';

  group('CA_016_09 el código no viaja en la carga del aviso', () {
    test('CA_016_09 una carga que trae el código lo descarta', () {
      final carga = CargaNotificacion.desde({
        'tipo': 'visitas',
        'destino': 'actividad',
        'codigo': codigo,
        'visita': 'vvvvvvvvvvvvvvvvvvvvvvvv',
        'texto': 'Tu código es $codigo',
      })!;

      expect(carga.tipo, TipoAviso.visitas);
      expect(carga.ruta, Rutas.actividad);
      expect(carga.ruta, isNot(contains(codigo)));
      expect(carga.conversacion, isNull);
      expect(carga.toString(), isNot(contains(codigo)));
    });

    test(
      'CA_016_09 abrir la visita desde el aviso no lleva el código en la ruta',
      () {
        final carga = CargaNotificacion.desde({
          'tipo': 'visitas',
          'destino': codigo,
        })!;

        // Un destino desconocido cae en la pantalla natural del tipo.
        expect(carga.ruta, Rutas.actividad);
      },
    );
  });

  group('CA_016_09 un texto con el código no es seguro para mostrarse', () {
    for (final texto in [
      'Tu técnico llegó. Código $codigo',
      'Dile 4 7 1 2 en la puerta',
      'Usa 4-7-1-2',
      'Tu clave de visita',
    ]) {
      test('CA_016_09 «$texto» se marca como sensible', () {
        expect(
          revisarTextoDeNotificacion(texto),
          contains(MotivoSensible.codigo),
        );
        expect(esTextoSeguro(texto), isFalse);
      });
    }

    test('CA_016_09 el aviso esperado de la visita sí es seguro', () {
      expect(
        esTextoSeguro('Tu técnico ya llegó. Abre Knock para verlo.'),
        isTrue,
      );
    });
  });
}
