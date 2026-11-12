import 'package:app/core/errores/failure.dart';
import 'package:app/core/plataforma/captura_en_recientes.dart';
import 'package:app/core/enlaces/abridor_de_enlaces.dart';
import 'package:app/core/enlaces/enlaces.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/datos_de_visita.dart';
import 'package:app/core/tema/tema.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/data/visita_local_repository.dart';
import 'package:app/features/actividad/domain/visita.dart';
import 'package:app/features/actividad/presentation/visita_controller.dart';
import 'package:app/features/actividad/presentation/visita_screen.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../soporte/accesibilidad.dart';
import '../../../soporte/pantalla_maqueta.dart';

const _id = 'vvvvvvvvvvvvvvvvvvvvvvvv';

Visita _visita({
  bool esTaller = false,
  String? codigo = '4712',
  MotivoCodigo? motivo,
  bool puedeAvisar = true,
  String? telefono = '5500000001',
  String? whatsapp,
  EstadoVisita estado = EstadoVisita.confirmada,
}) => Visita(
  id: _id,
  estado: estado,
  esTaller: esTaller,
  dia: DateTime(2026, 11, 14),
  hora: '10:30',
  direccion: esTaller
      ? 'Taller de prueba, Av. Ficticia 100'
      : 'Calle de Prueba 123',
  codigo: esTaller ? null : codigo,
  motivoCodigo: esTaller ? MotivoCodigo.noAplica : motivo,
  puedeAvisar: puedeAvisar,
  tecnico: TecnicoDeVisita(
    nombre: 'Técnico de prueba',
    verificado: true,
    telefono: telefono,
    whatsapp: whatsapp,
  ),
);

class _VisitasFalsas implements VisitaRepository {
  Visita? visita;
  Failure? falla;

  @override
  Future<Visita> obtenerVisita(String id) async {
    if (falla != null) throw falla!;
    if (id != _id || visita == null) throw const NoEncontradoFailure();
    return visita!;
  }
}

class _EnlacesFalsos implements AbridorDeEnlaces {
  final abiertos = <Uri>[];
  bool hayApp = true;

  @override
  Future<bool> abrir(Uri enlace) async {
    abiertos.add(enlace);
    return hayApp;
  }
}

class _CapturaFalsa implements CapturaEnRecientes {
  final llamadas = <bool>[];

  @override
  Future<void> permitir({required bool permitir}) async =>
      llamadas.add(permitir);
}

