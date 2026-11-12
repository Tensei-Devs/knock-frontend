import 'dart:convert';

import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/datos_de_visita.dart';
import 'package:app/features/actividad/domain/visita.dart';

/// La copia de la visita abierta en el almacenamiento seguro (Keystore), nunca
/// en `shared_preferences` ni en un archivo legible (spec 016, R-03 y CA-19).
class VisitaLocalRepositorySeguro implements VisitaLocalRepository {
  VisitaLocalRepositorySeguro(this._almacen);

  final AlmacenSeguro _almacen;

  @override
  Future<VisitaGuardada?> leer(String id) async {
    final texto = await _almacen.leer('$prefijoVisitaGuardada$id');
    if (texto == null) return null;
    try {
      final mapa = jsonDecode(texto);
      return mapa is Map<String, Object?>
          ? VisitaGuardada.desdeMapa(mapa)
          : null;
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> guardar(VisitaGuardada visita) async {
    await _almacen.escribir(
      '$prefijoVisitaGuardada${visita.id}',
      jsonEncode(visita.aMapa()),
    );
    final ids = await leerIndiceDeVisitas(_almacen)
      ..add(visita.id);
    await escribirIndiceDeVisitas(_almacen, ids);
  }

  @override
  Future<void> borrar(String id) async {
    await _almacen.borrar('$prefijoVisitaGuardada$id');
    final ids = await leerIndiceDeVisitas(_almacen)
      ..remove(id);
    await escribirIndiceDeVisitas(_almacen, ids);
  }
}
