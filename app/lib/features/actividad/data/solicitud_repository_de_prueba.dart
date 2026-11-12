import 'dart:math';

import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/domain/cotizacion.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/features/actividad/domain/solicitud_repository.dart';

/// Solicitudes en memoria mientras el contrato no publique `/solicitudes` ni
/// `/archivos` (backend 020 y spec 013). Sin red ni datos reales.
///
/// Se comporta como el servidor en lo que la pantalla necesita: responde
/// «no encontrada» para un identificador ajeno (CA-13), crea la solicitud en
/// estado `enviada` y, pasados [esperaCotizaciones], la deja en `cotizando`
/// con cuatro cotizaciones de técnicos ficticios (como las semillas de la
/// demo, KNOCK-246), que ordena y etiqueta como backend 021 (R-04 a R-07).
/// Se reemplaza en `solicitudRepositoryProvider` por la implementación con el
/// cliente generado sin tocar la pantalla.
class SolicitudRepositoryDePrueba implements SolicitudRepository {
  SolicitudRepositoryDePrueba({
    DateTime Function()? reloj,
    Random? azar,
    this.esperaCotizaciones = const Duration(seconds: 10),
  }) : _reloj = reloj ?? DateTime.now,
       _azar = azar ?? Random();

  final DateTime Function() _reloj;
  final Random _azar;

  /// Cuánto tardan en «llegar» las cotizaciones de prueba.
  final Duration esperaCotizaciones;
  final _solicitudes = <String, Solicitud>{};

  /// Dirección escrita en cada solicitud a domicilio (solo en memoria).
  final _direcciones = <String, String?>{};

  /// Cita de cada solicitud ya elegida.
  final _citas = <String, CitaConfirmada>{};

  /// Contacto público ficticio de cada técnico de prueba (sin datos reales).
  /// El técnico C no publicó contacto (CA-11).
  static const _contactos = {
    'tc1': (telefono: '5500000001', whatsapp: '5500000001'),
    'tc2': (telefono: '5500000002', whatsapp: null),
    'tc4': (telefono: null, whatsapp: '5500000004'),
  };

  /// Nombres de los oficios piloto, para el detalle.
  static const _nombres = {
    'ele': 'Electricidad',
    'mec': 'Mecánica',
    'plo': 'Plomería',
  };

  /// Textos fijos de «qué cubre» por tipo (backend 021 R-07).
  static const cubrePorTipo = {
    TipoPrecio.visita: 'Solo visita: ir a ver el trabajo',
    TipoPrecio.fijo:
        'Arreglo completo, mano de obra incluida, refacciones aparte',
    TipoPrecio.rango: 'Estimado del arreglo dentro del rango',
  };

  String _idHexadecimal() =>
      List.generate(24, (_) => _azar.nextInt(16).toRadixString(16)).join();

  @override
  Future<String> subirFoto(String rutaLocal) async => _idHexadecimal();

  @override
  Future<Solicitud> crear(NuevaSolicitud solicitud) async {
    final ahora = _reloj();
    final creada = Solicitud(
      id: _idHexadecimal(),
      estado: EstadoSolicitud.enviada,
      oficioNombre: _nombres[solicitud.oficioClave] ?? solicitud.oficioClave,
      descripcion: solicitud.descripcion.trim(),
      totalFotos: solicitud.archivoIds.length,
      dia: solicitud.dia,
      franja: solicitud.franja,
      creadoEn: ahora,
      venceEn: ahora.add(const Duration(hours: 48)),
    );
    _solicitudes[creada.id] = creada;
    _direcciones[creada.id] = solicitud.direccion;
    return creada;
  }

  bool _yaHayCotizaciones(Solicitud solicitud) =>
      !_reloj().isBefore(solicitud.creadoEn.add(esperaCotizaciones));

  @override
  Future<Solicitud> obtener(String id) async {
    final solicitud = _solicitudes[id];
    if (solicitud == null) throw const NoEncontradoFailure();
    if (!_yaHayCotizaciones(solicitud)) return solicitud;
    return Solicitud(
      id: solicitud.id,
      estado: _citas.containsKey(id)
          ? EstadoSolicitud.citaConfirmada
          : EstadoSolicitud.cotizando,
      oficioNombre: solicitud.oficioNombre,
      descripcion: solicitud.descripcion,
      totalFotos: solicitud.totalFotos,
      dia: solicitud.dia,
      franja: solicitud.franja,
      creadoEn: solicitud.creadoEn,
      venceEn: solicitud.venceEn,
      totalCotizaciones: _semillas(solicitud).length,
    );
  }

