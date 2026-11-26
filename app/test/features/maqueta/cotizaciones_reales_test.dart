// Spec 045 (enmienda 1, E-06) y spec 015: comparar cotizaciones y elegir en la
// maqueta usan los endpoints reales; el técnico sale como experto sintético,
// sin reseñas inventadas; los errores salen por motivo y sin códigos HTTP.
import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/cotizacion.dart';
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

Solicitud _solicitud() => Solicitud(
  id: _id,
  estado: EstadoSolicitud.cotizando,
  oficioNombre: 'Plomería',
  coloniaNombre: 'Col. Centro',
  descripcion: '',
  totalFotos: 0,
  dia: DateTime(2026, 11, 12),
  franja: Franja.tarde,
  creadoEn: DateTime(2026, 11, 10),
  totalCotizaciones: 2,
);

ResultadoComparacion _comparacion({bool puedeElegir = true}) =>
    ResultadoComparacion(
      cotizaciones: [
        cotizacionDePrueba(
          'c1',
          nombre: 'Rosa Pérez',
          etiquetas: {
            EtiquetaCotizacion.mejorPrecio,
            EtiquetaCotizacion.verificado,
          },
        ),
        cotizacionDePrueba(
          'c2',
          tipo: TipoPrecio.rango,
          nombre: 'Luis Gómez',
          calificacion: null,
          verificado: false,
        ),
      ],
      totalCotizaciones: 2,
      tiposMixtos: false,
      puedeElegir: puedeElegir,
      motivo: puedeElegir ? null : MotivoSinEleccion.yaElegida,
    );

SolicitudesFalsas _repo({ResultadoComparacion? comparacion}) {
  final r = SolicitudesFalsas()
    ..listadas.add(_solicitud())
    ..comparacion = comparacion ?? _comparacion();
  return r;
}

/// Abre Actividad con la solicitud real y entra a «Ver y elegir».
Future<void> _abrirComparar(
  WidgetTester tester,
  SolicitudesFalsas repo, {
  Size? tamano,
  double escala = 1,
  VisitaRepository? visitas,
}) async {
  fijarPantalla(tester, tamano: tamano ?? tamanoMovil, escalaDeTexto: escala);
  maq.resetAll();
  final container = await montarApp(
    tester,
    esTecnico: false,
    maqueta: true,
    extra: [
      solicitudesRealesRepositoryProvider.overrideWithValue(repo),
      if (visitas != null)
        visitasRealesRepositoryProvider.overrideWithValue(visitas),
      solicitudesRealesActivasProvider.overrideWithValue(true),
      oficiosRepositoryProvider.overrideWithValue(OficiosFalsos()),
      intervaloRefrescoSolicitudProvider.overrideWithValue(null),
    ],
  );
  container.read(appRouterProvider).go('/actividad');
  await asentarMaqueta(tester);
  await tester.tap(find.text('Ver y elegir'));
  await asentarMaqueta(tester);
}

Future<void> _elegirAPrimero(WidgetTester tester) async {
  await tester.tap(find.text('Elegir a Rosa'));
  await asentarMaqueta(tester);
}

