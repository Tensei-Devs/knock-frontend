import 'dart:math';

import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Identificador aleatorio de la instalación que se envía como `deviceId`
/// (spec 009, R-07).
///
/// Se genera una vez (UUID v4 con generador seguro) y se guarda en el
/// [AlmacenSeguro]. No se usa ningún identificador del teléfono (IMEI, ID de
/// publicidad, ANDROID_ID). Si se reinstala la app o se borran los datos, el
/// valor cambia y cuenta como dispositivo nuevo (spec §9).
class IdentificadorDispositivo {
  IdentificadorDispositivo(this._almacen, {Random? aleatorio})
    : _aleatorio = aleatorio ?? Random.secure();

  static const clave = 'knock.dispositivo.id';
  static final _formatoUuidV4 = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  );

  final AlmacenSeguro _almacen;
  final Random _aleatorio;

  Future<String> obtener() async {
    final guardado = await _almacen.leer(clave);
    if (guardado != null && _formatoUuidV4.hasMatch(guardado)) return guardado;
    final nuevo = _generarUuidV4();
    await _almacen.escribir(clave, nuevo);
    return nuevo;
  }

  String _generarUuidV4() {
    final bytes = List<int>.generate(16, (_) => _aleatorio.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = [for (final b in bytes) b.toRadixString(16).padLeft(2, '0')];
    return '${hex.sublist(0, 4).join()}-${hex.sublist(4, 6).join()}-'
        '${hex.sublist(6, 8).join()}-${hex.sublist(8, 10).join()}-'
        '${hex.sublist(10).join()}';
  }
}

final identificadorDispositivoProvider = Provider<IdentificadorDispositivo>(
  (ref) => IdentificadorDispositivo(ref.watch(almacenSeguroProvider)),
);
