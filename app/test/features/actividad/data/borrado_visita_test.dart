import 'dart:io';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/preferencias/directorio_fotos_borrador.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/datos_de_visita.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/core/tema/tema.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/data/aviso_local_repository.dart';
import 'package:app/features/actividad/data/visita_local_repository.dart';
import 'package:app/features/actividad/domain/aviso.dart';
import 'package:app/features/actividad/domain/visita.dart';
import 'package:app/features/actividad/presentation/visita_controller.dart';
import 'package:app/features/cuenta/presentation/contactos_confianza_screen.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _id = 'vvvvvvvvvvvvvvvvvvvvvvvv';

class _VisitasFalsas implements VisitaRepository {
  EstadoVisita estado = EstadoVisita.confirmada;

  @override
  Future<Visita> obtenerVisita(String id) async {
    if (id != _id) throw const NoEncontradoFailure();
    return Visita(
      id: _id,
      estado: estado,
      esTaller: false,
      dia: DateTime(2026, 11, 14),
      hora: '10:30',
      direccion: 'Calle de Prueba 123',
      codigo: '4821',
      puedeAvisar: true,
      tecnico: const TecnicoDeVisita(
        nombre: 'Técnico de prueba',
        verificado: true,
      ),
    );
  }
}

void main() {
  late AlmacenSeguroEnMemoria almacen;
  late Directory fotos;

  setUp(() {
    almacen = AlmacenSeguroEnMemoria();
    fotos = Directory.systemTemp.createTempSync('knock_fotos_');
    addTearDown(() => fotos.deleteSync(recursive: true));
  });

  ProviderContainer contenedor({VisitaRepository? visitas}) {
    final c = ProviderContainer(
      overrides: [
        almacenSeguroProvider.overrideWithValue(almacen),
        directorioFotosBorradorProvider.overrideWithValue(() async => fotos),
        if (visitas != null)
          visitaRepositoryProvider.overrideWithValue(visitas),
        visitaLocalRepositoryProvider.overrideWithValue(
          VisitaLocalRepositorySeguro(almacen),
        ),
        respaldoAvisoRepositoryProvider.overrideWithValue(
          RespaldoAvisoSeguro(almacen),
        ),
        relojSolicitudProvider.overrideWithValue(() => DateTime(2026, 11, 12)),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  testWidgets(
    'CA_022_13 al cerrar sesión la persona ya no ve los contactos de la cuenta',
    (tester) async {
      await ContactosConfianzaSeguros(almacen).guardar(
        const ContactoConfianza(id: '1', nombre: 'Mamá', celular: '5500000001'),
      );
      final c = contenedor();
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: c,
          child: MaterialApp(
            theme: temaClaro,
            locale: const Locale('es'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const ContactosConfianzaScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Mamá'), findsOneWidget);

      await tester.runAsync(() => c.read(sesionProvider.notifier).cerrar());
      await tester.pumpAndSettle();

      // Lo que ve la persona, no solo el almacén.
      expect(find.text('Mamá'), findsNothing);
      expect(
        find.text(
          'Agrega a alguien de confianza para avisarle cuando tengas una visita',
        ),
        findsOneWidget,
      );
      expect(almacen.contenido, isEmpty);
    },
  );

  test(
    'CA_022_20 cuando la visita termina se borra también el respaldo del aviso',
    () async {
      final visitas = _VisitasFalsas();
      final c = contenedor(visitas: visitas);
      final sub = c.listen(visitaProvider(_id), (_, _) {});
      addTearDown(sub.close);

      // Abrir la visita guarda su copia y el respaldo del aviso (R-12).
      await c.read(visitaProvider(_id).future);
      expect(almacen.contenido.keys, contains('$prefijoRespaldoAviso$_id'));

      // La visita termina: al volver a pedirla se borra todo lo suyo.
      visitas.estado = EstadoVisita.terminada;
      c.invalidate(visitaProvider(_id));
      await c.read(visitaProvider(_id).future);

      expect(
        almacen.contenido.keys,
        isNot(contains('$prefijoRespaldoAviso$_id')),
      );
      expect(almacen.contenido, isEmpty);
    },
  );

  test('CA_022_20 una visita ajena también borra su respaldo', () async {
    final c = contenedor(visitas: _VisitasFalsas());
    final sub = c.listen(visitaProvider(_id), (_, _) {});
    addTearDown(sub.close);
    await c.read(visitaProvider(_id).future);
    expect(almacen.contenido, isNotEmpty);

    await VisitaLocalRepositorySeguro(almacen).borrar(_id);
    await borrarDatosDeVisita(almacen);

    expect(almacen.contenido, isEmpty);
  });
}
