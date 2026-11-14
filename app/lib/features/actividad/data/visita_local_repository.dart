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

  /// Primero el índice y después los datos: si la app se cierra entre las dos
  /// escrituras, queda en el índice una visita sin datos (inofensiva), nunca
  /// un código guardado que el cierre de sesión no encuentre (R-17).
  @override
  Future<void> guardar(VisitaGuardada visita) async {
    final ids = await leerIndiceDeVisitas(_almacen)
      ..add(visita.id);
    await escribirIndiceDeVisitas(_almacen, ids);
    await _almacen.escribir(
      '$prefijoVisitaGuardada${visita.id}',
      jsonEncode(visita.aMapa()),
    );
  }

  /// Primero los datos y después el índice, por la misma razón.
  @override
  Future<void> borrar(String id) async {
    await _almacen.borrar('$prefijoVisitaGuardada$id');
    // El respaldo del aviso de esa visita (spec 022, R-12) se va con ella:
    // si quedara, el cierre de sesión ya no lo encontraría (CA-20).
    await _almacen.borrar('$prefijoRespaldoAviso$id');
    final ids = await leerIndiceDeVisitas(_almacen)
      ..remove(id);
    await escribirIndiceDeVisitas(_almacen, ids);
  }
}
