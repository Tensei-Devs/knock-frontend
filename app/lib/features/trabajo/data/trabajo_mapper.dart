import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/domain/cotizacion.dart' show TipoPrecio;
import 'package:app/features/actividad/domain/franja.dart' show Franja;
import 'package:app/features/oficios/domain/modalidad.dart' show Modalidad;
import 'package:app/features/trabajo/domain/resumen_de_trabajo.dart';
import 'package:app/features/trabajo/domain/trabajo_repository.dart';
import 'package:knock_api/api.dart' as api;

final class TrabajoMapper {
  static PaginaTrabajo<SolicitudNueva> bandeja(api.InboxResponse data) =>
      PaginaTrabajo(
        items: data.items.map(_solicitud).toList(),
        nextCursor: data.nextCursor,
      );

  static SolicitudNueva _solicitud(api.InboxItem item) => SolicitudNueva(
    solicitudId: item.solicitudId,
    oficio: OficioDeSolicitud(
      clave: item.oficio.clave,
      nombre: item.oficio.nombre,
    ),
    colonia: ColoniaDeSolicitud(
      nombre: item.colonia.nombre,
      cp: item.colonia.cp,
    ),
    descripcion: item.descripcion,
    fotos: item.fotos.map((foto) => foto.url).toList(),
    dia: DateTime.tryParse(item.dia) ?? (throw const DatosInvalidosFailure()),
    franja:
        Franja.desdeTexto(item.franja) ?? (throw const DatosInvalidosFailure()),
    modalidad: Modalidad.desdeTexto(item.modalidad),
    venceEn: item.venceEn,
    oleada: item.oleada,
    recibidaEn: item.recibidaEn,
    yaCotizo: item.yaCotizo,
  );

  static ResumenPaginado resumen(api.TrabajoResponse data) {
    final nivel = data.nivel;
    if (nivel is! Map ||
        nivel['clave'] is! String ||
        nivel['nombre'] is! String) {
      throw const DatosInvalidosFailure();
    }
    return ResumenPaginado(
      resumen: ResumenDeTrabajo(
        disponibleHoy: data.disponibleHoy,
        estadoVerificacion: data.verificacion.estado,
        nivel: NivelDeTrabajo(
          clave: nivel['clave'] as String,
          nombre: nivel['nombre'] as String,
        ),
        proximasVisitas: data.proximasVisitas.map(_visita).toList(),
        solicitudesNuevas: const [],
        cotizacionesEnviadas: data.cotizacionesEnviadas
            .map(_cotizacion)
            .toList(),
        terminadas: data.terminadas.items.map(_terminada).toList(),
        trabajosTerminados: data.resumen.trabajosTerminados,
        calificacion: _calificacion(data.resumen.calificacion),
      ),
      nextCursor: data.terminadas.nextCursor,
    );
  }

  static double? _calificacion(Object? valor) {
    if (valor == null) return null;
    if (valor is num) return valor.toDouble();
    throw const DatosInvalidosFailure();
  }

  static VisitaProxima _visita(api.TrabajoVisitResponse v) => VisitaProxima(
    visitaId: v.visitaId,
    solicitudId: v.solicitudId,
    dia: DateTime.tryParse(v.dia) ?? (throw const DatosInvalidosFailure()),
    hora: v.hora,
    modalidad: Modalidad.desdeTexto(v.modalidad),
    coloniaCliente: v.cliente.colonia,
    direccion: v.lugar.direccion,
    precio: v.precio?.toDouble(),
    tope: v.tope.toDouble(),
    estado: switch (v.estado) {
      'confirmada' => EstadoVisitaProxima.confirmada,
      'en_curso' => EstadoVisitaProxima.enCurso,
      _ => throw const DatosInvalidosFailure(),
    },
    puedeLlegar: v.puedeLlegar,
  );

  static CotizacionEnviada _cotizacion(api.TrabajoQuoteResponse c) =>
      CotizacionEnviada(
        cotizacionId: c.cotizacionId,
        solicitudId: c.solicitudId,
        oficio: c.oficioNombre,
        tipoPrecio:
            TipoPrecio.desdeTexto(c.tipoPrecio) ??
            (throw const DatosInvalidosFailure()),
        precio: c.precio?.toDouble(),
        precioMin: c.precioMin?.toDouble(),
        precioMax: c.precioMax?.toDouble(),
        tope: c.tope.toDouble(),
        estado: switch (c.estado) {
          'enviada' => EstadoCotizacionEnviada.enviada,
          'aceptada' => EstadoCotizacionEnviada.aceptada,
          'rechazada' => EstadoCotizacionEnviada.rechazada,
          'retirada' => EstadoCotizacionEnviada.retirada,
          _ => throw const DatosInvalidosFailure(),
        },
        motivoRechazo: c.motivoRechazo,
        enviadaEn: c.enviadaEn,
      );

  static TrabajoTerminado _terminada(api.TrabajoFinishedItem t) =>
      TrabajoTerminado(
        solicitudId: t.solicitudId,
        oficio: t.oficioNombre,
        terminadaEn: t.terminadaEn,
        precio: t.precio?.toDouble(),
        calificacion: _calificacion(t.calificacion),
      );
}
