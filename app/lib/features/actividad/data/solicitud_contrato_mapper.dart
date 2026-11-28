import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/data/contrato_json.dart';
import 'package:app/features/actividad/domain/cotizacion.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/domain/solicitud.dart';

/// Convierte las respuestas de `/solicitudes` (backend 020 y 021) en modelos
/// del dominio. Cualquier campo que no cumpla el contrato lanza
/// [DatosInvalidosFailure]: nunca se muestra un dato a medias.
abstract final class SolicitudContratoMapper {
  /// `GET /solicitudes`: una página y el cursor de la siguiente (o `null`).
  ///
  /// Las filas no traen la descripción ni la clave del oficio (solo el
  /// detalle): la descripción queda vacía.
  static ({List<Solicitud> items, String? siguiente}) pagina(Object? json) {
    final mapa = mapaDelContrato(json);
    final items = mapa['items'];
    if (items is! List<Object?>) throw const DatosInvalidosFailure();
    final cursor = mapa['nextCursor'];
    if (cursor != null && cursor is! String) {
      throw const DatosInvalidosFailure();
    }
    return (
      items: [for (final i in items) _resumen(mapaDelContrato(i))],
      siguiente: cursor as String?,
    );
  }

  /// `GET /solicitudes/{id}` y `POST /solicitudes`: la solicitud completa.
  static Solicitud detalle(Object? json) {
    final m = mapaDelContrato(json);
    final oficio = mapaDelContrato(m['oficio']);
    final colonia = mapaDelContrato(m['colonia']);
    final fotos = m['fotos'];
    if (fotos is! List<Object?>) throw const DatosInvalidosFailure();
    return Solicitud(
      id: textoDelContrato(m['id']),
      estado: EstadoSolicitud.desdeTexto(textoDelContrato(m['estado'])),
      oficioNombre: textoDelContrato(oficio['nombre']),
      oficioClave: textoDelContrato(oficio['clave']),
      coloniaNombre: textoDelContrato(colonia['nombre']),
      descripcion: textoDelContrato(m['descripcion']),
      totalFotos: fotos.length,
      dia: diaLocalDelContrato(m['dia']),
      franja: _franja(m['franja']),
      creadoEn: _fecha(m['creadoEn']),
      venceEn: _fecha(m['venceEn']),
      totalCotizaciones: _entero(m['totalCotizaciones'], porOmision: 0),
      puedeVolverAPedir: m['puedeVolverAPedir'] == true,
    );
  }

  /// `GET /solicitudes/{id}/cotizaciones`.
  static ResultadoComparacion comparacion(Object? json) {
    final m = mapaDelContrato(json);
    final cotizaciones = m['cotizaciones'];
    if (cotizaciones is! List<Object?>) throw const DatosInvalidosFailure();
    final motivo = m['motivo'];
    final visitaId = m['visitaId'];
    return ResultadoComparacion(
      cotizaciones: [
        for (final c in cotizaciones) _cotizacion(mapaDelContrato(c)),
      ],
      totalCotizaciones: _entero(m['totalCotizaciones']),
      tiposMixtos: booleanoDelContrato(m['tiposMixtos']),
      puedeElegir: booleanoDelContrato(m['puedeElegir']),
      motivo: motivo is String ? MotivoSinEleccion.desdeTexto(motivo) : null,
      visitaId: visitaId is String && visitaId.isNotEmpty ? visitaId : null,
    );
  }

  /// `POST /solicitudes/{id}/elegir`: la cita con el contacto del técnico.
  static CitaConfirmada cita(Object? json) {
    final m = mapaDelContrato(json);
    final tecnico = mapaDelContrato(m['tecnico']);
    final lugar = mapaDelContrato(m['lugar']);
    final direccion = lugar['direccion'];
    return CitaConfirmada(
      visitaId: textoDelContrato(m['visitaId']),
      solicitudId: textoDelContrato(m['solicitudId']),
      cotizacionId: textoDelContrato(m['cotizacionId']),
      modalidad: textoDelContrato(m['modalidad']),
      dia: diaLocalDelContrato(m['dia']),
      hora: textoDelContrato(m['hora']),
      precio: _enteroONulo(m['precio'], porOmision: null),
      tope: _entero(m['tope']),
      tecnico: TecnicoElegido(
        nombre: textoDelContrato(tecnico['nombre']),
        verificado: booleanoDelContrato(tecnico['verificado']),
        nivelVerificacion: textoOpcionalDelContrato(
          tecnico['nivelVerificacion'],
        ),
        telefono: textoOpcionalDelContrato(tecnico['telefono']),
        whatsapp: textoOpcionalDelContrato(tecnico['whatsapp']),
      ),
      direccion: direccion is String ? direccion : '',
    );
  }