  @override
  Future<ResultadoComparacion> cotizaciones(
    String solicitudId, {
    OrdenCotizaciones orden = OrdenCotizaciones.recomendadas,
  }) async {
    final solicitud = _solicitudes[solicitudId];
    if (solicitud == null) throw const NoEncontradoFailure();
    if (!_yaHayCotizaciones(solicitud)) {
      return const ResultadoComparacion(
        cotizaciones: [],
        totalCotizaciones: 0,
        tiposMixtos: false,
        puedeElegir: false,
        motivo: MotivoSinEleccion.sinCotizaciones,
      );
    }
    final todas = ordenarComoElServidor(_semillas(solicitud), orden);
    final cita = _citas[solicitudId];
    return ResultadoComparacion(
      cotizaciones: todas.take(5).toList(),
      totalCotizaciones: todas.length,
      tiposMixtos: todas.map((c) => c.tipoPrecio).toSet().length > 1,
      puedeElegir: cita == null,
      motivo: cita == null ? null : MotivoSinEleccion.yaElegida,
      visitaId: cita?.visitaId,
    );
  }

  /// Como backend 021 R-10 y R-11: una sola elección por solicitud; la
  /// segunda responde `request_already_chosen` y no crea otra cita.
  @override
  Future<CitaConfirmada> elegir(String solicitudId, String cotizacionId) async {
    final solicitud = _solicitudes[solicitudId];
    if (solicitud == null) throw const NoEncontradoFailure();
    if (_citas.containsKey(solicitudId)) {
      throw const EleccionRechazadaFailure(MotivoEleccionRechazada.yaElegida);
    }
    if (!_yaHayCotizaciones(solicitud)) {
      throw const EleccionRechazadaFailure(
        MotivoEleccionRechazada.sinCotizaciones,
      );
    }
    final cotizacion = _semillas(solicitud)
        .where((c) => c.id == cotizacionId)
        .firstOrNull;
    if (cotizacion == null) {
      throw const EleccionRechazadaFailure(
        MotivoEleccionRechazada.cotizacionNoDisponible,
      );
    }
    final direccion = _direcciones[solicitudId];
    final contacto = _contactos[cotizacion.tecnico.id];
    final cita = CitaConfirmada(
      visitaId: _idHexadecimal(),
      solicitudId: solicitudId,
      cotizacionId: cotizacionId,
      modalidad: direccion == null ? 'taller' : 'domicilio',
      dia: cotizacion.dia,
      hora: cotizacion.hora,
      precio: cotizacion.precio ?? cotizacion.precioMax,
      tope: cotizacion.tope,
      direccion: direccion ?? 'Taller de prueba, Av. Ficticia 100',
      tecnico: TecnicoElegido(
        nombre: cotizacion.tecnico.nombre,
        verificado: cotizacion.tecnico.verificado,
        nivelVerificacion: cotizacion.tecnico.nivelVerificacion,
        telefono: contacto?.telefono,
        whatsapp: contacto?.whatsapp,
      ),
    );
    _citas[solicitudId] = cita;
    return cita;
  }

  /// Cuatro técnicos ficticios con tipos de precio distintos.
  List<Cotizacion> _semillas(Solicitud solicitud) {
    final dia = solicitud.dia;
    Cotizacion cotizacion({
      required String id,
      required String nombre,
      required TipoPrecio tipo,
      required int tope,
      required String hora,
      required bool verificado,
      int? precio,
      int? minimo,
      int? maximo,
      double? calificacion,
      int diasDespues = 0,
      String? nota,
    }) => Cotizacion(
      id: id,
      tipoPrecio: tipo,
      precio: precio,
      precioMin: minimo,
      precioMax: maximo,
      tope: tope,
      requiereAprobacion: tipo != TipoPrecio.visita,
      dia: DateTime(dia.year, dia.month, dia.day + diasDespues),
      hora: hora,
      nota: nota,
      cubre: cubrePorTipo[tipo]!,
      tecnico: TecnicoResumen(
        id: 't$id',
        nombre: nombre,
        verificado: verificado,
        nivelVerificacion: verificado ? 'basico' : null,
        calificacion: calificacion,
      ),
    );
    return etiquetarComoElServidor([
      cotizacion(
        id: 'c1',
        nombre: 'Técnico de prueba A',
        tipo: TipoPrecio.fijo,
        precio: 900,
        tope: 990,
        hora: '10:00',
        verificado: true,
        calificacion: 4.8,
        nota: 'Llevo las piezas más comunes.',
      ),
      cotizacion(
        id: 'c2',
        nombre: 'Técnico de prueba B',
        tipo: TipoPrecio.rango,
        minimo: 600,
        maximo: 1000,
        tope: 1250,
        hora: '09:00',
        verificado: false,
        calificacion: 4.5,
      ),
      cotizacion(
        id: 'c3',
        nombre: 'Técnico de prueba C',
        tipo: TipoPrecio.visita,
        precio: 150,
        tope: 150,
        hora: '08:00',
        verificado: true,
        diasDespues: 1,
      ),
      cotizacion(
        id: 'c4',
        nombre: 'Técnico de prueba D',
        tipo: TipoPrecio.fijo,
        precio: 850,
        tope: 935,
        hora: '17:30',
        verificado: false,
        calificacion: 3.9,
        diasDespues: 2,
      ),
    ]);
  }
}

