import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/preferencias/almacen_preferencias.dart';
import 'package:app/features/actividad/actividad_providers.dart';
import 'package:app/features/actividad/domain/borrador_solicitud.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/domain/selector_de_fotos.dart';
import 'package:app/features/actividad/domain/solicitud.dart';
import 'package:app/features/actividad/domain/solicitud_repository.dart';
import 'package:app/features/actividad/presentation/solicitud_controller.dart';
import 'package:app/features/oficios/oficios.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _electricista = Oficio(
  clave: 'ele',
  nombre: 'Electricidad',
  modalidad: Modalidad.domicilio,
);
const _mecanico = Oficio(
  clave: 'mec',
  nombre: 'Mecánica',
  modalidad: Modalidad.taller,
);

class _Oficios implements OficiosRepository {
  @override
  Future<List<Oficio>> listar() async => [_electricista, _mecanico];
}

class _Repo implements SolicitudRepository {
  int creadas = 0;
  int subidas = 0;
  SolicitudNueva? ultima;
  Completer<void>? detener;
  Failure? fallar;

  @override
  Future<String> subirFoto(String ruta) async => 'archivo-${++subidas}';

  @override
  Future<Solicitud> crear(SolicitudNueva nueva) async {
    creadas++;
    ultima = nueva;
    await detener?.future;
    if (fallar != null) throw fallar!;
    return Solicitud(
      id: 'sol-1',
      estado: EstadoSolicitud.enviada,
      oficioClave: nueva.oficioClave,
      oficioNombre: 'x',
      modalidad: nueva.direccion == null
          ? Modalidad.taller
          : Modalidad.domicilio,
      descripcion: nueva.descripcion,
      fotos: const [],
      dia: nueva.dia,
      franja: nueva.franja,
      creadoEn: DateTime(2026, 11, 11),
    );
  }

  @override
  Future<Solicitud> obtener(String id) => throw const NoEncontradoFailure();
}

class _Selector implements SelectorDeFotos {
  int n = 0;

  @override
  Future<String?> elegir() async => 'foto-${++n}.jpg';
}

final _hoy = DateTime(2026, 11, 11);

