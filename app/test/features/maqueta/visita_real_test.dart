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
import 'package:app/features/visita/visita.dart';
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

class _AccionesFalsas implements AccionesVisitaRepository {
  final llamadas = <String>[];
  Failure? falla;
  bool tardia = false;

  void _anotar(String llamada) {
    llamadas.add(llamada);
    if (falla case final f?) throw f;
  }

  @override
  Future<VisitaCancelada> cancelar(String visitaId, String motivo) async {
    _anotar('cancelar $motivo');
    return VisitaCancelada(estado: 'cancelada', tardia: tardia);
  }

  @override
  Future<PropuestaDeFecha> reprogramar(String visitaId, DateTime f) async {
    _anotar('reprogramar ${f.hour}:00');
    return PropuestaDeFecha(fechaHora: f, propuestaPor: 'u-1', venceEn: f);
  }

  @override
  Future<String> clienteAusente(String visitaId) => throw UnimplementedError();

  @override
  Future<String> tecnicoAusente(String visitaId) async {
    _anotar('tecnico-ausente $visitaId');
    return 'no_presentado';
  }

  @override
  Future<String> terminar(
    String visitaId, {
    required String descripcion,
    required List<String> fotos,
    String? recomendacion,
  }) => throw UnimplementedError();

  @override
  Future<void> reportarNoTerminado(String visitaId, String texto) async =>
      _anotar('no-terminado $texto');
}

/// Sin cotización final ni ajustes (spec 039).
class _SinPrecio implements PrecioDeVisitaRepository {
  @override
  Future<CotizacionFinal?> cotizacionFinal(String visitaId) async => null;

  @override
  Future<List<AjusteDePrecio>> ajustesPendientes(String visitaId) async => [];

  @override
  Future<void> decidirCotizacionFinal(
    String visitaId, {
    required bool aprueba,
  }) async {}

  @override
  Future<void> decidirAjuste(String ajusteId, {required bool aprueba}) async {}
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
  EstadoVisita estado = EstadoVisita.confirmada,
  bool pendiente = false,
  String direccion = 'Calle 5 #10, Col. Centro',
}) => Visita(
  id: _visitaId,
  estado: estado,
  reprogramacionPendiente: pendiente,
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

Solicitud _solicitud({
  String clave = 'plo',
  String nombre = 'Plomería',
  EstadoSolicitud estado = EstadoSolicitud.citaConfirmada,
}) => Solicitud(
  id: _id,
  estado: estado,
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
  _AccionesFalsas? acciones,
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
      accionesVisitaRepositoryProvider.overrideWithValue(
        acciones ?? _AccionesFalsas(),
      ),
      precioDeVisitaRepositoryProvider.overrideWithValue(_SinPrecio()),
      abridorDeEnlacesProvider.overrideWithValue(enlaces ?? _EnlacesFalsos()),
      oficiosRepositoryProvider.overrideWithValue(OficiosFalsos()),
      intervaloRefrescoSolicitudProvider.overrideWithValue(null),
    ],
  );
  container.read(appRouterProvider).go('/actividad');
  await asentarMaqueta(tester);
  await _tocar(tester, boton);
}

