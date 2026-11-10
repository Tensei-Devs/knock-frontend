import 'package:app/core/preferencias/almacen_avisos.dart';
import 'package:app/core/router/rutas.dart';
import 'package:flutter/foundation.dart';

/// Pantallas a las que puede llevar una notificación (spec 012, R-02).
///
/// La carga trae el nombre del destino y nunca una ruta: un valor que no está
/// aquí se ignora, así que una carga manipulada no abre pantallas arbitrarias.
enum DestinoNotificacion {
  inicio(Rutas.inicio),
  explorar(Rutas.explorar),
  actividad(Rutas.actividad),
  trabajo(Rutas.trabajo),
  cuenta(Rutas.cuenta),
  configuracion(Rutas.configuracion);

  const DestinoNotificacion(this.ruta);

  final String ruta;
}

/// Carga que acompaña a una notificación: tipo y destino (spec 012 §5).
///
/// Formato del campo `data`: `tipo` (`cotizaciones`, `mensajes`, `visitas` o
/// `sistema`), `destino` (nombre de [DestinoNotificacion]) y, solo en los
/// mensajes, `conversacion` (identificador opaco). No lleva texto de la
/// notificación ni datos de la persona.
@immutable
class CargaNotificacion {
  const CargaNotificacion({
    required this.tipo,
    required this.destino,
    this.conversacion,
  });

  /// Lee la carga recibida; `null` si el tipo falta o no se conoce.
  ///
  /// Un destino ausente o desconocido cae en la pantalla natural del tipo.
  static CargaNotificacion? desde(Map<String, Object?> datos) {
    final tipo = _porNombre(TipoAviso.values, datos['tipo']);
    if (tipo == null) return null;
    final conversacion = datos['conversacion'];
    return CargaNotificacion(
      tipo: tipo,
      destino:
          _porNombre(DestinoNotificacion.values, datos['destino']) ??
          _destinoPorTipo[tipo]!,
      conversacion: conversacion is String && conversacion.isNotEmpty
          ? conversacion
          : null,
    );
  }

  static const _destinoPorTipo = {
    TipoAviso.cotizaciones: DestinoNotificacion.actividad,
    TipoAviso.mensajes: DestinoNotificacion.actividad,
    TipoAviso.visitas: DestinoNotificacion.actividad,
    TipoAviso.sistema: DestinoNotificacion.inicio,
  };

  final TipoAviso tipo;
  final DestinoNotificacion destino;

  /// Conversación de un mensaje, para no avisar si ya está abierta (R-04).
  final String? conversacion;

  /// Ruta de la pantalla que se abre al tocar la notificación.
  String get ruta => destino.ruta;

  @override
  bool operator ==(Object other) =>
      other is CargaNotificacion &&
      other.tipo == tipo &&
      other.destino == destino &&
      other.conversacion == conversacion;

  @override
  int get hashCode => Object.hash(tipo, destino, conversacion);

  /// Sin la conversación: el texto de un log no debe identificarla.
  @override
  String toString() => 'CargaNotificacion(${tipo.name}, ${destino.name})';

  static T? _porNombre<T extends Enum>(List<T> valores, Object? nombre) {
    for (final valor in valores) {
      if (valor.name == nombre) return valor;
    }
    return null;
  }
}
