import 'dart:async';

import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/domain/borrador_solicitud.dart';
import 'package:app/features/actividad/domain/franja.dart';
import 'package:app/features/actividad/presentation/solicitud_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../soporte/solicitud_falsa.dart';

void main() {
  late SolicitudesFalsas solicitudes;
  late BorradorFalso borrador;
  late ProviderContainer contenedor;

  SolicitudController control() =>
      contenedor.read(solicitudControllerProvider.notifier);
  FormularioSolicitud estado() => contenedor.read(solicitudControllerProvider);

  ProviderContainer crear({String? colonia = 'cccccccccccccccccccccccc'}) {
    final c = ProviderContainer(
      overrides: dobles(
        solicitudes: solicitudes,
        borrador: borrador,
        colonia: colonia,
      ),
    );
    addTearDown(c.dispose);
    // Mantiene vivo el controlador autoDispose durante la prueba.
    c.listen(solicitudControllerProvider, (_, _) {});
    return c;
  }

  /// Llena los tres pasos con datos válidos de plomería a domicilio.
  Future<void> llenarTodo() async {
    await control().iniciar();
    control().elegirOficio(plomeria);
    control().cambiarDescripcion('Gotea la llave del baño');
    await control().tomarFoto();
    control().avanzar();
    control().elegirDia(DateTime(2026, 11, 12));
    control().elegirFranja(Franja.tarde);
    control().cambiarDireccion('Calle Hidalgo 123');
  }

  setUp(() {
    solicitudes = SolicitudesFalsas();
    borrador = BorradorFalso();
    contenedor = crear();
  });

  group('CA_015_01 enviar la solicitud completa', () {
    test(
      'CA_015_01 sube las fotos, crea con la colonia y borra el borrador',
      () async {
        await llenarTodo();

        await control().enviar();

        expect(solicitudes.subidas, ['/privado/fotos/1.jpg']);
        expect(solicitudes.creaciones, hasLength(1));
        final (enviada, _) = solicitudes.creaciones.single;
        expect(enviada.oficioClave, 'plo');
        expect(enviada.descripcion, 'Gotea la llave del baño');
        expect(enviada.archivoIds, ['aaaaaaaaaaaaaaaaaaaaaaa1']);
        expect(enviada.dia, DateTime(2026, 11, 12));
        expect(enviada.franja, Franja.tarde);
        expect(enviada.coloniaId, 'cccccccccccccccccccccccc');
        expect(enviada.direccion, 'Calle Hidalgo 123');
        expect(estado().creada?.id, 'b' * 24);
        expect(borrador.borrados, 1);
      },
    );

    test('CA_015_01 en taller no envía dirección', () async {
      await control().iniciar();
      control().elegirOficio(mecanica);
      control().cambiarDescripcion('Ruido al frenar');
      await control().tomarFoto();
      control().avanzar();
      control().elegirDia(DateTime(2026, 11, 10));
      control().elegirFranja(Franja.manana);

      await control().enviar();

      expect(solicitudes.creaciones.single.$1.direccion, isNull);
    });

    test('CA_015_01 sin zona guardada no envía y lo avisa (R-05)', () async {
      contenedor = crear(colonia: null);
      await llenarTodo();

      await control().enviar();

      expect(solicitudes.creaciones, isEmpty);
      expect(estado().sinZona, isTrue);
    });

    test('CA_015_01 con un paso inválido no envía y muestra errores', () async {
      await llenarTodo();
      control().cambiarDescripcion('corta');

      await control().enviar();

      expect(solicitudes.creaciones, isEmpty);
      expect(estado().mostrarErrores, isTrue);
    });
  });

  group('CA_015_02 y CA_015_03 no se avanza con el paso 2 incompleto', () {
    test('CA_015_02 con 7 caracteres no avanza', () async {
      await control().iniciar();
      control().elegirOficio(plomeria);
      control().cambiarDescripcion('a' * 7);
      await control().tomarFoto();

      control().avanzar();

      expect(estado().paso, PasoSolicitud.descripcion);
      expect(estado().mostrarErrores, isTrue);
    });

    test('CA_015_03 sin fotos no avanza; con una sí', () async {
      await control().iniciar();
      control().elegirOficio(plomeria);
      control().cambiarDescripcion('Gotea la llave del baño');

      control().avanzar();
      expect(estado().paso, PasoSolicitud.descripcion);

      await control().tomarFoto();
      control().avanzar();
      expect(estado().paso, PasoSolicitud.cuandoDonde);
    });

    test('CA_015_03 no se agrega una sexta foto', () async {
      await control().iniciar();
      control().elegirOficio(plomeria);
      await control().elegirFotos();
      expect(estado().fotos, hasLength(5));

      await control().tomarFoto();

      expect(estado().fotos, hasLength(5));
      expect(borrador.fotosAgregadas, 5);
    });

    test(
      'CA_015_03 una foto no válida muestra el error y no se agrega',
      () async {
        borrador.rechazarFotos = true;
        await control().iniciar();
        control().elegirOficio(plomeria);

        await control().tomarFoto();

        expect(estado().fotos, isEmpty);
        expect(estado().errorFoto, isA<FotoNoValidaFailure>());
      },
    );
  });

  test('CA_015_04 no se elige un día fuera de hoy a hoy + 5', () async {
    await control().iniciar();

    control().elegirDia(DateTime(2026, 11, 16));
    expect(estado().dia, isNull);

    control().elegirDia(DateTime(2026, 11, 15));
    expect(estado().dia, DateTime(2026, 11, 15));
    expect(control().diasOfrecidos, hasLength(6));
  });

  group('CA_015_06 una sola Idempotency-Key por envío', () {
    test('CA_015_06 el doble toque crea una sola solicitud', () async {
      await llenarTodo();
      final suelta = Completer<void>();
      solicitudes.retraso = suelta.future;

      final primero = control().enviar();
      final segundo = control().enviar();
      suelta.complete();
      await Future.wait([primero, segundo]);

      expect(solicitudes.creaciones, hasLength(1));
    });

    test(
      'CA_015_06 tras un fallo de red el reintento repite la clave',
      () async {
        await llenarTodo();
        solicitudes.fallas.add(const ServicioNoDisponibleFailure());

        await control().enviar();
        await control().enviar();

        expect(solicitudes.creaciones, hasLength(2));
        expect(solicitudes.creaciones[0].$2, solicitudes.creaciones[1].$2);
        // La foto ya subida no se vuelve a subir.
        expect(solicitudes.subidas, hasLength(1));
      },
    );

    test('CA_015_06 si cambia el contenido se usa una clave nueva', () async {
      await llenarTodo();
      solicitudes.fallas.add(const ServicioNoDisponibleFailure());

      await control().enviar();
      control().cambiarDireccion('Calle Morelos 45');
      await control().enviar();

      expect(solicitudes.creaciones[0].$2, isNot(solicitudes.creaciones[1].$2));
    });
  });

  group('CA_015_15 un 429 se espera sin reintentar en bucle', () {
    test('CA_015_15 guarda la espera y no envía hasta que pase', () async {
      await llenarTodo();
      solicitudes.fallas.add(
        const DemasiadosIntentosFailure(espera: Duration(seconds: 12)),
      );

      await control().enviar();
      expect(estado().esperando, isTrue);
      expect(estado().error, isA<DemasiadosIntentosFailure>());

      await control().enviar();
      expect(solicitudes.creaciones, hasLength(1));
    });

    test('CA_015_15 al pasar la espera se puede volver a enviar', () async {
      await llenarTodo();
      solicitudes.fallas.add(
        const DemasiadosIntentosFailure(espera: Duration(milliseconds: 20)),
      );

      await control().enviar();
      expect(estado().esperando, isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 60));

      expect(estado().esperando, isFalse);
      await control().enviar();
      expect(solicitudes.creaciones, hasLength(2));
    });
  });

  group('CA_015_22 moderación: mensaje y borrador intacto', () {
    test('CA_015_22 un 422 contenido_rechazado vuelve al paso 2', () async {
      await llenarTodo();
      solicitudes.fallas.add(const ContenidoRechazadoFailure());

      await control().enviar();

      expect(estado().paso, PasoSolicitud.descripcion);
      expect(estado().error, isA<ContenidoRechazadoFailure>());
      expect(estado().descripcion, 'Gotea la llave del baño');
      expect(estado().fotos, ['/privado/fotos/1.jpg']);
      expect(borrador.borrados, 0);
      expect(solicitudes.creaciones, hasLength(1));
    });

    test(
      'CA_015_22 un 503 moderacion_no_disponible no se reintenta solo',
      () async {
        await llenarTodo();
        solicitudes.fallas.add(const ModeracionNoDisponibleFailure());

        await control().enviar();
        await Future<void>.delayed(const Duration(milliseconds: 20));

        expect(estado().error, isA<ModeracionNoDisponibleFailure>());
        expect(estado().paso, PasoSolicitud.cuandoDonde);
        expect(borrador.borrados, 0);
        expect(solicitudes.creaciones, hasLength(1));
      },
    );
  });

  group('CA_015_24 llegar desde un oficio salta el paso 1', () {
    test('CA_015_24 con oficioClave empieza en «Qué pasa»', () async {
      await control().iniciar(oficioClave: 'mec');

      expect(estado().oficio, mecanica);
      expect(estado().paso, PasoSolicitud.descripcion);
    });

    test('CA_015_24 una clave desconocida empieza en el paso 1', () async {
      await control().iniciar(oficioClave: 'xyz');

      expect(estado().oficio, isNull);
      expect(estado().paso, PasoSolicitud.oficio);
    });
  });

  group('CA_015_14 el formulario recupera el borrador', () {
    test(
      'CA_015_14 al abrir de nuevo vuelven el texto, las fotos y el oficio',
      () async {
        borrador.guardado = BorradorSolicitud(
          oficioClave: 'plo',
          descripcion: 'Gotea la llave del baño',
          rutasDeFotos: const ['/privado/fotos/7.jpg'],
          dia: DateTime(2026, 11, 11),
          franja: Franja.noche,
          actualizadoEn: hoyDePrueba,
        );

        await control().iniciar();

        expect(estado().oficio, plomeria);
        expect(estado().descripcion, 'Gotea la llave del baño');
        expect(estado().fotos, ['/privado/fotos/7.jpg']);
        expect(estado().dia, DateTime(2026, 11, 11));
        expect(estado().franja, Franja.noche);
      },
    );

    test('CA_015_14 un día del borrador que ya pasó no se recupera', () async {
      borrador.guardado = BorradorSolicitud(
        oficioClave: 'plo',
        dia: DateTime(2026, 11, 2),
        actualizadoEn: hoyDePrueba,
      );

      await control().iniciar();

      expect(estado().dia, isNull);
    });

    test(
      'CA_015_19 lo que se guarda en el borrador no lleva la dirección',
      () async {
        await llenarTodo();

        expect(
          borrador.guardado!.aMapa().toString(),
          isNot(contains('Hidalgo')),
        );
      },
    );

    test(
      'CA_015_19 descartar borra el borrador y vacía el formulario',
      () async {
        await llenarTodo();

        await control().descartar();

        expect(borrador.borrados, 1);
        expect(estado().descripcion, isEmpty);
        expect(estado().fotos, isEmpty);
        expect(estado().oficio, isNull);
      },
    );
  });
}