void main() {
  prepararPruebasDeMaqueta(
    alTerminar: () => provs.removeWhere((k, _) => k.startsWith('api:')),
  );

  group('comparar', () {
    testWidgets('CA_045_10 muestra las cotizaciones que manda el servidor', (
      tester,
    ) async {
      final repo = _repo();
      await _abrirComparar(tester, repo);
      expect(find.text('Rosa Pérez'), findsOneWidget);
      expect(find.text('Luis Gómez'), findsOneWidget);
      expect(find.text('2 recibidas'), findsOneWidget);
      expect(
        find.textContaining('Arreglo completo, mano de obra'),
        findsWidgets,
      );
      expect(find.text('Mejor precio'), findsOneWidget);
      expect(find.text('Verificado'), findsOneWidget);
      expect(find.text('Sin calificaciones aún'), findsOneWidget);
      expect(find.text('★ 4.5'), findsOneWidget);
      expect(repo.ordenesPedidos, [OrdenCotizaciones.recomendadas]);
    });

    testWidgets('CA_045_10 el técnico es un experto sintético sin reseñas', (
      tester,
    ) async {
      await _abrirComparar(tester, _repo());
      final p = provs['api:tc1']!;
      expect(p.name, 'Rosa Pérez');
      expect(p.esReal, isTrue);
      expect(p.n, 0);
      expect(p.revs, isEmpty);
      expect(p.about, isEmpty);
      // No aparece en búsquedas ni tiene perfil que abrir.
      maq.sCat = 'plo';
      expect(maq.results().any((o) => o.esReal), isFalse);
      expect(find.text('Preguntar'), findsNothing);
    });

    testWidgets('CA_045_10 cambiar el orden lo pide de nuevo al servidor', (
      tester,
    ) async {
      final repo = _repo();
      await _abrirComparar(tester, repo);
      await tester.tap(find.text('Menor precio'));
      await asentarMaqueta(tester);
      expect(repo.ordenesPedidos, [
        OrdenCotizaciones.recomendadas,
        OrdenCotizaciones.precio,
      ]);
    });

    testWidgets('CA_045_12 si ya se eligió no se puede elegir otra', (
      tester,
    ) async {
      await _abrirComparar(
        tester,
        _repo(comparacion: _comparacion(puedeElegir: false)),
      );
      expect(
        find.text('Ya elegiste una cotización para esta solicitud.'),
        findsOneWidget,
      );
      final boton = tester.widget<InkWell>(
        find
            .ancestor(
              of: find.text('Elegir a Rosa'),
              matching: find.byType(InkWell),
            )
            .first,
      );
      expect(boton.onTap, isNull);
    });

    testWidgets('CA_045_12 si falla la carga no se inventan cotizaciones', (
      tester,
    ) async {
      final repo = _repo();
      fijarPantalla(tester, tamano: tamanoMovil);
      maq.resetAll();
      final container = await montarApp(
        tester,
        esTecnico: false,
        maqueta: true,
        extra: [
          solicitudesRealesRepositoryProvider.overrideWithValue(
            _CotizacionesQueFallan(repo),
          ),
          solicitudesRealesActivasProvider.overrideWithValue(true),
          oficiosRepositoryProvider.overrideWithValue(OficiosFalsos()),
        ],
      );
      container.read(appRouterProvider).go('/actividad');
      await asentarMaqueta(tester);
      await tester.tap(find.text('Ver y elegir'));
      await asentarMaqueta(tester);
      expect(find.text('Rosa Pérez'), findsNothing);
      expect(
        find.text(
          'No pudimos conectar. Revisa tu conexión e inténtalo de nuevo.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('503'), findsNothing);
      await tester.tap(find.text('Reintentar'));
      await asentarMaqueta(tester);
      expect(find.text('Rosa Pérez'), findsOneWidget);
    });
  });

  group('elegir', () {
    testWidgets(
      'CA_015_20 muestra la visita recuperada sin atribuir cotización',
      (tester) async {
        final repo = _repo();
        await _abrirComparar(tester, repo, visitas: _VisitaExistente());
        await _elegirAPrimero(tester);
        repo
          ..fallasAlElegir.add(
            const EleccionRechazadaFailure(MotivoEleccionRechazada.yaElegida),
          )
          ..comparacion = const ResultadoComparacion(
            cotizaciones: [],
            totalCotizaciones: 1,
            tiposMixtos: false,
            puedeElegir: false,
            motivo: MotivoSinEleccion.yaElegida,
            visitaId: 'v1',
          );
        await tester.tap(find.text('Sí, elegir a Rosa'));
        await asentarMaqueta(tester);
        expect(find.text('Cita existente'), findsOneWidget);
        expect(find.text('Técnico existente'), findsOneWidget);
        expect(find.text('Cita confirmada'), findsNothing);
        expect(repo.elecciones, hasLength(1));
      },
    );

    testWidgets('CA_045_10 elegir confirma y muestra la cita con el contacto', (
      tester,
    ) async {
      final repo = _repo();
      await _abrirComparar(tester, repo);
      await _elegirAPrimero(tester);
      expect(find.text('¿Elegir a Rosa?'), findsOneWidget);
      await tester.tap(find.text('Sí, elegir a Rosa'));
      await asentarMaqueta(tester);
      expect(repo.elecciones, [(_id, 'c1')]);
      expect(find.text('Cita confirmada'), findsOneWidget);
      expect(find.text('Teléfono: 5500000001'), findsOneWidget);
      expect(find.text('Calle de Prueba 123'), findsOneWidget);
    });

    testWidgets('CA_045_10 sin contacto público lo dice y no inventa uno', (
      tester,
    ) async {
      final repo = _repo()
        ..citaAlElegir = citaDePrueba(cotizacionId: 'c1', telefono: null);
      await _abrirComparar(tester, repo);
      await _elegirAPrimero(tester);
      await tester.tap(find.text('Sí, elegir a Rosa'));
      await asentarMaqueta(tester);
      expect(
        find.text('Este técnico no publicó un teléfono ni WhatsApp.'),
        findsOneWidget,
      );
    });

    testWidgets('CA_045_10 un segundo toque mientras se elige no repite', (
      tester,
    ) async {
      final espera = Completer<void>();
      final repo = _repo()..retrasoAlElegir = espera.future;
      await _abrirComparar(tester, repo);
      await _elegirAPrimero(tester);
      await tester.tap(find.text('Sí, elegir a Rosa'));
      await tester.pump();
      await tester.tap(find.text('Sí, elegir a Rosa'), warnIfMissed: false);
      await tester.pump();
      expect(repo.elecciones, hasLength(1));
      espera.complete();
      await asentarMaqueta(tester);
      expect(repo.elecciones, hasLength(1));
      expect(find.text('Cita confirmada'), findsOneWidget);
    });

    for (final (motivo, texto) in [
      (
        MotivoEleccionRechazada.yaElegida,
        'Ya elegiste una cotización para esta solicitud.',
      ),
      (
        MotivoEleccionRechazada.cotizacionNoDisponible,
        'Esta cotización ya no está disponible. Elige otra.',
      ),
      (
        MotivoEleccionRechazada.vencida,
        'Esta solicitud venció. Puedes pedir una nueva.',
      ),
      (MotivoEleccionRechazada.cancelada, 'Esta solicitud se canceló.'),
    ]) {
      testWidgets('CA_045_12 un 409 por $motivo sale con su texto, sin '
          'reintento ni códigos', (tester) async {
        final repo = _repo()
          ..fallasAlElegir.add(EleccionRechazadaFailure(motivo));
        await _abrirComparar(tester, repo);
        await _elegirAPrimero(tester);
        await tester.tap(find.text('Sí, elegir a Rosa'));
        await asentarMaqueta(tester);
        expect(find.text(texto), findsWidgets);
        expect(find.textContaining('409'), findsNothing);
        expect(find.text('Reintentar'), findsNothing);
        expect(repo.elecciones, hasLength(1));
      });
    }

    testWidgets('CA_045_12 un 503 se puede reintentar a mano', (tester) async {
      final repo = _repo()
        ..fallasAlElegir.add(const ServicioNoDisponibleFailure());
      await _abrirComparar(tester, repo);
      await _elegirAPrimero(tester);
      await tester.tap(find.text('Sí, elegir a Rosa'));
      await asentarMaqueta(tester);
      expect(
        find.text(
          'No pudimos conectar. Revisa tu conexión e inténtalo de nuevo.',
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Reintentar'));
      await asentarMaqueta(tester);
      expect(repo.elecciones, hasLength(2));
      expect(find.text('Cita confirmada'), findsOneWidget);
    });
  });

  group('sin desbordes', () {
    for (final (nombre, tamano, escala) in const [
      ('320×640', Size(320, 640), 1.0),
      ('364×810 letra 1.3', Size(364, 810), 1.3),
      ('412×892', Size(412, 892), 1.0),
    ]) {
      testWidgets('CA_045_13 comparar y la hoja de elegir a $nombre', (
        tester,
      ) async {
        await _abrirComparar(tester, _repo(), tamano: tamano, escala: escala);
        expect(find.text('Rosa Pérez'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(find.text('Elegir a Rosa'));
        await tester.tap(find.text('Elegir a Rosa'));
        await asentarMaqueta(tester);
        await tester.tap(find.text('Sí, elegir a Rosa'));
        await asentarMaqueta(tester);
        expect(find.text('Cita confirmada'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });
}

/// Las cotizaciones fallan la primera vez; la lista y el detalle funcionan.
class _VisitaExistente implements VisitaRepository {
  @override
  Future<Visita> obtenerVisita(String id) async => Visita(
    id: 'v1',
    estado: EstadoVisita.confirmada,
    esTaller: false,
    dia: DateTime(2026, 11, 20),
    hora: '10:00',
    tecnico: const TecnicoDeVisita(
      nombre: 'Técnico existente',
      verificado: true,
    ),
    direccion: 'Dirección ficticia',
    puedeAvisar: true,
    tope: 100,
  );
}

class _CotizacionesQueFallan extends SolicitudesFalsas {
  _CotizacionesQueFallan(this.base) {
    listadas.addAll(base.listadas);
  }

  final SolicitudesFalsas base;
  var _intentos = 0;

  @override
  Future<ResultadoComparacion> cotizaciones(
    String solicitudId, {
    OrdenCotizaciones orden = OrdenCotizaciones.recomendadas,
  }) async {
    _intentos++;
    if (_intentos == 1) throw const ServicioNoDisponibleFailure();
    return base.cotizaciones(solicitudId, orden: orden);
  }
}
