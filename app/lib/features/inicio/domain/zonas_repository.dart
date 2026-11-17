import 'package:app/features/inicio/domain/zona.dart';

/// Fuente de la zona de un código postal. Falla con un `Failure` de
/// `core/errores`.
abstract interface class ZonasRepository {
  /// [cp] ya validado con exactamente 5 dígitos (spec 017, R-04).
  Future<ResultadoZona> porCodigoPostal(String cp);
}

/// Lista de espera de las zonas sin cobertura (spec 017, R-08). Nunca lleva
/// coordenadas: solo el código postal escrito por la persona y, si quiere, el
/// municipio.
abstract interface class ListaEsperaRepository {
  Future<RegistroListaEspera> registrar({
    required String cp,
    String? municipio,
  });
}
