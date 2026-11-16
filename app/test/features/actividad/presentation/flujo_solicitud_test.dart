// Recorrido de la solicitud con el doble en memoria: detalle que se refresca,
// lista de Actividad, salida «Ver y elegir (N)» y visita de la cita elegida
// (spec 015 CA-01 y CA-07; spec 016 CA-01, CA-04 y CA-21). Sin red ni disco.
import 'package:app/core/enlaces/abridor_de_enlaces.dart';
import 'package:app/core/plataforma/captura_en_recientes.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/tema/tema.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/data/solicitud_repository_de_prueba.dart';
import 'package:app/features/actividad/data/visita_local_repository.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/features/actividad/domain/visita.dart';
import 'package:app/features/actividad/presentation/actividad_screen.dart';
import 'package:app/features/actividad/presentation/cotizaciones_screen.dart';
import 'package:app/features/actividad/presentation/solicitud_detalle_screen.dart';
import 'package:app/features/actividad/presentation/visita_screen.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _EnlacesFalsos implements AbridorDeEnlaces {
  final abiertos = <Uri>[];

  @override
  Future<bool> abrir(Uri enlace) async {
    abiertos.add(enlace);
    return true;
  }
}

class _CapturaFalsa implements CapturaEnRecientes {
  @override
  Future<void> permitir({required bool permitir}) async {}
}

/// Una visita cuyo técnico trae `fotoUrl` de un dominio que nadie permitió.
class _VisitaConFotoAjena implements VisitaRepository {
  @override
  Future<Visita> obtenerVisita(String id) async => Visita(
    id: id,
    estado: EstadoVisita.confirmada,
    esTaller: false,
    dia: DateTime(2026, 11, 14),
    hora: '10:30',
    direccion: 'Calle de Prueba 123',
    codigo: '4712',
    puedeAvisar: true,
    tecnico: const TecnicoDeVisita(
      nombre: 'Técnico de prueba',
      verificado: true,
      fotoUrl: 'https://otro-sitio.example/foto.png',
    ),
  );
}

