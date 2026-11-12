import 'dart:convert';

import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/datos_de_visita.dart';
import 'package:app/features/actividad/domain/aviso.dart';

/// Contactos de confianza en el almacén seguro (Keystore); nunca salen del
/// teléfono (spec 022, R-01 y CA-04).
class ContactosConfianzaSeguros implements ContactosConfianzaRepository {
  ContactosConfianzaSeguros(this._almacen);

  final AlmacenSeguro _almacen;

  @override
  Future<List<ContactoConfianza>> listar() async {
    final texto = await _almacen.leer(claveContactosConfianza);
    if (texto == null) return const [];
    try {
      final lista = jsonDecode(texto);
      if (lista is! List) return const [];
      return [for (final mapa in lista) ?ContactoConfianza.desdeMapa(mapa)];
    } on FormatException {
      return const [];
    }
  }

  @override
  Future<void> guardar(ContactoConfianza contacto) async {
    final lista = await listar();
    final error = puedeGuardarse(
      lista,
      nombre: contacto.nombre,
      celular: contacto.celular,
      idEditado: lista.any((c) => c.id == contacto.id) ? contacto.id : null,
    );
    if (error != null) throw ContactoNoGuardado(error);
    final limpio = ContactoConfianza(
      id: contacto.id,
      nombre: contacto.nombre.trim(),
      celular: soloDigitos(contacto.celular),
    );
    final nueva = [
      for (final c in lista) c.id == limpio.id ? limpio : c,
      if (!lista.any((c) => c.id == limpio.id)) limpio,
    ];
    await _escribir(nueva);
  }

  @override
  Future<void> borrar(String id) async =>
      _escribir([...await listar()]..removeWhere((c) => c.id == id));

  Future<void> _escribir(List<ContactoConfianza> lista) => lista.isEmpty
      ? _almacen.borrar(claveContactosConfianza)
      : _almacen.escribir(
          claveContactosConfianza,
          jsonEncode([for (final c in lista) c.aMapa()]),
        );
}

/// Copia de [DatosAvisoLocal] por visita (`knock.aviso.respaldo.{id}`, R-12).
/// Usa el mismo índice de visitas, así el cierre de sesión la borra.
class RespaldoAvisoSeguro implements RespaldoAvisoRepository {
  RespaldoAvisoSeguro(this._almacen);

  final AlmacenSeguro _almacen;

  @override
  Future<DatosAvisoLocal?> leer(String visitaId) async {
    final texto = await _almacen.leer('$prefijoRespaldoAviso$visitaId');
    if (texto == null) return null;
    try {
      final mapa = jsonDecode(texto);
      if (mapa is! Map) return null;
      final dia = DateTime.tryParse('${mapa['dia']}');
      final nombre = mapa['tecnicoNombre'];
      final hora = mapa['hora'];
      if (dia == null || nombre is! String || hora is! String) return null;
      return DatosAvisoLocal(
        tecnicoNombre: nombre,
        tecnicoVerificado: mapa['tecnicoVerificado'] == true,
        dia: dia,
        hora: hora,
      );
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> guardar(String visitaId, DatosAvisoLocal datos) async {
    await _almacen.escribir(
      '$prefijoRespaldoAviso$visitaId',
      jsonEncode({
        'tecnicoNombre': datos.tecnicoNombre,
        'tecnicoVerificado': datos.tecnicoVerificado,
        'dia': datos.dia.toIso8601String(),
        'hora': datos.hora,
      }),
    );
    final ids = await leerIndiceDeVisitas(_almacen)
      ..add(visitaId);
    await escribirIndiceDeVisitas(_almacen, ids);
  }
}