DateTime _momento(Cotizacion c) {
  final partes = c.hora.split(':');
  return DateTime(
    c.dia.year,
    c.dia.month,
    c.dia.day,
    int.parse(partes[0]),
    int.parse(partes[1]),
  );
}

/// Etiquetas de backend 021 R-06: `verificado`; `mejor_precio` al tope más
/// bajo que no es visita; `puede_ir_mas_pronto` a la fecha más temprana.
List<Cotizacion> etiquetarComoElServidor(List<Cotizacion> cotizaciones) {
  final noVisitas = cotizaciones.where(
    (c) => c.tipoPrecio != TipoPrecio.visita,
  );
  final menorTope = noVisitas.isEmpty
      ? null
      : noVisitas.map((c) => c.tope).reduce(min);
  final masPronto = cotizaciones.isEmpty
      ? null
      : cotizaciones.map(_momento).reduce((a, b) => a.isBefore(b) ? a : b);
  return [
    for (final c in cotizaciones)
      Cotizacion(
        id: c.id,
        tipoPrecio: c.tipoPrecio,
        precio: c.precio,
        precioMin: c.precioMin,
        precioMax: c.precioMax,
        tope: c.tope,
        requiereAprobacion: c.requiereAprobacion,
        dia: c.dia,
        hora: c.hora,
        nota: c.nota,
        cubre: c.cubre,
        tecnico: c.tecnico,
        etiquetas: {
          if (c.tecnico.verificado) EtiquetaCotizacion.verificado,
          if (c.tipoPrecio != TipoPrecio.visita && c.tope == menorTope)
            EtiquetaCotizacion.mejorPrecio,
          if (_momento(c) == masPronto) EtiquetaCotizacion.puedeIrMasPronto,
        },
      ),
  ];
}

/// Orden de backend 021 (R-04 y R-05). Solo lo usa el doble del servidor: la
/// app muestra el orden que recibe.
List<Cotizacion> ordenarComoElServidor(
  List<Cotizacion> cotizaciones,
  OrdenCotizaciones orden,
) {
  int porCalificacion(Cotizacion a, Cotizacion b) =>
      (b.tecnico.calificacion ?? -1).compareTo(a.tecnico.calificacion ?? -1);
  int porTope(Cotizacion a, Cotizacion b) {
    final visitaA = a.tipoPrecio == TipoPrecio.visita ? 1 : 0;
    final visitaB = b.tipoPrecio == TipoPrecio.visita ? 1 : 0;
    if (visitaA != visitaB) return visitaA - visitaB;
    return a.tope.compareTo(b.tope);
  }

  final copia = [...cotizaciones];
  switch (orden) {
    case OrdenCotizaciones.precio:
      copia.sort(porTope);
    case OrdenCotizaciones.calificacion:
      copia.sort(porCalificacion);
    case OrdenCotizaciones.pronto:
      copia.sort((a, b) => _momento(a).compareTo(_momento(b)));
    case OrdenCotizaciones.recomendadas:
      copia.sort((a, b) {
        final verificado =
            (b.tecnico.verificado ? 1 : 0) - (a.tecnico.verificado ? 1 : 0);
        if (verificado != 0) return verificado;
        final calificacion = porCalificacion(a, b);
        if (calificacion != 0) return calificacion;
        return a.tope.compareTo(b.tope);
      });
  }
  return copia;
}
