import 'package:app/core/errores/failure.dart';
import 'package:app/core/plataforma/compartir.dart';
import 'package:app/core/plataforma/enlaces.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/tema/tema.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/data/aviso_local_repository.dart';
import 'package:app/features/actividad/domain/aviso.dart';
import 'package:app/features/actividad/presentation/widgets/hoja_avisar.dart';
import 'package:app/features/cuenta/presentation/contactos_confianza_screen.dart';
import 'package:app/l10n/generado/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../soporte/accesibilidad.dart';
import '../../../soporte/pantalla_maqueta.dart';

const _visita = 'vvvvvvvvvvvvvvvvvvvvvvvv';
const _textoServidor =
    'Hoy recibo a un técnico de Knock: Técnico de prueba (verificado por '
    'Knock). Le pediré el código en la puerta antes de abrir.';

class _AvisosFalsos implements AvisoRepository {
  var llamadas = 0;
  MensajeAviso mensaje = const MensajeAviso(
    texto: _textoServidor,
    incluyeCodigo: false,
    incluyeDireccion: false,
  );
  Failure? falla;

  @override
  Future<MensajeAviso> pedirAviso(String visitaId) async {
    llamadas++;
    if (falla != null) throw falla!;
    return mensaje;
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

class _CompartirFalso implements CompartidorDeTexto {
  final compartidos = <String>[];

  @override
  Future<void> compartir(String texto) async => compartidos.add(texto);
}

void main() {
  late _AvisosFalsos avisos;
  late _EnlacesFalsos enlaces;
  late _CompartirFalso compartir;
  late AlmacenSeguroEnMemoria almacen;

  setUp(() {
    avisos = _AvisosFalsos();
    enlaces = _EnlacesFalsos();
    compartir = _CompartirFalso();
    almacen = AlmacenSeguroEnMemoria();
  });

  Future<void> montar(WidgetTester tester, Widget hijo) async {
    final contenedor = ProviderContainer(
      overrides: [
        avisoRepositoryProvider.overrideWithValue(avisos),
        abridorDeEnlacesProvider.overrideWithValue(enlaces),
        compartidorDeTextoProvider.overrideWithValue(compartir),
        contactosConfianzaRepositoryProvider.overrideWithValue(
          ContactosConfianzaSeguros(almacen),
        ),
        respaldoAvisoRepositoryProvider.overrideWithValue(
          RespaldoAvisoSeguro(almacen),
        ),
        relojSolicitudProvider.overrideWithValue(() => DateTime(2026, 11, 14)),
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
          home: Scaffold(body: hijo),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> conContacto() => ContactosConfianzaSeguros(almacen).guardar(
    const ContactoConfianza(id: '1', nombre: 'Mamá', celular: '5500000001'),
  );

  Future<void> tocar(WidgetTester tester, String texto) async {
    await tester.ensureVisible(find.text(texto));
    await tester.pumpAndSettle();
    await tester.tap(find.text(texto));
    await tester.pumpAndSettle();
  }

  group('CA_022_01 vista previa con el texto del servidor', () {
    testWidgets('CA_022_01 pide el texto una vez y lo muestra tal cual', (
      tester,
    ) async {
      await conContacto();
      await montar(tester, const HojaAvisar(visitaId: _visita));

      expect(avisos.llamadas, 1);
      expect(find.text(_textoServidor), findsOneWidget);
      expect(find.text('Mamá'), findsOneWidget);
    });

    testWidgets('CA_022_09 «Enviar por SMS» abre sms: con número y texto', (
      tester,
    ) async {
      await conContacto();
      await montar(tester, const HojaAvisar(visitaId: _visita));

      await tocar(tester, 'Mamá');
      await tocar(tester, 'Enviar por SMS');

      expect(
        enlaces.abiertos.single.toString(),
        'sms:5500000001?body=${Uri.encodeComponent(_textoServidor)}',
      );
    });

    testWidgets('CA_022_10 sin WhatsApp se abre la hoja de compartir', (
      tester,
    ) async {
      await conContacto();
      enlaces.hayApp = false;
      await montar(tester, const HojaAvisar(visitaId: _visita));

      await tocar(tester, 'Mamá');
      await tocar(tester, 'Enviar por WhatsApp');

      expect(enlaces.abiertos.single.host, 'wa.me');
      expect(compartir.compartidos, [_textoServidor]);
    });

    testWidgets('CA_022_09 sin contacto elegido no se puede enviar', (
      tester,
    ) async {
      await conContacto();
      await montar(tester, const HojaAvisar(visitaId: _visita));

      await tocar(tester, 'Enviar por SMS');

      expect(enlaces.abiertos, isEmpty);
    });
  });

  testWidgets('CA_022_12 «Compartir sin guardar» no guarda nada', (
    tester,
  ) async {
    await montar(tester, const HojaAvisar(visitaId: _visita));

    await tocar(tester, 'Compartir sin guardar');

    expect(compartir.compartidos, [_textoServidor]);
    expect(almacen.contenido, isEmpty);
  });

  group('CA_022_15 y CA_022_16 sin texto del servidor', () {
    Future<void> conRespaldo() => RespaldoAvisoSeguro(almacen).guardar(
      _visita,
      DatosAvisoLocal(
        tecnicoNombre: 'Técnico de prueba',
        tecnicoVerificado: true,
        dia: DateTime(2026, 11, 14),
        hora: '10:30',
      ),
    );

    testWidgets('CA_022_16 sin conexión usa el respaldo y no bloquea', (
      tester,
    ) async {
      await conRespaldo();
      avisos.falla = const ServicioNoDisponibleFailure();
      await montar(tester, const HojaAvisar(visitaId: _visita));

      expect(
        find.text(
          'No pudimos registrar el aviso; puedes enviarlo de todos modos',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Le pediré el código en la puerta'),
        findsOneWidget,
      );
      expect(find.text('Compartir sin guardar'), findsOneWidget);
    });

    testWidgets('CA_022_15 si el servidor dice traer el código, no se usa', (
      tester,
    ) async {
      await conRespaldo();
      avisos.mensaje = const MensajeAviso(
        texto: 'Código 4821',
        incluyeCodigo: true,
        incluyeDireccion: false,
      );
      await montar(tester, const HojaAvisar(visitaId: _visita));

      expect(find.textContaining('4821'), findsNothing);
      expect(
        find.textContaining('Le pediré el código en la puerta'),
        findsOneWidget,
      );
    });

    testWidgets('CA_022_16 con 409 no se ofrece ningún canal', (tester) async {
      await conRespaldo();
      avisos.falla = const ConflictoFailure();
      await montar(tester, const HojaAvisar(visitaId: _visita));

      expect(find.text('Esta visita ya no permite avisos'), findsOneWidget);
      expect(find.text('Compartir sin guardar'), findsNothing);
      expect(find.text('Enviar por SMS'), findsNothing);
    });
  });

  testWidgets('CA_022_17 la hoja es accesible con texto al 200 %', (
    tester,
  ) async {
    fijarPantalla(tester, escalaDeTexto: 2);
    final semantica = tester.ensureSemantics();
    await conContacto();
    await montar(tester, const HojaAvisar(visitaId: _visita));

    await expectAccesible(tester);
    expect(tester.takeException(), isNull);
    semantica.dispose();
  });

  group('CA_022_14 contactos desde Mi cuenta', () {
    testWidgets('CA_022_14 agregar, ver la privacidad y borrar', (
      tester,
    ) async {
      await montar(tester, const ContactosConfianzaScreen());
      expect(
        find.text(
          'Agrega a alguien de confianza para avisarle cuando tengas una visita',
        ),
        findsOneWidget,
      );
      expect(
        find.text('Tus contactos se guardan solo en este teléfono'),
        findsOneWidget,
      );

      await tocar(tester, 'Agregar contacto');
      await tester.enterText(find.byType(TextField).at(0), 'Mamá');
      await tester.enterText(find.byType(TextField).at(1), '5500000001');
      await tocar(tester, 'Guardar');

      expect(find.text('Mamá'), findsOneWidget);
      expect(almacen.contenido.values.join(), contains('5500000001'));

      await tester.tap(find.byTooltip('Borrar a Mamá'));
      await tester.pumpAndSettle();
      expect(find.text('Mamá'), findsNothing);
      expect(almacen.contenido, isEmpty);
    });

    testWidgets('CA_022_05 el formulario muestra el error y no guarda', (
      tester,
    ) async {
      await montar(tester, const ContactosConfianzaScreen());

      await tocar(tester, 'Agregar contacto');
      await tester.enterText(find.byType(TextField).at(0), 'A');
      await tester.enterText(find.byType(TextField).at(1), '55');
      await tocar(tester, 'Guardar');

      expect(
        find.text('Escribe un nombre de 2 a 40 caracteres'),
        findsOneWidget,
      );
      expect(almacen.contenido, isEmpty);
    });
  });
}