ProviderContainer _c(
  _Repo repo, {
  String? colonia = 'col-1',
  AlmacenPreferenciasEnMemoria? almacen,
}) {
  final c = ProviderContainer(
    overrides: [
      solicitudRepositoryProvider.overrideWithValue(repo),
      oficiosRepositoryProvider.overrideWithValue(_Oficios()),
      selectorDeFotosProvider.overrideWithValue(_Selector()),
      coloniaIdSolicitudProvider.overrideWithValue(colonia),
      hoyProvider.overrideWithValue(_hoy),
      if (almacen != null)
        almacenPreferenciasProvider.overrideWithValue(almacen),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

Future<void> _llenar(ProviderContainer c, Oficio oficio) async {
  final n = c.read(solicitudControllerProvider.notifier)
    ..elegirOficio(oficio)
    ..cambiarDescripcion('Se botó la luz en toda la casa');
  await n.agregarFoto();
  n
    ..elegirDia(DateTime(2026, 11, 12))
    ..elegirFranja(Franja.tarde);
  if (oficio.modalidad.esDomicilio) n.cambiarDireccion('Calle Reforma 123');
}

void main() {
  test('CA_015_01 con los tres pasos completos crea la solicitud', () async {
    final repo = _Repo();
    final almacen = AlmacenPreferenciasEnMemoria();
    final c = _c(repo, almacen: almacen);
    await _llenar(c, _electricista);
    await c.read(solicitudControllerProvider.notifier).enviar();

    final estado = c.read(solicitudControllerProvider);
    expect(estado.creada?.estado, EstadoSolicitud.enviada);
    expect(repo.ultima?.coloniaId, 'col-1');
    expect(repo.ultima?.fotos, ['archivo-1']);
    expect(repo.ultima?.dia, DateTime(2026, 11, 12));
    expect(estado.enviando, isFalse);
    expect(almacen.leerBorrador(), isNull, reason: 'el borrador se borra');
  });

  test('CA_015_23 a domicilio lleva dirección y nunca modalidad', () async {
    final repo = _Repo();
    final c = _c(repo);
    await _llenar(c, _electricista);
    await c.read(solicitudControllerProvider.notifier).enviar();
    expect(repo.ultima?.direccion, 'Calle Reforma 123');
    expect(repo.ultima?.oficioClave, 'ele');
  });

  test(
    'CA_015_23 en taller no viaja dirección aunque se hubiera escrito',
    () async {
      final repo = _Repo();
      final c = _c(repo);
      final n = c.read(solicitudControllerProvider.notifier)
        ..elegirOficio(_electricista)
        ..cambiarDireccion('Calle Reforma 123');
      await _llenar(c, _mecanico);
      await n.enviar();
      expect(repo.ultima?.oficioClave, 'mec');
      expect(repo.ultima?.direccion, isNull);
    },
  );

  test(
    'CA_015_06 un segundo toque en pleno envío no manda otra petición',
    () async {
      final repo = _Repo()..detener = Completer<void>();
      final c = _c(repo);
      await _llenar(c, _mecanico);
      final n = c.read(solicitudControllerProvider.notifier);

      final primero = n.enviar();
      await Future<void>.delayed(Duration.zero);
      expect(c.read(solicitudControllerProvider).enviando, isTrue);
      await n.enviar();
      repo.detener!.complete();
      await primero;

      expect(repo.creadas, 1);
    },
  );

  test('CA_015_15 con 429 espera lo indicado y no reintenta solo', () async {
    final repo = _Repo()
      ..fallar = const DemasiadosIntentosFailure(espera: Duration(seconds: 30));
    final c = _c(repo);
    await _llenar(c, _mecanico);
    final n = c.read(solicitudControllerProvider.notifier);
    await n.enviar();

    expect(
      c.read(solicitudControllerProvider).espera,
      const Duration(seconds: 30),
    );
    await n.enviar();
    expect(repo.creadas, 1, reason: 'mientras espera no se vuelve a enviar');
  });

  test(
    'CA_015_22 contenido rechazado conserva texto y fotos y no reintenta',
    () async {
      final repo = _Repo()
        ..fallar = const SolicitudRechazadaFailure(
          MotivoSolicitudRechazada.contenidoRechazado,
        );
      final almacen = AlmacenPreferenciasEnMemoria();
      final c = _c(repo, almacen: almacen);
      await _llenar(c, _mecanico);
      await c.read(solicitudControllerProvider.notifier).enviar();

      final estado = c.read(solicitudControllerProvider);
      expect(estado.error, isA<SolicitudRechazadaFailure>());
      expect(estado.descripcion, 'Se botó la luz en toda la casa');
      expect(estado.rutasDeFotos, hasLength(1));
      expect(estado.paso, 1, reason: 'vuelve al paso 2');
      expect(repo.creadas, 1);
      expect(almacen.leerBorrador(), isNotNull, reason: 'borrador intacto');
    },
  );

  test('CA_015_24 desde un oficio concreto se salta el paso 1', () async {
    final c = _c(_Repo());
    await c
        .read(solicitudControllerProvider.notifier)
        .iniciar(oficioClave: 'mec');
    final estado = c.read(solicitudControllerProvider);
    expect(estado.oficio?.clave, 'mec');
    expect(estado.paso, 1);
  });

  test('CA_015_14 al reabrir recupera lo escrito del borrador', () async {
    final almacen = AlmacenPreferenciasEnMemoria();
    await almacen.guardarBorrador(
      BorradorSolicitud(
        oficioClave: 'ele',
        descripcion: 'Un contacto no funciona',
        rutasDeFotos: const ['a.jpg'],
        franja: Franja.noche,
        actualizadoEn: DateTime.utc(2026, 11, 11),
      ).comoTexto(),
    );
    final c = _c(_Repo(), almacen: almacen);
    await c.read(solicitudControllerProvider.notifier).iniciar();
    final estado = c.read(solicitudControllerProvider);
    expect(estado.descripcion, 'Un contacto no funciona');
    expect(estado.rutasDeFotos, ['a.jpg']);
    expect(estado.franja, Franja.noche);
    expect(estado.oficio?.clave, 'ele');
  });

  test('CA_015_03 la sexta foto se rechaza y el máximo es 5', () async {
    final c = _c(_Repo());
    final n = c.read(solicitudControllerProvider.notifier);
    for (var i = 0; i < 6; i++) {
      await n.agregarFoto();
    }
    final estado = c.read(solicitudControllerProvider);
    expect(estado.rutasDeFotos, hasLength(5));
    expect(estado.errorFotos, isNotNull);
  });

  test(
    'CA_015_02 el paso 2 no avanza con descripción corta o sin foto',
    () async {
      final c = _c(_Repo());
      final n = c.read(solicitudControllerProvider.notifier)
        ..elegirOficio(_mecanico)
        ..cambiarDescripcion('corta')
        ..siguiente();
      expect(c.read(solicitudControllerProvider).paso, 1);
      expect(c.read(solicitudControllerProvider).mostrarErrores, isTrue);
      n
        ..cambiarDescripcion('Descripción suficiente')
        ..siguiente();
      expect(c.read(solicitudControllerProvider).paso, 1, reason: 'sin foto');
      await n.agregarFoto();
      n.siguiente();
      expect(c.read(solicitudControllerProvider).paso, 2);
    },
  );

  test(
    'CA_015_17 a domicilio no envía con dirección de 7 caracteres',
    () async {
      final repo = _Repo();
      final c = _c(repo);
      await _llenar(c, _electricista);
      final n = c.read(solicitudControllerProvider.notifier)
        ..cambiarDireccion('1234567');
      await n.enviar();
      expect(repo.creadas, 0);
      expect(c.read(solicitudControllerProvider).mostrarErrores, isTrue);
    },
  );

  test('CA_015_04 un día fuera de la ventana no se puede elegir', () async {
    final c = _c(_Repo());
    final n = c.read(solicitudControllerProvider.notifier)
      ..elegirDia(DateTime(2026, 11, 20));
    expect(c.read(solicitudControllerProvider).dia, isNull);
    n.elegirDia(DateTime(2026, 11, 16));
    expect(c.read(solicitudControllerProvider).dia, DateTime(2026, 11, 16));
  });

  test('CA_015_01 sin zona guardada no se envía y se avisa', () async {
    final repo = _Repo();
    final c = _c(repo, colonia: null);
    await _llenar(c, _mecanico);
    await c.read(solicitudControllerProvider.notifier).enviar();
    expect(repo.creadas, 0);
    expect(c.read(solicitudControllerProvider).sinZona, isTrue);
  });
}
