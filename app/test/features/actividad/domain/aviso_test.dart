import 'package:app/core/plataforma/enlaces.dart';
import 'package:app/features/actividad/domain/aviso.dart';
import 'package:app/features/actividad/domain/visita.dart';
import 'package:flutter_test/flutter_test.dart';

const _plantilla = PlantillaAviso(
  encabezado: 'Hoy recibo a un técnico de Knock.',
  tecnicoVerificado: _verificado,
  tecnicoSinVerificar: _sinVerificar,
  cuando: _cuando,
  recomendacion: 'Le pediré el código en la puerta antes de abrir.',
);
String _verificado(String n) => 'Se llama $n y está verificado por Knock.';
String _sinVerificar(String n) => 'Se llama $n; todavía no está verificado.';
String _cuando(String d, String h) => 'Viene el $d a las $h.';

ContactoConfianza _contacto(String id, String celular) =>
    ContactoConfianza(id: id, nombre: 'Persona $id', celular: celular);

void main() {
  group('CA_022_05 nombre de 2 a 40 y celular de 10 dígitos', () {
    test('CA_022_05 acepta los límites y rechaza fuera de ellos', () {
      expect(validarContacto('Al', '5500000001'), isNull);
      expect(validarContacto('a' * 40, '5500000001'), isNull);
      expect(validarContacto('A', '5500000001'), ErrorContacto.nombre);
      expect(validarContacto('a' * 41, '5500000001'), ErrorContacto.nombre);
      expect(validarContacto('Ana', '550000000'), ErrorContacto.celular);
      expect(validarContacto('Ana', '55000000011'), ErrorContacto.celular);
      expect(validarContacto('Ana', '55-0000-0001'), ErrorContacto.celular);
    });
  });

  group('CA_022_06 y CA_022_07 lista de contactos', () {
    final diez = [for (var i = 0; i < 10; i++) _contacto('$i', '550000001$i')];

    test('CA_022_07 un celular repetido no se agrega', () {
      expect(
        puedeGuardarse(
          diez.take(2).toList(),
          nombre: 'Otra',
          celular: '5500000011',
        ),
        ErrorContacto.repetido,
      );
    });

    test('CA_022_07 editar el mismo contacto no cuenta como repetido', () {
      expect(
        puedeGuardarse(
          diez.take(2).toList(),
          nombre: 'Nuevo nombre',
          celular: '5500000011',
          idEditado: '1',
        ),
        isNull,
      );
    });

    test('CA_022_06 con 10 contactos no se agrega el 11', () {
      expect(
        puedeGuardarse(diez, nombre: 'Once', celular: '5599999999'),
        ErrorContacto.lleno,
      );
    });
  });

  group(
    'CA_022_02, CA_022_03 y CA_022_19 el mensaje no lleva código ni dirección',
    () {
      final visita = VisitaGuardada(
        id: 'v1',
        estado: EstadoVisita.confirmada,
        esTaller: false,
        dia: DateTime(2026, 11, 14),
        hora: '10:30',
        tecnicoNombre: 'Técnico de prueba',
        tecnicoVerificado: true,
        codigo: '4821',
        guardadoEn: DateTime(2026, 11, 12),
      );

      test('CA_022_19 la plantilla local solo recibe cuatro campos', () {
        final datos = DatosAvisoLocal.deVisita(visita);
        final texto = armarAvisoLocal(
          datos,
          _plantilla,
          // Sin dígitos en el día para comparar dígito por dígito.
          diaFormateado: 'sábado',
        );

        expect(texto, isNot(contains('4821')));
        for (final digito in ['4', '8', '2', '1']) {
          // Ningún dígito del código aparece suelto (la hora es 10:30).
          expect(texto.replaceAll('10:30', ''), isNot(contains(digito)));
        }
        expect(texto, contains('Técnico de prueba'));
      });

      test(
        'CA_022_19 el texto local con dirección de domicilio tampoco la lleva',
        () {
          final conDireccion = VisitaGuardada(
            id: 'v2',
            estado: EstadoVisita.confirmada,
            esTaller: true,
            dia: DateTime(2026, 11, 14),
            hora: '10:30',
            tecnicoNombre: 'Técnico de prueba',
            tecnicoVerificado: false,
            direccionTaller: 'Calle Secreta 123',
            guardadoEn: DateTime(2026, 11, 12),
          );
          final texto = armarAvisoLocal(
            DatosAvisoLocal.deVisita(conDireccion),
            _plantilla,
            diaFormateado: 'sábado',
          );

          expect(texto, isNot(contains('Calle')));
          expect(texto, isNot(contains('Secreta')));
          expect(texto, contains('todavía no está verificado'));
        },
      );

      test('CA_022_03 es texto plano sin enlaces', () {
        final texto = armarAvisoLocal(
          DatosAvisoLocal.deVisita(visita),
          _plantilla,
          diaFormateado: 'sábado',
        );
        expect(texto, isNot(contains('http')));
        expect(texto, isNot(contains('://')));
      });

      test(
        'CA_022_15 un mensaje que dice traer código o dirección no es seguro',
        () {
          const ok = MensajeAviso(
            texto: 'x',
            incluyeCodigo: false,
            incluyeDireccion: false,
          );
          expect(ok.esSeguro, isTrue);
          expect(
            const MensajeAviso(
              texto: 'x',
              incluyeCodigo: true,
              incluyeDireccion: false,
            ).esSeguro,
            isFalse,
          );
          expect(
            const MensajeAviso(
              texto: 'x',
              incluyeCodigo: false,
              incluyeDireccion: true,
            ).esSeguro,
            isFalse,
          );
        },
      );

      test('R-12 la copia vence 24 h después del día de la cita', () {
        final datos = DatosAvisoLocal.deVisita(visita);
        expect(datos.vigente(DateTime(2026, 11, 15, 23, 59)), isTrue);
        expect(datos.vigente(DateTime(2026, 11, 16)), isFalse);
      });
    },
  );

  group('CA_022_09 y CA_022_10 enlaces de envío', () {
    test('CA_022_09 SMS con número y texto codificado, sin enviar solo', () {
      expect(
        Enlaces.sms('5500000001', 'Hola & adiós').toString(),
        'sms:5500000001?body=Hola%20%26%20adi%C3%B3s',
      );
      expect(Enlaces.sms('123', 'x'), isNull);
    });

    test('CA_022_10 WhatsApp a wa.me/52 con el texto codificado', () {
      expect(
        Enlaces.whatsappConTexto('5500000001', 'Hola mundo').toString(),
        'https://wa.me/525500000001?text=Hola%20mundo',
      );
    });
  });
}