  static Solicitud _resumen(Map<Object?, Object?> m) => Solicitud(
    id: textoDelContrato(m['id']),
    estado: EstadoSolicitud.desdeTexto(textoDelContrato(m['estado'])),
    oficioNombre: textoDelContrato(m['oficioNombre']),
    coloniaNombre: textoDelContrato(m['coloniaNombre']),
    descripcion: '',
    totalFotos: _entero(m['totalFotos']),
    dia: diaLocalDelContrato(m['dia']),
    franja: _franja(m['franja']),
    creadoEn: _fecha(m['creadoEn']),
    venceEn: _fecha(m['venceEn']),
    totalCotizaciones: _entero(m['totalCotizaciones']),
    visitaId: textoOpcionalDelContrato(m['visitaId']),
  );

  static Cotizacion _cotizacion(Map<Object?, Object?> m) {
    final tipo = TipoPrecio.desdeTexto(textoDelContrato(m['tipoPrecio']));
    if (tipo == null) throw const DatosInvalidosFailure();
    final etiquetas = m['etiquetas'];
    if (etiquetas is! List<Object?>) throw const DatosInvalidosFailure();
    return Cotizacion(
      id: textoDelContrato(m['id']),
      tipoPrecio: tipo,
      precio: _enteroONulo(m['precio'], porOmision: null),
      precioMin: _enteroONulo(m['precioMin'], porOmision: null),
      precioMax: _enteroONulo(m['precioMax'], porOmision: null),
      tope: _entero(m['tope']),
      requiereAprobacion: booleanoDelContrato(m['requiereAprobacion']),
      dia: diaLocalDelContrato(m['dia']),
      hora: textoDelContrato(m['hora']),
      nota: textoOpcionalDelContrato(m['nota']),
      cubre: textoDelContrato(m['cubre']),
      etiquetas: {
        for (final e in etiquetas)
          if (e is String && EtiquetaCotizacion.desdeTexto(e) != null)
            EtiquetaCotizacion.desdeTexto(e)!,
      },
      tecnico: _tecnico(mapaDelContrato(m['tecnico'])),
    );
  }

  static TecnicoResumen _tecnico(Map<Object?, Object?> m) => TecnicoResumen(
    id: textoDelContrato(m['id']),
    nombre: textoDelContrato(m['nombre']),
    verificado: booleanoDelContrato(m['verificado']),
    fotoUrl: textoOpcionalDelContrato(m['fotoUrl']),
    calificacion: _numero(m['calificacion']),
    nivelVerificacion: textoOpcionalDelContrato(m['nivelVerificacion']),
  );

  /// Enteros del contrato: llegan como número o como texto numérico.
  static int _entero(Object? valor, {Object? porOmision = _sinValor}) {
    final resultado = _enteroONulo(valor, porOmision: porOmision);
    if (resultado == null) throw const DatosInvalidosFailure();
    return resultado;
  }

  static const Object _sinValor = Object();

  static int? _enteroONulo(Object? valor, {Object? porOmision = _sinValor}) {
    if (valor == null) {
      if (identical(porOmision, _sinValor)) throw const DatosInvalidosFailure();
      return porOmision as int?;
    }
    if (valor is int) return valor;
    if (valor is String) {
      final n = int.tryParse(valor);
      if (n != null) return n;
    }
    throw const DatosInvalidosFailure();
  }

  static double? _numero(Object? valor) {
    if (valor == null) return null;
    if (valor is num) return valor.toDouble();
    if (valor is String) {
      final n = double.tryParse(valor);
      if (n != null) return n;
    }
    throw const DatosInvalidosFailure();
  }

  static DateTime _fecha(Object? valor) {
    final f = valor is String ? DateTime.tryParse(valor) : null;
    if (f == null) throw const DatosInvalidosFailure();
    return f;
  }

  static Franja _franja(Object? valor) {
    final f = valor is String ? Franja.desdeTexto(valor) : null;
    if (f == null) throw const DatosInvalidosFailure();
    return f;
  }
}
