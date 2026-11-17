import 'package:app/features/inicio/data/zona_mapper.dart';
import 'package:app/features/inicio/domain/zona.dart';
import 'package:app/features/inicio/domain/zonas_repository.dart';

/// SIMULADO: respuesta ficticia con la forma del contrato, para la demo sin
/// `KNOCK_API_URL`. Pasa por [ZonaMapper] igual que la respuesta real. El
/// servidor real es quien decide la cobertura; aquí solo se imita con el código
/// postal de la colonia de ejemplo.
class ZonasRepositorySimulado implements ZonasRepository {
  const ZonasRepositorySimulado();

  static const cpDeEjemplo = '42800';

  @override
  Future<ResultadoZona> porCodigoPostal(String cp) async =>
      ZonaMapper.zonaDesdeContrato(
        cp == cpDeEjemplo
            ? const {
                'enCobertura': true,
                'ciudadPiloto': true,
                'colonias': [
                  {
                    'id': '00000000-0000-4000-8000-000000000001',
                    'nombre': 'Colonia de ejemplo',
                    'cp': cpDeEjemplo,
                    'municipio': 'Municipio de ejemplo',
                  },
                ],
              }
            : const {
                'enCobertura': false,
                'ciudadPiloto': false,
                'colonias': <Object?>[],
              },
      );
}

/// SIMULADO: acepta el registro sin enviarlo a ningún sitio.
class ListaEsperaRepositorySimulado implements ListaEsperaRepository {
  const ListaEsperaRepositorySimulado();

  @override
  Future<RegistroListaEspera> registrar({
    required String cp,
    String? municipio,
  }) async => RegistroListaEspera(cp: cp, yaRegistrado: false);
}
