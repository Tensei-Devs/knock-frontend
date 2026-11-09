import 'package:app/app.dart';
import 'package:app/core/notificaciones/carga_notificacion.dart';
import 'package:app/core/notificaciones/servicio_notificaciones.dart';
import 'package:app/core/preferencias/almacen_avisos.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/sesion/es_tecnico_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/fakes_notificaciones.dart';
import '../../soporte/montar_app.dart';

Future<ProviderContainer> _montar(
  WidgetTester tester,
  ServicioNotificacionesFalso servicio, {
  bool esTecnico = true,
}) async {
  final container = ProviderContainer(
    overrides: [
      conSesion(),
      servicioNotificacionesProvider.overrideWithValue(servicio),
      esTecnicoProvider.overrideWith(() => EsTecnicoFijo(esTecnico)),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const KnockApp()),
  );
  await tester.pumpAndSettle();
  return container;
}

class EsTecnicoFijo extends EsTecnicoNotifier {
  EsTecnicoFijo(this._valor);

  final bool _valor;

  @override
  bool build() => _valor;
}

void main() {
  group('CA-012-03 tocar una notificación abre su pantalla', () {
    testWidgets('CA_012_03 con la app abierta en segundo plano', (
      tester,
    ) async {
      final servicio = ServicioNotificacionesFalso();
      final container = await _montar(tester, servicio);
      expect(ubicacion(container), Rutas.inicio);

      servicio.tocar({'tipo': 'cotizaciones', 'destino': 'actividad'});
      await tester.pumpAndSettle();

      expect(ubicacion(container), Rutas.actividad);
    });

    testWidgets('CA_012_03 al abrir la app cerrada desde la notificación', (
      tester,
    ) async {
      final servicio = ServicioNotificacionesFalso()
        ..inicial = {'tipo': 'sistema', 'destino': 'configuracion'};
      final container = await _montar(tester, servicio);

      expect(ubicacion(container), Rutas.configuracion);
    });

    testWidgets('CA_012_03 sin destino cae en la pantalla natural del tipo', (
      tester,
    ) async {
      final servicio = ServicioNotificacionesFalso();
      final container = await _montar(tester, servicio);

      servicio.tocar({'tipo': 'visitas'});
      await tester.pumpAndSettle();

      expect(ubicacion(container), Rutas.actividad);
    });

    testWidgets(
      'CA_012_03 seguridad negativa: una ruta o un tipo inventados se ignoran',
      (tester) async {
        final servicio = ServicioNotificacionesFalso();
        final container = await _montar(tester, servicio);

        servicio.tocar({
          'tipo': 'mensajes',
          'destino': '/cuenta/configuracion',
        });
        await tester.pumpAndSettle();
        // El destino no es un nombre conocido: cae en el del tipo, no en la ruta.
        expect(ubicacion(container), Rutas.actividad);

        servicio.tocar({'tipo': 'otro', 'destino': 'cuenta'});
        servicio.tocar({'destino': 'cuenta'});
        await tester.pumpAndSettle();
        expect(ubicacion(container), Rutas.actividad);
      },
    );

    testWidgets(
      'CA_012_03 una notificación de Trabajo no abre Trabajo sin el rol',
      (tester) async {
        final servicio = ServicioNotificacionesFalso();
        final container = await _montar(tester, servicio, esTecnico: false);

        servicio.tocar({'tipo': 'cotizaciones', 'destino': 'trabajo'});
        await tester.pumpAndSettle();

        expect(ubicacion(container), Rutas.inicio);
      },
    );

    test('CA_012_03 la carga lee tipo, destino y conversación', () {
      final carga = CargaNotificacion.desde({
        'tipo': 'mensajes',
        'destino': 'actividad',
        'conversacion': 'c-1',
      });

      expect(carga?.tipo, TipoAviso.mensajes);
      expect(carga?.destino, DestinoNotificacion.actividad);
      expect(carga?.conversacion, 'c-1');
      expect('$carga', isNot(contains('c-1')));
    });
  });
}
