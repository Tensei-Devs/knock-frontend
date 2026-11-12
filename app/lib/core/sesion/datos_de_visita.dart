import 'dart:convert';

import 'package:app/core/sesion/almacen_seguro.dart';

/// Claves de la copia cifrada de las visitas abiertas (spec 016, R-03 y
/// R-17). Viven en `core` para que el cierre de sesión las borre sin conocer
/// la función Actividad.
const prefijoVisitaGuardada = 'knock.visita.abierta.';

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

/// Borra todas las visitas guardadas y su índice (CA-16). Lo llama el cierre
/// de sesión. Nunca lanza.
Future<void> borrarDatosDeVisita(AlmacenSeguro almacen) async {
  try {
    // Sin índice no hay visitas guardadas: no se toca el almacén.
    if (await almacen.leer(claveIndiceDeVisitas) == null) return;
    for (final id in await leerIndiceDeVisitas(almacen)) {
      await almacen.borrar('$prefijoVisitaGuardada$id');
    }
    await almacen.borrar(claveIndiceDeVisitas);
  } on Object {
    // Sin registro (spec 009, R-11).
  }
}
