import 'package:app/core/notificaciones/avisos_provider.dart';
import 'package:app/core/notificaciones/carga_notificacion.dart';
import 'package:app/core/preferencias/almacen_avisos.dart';
import 'package:app/core/preferencias/almacen_preferencias.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _mensaje = CargaNotificacion(
  tipo: TipoAviso.mensajes,
  destino: DestinoNotificacion.actividad,
  conversacion: 'c-1',
);

ProviderContainer _contenedor([AlmacenPreferencias? almacen]) {
  final c = ProviderContainer(
    overrides: [
      if (almacen != null)
        almacenPreferenciasProvider.overrideWithValue(almacen),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  group('R-05 cada persona elige qué avisos recibir', () {
    test('R_012_05 por defecto recibe todos', () {
      final avisos = _contenedor().read(avisosProvider);

      for (final tipo in TipoAviso.values) {
        expect(avisos.recibe(tipo), isTrue, reason: tipo.name);
      }
    });

    test('R_012_05 apagar un tipo lo deja de mostrar y no toca los demás', () {
      final c = _contenedor();
      c.read(avisosProvider.notifier).elegir(TipoAviso.visitas, recibir: false);

      expect(c.read(avisosProvider).recibe(TipoAviso.visitas), isFalse);
      expect(c.read(avisosProvider).recibe(TipoAviso.mensajes), isTrue);
      expect(
        c.read(
          debeMostrarNotificacionProvider(
            const CargaNotificacion(
              tipo: TipoAviso.visitas,
              destino: DestinoNotificacion.actividad,
            ),
          ),
        ),
        isFalse,
      );
    });

    test('R_012_05 los avisos del sistema no se pueden apagar', () {
      final c = _contenedor();
      c.read(avisosProvider.notifier).elegir(TipoAviso.sistema, recibir: false);

      expect(c.read(avisosProvider).recibe(TipoAviso.sistema), isTrue);
    });

    test('R_012_05 lo elegido se conserva en el almacén', () async {
      SharedPreferences.setMockInitialValues({});
      final almacen = AlmacenPreferenciasShared(
        await SharedPreferences.getInstance(),
      );
      _contenedor(almacen)
          .read(avisosProvider.notifier)
          .elegir(TipoAviso.cotizaciones, recibir: false);
      await Future<void>.delayed(Duration.zero);

      final otraSesion = _contenedor(almacen).read(avisosProvider);
      expect(otraSesion.recibe(TipoAviso.cotizaciones), isFalse);
      expect(otraSesion.recibe(TipoAviso.mensajes), isTrue);
    });

    test('R_012_05 un valor guardado que no es booleano se ignora', () async {
      SharedPreferences.setMockInitialValues({
        claveDeAviso(TipoAviso.mensajes): 'no',
      });
      final almacen = AlmacenPreferenciasShared(
        await SharedPreferences.getInstance(),
      );

      expect(
        _contenedor(almacen).read(avisosProvider).recibe(TipoAviso.mensajes),
        isTrue,
      );
    });
  });

  group('R-04 en el chat el mensaje llega en vivo', () {
    test(
      'R_012_04 con la conversación abierta no se muestra la notificación',
      () {
        final c = _contenedor();
        c.read(conversacionAbiertaProvider.notifier).abrir('c-1');

        expect(c.read(debeMostrarNotificacionProvider(_mensaje)), isFalse);
      },
    );

    test('R_012_04 otra conversación o salir del chat sí la muestra', () {
      final c = _contenedor();
      c.read(conversacionAbiertaProvider.notifier).abrir('c-2');
      expect(c.read(debeMostrarNotificacionProvider(_mensaje)), isTrue);

      c.read(conversacionAbiertaProvider.notifier).abrir(null);
      expect(c.read(debeMostrarNotificacionProvider(_mensaje)), isTrue);
    });
  });
}
