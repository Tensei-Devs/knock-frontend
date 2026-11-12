import 'dart:convert';

import 'package:app/core/sesion/almacen_seguro.dart';

/// Claves de la copia cifrada de las visitas abiertas (spec 016, R-03 y
/// R-17). Viven en `core` para que el cierre de sesión las borre sin conocer
/// la función Actividad.
const prefijoVisitaGuardada = 'knock.visita.abierta.';

/// Copia de los datos del aviso de confianza de cada visita (spec 022, R-12).
const prefijoRespaldoAviso = 'knock.aviso.respaldo.';

/// Contactos de confianza del teléfono (spec 022, R-01).
const claveContactosConfianza = 'knock.contactos.confianza';

/// Índice con los identificadores guardados: `AlmacenSeguro` no borra por
/// prefijo, así que sin índice no se podrían enumerar al cerrar sesión.
const claveIndiceDeVisitas = 'knock.visita.claves';

/// Los identificadores del índice (vacío si no hay o está dañado).
Future<Set<String>> leerIndiceDeVisitas(AlmacenSeguro almacen) async {
  final texto = await almacen.leer(claveIndiceDeVisitas);
  if (texto == null) return {};
  try {
    final valor = jsonDecode(texto);
    return valor is List ? valor.whereType<String>().toSet() : {};
  } on FormatException {
    return {};
  }
}

Future<void> escribirIndiceDeVisitas(AlmacenSeguro almacen, Set<String> ids) =>
    ids.isEmpty
    ? almacen.borrar(claveIndiceDeVisitas)
    : almacen.escribir(claveIndiceDeVisitas, jsonEncode(ids.toList()));

/// Borra las visitas guardadas, sus copias de aviso, su índice y los
/// contactos de confianza (spec 016 CA-16, spec 022 CA-13 y CA-20). Lo llama
/// el cierre de sesión. Solo borra lo que existe. Nunca lanza.
Future<void> borrarDatosDeVisita(AlmacenSeguro almacen) async {
  try {
    if (await almacen.leer(claveContactosConfianza) != null) {
      await almacen.borrar(claveContactosConfianza);
    }
    if (await almacen.leer(claveIndiceDeVisitas) == null) return;
    for (final id in await leerIndiceDeVisitas(almacen)) {
      await almacen.borrar('$prefijoVisitaGuardada$id');
      if (await almacen.leer('$prefijoRespaldoAviso$id') != null) {
        await almacen.borrar('$prefijoRespaldoAviso$id');
      }
    }
    await almacen.borrar(claveIndiceDeVisitas);
  } on Object {
    // Sin registro (spec 009, R-11).
  }
}
