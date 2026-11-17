import 'dart:typed_data';

import 'package:app/features/actividad/data/foto_preparada.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

Uint8List _jpegConUbicacion(int ancho, int alto) {
  final imagen = img.Image(width: ancho, height: alto)
    ..clear(img.ColorRgb8(200, 120, 40));
  imagen.exif.imageIfd['Make'] = img.IfdValueAscii('Telefono de prueba');
  imagen.exif.gpsIfd['GPSLatitudeRef'] = img.IfdValueAscii('N');
  imagen.exif.gpsIfd['GPSLongitudeRef'] = img.IfdValueAscii('W');
  return img.encodeJpg(imagen);
}

FotoLista _lista(ResultadoFoto resultado) {
  expect(resultado, isA<FotoLista>());
  return resultado as FotoLista;
}

void main() {
  group('CA_015_18 foto preparada para subir', () {
    test('CA_015_18 la prueba parte de una foto con EXIF y ubicación', () {
      final original = img.decodeJpg(_jpegConUbicacion(40, 20))!;

      expect(original.exif.isEmpty, isFalse);
      expect(original.exif.gpsIfd.isEmpty, isFalse);
    });

    test('CA_015_18 una foto de 4000 px queda en 1600 px y sin EXIF', () {
      final lista = _lista(prepararFoto(_jpegConUbicacion(4000, 600)));

      expect(lista.ancho, 1600);
      expect(lista.alto, 240);
      expect(lista.tipoContenido, 'image/jpeg');
      final subida = img.decodeJpg(lista.bytes)!;
      expect(subida.width, 1600);
      expect(subida.exif.isEmpty, isTrue);
      expect(subida.exif.gpsIfd.isEmpty, isTrue);
    });

    test('CA_015_18 una foto vertical se reduce por su lado mayor', () {
      final lista = _lista(prepararFoto(_jpegConUbicacion(300, 3200)));

      expect(lista.alto, 1600);
      expect(lista.ancho, 150);
    });

    test('CA_015_18 una foto chica no se agranda, pero pierde el EXIF', () {
      final lista = _lista(prepararFoto(_jpegConUbicacion(800, 600)));

      expect(lista.ancho, 800);
      expect(lista.alto, 600);
      expect(img.decodeJpg(lista.bytes)!.exif.isEmpty, isTrue);
    });

    test('CA_015_18 un PNG sigue siendo PNG', () {
      final png = img.encodePng(img.Image(width: 2000, height: 1000));

      final lista = _lista(prepararFoto(png));

      expect(lista.tipoContenido, 'image/png');
      expect(lista.ancho, 1600);
    });

    test('CA_015_18 rechaza por tamaño antes de decodificar', () {
      // 5 MB + 1 byte con firma JPEG y el resto basura: si decodificara,
      // sería «ilegible»; el motivo debe ser el tamaño.
      final grande = Uint8List(maximoBytesFoto + 1)
        ..setAll(0, [0xFF, 0xD8, 0xFF]);

      final resultado = prepararFoto(grande);

      expect((resultado as FotoRechazada).motivo, MotivoFotoRechazada.tamano);
    });

    test('CA_015_18 acepta una foto de exactamente 5 242 880 bytes', () {
      // Una foto real rellenada después de su fin (EOI) hasta el tope exacto.
      final foto = _jpegConUbicacion(100, 50);
      final justa = Uint8List(maximoBytesFoto)..setAll(0, foto);

      expect(maximoBytesFoto, 5242880);
      expect(_lista(prepararFoto(justa)).ancho, 100);
    });

    test('CA_015_18 rechaza lo que no es JPEG ni PNG por su contenido', () {
      final gif = Uint8List.fromList('GIF89a....'.codeUnits);

      expect(
        (prepararFoto(gif) as FotoRechazada).motivo,
        MotivoFotoRechazada.tipo,
      );
    });

    test('CA_015_18 rechaza una cabecera JPEG que no se puede leer', () {
      final corrupta = Uint8List.fromList([0xFF, 0xD8, 0xFF, 0x00, 0x01, 0x02]);

      expect(
        (prepararFoto(corrupta) as FotoRechazada).motivo,
        MotivoFotoRechazada.ilegible,
      );
    });

    test('CA_015_18 en segundo plano da el mismo resultado', () async {
      final resultado = await prepararFotoEnSegundoPlano(
        _jpegConUbicacion(2000, 100),
      );

      expect(_lista(resultado).ancho, 1600);
    });
  });
}