void main() {
  late DateTime ahora;
  late SolicitudRepositoryDePrueba doble;
  late _EnlacesFalsos enlaces;

  setUp(() {
    ahora = DateTime(2026, 11, 10, 10);
    doble = SolicitudRepositoryDePrueba(reloj: () => ahora);
    enlaces = _EnlacesFalsos();
  });

  Future<Solicitud> crear({String oficio = 'plo', String? direccion}) =>
      doble.crear(
        NuevaSolicitud(
          oficioClave: oficio,
          descripcion: 'Gotea la llave del baño',
          archivoIds: const ['a'],
          dia: DateTime(2026, 11, 12),
          franja: Franja.tarde,
          coloniaId: 'c' * 24,
          direccion: direccion,
        ),
      );

  Future<ProviderContainer> montar(
    WidgetTester tester,
    Widget pantalla, {
    VisitaRepository? visitas,
  }) async {
    final contenedor = ProviderContainer(
      overrides: [
        solicitudRepositoryProvider.overrideWithValue(doble),
        visitaRepositoryProvider.overrideWithValue(visitas ?? doble),
        visitaLocalRepositoryProvider.overrideWithValue(
          VisitaLocalRepositorySeguro(AlmacenSeguroEnMemoria()),
        ),
        abridorDeEnlacesProvider.overrideWithValue(enlaces),
        capturaEnRecientesProvider.overrideWithValue(_CapturaFalsa()),
        relojSolicitudProvider.overrideWithValue(() => ahora),
        intervaloRefrescoSolicitudProvider.overrideWithValue(
          const Duration(seconds: 3),
        ),
      ],
    );
    addTearDown(contenedor.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: contenedor,
        child: MaterialApp(
          theme: temaClaro,
          locale: const Locale('es'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: pantalla,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return contenedor;
  }

  /// Cierra la pantalla para que se cancele el temporizador de refresco.
  Future<void> cerrar(WidgetTester tester) =>
      tester.pumpWidget(const SizedBox.shrink());

  group('CA_015_01 el detalle se refresca solo', () {
    testWidgets('CA_015_01 pasada la espera aparece «Ver y elegir (4)»', (
      tester,
    ) async {
      final creada = await crear();
      await montar(tester, SolicitudDetalleScreen(id: creada.id));

      expect(find.text('Enviada'), findsOneWidget);
      expect(
        find.textContaining('Todavía no hay cotizaciones'),
        findsOneWidget,
      );
      expect(find.text('Ver y elegir (4)'), findsNothing);

      // Vence la espera de 10 s del doble; el detalle lo vuelve a pedir solo.
      ahora = ahora.add(const Duration(seconds: 11));
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.text('Recibiendo cotizaciones'), findsOneWidget);
      expect(find.text('Ver y elegir (4)'), findsOneWidget);
      expect(find.textContaining('Todavía no hay cotizaciones'), findsNothing);
      await cerrar(tester);
    });

    testWidgets('CA_015_01 con cotizaciones ya no se vuelve a pedir', (
      tester,
    ) async {
      final creada = await crear();
      ahora = ahora.add(const Duration(seconds: 11));
      await montar(tester, SolicitudDetalleScreen(id: creada.id));

      expect(find.text('Ver y elegir (4)'), findsOneWidget);
      // Si quedara un temporizador, el chequeo final de la prueba fallaría.
    });
  });

  group('CA_015_07 la pantalla de cotizaciones sin ellas tiene salida', () {
    testWidgets('CA_015_07 «Reintentar» vuelve a pedirlas y las muestra', (
      tester,
    ) async {
      final creada = await crear();
      await montar(tester, CotizacionesScreen(solicitudId: creada.id));
      expect(
        find.textContaining('Todavía no hay cotizaciones'),
        findsOneWidget,
      );

      ahora = ahora.add(const Duration(seconds: 11));
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();

      expect(find.text('Elegir'), findsWidgets);
      expect(find.textContaining('Todavía no hay cotizaciones'), findsNothing);
    });
  });

  group('CA_015_01 la lista de Actividad conserva la solicitud', () {
    testWidgets('CA_015_01 sin solicitudes muestra el estado vacío', (
      tester,
    ) async {
      await montar(tester, const ActividadScreen());
      expect(find.text('Aún no tienes actividad'), findsOneWidget);
    });

    testWidgets('CA_015_01 la solicitud creada aparece con su estado', (
      tester,
    ) async {
      final c = await montar(tester, const ActividadScreen());
      await crear();
      c.invalidate(solicitudesActividadProvider);
      await tester.pumpAndSettle();

      expect(find.text('Aún no tienes actividad'), findsNothing);
      expect(find.text('Plomería'), findsOneWidget);
      expect(find.textContaining('Enviada'), findsOneWidget);
      expect(find.textContaining('Gotea la llave del baño'), findsOneWidget);
    });

    test(
      'CA_015_01 el doble lista primero la solicitud más reciente',
      () async {
        final primera = await crear();
        ahora = ahora.add(const Duration(minutes: 1));
        final segunda = await crear(oficio: 'mec');

        final lista = await doble.listar();
        expect(lista.map((s) => s.id), [segunda.id, primera.id]);
        expect(lista.first.oficioNombre, 'Mecánica');
      },
    );
  });

  group('visita de la cita elegida en el doble', () {
    Future<String> elegir({
      required String oficio,
      required String cotizacionId,
      String? direccion,
    }) async {
      final creada = await crear(oficio: oficio, direccion: direccion);
      ahora = ahora.add(const Duration(seconds: 11));
      final cita = await doble.elegir(creada.id, cotizacionId);
      return cita.visitaId;
    }

    testWidgets('CA_016_04 cita en taller: dirección y «Cómo llegar»', (
      tester,
    ) async {
      final id = await elegir(oficio: 'mec', cotizacionId: 'c1');
      await montar(tester, VisitaScreen(id: id));

      expect(find.text('Cita en el taller'), findsOneWidget);
      await tester.tap(find.text('Cómo llegar'));
      await tester.pumpAndSettle();
      expect(
        enlaces.abiertos.single.toString(),
        'https://www.google.com/maps/search/?api=1&query='
        'Taller%20de%20prueba%2C%20Av.%20Ficticia%20100',
      );
    });

    testWidgets('CA_016_21 el técnico C no publicó contacto y se explica', (
      tester,
    ) async {
      final id = await elegir(
        oficio: 'plo',
        cotizacionId: 'c3',
        direccion: 'Calle de Prueba 123',
      );
      await montar(tester, VisitaScreen(id: id));

      expect(find.text('Llamar'), findsNothing);
      expect(find.text('WhatsApp'), findsNothing);
      expect(
        find.text(
          'Este técnico no publicó un teléfono. Podrás escribirle por el chat '
          'cuando esté disponible',
        ),
        findsOneWidget,
      );
    });

    testWidgets('CA_016_01 el técnico con contacto sí ofrece llamar', (
      tester,
    ) async {
      final id = await elegir(
        oficio: 'plo',
        cotizacionId: 'c1',
        direccion: 'Calle de Prueba 123',
      );
      await montar(tester, VisitaScreen(id: id));

      expect(find.text('Llamar'), findsOneWidget);
      expect(find.text('Técnico de prueba A'), findsOneWidget);
    });

    testWidgets('CA_016_01 una foto de un dominio no permitido no se carga', (
      tester,
    ) async {
      await montar(
        tester,
        const VisitaScreen(id: 'vvvvvvvvvvvvvvvvvvvvvvvv'),
        visitas: _VisitaConFotoAjena(),
      );

      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.foregroundImage, isNull);
      expect(find.text('T'), findsOneWidget);
    });
  });
}
