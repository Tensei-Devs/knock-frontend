import 'dart:isolate';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Tope de bytes por foto antes de decodificarla (spec 015, R-03 y CA-18).
const maximoBytesFoto = 5 * 1024 * 1024;

/// Lado mayor máximo de la foto que se sube (R-03).
const maximoLadoFoto = 1600;

/// Tope de píxeles para no decodificar una imagen enorme (bomba de
/// descompresión): 50 megapíxeles cubren cualquier cámara de teléfono.
const maximoPixelesFoto = 50 * 1000 * 1000;

/// Calidad JPEG al volver a codificar: alta, para no perder detalle que el
/// técnico necesita ver («sin recomprimir agresivamente», R-03).
const calidadJpeg = 90;

/// Por qué no se puede usar una foto.
enum MotivoFotoRechazada {
  /// No es JPEG ni PNG (por su contenido, no por su extensión).
  tipo,

  /// Pesa más de [maximoBytesFoto].
  tamano,

  /// Tiene más de [maximoPixelesFoto] píxeles.
  pixeles,

  /// Dice ser JPEG o PNG pero no se puede leer.
  ilegible,
}

/// Resultado de preparar una foto para subirla.
sealed class ResultadoFoto {
  const ResultadoFoto();
}

/// Foto lista: reducida si hacía falta, orientada y **sin metadatos** (EXIF,
/// incluida la ubicación).
final class FotoLista extends ResultadoFoto {
  const FotoLista({
    required this.bytes,
    required this.tipoContenido,
    required this.ancho,
    required this.alto,
  });

  final Uint8List bytes;

  /// `image/jpeg` o `image/png`.
  final String tipoContenido;
  final int ancho;
  final int alto;
}

final class FotoRechazada extends ResultadoFoto {
  const FotoRechazada(this.motivo);

  final MotivoFotoRechazada motivo;
}

enum _Formato { jpeg, png }

_Formato? _formatoPorFirma(Uint8List bytes) {
  if (bytes.length >= 3 &&
      bytes[0] == 0xFF &&
      bytes[1] == 0xD8 &&
      bytes[2] == 0xFF) {
    return _Formato.jpeg;
  }
  const png = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];
  if (bytes.length >= png.length) {
    for (var i = 0; i < png.length; i++) {
      if (bytes[i] != png[i]) return null;
    }
    return _Formato.png;
  }
  return null;
}

/// Prepara una foto para subirla (CA-18).
///
/// En orden: tamaño y tipo **antes** de decodificar; dimensiones leyendo solo
/// la cabecera; decodificación; orientación según EXIF; reducción si el lado
/// mayor pasa de [maximoLadoFoto]; y nueva codificación sin metadatos.
ResultadoFoto prepararFoto(Uint8List bytes) {
  if (bytes.length > maximoBytesFoto) {
    return const FotoRechazada(MotivoFotoRechazada.tamano);
  }
  final formato = _formatoPorFirma(bytes);
  if (formato == null) return const FotoRechazada(MotivoFotoRechazada.tipo);

  final img.Decoder decodificador = formato == _Formato.jpeg
      ? img.JpegDecoder()
      : img.PngDecoder();
  final info = decodificador.startDecode(bytes);
  if (info == null || info.width <= 0 || info.height <= 0) {
    return const FotoRechazada(MotivoFotoRechazada.ilegible);
  }
  if (info.width * info.height > maximoPixelesFoto) {
    return const FotoRechazada(MotivoFotoRechazada.pixeles);
  }

  final img.Image? decodificada;
  try {
    decodificada = decodificador.decode(bytes);
  } on Object {
    return const FotoRechazada(MotivoFotoRechazada.ilegible);
  }
  if (decodificada == null) {
    return const FotoRechazada(MotivoFotoRechazada.ilegible);
  }

  var imagen = img.bakeOrientation(decodificada);
  final ladoMayor = imagen.width > imagen.height ? imagen.width : imagen.height;
  if (ladoMayor > maximoLadoFoto) {
    imagen = imagen.width >= imagen.height
        ? img.copyResize(
            imagen,
            width: maximoLadoFoto,
            interpolation: img.Interpolation.average,
          )
        : img.copyResize(
            imagen,
            height: maximoLadoFoto,
            interpolation: img.Interpolation.average,
          );
  }
  imagen.exif = img.ExifData();
  imagen.iccProfile = null;
  imagen.textData = null;

  return FotoLista(
    bytes: formato == _Formato.jpeg
        ? img.encodeJpg(imagen, quality: calidadJpeg)
        : img.encodePng(imagen),
    tipoContenido: formato == _Formato.jpeg ? 'image/jpeg' : 'image/png',
    ancho: imagen.width,
    alto: imagen.height,
  );
}

/// [prepararFoto] en un isolate aparte, para no congelar la pantalla al
/// decodificar una foto grande en un teléfono lento.
Future<ResultadoFoto> prepararFotoEnSegundoPlano(Uint8List bytes) =>
    Isolate.run(() => prepararFoto(bytes));