void main() {
  late _VisitasFalsas visitas;
  late AlmacenSeguroEnMemoria almacen;
  late _EnlacesFalsos enlaces;
  late _CapturaFalsa captura;

  setUp(() {
    visitas = _VisitasFalsas();
    almacen = AlmacenSeguroEnMemoria();
    enlaces = _EnlacesFalsos();
    captura = _CapturaFalsa();
  });

  Future<ProviderContainer> montar(
    WidgetTester tester, {
    bool avisoDisponible = true,
  }) async {
    final contenedor = ProviderContainer(
      overrides: [
        visitaRepositoryProvider.overrideWithValue(visitas),
        visitaLocalRepositoryProvider.overrideWithValue(
          VisitaLocalRepositorySeguro(almacen),
        ),
        abridorDeEnlacesProvider.overrideWithValue(enlaces),
        capturaEnRecientesProvider.overrideWithValue(captura),
        avisoDeConfianzaDisponibleProvider.overrideWithValue(avisoDisponible),
        relojSolicitudProvider.overrideWithValue(() => DateTime(2026, 11, 12)),
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
          home: const VisitaScreen(id: _id),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return contenedor;
  }

  /// Vuelve a pedir la visita en la misma pantalla (como al volver a la app).
  Future<void> refrescar(WidgetTester tester, ProviderContainer c) async {
    c.invalidate(visitaProvider(_id));
    await tester.pumpAndSettle();
  }

  Future<VisitaGuardada?> guardada() =>
      VisitaLocalRepositorySeguro(almacen).leer(_id);

  group('CA_016_01 visita a domicilio con código', () {
    testWidgets('CA_016_01 técnico, insignia, día, hora, código y regla', (
      tester,
    ) async {
      visitas.visita = _visita();
      await montar(tester);

      expect(find.text('Técnico de prueba'), findsOneWidget);
      expect(find.text('Verificado'), findsOneWidget);
      expect(find.textContaining('10:30'), findsOneWidget);
      for (final digito in ['4', '7', '1', '2']) {
        expect(find.text(digito), findsOneWidget);
      }
      expect(
        find.text(
          'Pídele a Técnico de prueba que te diga este código en la puerta. '
          'Si no lo sabe, no abras.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('CA_016_14 el código se lee dígito por dígito', (tester) async {
      final semantica = tester.ensureSemantics();
      visitas.visita = _visita();
      await montar(tester);

      expect(
        find.bySemanticsLabel(RegExp('Código: 4, 7, 1, 2')),
        findsOneWidget,
      );
      semantica.dispose();
    });

    testWidgets('CA_016_08 «Ocultar código» lo tapa sin borrarlo', (
      tester,
    ) async {
      final semantica = tester.ensureSemantics();
      visitas.visita = _visita();
      await montar(tester);

      await tester.tap(find.text('Ocultar código'));
      await tester.pumpAndSettle();
      expect(find.text('4'), findsNothing);
      expect(find.bySemanticsLabel(RegExp('Código oculto')), findsOneWidget);

      await tester.tap(find.text('Mostrar código'));
      await tester.pumpAndSettle();
      expect(find.text('4'), findsOneWidget);
      semantica.dispose();
    });

    testWidgets('R-18 apaga la miniatura en recientes y la vuelve a prender', (
      tester,
    ) async {
      visitas.visita = _visita();
      await montar(tester);
      expect(captura.llamadas, [false]);

      await tester.pumpWidget(const SizedBox());
      expect(captura.llamadas, [false, true]);
    });
  });

  group('CA_016_02, CA_016_18 y CA_016_19 copia local', () {
    testWidgets('CA_016_02 sin conexión muestra lo guardado', (tester) async {
      visitas.visita = _visita();
      final c = await montar(tester);
      visitas.falla = const ServicioNoDisponibleFailure();

      await refrescar(tester, c);

      expect(
        find.text(
          'Sin conexión. Te mostramos los datos guardados de tu visita.',
        ),
        findsOneWidget,
      );
      expect(find.text('Técnico de prueba'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
    });

    testWidgets(
      'CA_016_18 a domicilio la copia no lleva dirección ni contacto',
      (tester) async {
        visitas.visita = _visita(whatsapp: '5500000009');
        await montar(tester);

        final copia = almacen.contenido.values.join(' ');
        expect(copia, contains('4712'));
        expect(copia, isNot(contains('Calle de Prueba')));
        expect(copia, isNot(contains('5500000001')));
        expect(copia, isNot(contains('5500000009')));
      },
    );

    testWidgets('CA_016_18 en taller sí guarda la dirección del taller', (
      tester,
    ) async {
      visitas.visita = _visita(esTaller: true);
      await montar(tester);

      expect(
        (await guardada())!.direccionTaller,
        'Taller de prueba, Av. Ficticia 100',
      );
      expect((await guardada())!.codigo, isNull);
    });

    testWidgets('CA_016_19 el código solo vive en el almacén seguro', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      visitas.visita = _visita();
      await montar(tester);

      final preferencias = await SharedPreferences.getInstance();
      expect(preferencias.getKeys(), isEmpty);
      expect(almacen.contenido.keys, contains('$prefijoVisitaGuardada$_id'));
    });
  });

  group('CA_016_07 sin código, el motivo', () {
    for (final (motivo, texto) in [
      (
        MotivoCodigo.usado,
        'El técnico ya confirmó su llegada con este código.',
      ),
      (MotivoCodigo.vencido, 'Este código ya venció.'),
      (
        MotivoCodigo.bloqueada,
        'Esta visita quedó bloqueada por seguridad. El equipo de Knock la revisará.',
      ),
    ]) {
      testWidgets('CA_016_07 ${motivo.valor} y la copia pierde el código', (
        tester,
      ) async {
        visitas.visita = _visita();
        final c = await montar(tester);
        expect((await guardada())!.codigo, '4712');

        visitas.visita = _visita(codigo: null, motivo: motivo);
        await refrescar(tester, c);

        expect(find.text(texto), findsOneWidget);
        expect(find.text('Ocultar código'), findsNothing);
        expect((await guardada())!.codigo, isNull);
      });
    }
  });

  group('CA_016_04 cita en taller', () {
    testWidgets(
      'CA_016_04 dirección y «Cómo llegar» con la dirección codificada',
      (tester) async {
        visitas.visita = _visita(esTaller: true);
        await montar(tester);

        expect(find.text('Cita en el taller'), findsOneWidget);
        expect(find.text('Esta cita no necesita código.'), findsNothing);
        await tester.tap(find.text('Cómo llegar'));
        await tester.pumpAndSettle();

        expect(
          enlaces.abiertos.single.toString(),
          'https://www.google.com/maps/search/?api=1&query='
          'Taller%20de%20prueba%2C%20Av.%20Ficticia%20100',
        );
      },
    );

    testWidgets('CA_016_04 sin app de mapas avisa sin bloquear', (
      tester,
    ) async {
      visitas.visita = _visita(esTaller: true);
      enlaces.hayApp = false;
      await montar(tester);

      await tester.tap(find.text('Cómo llegar'));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'No encontramos una app de mapas. Copia la dirección para buscarla.',
        ),
        findsOneWidget,
      );
    });
  });

  group('CA_016_21 contacto del técnico', () {
    testWidgets('CA_016_21 «Llamar» y «WhatsApp» abren el marcador y wa.me', (
      tester,
    ) async {
      visitas.visita = _visita(whatsapp: '55 0000 0002');
      await montar(tester);

      await tester.tap(find.text('Llamar'));
      await tester.tap(find.text('WhatsApp'));
      await tester.pumpAndSettle();

      expect(enlaces.abiertos.map((u) => u.toString()), [
        'tel:5500000001',
        'https://wa.me/525500000002',
      ]);
    });

    testWidgets(
      'CA_016_21 sin contacto público explica que escribirá por chat',
      (tester) async {
        visitas.visita = _visita(telefono: null);
        await montar(tester);

        expect(find.text('Llamar'), findsNothing);
        expect(
          find.text(
            'Este técnico no publicó un teléfono. Podrás escribirle por el chat '
            'cuando esté disponible',
          ),
          findsOneWidget,
        );
      },
    );
  });

  group('CA_016_06 botón de aviso de confianza', () {
    testWidgets('CA_016_06 con puedeAvisar verdadero abre la hoja de la 022', (
      tester,
    ) async {
      visitas.visita = _visita();
      await montar(tester);

      await tester.ensureVisible(find.text('Avisar a alguien de confianza'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Avisar a alguien de confianza'));
      await tester.pumpAndSettle();

      expect(find.text('Avisar a alguien de confianza'), findsNWidgets(2));
      expect(find.text('Cerrar'), findsOneWidget);
    });

    testWidgets('CA_016_06 con puedeAvisar falso no aparece', (tester) async {
      visitas.visita = _visita(puedeAvisar: false);
      await montar(tester);

      expect(find.text('Avisar a alguien de confianza'), findsNothing);
    });

    testWidgets('CA_016_06 sin la hoja de la spec 022 tampoco aparece', (
      tester,
    ) async {
      visitas.visita = _visita();
      await montar(tester, avisoDisponible: false);

      expect(find.text('Avisar a alguien de confianza'), findsNothing);
    });
  });

  group('CA_016_05 y CA_016_15 errores', () {
    testWidgets('CA_016_05 una visita ajena dice que ya no está disponible', (
      tester,
    ) async {
      await montar(tester);

      expect(find.text('Esta visita ya no está disponible.'), findsOneWidget);
    });

    testWidgets('CA_016_15 un error sin copia local ofrece «Reintentar»', (
      tester,
    ) async {
      visitas.falla = const ServicioNoDisponibleFailure();
      await montar(tester);

      expect(find.text('Reintentar'), findsOneWidget);
      visitas
        ..falla = null
        ..visita = _visita();
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();
      expect(find.text('Técnico de prueba'), findsOneWidget);
    });
  });

  test('CA_016_16 cerrar sesión borra todas las visitas guardadas', () async {
    final local = VisitaLocalRepositorySeguro(almacen);
    await local.guardar(VisitaGuardada.de(_visita(), DateTime(2026, 11, 12)));

    await borrarDatosDeVisita(almacen);

    expect(almacen.contenido, isEmpty);
  });

  testWidgets('CA_016_16 una visita terminada borra su copia', (tester) async {
    visitas.visita = _visita();
    final c = await montar(tester);
    expect(await guardada(), isNotNull);

    visitas.visita = _visita(estado: EstadoVisita.terminada);
    await refrescar(tester, c);

    expect(await guardada(), isNull);
  });

  testWidgets('CA_016_14 accesible con texto al 200 %', (tester) async {
    fijarPantalla(tester, escalaDeTexto: 2);
    final semantica = tester.ensureSemantics();
    visitas.visita = _visita(whatsapp: '5500000002');
    await montar(tester);

    await expectAccesible(tester);
    expect(tester.takeException(), isNull);
    semantica.dispose();
  });

  group('Enlaces sin esquemas arbitrarios (R-05)', () {
    test('CA_016_04 el mapa siempre es https de Google Maps', () {
      final uri = Enlaces.mapa('javascript:alert(1)');
      expect(uri.scheme, 'https');
      expect(uri.host, 'www.google.com');
      expect(uri.queryParameters['query'], 'javascript:alert(1)');
    });

    test('CA_016_21 un número sin 10 dígitos no arma enlace', () {
      expect(Enlaces.llamada('123'), isNull);
      expect(Enlaces.whatsapp('abc'), isNull);
    });
  });
}
