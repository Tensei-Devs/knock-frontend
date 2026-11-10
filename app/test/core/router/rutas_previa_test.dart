// Spec 027: tabla de rutas por sesión y destinos de regreso (unitarias).
import 'package:app/core/router/rutas.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('rutas por sesión', () {
    test('CA_027_02 sin sesión toda ruta protegida lleva a la previa', () {
      for (final ruta in [
        Rutas.inicio,
        Rutas.explorar,
        Rutas.actividad,
        Rutas.trabajo,
        Rutas.cuenta,
        Rutas.configuracion,
        Rutas.oficios,
        Rutas.completarPerfil,
        '/entrarx',
        '/previax',
      ]) {
        expect(
          redireccionPorSesion(sesionIniciada: false, ubicacion: ruta),
          Rutas.previa,
          reason: ruta,
        );
      }
    });

    test('CA_027_01 sin sesión la previa y su catálogo no redirigen', () {
      for (final ruta in [Rutas.previa, Rutas.previaOficios]) {
        expect(
          redireccionPorSesion(sesionIniciada: false, ubicacion: ruta),
          isNull,
          reason: ruta,
        );
      }
    });

    test('CA_027_03 sin sesión /entrar y /entrar/codigo no redirigen', () {
      for (final ruta in [Rutas.entrar, Rutas.codigo]) {
        expect(
          redireccionPorSesion(sesionIniciada: false, ubicacion: ruta),
          isNull,
          reason: ruta,
        );
      }
    });

    test('CA_027_04 con sesión la previa y /entrar llevan a Inicio', () {
      for (final ruta in [
        Rutas.previa,
        Rutas.previaOficios,
        Rutas.entrar,
        Rutas.codigo,
      ]) {
        expect(
          redireccionPorSesion(sesionIniciada: true, ubicacion: ruta),
          Rutas.inicio,
          reason: ruta,
        );
      }
      expect(
        redireccionPorSesion(sesionIniciada: true, ubicacion: Rutas.cuenta),
        isNull,
      );
    });

    test(
      'CA_027_04 sin bucles: cada redirección termina en una ruta estable',
      () {
        for (final sesion in [false, true]) {
          for (final ruta in [
            Rutas.previa,
            Rutas.previaOficios,
            Rutas.entrar,
            Rutas.codigo,
            Rutas.inicio,
            Rutas.cuenta,
          ]) {
            final primera = redireccionPorSesion(
              sesionIniciada: sesion,
              ubicacion: ruta,
            );
            if (primera == null) continue;
            expect(
              redireccionPorSesion(sesionIniciada: sesion, ubicacion: primera),
              isNull,
              reason: '$sesion $ruta -> $primera',
            );
          }
        }
      },
    );
  });

  group('destino de regreso', () {
    test('CA_027_21 un destino permitido se conserva', () {
      for (final ruta in [
        Rutas.explorar,
        Rutas.actividad,
        Rutas.trabajo,
        Rutas.cuenta,
        Rutas.oficios,
      ]) {
        expect(destinoDeRegreso(ruta), ruta, reason: ruta);
      }
    });

    test('CA_027_21 sin destino se va a Inicio', () {
      expect(destinoDeRegreso(null), Rutas.inicio);
      expect(destinoDeRegreso(''), Rutas.inicio);
    });

    test('CA_027_21 el catálogo de la previa pasa al de Explorar', () {
      expect(destinoDeRegreso(Rutas.previaOficios), Rutas.oficios);
    });

    test('CA_027_22 los destinos hostiles o mal formados van a Inicio', () {
      for (final malo in [
        'https://otro.sitio',
        '//otro',
        '//otro.sitio/cuenta',
        r'/\otro',
        'otro',
        '/cuenta/../entrar',
        '/cuenta?x=1',
        '/cuenta#a',
        '/cuenta con espacio',
        'javascript:alert(1)',
        '/desconocida',
        Rutas.entrar,
        Rutas.completarPerfil,
        Rutas.previa,
      ]) {
        expect(destinoDeRegreso(malo), Rutas.inicio, reason: malo);
      }
    });

    test(
      'CA_027_20 rutaDeEntrada agrega el destino válido y descarta el resto',
      () {
        expect(rutaDeEntrada(null), Rutas.entrar);
        expect(rutaDeEntrada('https://otro.sitio'), Rutas.entrar);
        final ruta = rutaDeEntrada(Rutas.explorar);
        expect(Uri.parse(ruta).path, Rutas.entrar);
        expect(
          Uri.parse(ruta).queryParameters[Rutas.parametroVolver],
          Rutas.explorar,
        );
      },
    );

    test('CA_027_21 con sesión /entrar lleva al destino pendiente válido', () {
      expect(
        redireccionPorSesion(
          sesionIniciada: true,
          ubicacion: Rutas.entrar,
          volver: Rutas.explorar,
        ),
        Rutas.explorar,
      );
      expect(
        redireccionPorSesion(
          sesionIniciada: true,
          ubicacion: Rutas.entrar,
          volver: '//otro',
        ),
        Rutas.inicio,
      );
    });
  });
}
