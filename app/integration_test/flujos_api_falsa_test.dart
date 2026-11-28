import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/almacen_sesion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';

import '../test/soporte/api_falsa.dart';
import 'soporte/arranque_e2e.dart';

/// Humo de los flujos con sesión (KNOCK-293): la app real en el teléfono contra
/// una API falsa en memoria. Sin SMS, sin cuenta y sin tocar dev. Solo datos
/// ficticios.
///
/// `cd app; flutter test integration_test/flujos_api_falsa_test.dart -d <id>`
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'TC-KNOCK-293-API-01 la sesión guardada abre la app; ver cotizaciones y '
    'elegir una',
    (tester) async {
      final api = _servidor();
      await arrancarE2e(tester, api: api, conSesion: true);

      expect(find.byType(NavigationDestination), findsNWidgets(4));
      await tocar(tester, enLaBarra('Actividad'));
      await tocar(tester, find.text('Ver y elegir'));
      expect(find.text('Rosa Pérez'), findsOneWidget);
      expect(find.text('2 recibidas'), findsOneWidget);

      await tocar(tester, find.text('Elegir a Rosa'));
      await tocar(tester, find.text('Sí, elegir a Rosa'));
      expect(find.text('Cita confirmada'), findsOneWidget);

      final elegir = api.peticiones.singleWhere(
        (p) => p.llamadaCompleta == 'POST /api/v1/solicitudes/$_id/elegir',
      );
      expect(elegir.json, {'cotizacionId': 'c1'});
      expect(elegir.autorizacion, 'Bearer ${tokensA.accessToken}');
    },
  );

  testWidgets(
    'TC-KNOCK-293-API-02 con el servidor caído avisa sin inventar datos y '
    'Reintentar carga la lista',
    (tester) async {
      var caido = true;
      final base = _servidor();
      final api = ApiFalsa(
        (p) => caido && p.ruta == 'solicitudes'
            ? http.Response('', 503)
            : base.responder(p),
      );
      await arrancarE2e(tester, api: api, conSesion: true);

      await tocar(tester, enLaBarra('Actividad'));
      expect(find.text('No pudimos cargar tus solicitudes.'), findsOneWidget);
      expect(find.text('Ver y elegir'), findsNothing);
      expect(find.textContaining('boiler'), findsNothing);

      caido = false;
      await tocar(tester, find.text('Reintentar'));
      expect(find.text('No pudimos cargar tus solicitudes.'), findsNothing);
      expect(find.text('Ver y elegir'), findsOneWidget);
    },
  );

  testWidgets(
    'TC-KNOCK-293-API-03 cerrar sesión avisa a la API, borra los tokens y '
    'vuelve a la previa',
    (tester) async {
      final api = _servidor();
      await arrancarE2e(tester, api: api, conSesion: true);
      // Celular ficticio que «Mi cuenta» recuerda en el dispositivo.
      const guardado = FlutterSecureStorage();
      await guardado.write(key: 'knock.maqueta.telefono', value: '5512345678');

      await tocar(tester, enLaBarra('Mi cuenta'));
      await tocar(tester, find.text('Cerrar sesión'));
      expect(find.text('¿Cerrar sesión?'), findsOneWidget);
      // El de la hoja es el último; el de la pantalla queda debajo.
      await tocar(tester, find.text('Cerrar sesión').hitTestable().last);

      expect(api.llamadas, contains('POST auth/logout'));
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.text('Entrar'), findsWidgets);
      final almacen = AlmacenSesion(AlmacenSeguroFlutterSecureStorage());
      // El borrado en el Keystore va por el canal nativo: puede terminar
      // después de que la pantalla ya cambió. Se espera como máximo 10 s.
      for (var i = 0; i < 100 && await almacen.leerAcceso() != null; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(await almacen.leerAcceso(), isNull);
      expect(await almacen.leerRefresco(), isNull);
      for (
        var i = 0;
        i < 100 && await guardado.containsKey(key: 'knock.maqueta.telefono');
        i++
      ) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(await guardado.read(key: 'knock.maqueta.telefono'), isNull);
    },
  );
}

final _id = 'b' * 24;

Map<String, Object?> _fila() => {
  'id': _id,
  'estado': 'cotizando',
  'oficioNombre': 'Plomería',
  'coloniaNombre': 'Col. Centro',
  'dia': '2026-12-12',
  'franja': 'tarde',
  'totalFotos': 0,
  'totalCotizaciones': 2,
  'venceEn': '2026-12-10T18:00:00Z',
  'creadoEn': '2026-12-08T18:00:00Z',
};

Map<String, Object?> _cotizacion(String id, String nombre, int precio) => {
  'id': id,
  'tipoPrecio': 'fijo',
  'precio': precio,
  'precioMin': null,
  'precioMax': null,
  'tope': precio + 100,
  'requiereAprobacion': true,
  'dia': '2026-12-12',
  'hora': '10:30',
  'nota': 'Nota de prueba',
  'cubre': 'Arreglo completo, mano de obra incluida',
  'etiquetas': <Object?>[],
  'tecnico': {
    'id': 't$id',
    'nombre': nombre,
    'verificado': true,
    'nivelVerificacion': 'basico',
    'fotoUrl': null,
    'calificacion': 4.5,
  },
};

/// Lo mínimo que piden estos recorridos; lo demás responde 404.
ApiFalsa _servidor() => ApiFalsa((p) {
  switch (p.llamadaCompleta.replaceFirst(_id, '{id}')) {
    case 'GET /api/v1/me':
      return jsonOk(perfilJson());
    case 'GET /api/v1/solicitudes':
      return jsonOk({
        'items': [_fila()],
        'nextCursor': null,
      });
    case 'GET /api/v1/solicitudes/{id}/cotizaciones':
      return jsonOk({
        'solicitudId': _id,
        'cotizaciones': [
          _cotizacion('c1', 'Rosa Pérez', 1000),
          _cotizacion('c2', 'Luis Gómez', 900),
        ],
        'totalCotizaciones': 2,
        'tiposMixtos': false,
        'puedeElegir': true,
        'motivo': null,
        'visitaId': null,
      });
    case 'POST /api/v1/solicitudes/{id}/elegir':
      return jsonOk({
        'visitaId': 'v1',
        'solicitudId': _id,
        'cotizacionId': 'c1',
        'modalidad': 'domicilio',
        'dia': '2026-12-12',
        'hora': '10:30',
        'precio': 1000,
        'tope': 1100,
        'tecnico': {
          'nombre': 'Rosa Pérez',
          'verificado': true,
          'nivelVerificacion': 'basico',
          'telefono': null,
          'whatsapp': null,
        },
        'lugar': {'direccion': 'Calle Ficticia 1'},
      });
    case 'POST /api/v1/auth/logout':
      return http.Response('', 204);
    default:
      return http.Response('', 404);
  }
});
