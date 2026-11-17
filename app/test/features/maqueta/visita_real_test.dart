// Spec 045 (enmienda 1, E-06), spec 016 y spec 022: la visita, la cita y el aviso
// de confianza de la maqueta usan los endpoints reales. El código solo sale
// cuando el servidor lo manda (nunca un «0000» inventado), el aviso lo escribe
// el servidor sin código ni dirección y los errores salen sin códigos HTTP.
import 'package:app/core/enlaces/abridor_de_enlaces.dart';
import 'package:app/core/errores/failure.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/aviso.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/features/actividad/domain/visita.dart';
import 'package:app/features/actividad/presentation/solicitudes_reales_controller.dart';
import 'package:app/features/maqueta/datos.dart';
import 'package:app/features/maqueta/estado.dart' show maq;
import 'package:app/features/oficios/oficios.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/preparar_maqueta.dart';
import '../../soporte/solicitud_falsa.dart';

final _id = 'b' * 24;
const _visitaId = 'c1c1c1c1c1c1c1c1c1c1c1c1';

class _VisitasFalsas implements VisitaRepository, AvisoRepository {
  /// Cada `obtenerVisita` toma la siguiente respuesta; una excepción falla.
  final List<Object> respuestas;
  _VisitasFalsas(this.respuestas);

  int visitasPedidas = 0;
  int avisosPedidos = 0;
  Object aviso = const MensajeAviso(
    texto: 'Hoy me visita Ricardo Mendoza entre 16:00 y 18:00.',
    incluyeCodigo: false,
    incluyeDireccion: false,
  );

  @override
  Future<Visita> obtenerVisita(String id) async {
    final r =
        respuestas[visitasPedidas < respuestas.length
            ? visitasPedidas
            : respuestas.length - 1];
    visitasPedidas++;
    if (r is Failure) throw r;
    return r as Visita;
  }

  @override
  Future<MensajeAviso> pedirAviso(String visitaId) async {
    avisosPedidos++;
    final a = aviso;
    if (a is Failure) throw a;
    return a as MensajeAviso;
  }
}

class _EnlacesFalsos implements AbridorDeEnlaces {
  final abiertos = <Uri>[];

  @override
  Future<bool> abrir(Uri direccion) async {
    abiertos.add(direccion);
    return true;
  }
}

Visita _visita({
  bool taller = false,
  String? codigo = '4821',
  MotivoCodigo? motivo,
  String direccion = 'Calle 5 #10, Col. Centro',
}) => Visita(
  id: _visitaId,
  estado: EstadoVisita.confirmada,
  esTaller: taller,
  dia: DateTime(2026, 11, 20),
  hora: '16:00 a 18:00',
  tecnico: const TecnicoDeVisita(
    nombre: 'Ricardo Mendoza',
    verificado: true,
    telefono: '+527711234567',
  ),
  direccion: direccion,
  codigo: codigo,
  motivoCodigo: motivo,
  puedeAvisar: true,
  precio: 450,
  tope: 500,
);

Solicitud _solicitud({String clave = 'plo', String nombre = 'Plomería'}) =>
    Solicitud(
      id: _id,
      estado: EstadoSolicitud.citaConfirmada,
      oficioNombre: nombre,
      oficioClave: clave,
      coloniaNombre: 'Col. Centro',
      descripcion: '',
      totalFotos: 0,
      dia: DateTime(2026, 11, 12),
      franja: Franja.tarde,
      creadoEn: DateTime(2026, 11, 10),
      totalCotizaciones: 1,
      visitaId: _visitaId,
    );

