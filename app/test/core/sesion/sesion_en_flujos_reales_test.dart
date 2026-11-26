// Spec 026, R-04 (KNOCK-288): las llamadas de los repositorios reales llevan la
// sesión. La API falsa responde 401 a lo que llegue sin ella, como el gateway.
import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/features/actividad/data/solicitud_repository_api.dart';
import 'package:app/features/actividad/data/visita_repository_api.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/features/inicio/data/zonas_repository_http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';

void main() {
  test(
    'CA_026_11 solicitudes, visitas y zonas envían el token de la sesión',
    () async {
      final api = ApiFalsa(
        (p) => http.Response('{}', p.autorizacion == null ? 401 : 200),
      );
      final c = contenedorConApi(api);
      addTearDown(c.dispose);
      final transporte = c.read(transporteApiProvider);
      final solicitudes = SolicitudRepositoryApi(
        transporte: transporte,
        url: urlApiPrueba,
      );
      final visitas = VisitaRepositoryApi(
        transporte: transporte,
        url: urlApiPrueba,
      );
      final avisos = AvisoRepositoryApi(
        transporte: transporte,
        url: urlApiPrueba,
      );
      final zonas = ZonasRepositoryHttp(
        transporte: transporte,
        url: urlApiPrueba,
      );
      final listaDeEspera = ListaEsperaRepositoryHttp(
        transporte: transporte,
        url: urlApiPrueba,
      );
      final nueva = NuevaSolicitud(
        oficioClave: 'plo',
        descripcion: 'Descripción de ejemplo',
        archivoIds: const [],
        dia: DateTime(2026, 11, 26),
        franja: Franja.values.first,
        coloniaId: '000000000000000000000001',
      );

      final llamadas = <Future<Object?> Function()>[
        solicitudes.listar,
        () => solicitudes.crear(nueva),
        () => solicitudes.obtener('s1'),
        () => solicitudes.cotizaciones('s1'),
        () => solicitudes.elegir('s1', 'c1'),
        () => visitas.obtenerVisita('v1'),
        () => avisos.pedirAviso('v1'),
        () => zonas.porCodigoPostal('42800'),
        () => listaDeEspera.registrar(cp: '42800'),
      ];
      for (final llamada in llamadas) {
        // El cuerpo vacío no es una respuesta válida: aquí solo importa lo que
        // salió hacia la API.
        await expectLater(llamada(), throwsA(isA<DatosInvalidosFailure>()));
      }

      expect(api.llamadas, [
        'GET solicitudes',
        'POST solicitudes',
        'GET solicitudes/s1',
        'GET solicitudes/s1/cotizaciones',
        'POST solicitudes/s1/elegir',
        'GET visitas/v1',
        'POST visitas/v1/aviso',
        'GET zonas/cp/42800',
        'POST zonas/lista-espera',
      ]);
      expect(
        api.peticiones.map((p) => p.autorizacion),
        everyElement('Bearer ${tokensA.accessToken}'),
      );
    },
  );
}
