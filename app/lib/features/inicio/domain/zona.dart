import 'package:app/features/inicio/domain/colonia.dart';

/// Zona de un código postal (contrato de `GET /api/v1/zonas/cp/{cp}`).
///
/// La cobertura la decide el servidor (spec 017, R-05): la app no la deduce del
/// prefijo ni de la colonia.
final class ResultadoZona {
  const ResultadoZona({
    required this.enCobertura,
    required this.ciudadPiloto,
    this.colonias = const [],
  });

  final bool enCobertura;

  /// Si el código postal es de la ciudad piloto.
  final bool ciudadPiloto;

  /// Colonias de ese código postal; vacío fuera de cobertura.
  final List<Colonia> colonias;
}

/// Registro en la lista de espera (contrato de
/// `POST /api/v1/zonas/lista-espera`). El servidor es idempotente por persona
/// y código postal: 201 la primera vez, 200 con `yaRegistrado` después.
final class RegistroListaEspera {
  const RegistroListaEspera({required this.cp, required this.yaRegistrado});

  final String cp;
  final bool yaRegistrado;
}
