/// Dirección guardada de la persona (spec 030, `GET /me/direcciones`). Solo
/// lleva los campos que declara el contrato. Es un dato personal: su
/// [toString] no la muestra, para que no llegue a registros (CA-16).
final class Direccion {
  const Direccion({
    required this.id,
    required this.calleNumero,
    required this.colonia,
    required this.principal,
    required this.creadoEn,
    this.referencias,
  });

  final String id;
  final String calleNumero;
  final String colonia;
  final String? referencias;
  final bool principal;
  final DateTime creadoEn;

  @override
  String toString() => 'Direccion(id: $id)';
}

/// Cuerpo de `POST /me/direcciones`; el servidor responde 422 por campo si
/// calle o colonia no son válidas.
final class DireccionNueva {
  const DireccionNueva({
    required this.calleNumero,
    required this.colonia,
    this.referencias,
    this.principal = false,
  });

  final String calleNumero;
  final String colonia;
  final String? referencias;
  final bool principal;

  @override
  String toString() => 'DireccionNueva()';
}

/// Cuerpo de `PUT /me/direcciones/{id}`: solo cambian los campos que no son
/// `null`. En las referencias, un texto vacío las borra (backend 040, R-10).
final class CambiosDireccion {
  const CambiosDireccion({
    this.calleNumero,
    this.colonia,
    this.referencias,
    this.principal,
  });

  final String? calleNumero;
  final String? colonia;
  final String? referencias;
  final bool? principal;

  bool get estaVacio =>
      calleNumero == null &&
      colonia == null &&
      referencias == null &&
      principal == null;

  @override
  String toString() => 'CambiosDireccion()';
}
