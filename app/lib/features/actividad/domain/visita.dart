/// La visita vista por el cliente (spec 016, §5; backend 022 R-02).
library;

/// Estado de la visita. Solo lo cambia el servidor.
enum EstadoVisita {
  confirmada('confirmada'),
  enCurso('en_curso'),
  terminada('terminada'),
  cancelada('cancelada'),
  noPresentado('no_presentado'),

  /// Un estado que la app no conoce: se muestra como «En proceso».
  desconocido('');

  const EstadoVisita(this.valor);

  final String valor;

  static EstadoVisita desdeTexto(String texto) {
    for (final estado in values) {
      if (estado != desconocido && estado.valor == texto) return estado;
    }
    return desconocido;
  }

  /// La visita ya no está abierta: su copia local se borra (CA-16).
  bool get cerrada =>
      this == terminada || this == cancelada || this == noPresentado;
}

/// Por qué la vista del cliente no trae el código (backend 022 R-03).
enum MotivoCodigo {
  usado('usado'),
  vencido('vencido'),
  bloqueada('bloqueada'),
  noAplica('no_aplica');

  const MotivoCodigo(this.valor);

  final String valor;

  static MotivoCodigo? desdeTexto(String texto) {
    for (final motivo in values) {
      if (motivo.valor == texto) return motivo;
    }
    return null;
  }
}

/// El técnico de la visita, con su contacto público si lo publicó (CA-21).
final class TecnicoDeVisita {
  const TecnicoDeVisita({
    required this.nombre,
    required this.verificado,
    this.nivelVerificacion,
    this.telefono,
    this.whatsapp,
  });

  final String nombre;
  final bool verificado;
  final String? nivelVerificacion;
  final String? telefono;
  final String? whatsapp;
}

/// La visita del cliente. Solo el cliente recibe [codigo] (CA-03, R-02).
final class Visita {
  const Visita({
    required this.id,
    required this.estado,
    required this.esTaller,
    required this.dia,
    required this.hora,
    required this.tecnico,
    required this.direccion,
    required this.puedeAvisar,
    this.codigo,
    this.motivoCodigo,
    this.precio,
    this.tope,
  });

  final String id;
  final EstadoVisita estado;

  /// `taller` o `domicilio`.
  final bool esTaller;
  final DateTime dia;
  final String hora;
  final TecnicoDeVisita tecnico;

  /// `lugar.direccion`: la del taller o la del cliente.
  final String direccion;

  /// Cuatro dígitos; `null` si llega [motivoCodigo] o es taller (R-07).
  final String? codigo;
  final MotivoCodigo? motivoCodigo;
  final bool puedeAvisar;
  final int? precio;
  final int? tope;
}

/// Lo mínimo de la visita que se guarda cifrado para verla sin conexión
/// (spec 016, R-03): **sin** la dirección del domicilio ni el contacto del
/// técnico; la dirección solo si es un taller (CA-18).
final class VisitaGuardada {
  const VisitaGuardada({
    required this.id,
    required this.estado,
    required this.esTaller,
    required this.dia,
    required this.hora,
    required this.tecnicoNombre,
    required this.tecnicoVerificado,
    required this.guardadoEn,
    this.direccionTaller,
    this.codigo,
  });

  /// La copia de [visita]: quita la dirección de un domicilio y el contacto.
  factory VisitaGuardada.de(Visita visita, DateTime ahora) => VisitaGuardada(
    id: visita.id,
    estado: visita.estado,
    esTaller: visita.esTaller,
    dia: visita.dia,
    hora: visita.hora,
    tecnicoNombre: visita.tecnico.nombre,
    tecnicoVerificado: visita.tecnico.verificado,
    direccionTaller: visita.esTaller ? visita.direccion : null,
    codigo: visita.codigo,
    guardadoEn: ahora,
  );

  final String id;
  final EstadoVisita estado;
  final bool esTaller;
  final DateTime dia;
  final String hora;
  final String tecnicoNombre;
  final bool tecnicoVerificado;
  final String? direccionTaller;
  final String? codigo;
  final DateTime guardadoEn;

  Map<String, Object?> aMapa() => {
    'v': 1,
    'id': id,
    'estado': estado.valor,
    'taller': esTaller,
    'dia': dia.toIso8601String(),
    'hora': hora,
    'tecnicoNombre': tecnicoNombre,
    'tecnicoVerificado': tecnicoVerificado,
    'direccionTaller': direccionTaller,
    'codigo': codigo,
    'guardadoEn': guardadoEn.toUtc().toIso8601String(),
  };

  /// La copia de un mapa guardado, o `null` si está dañado.
  static VisitaGuardada? desdeMapa(Map<String, Object?> mapa) {
    final dia = DateTime.tryParse('${mapa['dia']}');
    final guardado = DateTime.tryParse('${mapa['guardadoEn']}');
    final id = mapa['id'];
    final hora = mapa['hora'];
    final nombre = mapa['tecnicoNombre'];
    if (mapa['v'] != 1 ||
        dia == null ||
        guardado == null ||
        id is! String ||
        hora is! String ||
        nombre is! String) {
      return null;
    }
    final codigo = mapa['codigo'];
    final direccion = mapa['direccionTaller'];
    final esTaller = mapa['taller'] == true;
    return VisitaGuardada(
      id: id,
      estado: EstadoVisita.desdeTexto('${mapa['estado']}'),
      esTaller: esTaller,
      dia: dia,
      hora: hora,
      tecnicoNombre: nombre,
      tecnicoVerificado: mapa['tecnicoVerificado'] == true,
      direccionTaller: esTaller && direccion is String ? direccion : null,
      codigo: codigo is String ? codigo : null,
      guardadoEn: guardado,
    );
  }
}

/// La visita desde la API (backend 022). Falla con un `Failure`.
abstract interface class VisitaRepository {
  /// `NoEncontradoFailure` si no existe o es de otra persona (CA-05).
  Future<Visita> obtenerVisita(String id);
}

/// La copia cifrada de la visita abierta (R-03, R-17).
abstract interface class VisitaLocalRepository {
  Future<VisitaGuardada?> leer(String id);

  Future<void> guardar(VisitaGuardada visita);

  Future<void> borrar(String id);
}