Future<void> _abrir(
  WidgetTester tester,
  _VisitasFalsas visitas, {
  Solicitud? solicitud,
  String boton = 'Ver visita y código',
  _EnlacesFalsos? enlaces,
  Size? tamano,
  double escala = 1,
}) async {
  fijarPantalla(tester, tamano: tamano ?? tamanoMovil, escalaDeTexto: escala);
  maq.resetAll();
  // Los pliegues son estado global de la maqueta: cada prueba parte cerrada.
  maq.fold.clear();
  final repo = SolicitudesFalsas()..listadas.add(solicitud ?? _solicitud());
  final container = await montarApp(
    tester,
    esTecnico: false,
    maqueta: true,
    extra: [
      solicitudesRealesRepositoryProvider.overrideWithValue(repo),
      solicitudesRealesActivasProvider.overrideWithValue(true),
      visitasRealesRepositoryProvider.overrideWithValue(visitas),
      avisosRealesRepositoryProvider.overrideWithValue(visitas),
      abridorDeEnlacesProvider.overrideWithValue(enlaces ?? _EnlacesFalsos()),
      oficiosRepositoryProvider.overrideWithValue(OficiosFalsos()),
      intervaloRefrescoSolicitudProvider.overrideWithValue(null),
    ],
  );
  container.read(appRouterProvider).go('/actividad');
  await asentarMaqueta(tester);
  await tester.tap(find.text(boton));
  await asentarMaqueta(tester);
}

/// Abre un pliegue de la pantalla (vienen cerrados y pueden quedar fuera de
/// la vista).
Future<void> _abrirPliegue(WidgetTester tester, String titulo) async {
  await tester.ensureVisible(find.text(titulo));
  await tester.tap(find.text(titulo));
  await asentarMaqueta(tester);
}

