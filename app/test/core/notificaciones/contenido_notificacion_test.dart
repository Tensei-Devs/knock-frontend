import 'package:app/core/notificaciones/contenido_notificacion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CA-012-05 los textos no llevan datos sensibles', () {
    const seguros = [
      'Tienes una nueva cotización',
      'Te llegó un mensaje',
      'Tu visita fue confirmada',
      '3 novedades en tus solicitudes',
    ];
    for (final texto in seguros) {
      test('CA_012_05 «$texto» es seguro', () {
        expect(revisarTextoDeNotificacion(texto), isEmpty);
        expect(esTextoSeguro(texto), isTrue);
      });
    }

    const conCodigo = [
      'Tu código de visita es 4821',
      'Código: ABC',
      'Tu clave llegó',
      'Llama al 771 123 4567',
      'PIN de la visita 12-34',
    ];
    for (final texto in conCodigo) {
      test('CA_012_05 «$texto» se rechaza por código', () {
        expect(
          revisarTextoDeNotificacion(texto),
          contains(MotivoSensible.codigo),
        );
      });
    }

    const conDireccion = [
      'El técnico llega a Calle Hidalgo',
      'Visita en Av. Juárez #12',
      'Colonia Aviación, Actopan',
      'Tu domicilio fue confirmado',
    ];
    for (final texto in conDireccion) {
      test('CA_012_05 «$texto» se rechaza por dirección', () {
        expect(
          revisarTextoDeNotificacion(texto),
          contains(MotivoSensible.direccion),
        );
      });
    }
  });
}
