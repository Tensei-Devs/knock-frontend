/// Avisar a alguien de confianza (spec 022, HU-037): contactos del teléfono,
/// el mensaje del servidor y el respaldo sin conexión.
library;

import 'package:app/features/actividad/domain/visita.dart';

/// Máximo de contactos de confianza (R-01).
const maximoContactos = 10;

/// Largo del nombre del contacto (R-02).
const minimoNombreContacto = 2;
const maximoNombreContacto = 40;

/// Por qué no se puede guardar un contacto (CA-05 a CA-07).
enum ErrorContacto { nombre, celular, repetido, lleno }

/// No se pudo guardar el contacto (CA-05 a CA-07).
final class ContactoNoGuardado implements Exception {
  const ContactoNoGuardado(this.error);

  final ErrorContacto error;
}

/// Una persona de confianza. Vive solo en el almacén seguro del teléfono y
/// nunca se envía al servidor (R-01, CA-04).
final class ContactoConfianza {
  const ContactoConfianza({
    required this.id,
    required this.nombre,
    required this.celular,
  });

  final String id;
  final String nombre;

  /// Exactamente 10 dígitos de México.
  final String celular;

  Map<String, Object?> aMapa() => {
    'id': id,
    'nombre': nombre,
    'celular': celular,
  };

  static ContactoConfianza? desdeMapa(Object? mapa) {
    if (mapa is! Map) return null;
    final id = mapa['id'];
    final nombre = mapa['nombre'];
    final celular = mapa['celular'];
    if (id is! String || nombre is! String || celular is! String) return null;
    if (validarContacto(nombre, celular) != null) return null;
    return ContactoConfianza(id: id, nombre: nombre.trim(), celular: celular);
  }
}

/// Solo los dígitos de un celular.
String soloDigitos(String texto) => texto.replaceAll(RegExp(r'[^0-9]'), '');

/// `null` si el nombre y el celular son válidos (CA-05).
ErrorContacto? validarContacto(String nombre, String celular) {
  final largo = nombre.trim().runes.length;
  if (largo < minimoNombreContacto || largo > maximoNombreContacto) {
    return ErrorContacto.nombre;
  }
  if (!RegExp(r'^[0-9]{10}$').hasMatch(soloDigitos(celular)) ||
      soloDigitos(celular).length != celular.replaceAll(' ', '').length) {
    return ErrorContacto.celular;
  }
  return null;
}

/// Si se puede guardar [nuevo] en [lista] (CA-05 a CA-07). Al editar, [idEditado]
/// es el contacto que se reemplaza.
ErrorContacto? puedeGuardarse(
  List<ContactoConfianza> lista, {
  required String nombre,
  required String celular,
  String? idEditado,
}) {
  final invalido = validarContacto(nombre, celular);
  if (invalido != null) return invalido;
  final digitos = soloDigitos(celular);
  if (lista.any((c) => c.celular == digitos && c.id != idEditado)) {
    return ErrorContacto.repetido;
  }
  if (idEditado == null && lista.length >= maximoContactos) {
    return ErrorContacto.lleno;
  }
  return null;
}

/// El texto que prepara el servidor (backend 022 R-12). Se rechaza si dice
/// traer el código o la dirección (CA-15).
final class MensajeAviso {
  const MensajeAviso({
    required this.texto,
    required this.incluyeCodigo,
    required this.incluyeDireccion,
  });

  final String texto;
  final bool incluyeCodigo;
  final bool incluyeDireccion;

  bool get esSeguro => !incluyeCodigo && !incluyeDireccion;
}

/// Lo único que la plantilla local puede usar (R-12): nombre público del
/// técnico, verificación, día y hora. **Nunca** el código ni la dirección.
final class DatosAvisoLocal {
  const DatosAvisoLocal({
    required this.tecnicoNombre,
    required this.tecnicoVerificado,
    required this.dia,
    required this.hora,
  });

  /// Copia solo los cuatro campos permitidos de la copia de la visita.
  factory DatosAvisoLocal.deVisita(VisitaGuardada visita) => DatosAvisoLocal(
    tecnicoNombre: visita.tecnicoNombre,
    tecnicoVerificado: visita.tecnicoVerificado,
    dia: visita.dia,
    hora: visita.hora,
  );

  final String tecnicoNombre;
  final bool tecnicoVerificado;
  final DateTime dia;
  final String hora;

  /// La copia sirve hasta 24 horas después del día de la cita (R-12).
  bool vigente(DateTime ahora) =>
      ahora.isBefore(DateTime(dia.year, dia.month, dia.day + 2));
}

/// Frases de la plantilla local; las da la pantalla desde los ARB (R-09).
final class PlantillaAviso {
  const PlantillaAviso({
    required this.encabezado,
    required this.tecnicoVerificado,
    required this.tecnicoSinVerificar,
    required this.cuando,
    required this.recomendacion,
  });

  /// «Hoy recibo a un técnico de Knock.»
  final String encabezado;

  /// Reciben el nombre del técnico.
  final String Function(String nombre) tecnicoVerificado;
  final String Function(String nombre) tecnicoSinVerificar;

  /// Recibe el día ya formateado y la hora.
  final String Function(String dia, String hora) cuando;

  /// «Le pediré el código en la puerta antes de abrir.»
  final String recomendacion;
}

/// Texto de respaldo sin conexión, en texto plano y sin enlaces (CA-03, R-12).
String armarAvisoLocal(
  DatosAvisoLocal datos,
  PlantillaAviso plantilla, {
  required String diaFormateado,
}) => [
  plantilla.encabezado,
  if (datos.tecnicoVerificado)
    plantilla.tecnicoVerificado(datos.tecnicoNombre)
  else
    plantilla.tecnicoSinVerificar(datos.tecnicoNombre),
  plantilla.cuando(diaFormateado, datos.hora),
  plantilla.recomendacion,
].join('\n');

/// Por dónde se avisa. Solo vive en el teléfono (D-05).
enum CanalDeAviso { sms, whatsapp, compartir }

/// El texto del aviso desde la API (backend 022). Falla con un `Failure`.
abstract interface class AvisoRepository {
  /// `POST /visitas/{id}/aviso` con cuerpo vacío (R-07, CA-15).
  Future<MensajeAviso> pedirAviso(String visitaId);
}

/// Contactos de confianza en el almacén seguro (R-01).
abstract interface class ContactosConfianzaRepository {
  Future<List<ContactoConfianza>> listar();

  /// Agrega o, con el mismo `id`, reemplaza. Lanza si no se puede (CA-06).
  Future<void> guardar(ContactoConfianza contacto);

  Future<void> borrar(String id);
}

/// La copia de [DatosAvisoLocal] para avisar sin conexión (R-12).
abstract interface class RespaldoAvisoRepository {
  Future<DatosAvisoLocal?> leer(String visitaId);

  Future<void> guardar(String visitaId, DatosAvisoLocal datos);
}