void main() {
  prepararPruebasDeMaqueta(
    alTerminar: () => provs.removeWhere((k, _) => k.startsWith('api:')),
  );

  group('visita a domicilio', () {
    testWidgets(
      'CA_045_10 muestra el código y los datos que manda el servidor',
      (tester) async {
        final visitas = _VisitasFalsas([_visita()]);
        await _abrir(tester, visitas);
        expect(visitas.visitasPedidas, 1);
        expect(find.text('Tu código para cuando llegue'), findsOneWidget);
        for (final d in ['4', '8', '2', '1']) {
          expect(find.text(d), findsWidgets);
        }
        expect(find.text('Ricardo Mendoza'), findsOneWidget);
        await _abrirPliegue(tester, 'Detalles de la visita');
        expect(find.text('Cotización: \$450'), findsOneWidget);
        expect(
          find.text('Calle 5 #10, Col. Centro'),
          findsOneWidget,
          reason: 'la dirección es la del servidor, no la simulada',
        );
      },
    );

    testWidgets('CA_045_10 sin código no se inventa un «0000»', (tester) async {
      final visitas = _VisitasFalsas([
        _visita(codigo: null, motivo: MotivoCodigo.vencido),
      ]);
      await _abrir(tester, visitas);
      expect(find.text('Tu código venció.'), findsOneWidget);
      expect(find.text('Tu código para cuando llegue'), findsNothing);
      expect(find.text('0'), findsNothing);
    });

    testWidgets('CA_045_10 una visita real no ofrece reprogramar ni cancelar', (
      tester,
    ) async {
      await _abrir(tester, _VisitasFalsas([_visita()]));
      expect(find.text('Cancelar el servicio'), findsNothing);
      expect(find.textContaining('Cambiar el día'), findsNothing);
    });

    testWidgets('CA_045_12 si falla no hay datos inventados y Reintentar '
        'la pide de nuevo', (tester) async {
      final visitas = _VisitasFalsas([
        const ServicioNoDisponibleFailure(),
        _visita(),
      ]);
      await _abrir(tester, visitas);
      expect(
        find.text(
          'No pudimos conectar. Revisa tu conexión e inténtalo de nuevo.',
        ),
        findsOneWidget,
      );
      expect(find.text('Tu código para cuando llegue'), findsNothing);
      await tester.tap(find.text('Reintentar'));
      await asentarMaqueta(tester);
      expect(find.text('Tu código para cuando llegue'), findsOneWidget);
      expect(visitas.visitasPedidas, 2);
    });

    testWidgets('CA_045_12 una visita que ya no existe lo dice sin código', (
      tester,
    ) async {
      await _abrir(tester, _VisitasFalsas([const NoEncontradoFailure()]));
      expect(
        find.text('Esta solicitud ya no está disponible.'),
        findsOneWidget,
      );
      expect(find.text('Reintentar'), findsNothing);
    });

    for (final (nombre, tamano, escala) in [
      ('320×640', const Size(320, 640), 1.0),
      ('364×810', const Size(364, 810), 1.0),
      ('360×740 con letra grande', const Size(360, 740), 1.3),
    ]) {
      testWidgets('CA_045_13 $nombre: la visita real no desborda', (
        tester,
      ) async {
        await _abrir(
          tester,
          _VisitasFalsas([_visita()]),
          tamano: tamano,
          escala: escala,
        );
        expect(find.text('Tu código para cuando llegue'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('cita en taller', () {
    testWidgets('CA_045_10 muestra el día, la hora y la dirección del taller', (
      tester,
    ) async {
      final visitas = _VisitasFalsas([
        _visita(taller: true, codigo: null, direccion: 'Av. Hidalgo 12'),
      ]);
      await _abrir(
        tester,
        visitas,
        solicitud: _solicitud(clave: 'mec', nombre: 'Mecánica'),
        boton: 'Ver cita y cómo llegar',
      );
      expect(find.text('Cita confirmada'), findsOneWidget);
      expect(find.text('Ricardo Mendoza'), findsOneWidget);
      expect(find.text('Av. Hidalgo 12'), findsOneWidget);
      expect(find.textContaining('16:00 a 18:00'), findsWidgets);
      expect(
        find.textContaining(' km'),
        findsNothing,
        reason: 'no se inventa la distancia',
      );
      expect(find.text('Cancelar el servicio'), findsNothing);
    });
  });

  group('aviso de confianza', () {
    Future<void> abrirAviso(
      WidgetTester tester,
      _VisitasFalsas visitas, {
      _EnlacesFalsos? enlaces,
    }) async {
      await _abrir(tester, visitas, enlaces: enlaces);
      maq.contacts.clear();
      maq.addContact('Mamá', '771 234 5678');
      maq.refresh();
      await _abrirPliegue(tester, 'Más opciones');
      await tester.ensureVisible(find.text('Avisar a alguien de confianza'));
      await tester.tap(find.text('Avisar a alguien de confianza'));
      await asentarMaqueta(tester);
    }

    testWidgets('CA_045_10 el texto lo escribe el servidor y no lleva el '
        'código ni la dirección', (tester) async {
      final visitas = _VisitasFalsas([_visita()]);
      await abrirAviso(tester, visitas);
      expect(visitas.avisosPedidos, 1);
      expect(
        find.text('Hoy me visita Ricardo Mendoza entre 16:00 y 18:00.'),
        findsOneWidget,
      );
      expect(find.textContaining('4821'), findsNothing);
      expect(find.textContaining('Calle 5'), findsNothing);
    });

    testWidgets('CA_045_10 enviar abre WhatsApp con el texto del servidor', (
      tester,
    ) async {
      final enlaces = _EnlacesFalsos();
      await abrirAviso(tester, _VisitasFalsas([_visita()]), enlaces: enlaces);
      await tester.tap(find.text('Enviar por WhatsApp'));
      await asentarMaqueta(tester);
      expect(enlaces.abiertos, hasLength(1));
      final uri = enlaces.abiertos.single;
      expect(uri.host, 'wa.me');
      expect(uri.path, '/527712345678');
      expect(uri.queryParameters['text'], contains('Ricardo Mendoza'));
      expect(uri.toString(), isNot(contains('4821')));
    });

    testWidgets('CA_045_12 si la visita ya no permite avisar, lo dice', (
      tester,
    ) async {
      final visitas = _VisitasFalsas([_visita()])
        ..aviso = const AvisoNoPermitidoFailure();
      await abrirAviso(tester, visitas);
      expect(
        find.text('Ya no se puede avisar de esta visita.'),
        findsOneWidget,
      );
      expect(find.text('Reintentar'), findsNothing);
    });
  });
}
