// Avisos dentro de la app (spec 034; backend 044). Solo los campos que usa la
// interfaz. `destino` no se lee: el contrato no publica su forma.

/// Un aviso de la bandeja.
final class AvisoEnBandeja {
  const AvisoEnBandeja({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.texto,
    required this.leido,
    required this.creadoEn,
  });

  final String id;

  /// Un tipo que la app no conoce se muestra igual, con un icono genérico.
  final String tipo;
  final String titulo;
  final String texto;
  final bool leido;
  final DateTime creadoEn;

  AvisoEnBandeja comoLeido() => AvisoEnBandeja(
    id: id,
    tipo: tipo,
    titulo: titulo,
    texto: texto,
    leido: true,
    creadoEn: creadoEn,
  );

  @override
  String toString() => 'AvisoEnBandeja(id: $id, tipo: $tipo)';
}

/// Página de avisos; [siguiente] es el cursor opaco o `null`.
final class PaginaAvisos {
  const PaginaAvisos(this.items, this.siguiente);

  final List<AvisoEnBandeja> items;
  final String? siguiente;
}

/// Un interruptor de «Qué avisos recibir».
final class PreferenciaDeAviso {
  const PreferenciaDeAviso({
    required this.tipo,
    required this.activo,
    required this.apagable,
  });

  final String tipo;
  final bool activo;

  /// Lo decide el servidor: los de seguridad no se apagan.
  final bool apagable;
}

abstract interface class BandejaAvisosRepository {
  Future<PaginaAvisos> listar({String? cursor});

  /// Falla con `NoEncontradoFailure` si el aviso ya no existe.
  Future<void> marcarLeido(String id);
  Future<void> marcarTodos();
  Future<List<PreferenciaDeAviso>> preferencias();

  /// Cambia un interruptor y devuelve las preferencias vigentes.
  Future<List<PreferenciaDeAviso>> cambiar(String tipo, {required bool activo});
}
