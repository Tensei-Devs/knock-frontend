// Spec 045 (enmienda 1, E-06) y spec 015: Actividad de la maqueta muestra las
// solicitudes reales (`GET /solicitudes`) y su detalle al abrirlas; sin sesión
// o sin API no cambia nada; sin datos de ejemplo cuando falla (CA-12).
import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/features/actividad/presentation/solicitudes_reales_controller.dart';
import 'package:app/features/maqueta/estado.dart' show CargaReal, Job, maq;
import 'package:app/features/maqueta/solicitudes_reales.dart';
import 'package:app/features/oficios/oficios.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/preparar_maqueta.dart';
import '../../soporte/solicitud_falsa.dart';

/// `listar` toma la siguiente respuesta; una [Failure] hace fallar.
class _Solicitudes extends SolicitudesFalsas {
  _Solicitudes(this.respuestas);

  final List<Object> respuestas;
  int listados = 0;
  final detallesPedidos = <String>[];
  Failure? falloAlObtener;

  @override
  Future<List<Solicitud>> listar() async {
    final r = respuestas[listados < respuestas.length ? listados : 0];
    listados++;
    if (r is Failure) throw r;
    return r as List<Solicitud>;
  }

  @override
  Future<Solicitud> obtener(String id) async {
    detallesPedidos.add(id);
    if (falloAlObtener != null) throw falloAlObtener!;
    return _solicitud(
      id: id,
      descripcion: 'Gotea la llave del baño desde ayer',
      oficioClave: 'plo',
    );
  }
}

final _idUno = 'a' * 24;
final _idDos = 'b' * 24;

Solicitud _solicitud({
  String? id,
  EstadoSolicitud estado = EstadoSolicitud.enviada,
  String oficio = 'Plomería',
  String? oficioClave,
  String descripcion = '',
  int cotizaciones = 0,
  String? visitaId,
}) => Solicitud(
  id: id ?? _idUno,
  estado: estado,
  oficioNombre: oficio,
  oficioClave: oficioClave,
  coloniaNombre: 'Col. Centro',
  descripcion: descripcion,
  totalFotos: 0,
  dia: DateTime(2026, 11, 12),
  franja: Franja.tarde,
  creadoEn: DateTime(2026, 11, 10),
  totalCotizaciones: cotizaciones,
  visitaId: visitaId,
);

Future<ProviderContainer> _abrir(
  WidgetTester tester,
  _Solicitudes repo, {
  String ruta = '/actividad',
  bool activas = true,
  Size? tamano,
  double escala = 1,
}) async {
  fijarPantalla(tester, tamano: tamano ?? tamanoMovil, escalaDeTexto: escala);
  // Sin el set de ejemplo, que no existe en una sesión real.
  if (activas) maq.resetAll();
  final container = await montarApp(
    tester,
    esTecnico: false,
    maqueta: true,
    extra: [
      solicitudesRealesRepositoryProvider.overrideWithValue(repo),
      solicitudesRealesActivasProvider.overrideWithValue(activas),
      oficiosRepositoryProvider.overrideWithValue(OficiosFalsos()),
    ],
  );
  container.read(appRouterProvider).go(ruta);
  await asentarMaqueta(tester);
  return container;
}