Future<void> _tocar(WidgetTester tester, String texto) async {
  await tester.ensureVisible(find.text(texto));
  await tester.tap(find.text(texto));
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
      expect(find.text('Cancelar el servicio'), findsOneWidget);
    });
  });

  group('acciones del cliente (spec 040)', () {
    testWidgets('CA_040_11 cancela con el motivo elegido y vuelve a '
        'Actividad', (tester) async {
      final acciones = _AccionesFalsas()..tardia = true;
      await _abrir(tester, _VisitasFalsas([_visita()]), acciones: acciones);
      await _tocar(tester, 'Cancelar el servicio');
      await _tocar(tester, 'Sí, cancelar');
      expect(acciones.llamadas, isEmpty, reason: 'el motivo es obligatorio');
      await _tocar(tester, 'Cambié de planes');
      await _tocar(tester, 'Sí, cancelar');
      expect(acciones.llamadas, ['cancelar Cambié de planes']);
      expect(find.textContaining('cancelación tardía'), findsOneWidget);
      expect(find.text('Tu código para cuando llegue'), findsNothing);
    });

    for (final (falla, texto) in <(Failure, String)>[
      (const ConflictoFailure(), 'ya terminó o ya estaba cancelada'),
      (const NoEncontradoFailure(), 'Esta visita ya no está disponible.'),
    ]) {
      testWidgets('CA_040_13 $falla al cancelar: mensaje y se conserva lo '
          'elegido', (tester) async {
        final acciones = _AccionesFalsas()..falla = falla;
        await _abrir(tester, _VisitasFalsas([_visita()]), acciones: acciones);
        await _tocar(tester, 'Cancelar el servicio');
        await _tocar(tester, 'Otro motivo');
        await _tocar(tester, 'Sí, cancelar');
        expect(find.textContaining(texto), findsOneWidget);
        await _tocar(tester, 'Sí, cancelar');
        expect(acciones.llamadas, hasLength(2));
        expect(acciones.llamadas.last, 'cancelar Otro motivo');
      });
    }

    testWidgets('CA_040_05 propone otra fecha y la visita se pide de nuevo', (
      tester,
    ) async {
      final visitas = _VisitasFalsas([_visita(), _visita(pendiente: true)]);
      final acciones = _AccionesFalsas();
      await _abrir(tester, visitas, acciones: acciones);
      await _tocar(tester, 'Reprogramar la cita');
      await _tocar(tester, '12:00');
      await _tocar(tester, 'Enviar cambio');
      expect(acciones.llamadas, ['reprogramar 12:00']);
      expect(visitas.visitasPedidas, 2);
      expect(find.textContaining('esperando respuesta'), findsOneWidget);
      expect(find.text('Reprogramar la cita'), findsNothing);
    });

    testWidgets('CA_040_07 un 409 al reprogramar lo explica', (tester) async {
      final acciones = _AccionesFalsas()..falla = const ConflictoFailure();
      await _abrir(tester, _VisitasFalsas([_visita()]), acciones: acciones);
      await _tocar(tester, 'Reprogramar la cita');
      await _tocar(tester, 'Enviar cambio');
      expect(find.textContaining('ya no se puede reprogramar'), findsOneWidget);
    });

    for (final (estado, cancelar) in [
      (EstadoVisita.enCurso, findsOneWidget),
      (EstadoVisita.cancelada, findsNothing),
    ]) {
      testWidgets('CA_040_28 con la visita ${estado.name} solo ofrece lo que '
          'el servidor acepta', (tester) async {
        await _abrir(tester, _VisitasFalsas([_visita(estado: estado)]));
        expect(find.text('Cancelar el servicio'), cancelar);
        expect(find.text('Reprogramar la cita'), findsNothing);
      });
    }

    Future<void> abrirReporte(
      WidgetTester tester,
      _AccionesFalsas acciones,
    ) async {
      await _abrir(
        tester,
        _VisitasFalsas([_visita()]),
        solicitud: _solicitud(estado: EstadoSolicitud.terminada),
        boton: 'No se terminó el trabajo',
        acciones: acciones,
      );
      await _tocar(tester, 'Enviar reporte');
      expect(acciones.llamadas, isEmpty, reason: 'faltan 8 caracteres');
      await tester.enterText(find.byType(TextField), 'La llave sigue goteando');
      await asentarMaqueta(tester);
      await _tocar(tester, 'Enviar reporte');
    }

    testWidgets('CA_040_20 reporta que no se terminó', (tester) async {
      final acciones = _AccionesFalsas();
      await abrirReporte(tester, acciones);
      expect(acciones.llamadas, ['no-terminado La llave sigue goteando']);
      expect(find.textContaining('Pasa a revisión'), findsOneWidget);
    });

    testWidgets('CA_040_22 fuera de plazo lo dice y conserva el texto', (
      tester,
    ) async {
      await abrirReporte(
        tester,
        _AccionesFalsas()..falla = const ConflictoFailure(),
      );
      expect(find.textContaining('Ya no se puede reportar'), findsOneWidget);
      expect(find.text('La llave sigue goteando'), findsOneWidget);
    });
  });

  group('el técnico no llegó (enmienda 2026-11-26)', () {
    const boton = 'El técnico no llegó';
    const confirmar = 'Sí, el técnico no llegó';

    testWidgets('CA_040_E01 el cliente dueño confirma y la visita queda como '
        'no presentada por el técnico', (tester) async {
      final visitas = _VisitasFalsas([
        _visita(),
        _visita(estado: EstadoVisita.noPresentado),
      ]);
      final acciones = _AccionesFalsas();
      await _abrir(tester, visitas, acciones: acciones);
      await _tocar(tester, boton);
      expect(
        find.textContaining('Úsalo solo si el técnico no llegó'),
        findsOneWidget,
      );
      expect(acciones.llamadas, isEmpty, reason: 'pide confirmación');
      await _tocar(tester, confirmar);
      expect(acciones.llamadas, ['tecnico-ausente $_visitaId']);
      expect(
        find.text('Registramos que el técnico no se presentó.'),
        findsOneWidget,
      );
      expect(visitas.visitasPedidas, 2, reason: 'se vuelve a leer la visita');
      expect(
        find.text('Esta visita quedó como no presentada.'),
        findsOneWidget,
      );
      expect(find.text(boton), findsNothing);
    });

    for (final estado in [EstadoVisita.enCurso, EstadoVisita.cancelada]) {
      testWidgets('CA_040_E01 con la visita ${estado.name} no se ofrece', (
        tester,
      ) async {
        await _abrir(tester, _VisitasFalsas([_visita(estado: estado)]));
        expect(find.text(boton), findsNothing);
      });
    }

    for (final (falla, texto) in <(Failure, String)>[
      (
        const ConflictoFailure(),
        'Ahora no se puede registrar: solo dentro de la ventana de la cita.',
      ),
      (const NoEncontradoFailure(), 'Esta visita ya no está disponible.'),
    ]) {
      testWidgets('CA_040_E02 $falla: mensaje del catálogo y se vuelve a '
          'leer la visita', (tester) async {
        final visitas = _VisitasFalsas([_visita()]);
        final acciones = _AccionesFalsas()..falla = falla;
        await _abrir(tester, visitas, acciones: acciones);
        await _tocar(tester, boton);
        await _tocar(tester, confirmar);
        expect(find.text(texto), findsOneWidget);
        expect(visitas.visitasPedidas, 2);
        expect(acciones.llamadas, hasLength(1));
      });
    }

    testWidgets('CA_040_E02 un 429 usa el mensaje genérico y no vuelve a '
        'leer', (tester) async {
      final visitas = _VisitasFalsas([_visita()]);
      final acciones = _AccionesFalsas()
        ..falla = const DemasiadosIntentosFailure();
      await _abrir(tester, visitas, acciones: acciones);
      await _tocar(tester, boton);
      await _tocar(tester, confirmar);
      expect(find.text(confirmar), findsOneWidget, reason: 'la hoja sigue');
      expect(visitas.visitasPedidas, 1);
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