void main() {
  prepararPruebasDeMaqueta();

  group('mapeo del contrato a la maqueta', () {
    test(
      'CA_045_10 cada estado del servidor tiene su estado en la maqueta',
      () {
        const catalogo = {'plomería': 'plo', 'mecánica': 'mec'};
        String estado(EstadoSolicitud e, {String oficio = 'Plomería'}) =>
            jobDeSolicitud(
              _solicitud(estado: e, oficio: oficio),
              catalogo: catalogo,
            )!.status;
        expect(estado(EstadoSolicitud.enviada), 'enviada');
        expect(estado(EstadoSolicitud.cotizando), 'cotizando');
        expect(estado(EstadoSolicitud.citaConfirmada), 'visita');
        expect(
          estado(EstadoSolicitud.citaConfirmada, oficio: 'Mecánica'),
          'cita',
        );
        expect(estado(EstadoSolicitud.terminada), 'terminado');
        expect(estado(EstadoSolicitud.calificada), 'terminado');
        expect(estado(EstadoSolicitud.cancelada), 'cancelado');
        expect(estado(EstadoSolicitud.vencida), 'cancelado');
        expect(estado(EstadoSolicitud.desconocido), 'enviada');
      },
    );

    test('CA_045_10 la solicitud real lleva su id, colonia y preferencia', () {
      final job = jobDeSolicitud(
        _solicitud(estado: EstadoSolicitud.cotizando, cotizaciones: 3),
        catalogo: const {},
      )!;
      expect(job.real, isTrue);
      expect(job.id, _idUno);
      expect(job.cat, 'plo');
      expect(job.colonia, 'Col. Centro');
      expect(job.nQuotes, 3);
      expect(job.pref, contains('jueves 12 de noviembre'));
      expect(job.pref, contains('en la tarde'));
    });

    test('CA_045_10 un oficio que la maqueta no sabe dibujar se omite', () {
      expect(
        jobDeSolicitud(_solicitud(oficio: 'Jardinería'), catalogo: const {}),
        isNull,
      );
    });

    test('CA_045_10 la clave del detalle manda sobre el nombre', () {
      expect(
        jobDeSolicitud(
          _solicitud(oficio: 'Fontanería', oficioClave: 'plo'),
          catalogo: const {},
        )!.cat,
        'plo',
      );
    });
  });

  group('Actividad con solicitudes reales', () {
    testWidgets('CA_045_10 muestra las solicitudes del servidor', (
      tester,
    ) async {
      await _abrir(
        tester,
        _Solicitudes([
          [
            _solicitud(estado: EstadoSolicitud.cotizando, cotizaciones: 2),
            _solicitud(id: _idDos, oficio: 'Mecánica'),
          ],
        ]),
      );
      expect(find.text('Plomería'), findsWidgets);
      expect(find.text('Mecánica'), findsWidgets);
      expect(find.text('2 cotizaciones listas'), findsOneWidget);
      expect(find.text('Esperando cotizaciones'), findsOneWidget);
      expect(find.text('Col. Centro · A domicilio'), findsOneWidget);
      expect(find.text('Ver y elegir'), findsOneWidget);
    });

    testWidgets('CA_045_10 se conservan las simuladas creadas en la sesión', (
      tester,
    ) async {
      final repo = _Solicitudes([
        [_solicitud()],
      ]);
      await _abrir(tester, repo);
      maq.jobs.insert(
        0,
        Job(
          id: 'j99',
          title: 'Foco que parpadea',
          cat: 'ele',
          status: 'enviada',
        ),
      );
      maq.refresh();
      await asentarMaqueta(tester);
      expect(find.text('Foco que parpadea'), findsOneWidget);
      expect(find.text('Plomería'), findsWidgets);
      // Al refrescar las reales no se pierden las simuladas.
      maq.fijarSolicitudesReales(const [], estado: CargaReal.lista);
      expect(maq.job('j99'), isNotNull);
      expect(maq.jobs.where((j) => j.real), isEmpty);
    });

    testWidgets(
      'CA_045_12 sin solicitudes sale el vacío, no datos de ejemplo',
      (tester) async {
        await _abrir(tester, _Solicitudes([<Solicitud>[]]));
        expect(find.text('Aún no tienes actividad'), findsOneWidget);
        expect(find.text('El boiler no enciende'), findsNothing);
      },
    );

    testWidgets('CA_045_12 si falla no se inventan solicitudes y Reintentar '
        'las pide de nuevo', (tester) async {
      final repo = _Solicitudes([
        const ServicioNoDisponibleFailure(),
        [_solicitud()],
      ]);
      await _abrir(tester, repo);
      expect(find.text('No pudimos cargar tus solicitudes.'), findsOneWidget);
      expect(find.text('Aún no tienes actividad'), findsNothing);
      expect(find.text('Plomería'), findsNothing);
      await tester.tap(find.text('Reintentar'));
      await asentarMaqueta(tester);
      expect(find.text('No pudimos cargar tus solicitudes.'), findsNothing);
      expect(find.text('Plomería'), findsWidgets);
      expect(repo.listados, 2);
    });

    testWidgets('CA_045_12 un error no muestra códigos HTTP ni la URL', (
      tester,
    ) async {
      await _abrir(tester, _Solicitudes([const NoAutorizadoFailure()]));
      expect(find.textContaining('401'), findsNothing);
      expect(find.textContaining('http'), findsNothing);
    });

    testWidgets('CA_045_10 sin KNOCK_API_URL no se pide nada y queda la '
        'maqueta de ejemplo', (tester) async {
      final repo = _Solicitudes([
        [_solicitud()],
      ]);
      await _abrir(tester, repo, activas: false);
      expect(repo.listados, 0);
      expect(find.text('El boiler no enciende'), findsOneWidget);
    });

    testWidgets('CA_045_10 una solicitud con cita, terminada o cancelada se '
        'dibuja sin inventar al técnico', (tester) async {
      await _abrir(
        tester,
        _Solicitudes([
          [
            _solicitud(estado: EstadoSolicitud.citaConfirmada),
            _solicitud(id: _idDos, estado: EstadoSolicitud.terminada),
            _solicitud(id: 'c' * 24, estado: EstadoSolicitud.vencida),
            _solicitud(id: 'd' * 24, estado: EstadoSolicitud.cancelada),
          ],
        ]),
      );
      expect(find.text('Visita confirmada'), findsOneWidget);
      expect(find.text('Terminado'), findsOneWidget);
      expect(find.text('Cancelado'), findsNWidgets(2));
      expect(
        find.text('Esta solicitud venció sin que eligieras una cotización.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('CA_045_13 la lista no desborda a 364 dp con letra 1.3', (
      tester,
    ) async {
      await _abrir(
        tester,
        _Solicitudes([
          [
            _solicitud(estado: EstadoSolicitud.cotizando, cotizaciones: 5),
            _solicitud(id: _idDos, oficio: 'Mecánica'),
            _solicitud(
              id: 'c' * 24,
              estado: EstadoSolicitud.cancelada,
              oficio: 'Electricidad',
            ),
          ],
        ]),
        tamano: const Size(364, 810),
        escala: 1.3,
      );
      expect(find.text('Plomería'), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });

  group('regla de activación', () {
    test('CA_045_10 solo hay solicitudes reales con sesión y API válida', () {
      ProviderContainer crear({required bool sesion, required String url}) {
        final c = ProviderContainer(
          overrides: [
            conSesion(iniciada: sesion),
            urlApiProvider.overrideWithValue(url),
          ],
        );
        addTearDown(c.dispose);
        return c;
      }

      expect(
        crear(
          sesion: true,
          url: 'https://api.ejemplo.test',
        ).read(solicitudesRealesActivasProvider),
        isTrue,
      );
      expect(
        crear(
          sesion: false,
          url: 'https://api.ejemplo.test',
        ).read(solicitudesRealesActivasProvider),
        isFalse,
      );
      expect(
        crear(sesion: true, url: '').read(solicitudesRealesActivasProvider),
        isFalse,
      );
    });
  });

  group('detalle al abrir', () {
    testWidgets('CA_045_10 abrir una solicitud real pide su detalle', (
      tester,
    ) async {
      final repo = _Solicitudes([
        [_solicitud()],
      ]);
      await _abrir(tester, repo, ruta: '/m/comparar/$_idUno');
      expect(repo.detallesPedidos, [_idUno]);
      expect(find.text('Gotea la llave del baño desde ayer'), findsOneWidget);
    });

    testWidgets('CA_045_12 si el detalle ya no existe, lo dice sin código', (
      tester,
    ) async {
      final repo = _Solicitudes([
        [_solicitud()],
      ])..falloAlObtener = const NoEncontradoFailure();
      await _abrir(tester, repo, ruta: '/m/comparar/$_idUno');
      expect(
        find.text('Esta solicitud ya no está disponible.'),
        findsOneWidget,
      );
      expect(find.textContaining('404'), findsNothing);
      expect(find.text('Reintentar'), findsNothing);
    });

    testWidgets('CA_045_12 si el detalle falla por red hay Reintentar', (
      tester,
    ) async {
      final repo = _Solicitudes([
        [_solicitud()],
      ])..falloAlObtener = const ServicioNoDisponibleFailure();
      await _abrir(tester, repo, ruta: '/m/comparar/$_idUno');
      expect(find.text('Reintentar'), findsOneWidget);
      repo.falloAlObtener = null;
      await tester.tap(find.text('Reintentar'));
      await asentarMaqueta(tester);
      expect(find.text('Gotea la llave del baño desde ayer'), findsOneWidget);
    });
  });
}
