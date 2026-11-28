// KNOCK-293: cerrar sesión en la maqueta cuando el almacén del teléfono tarda.
// El router quita «Mi cuenta» antes de que termine el borrado. Datos ficticios.
import 'dart:io';

import 'package:app/core/preferencias/directorio_fotos_borrador.dart';
import 'package:app/core/red/cliente_api_provider.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/core/router/rutas.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../soporte/api_falsa.dart';
import '../../soporte/montar_app.dart';
import '../../soporte/pantalla_maqueta.dart';
import '../../soporte/preparar_maqueta.dart';

/// Como el Keystore: cada borrado tarda y entre tanto se pintan cuadros.
class _AlmacenLento extends AlmacenSeguroEnMemoria {
  @override
  Future<void> borrar(String clave) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    await super.borrar(clave);
  }
}

void main() {
  prepararPruebasDeMaqueta();

  testWidgets('TC-KNOCK-293-API-03 cerrar sesión olvida el celular guardado', (
    tester,
  ) async {
    fijarPantalla(tester, tamano: tamanoMovil);
    final almacen = _AlmacenLento();
    await almacen.escribir('knock.maqueta.telefono', '55 1234 5678');
    final api = ApiFalsa(
      (p) => p.ruta == 'me' ? jsonOk(perfilJson()) : http.Response('', 404),
    );
    final container = await montarApp(
      tester,
      esTecnico: false,
      maqueta: true,
      extra: [
        almacenSeguroProvider.overrideWithValue(almacen),
        urlApiProvider.overrideWithValue(urlApiPrueba),
        transporteHttpProvider.overrideWithValue(api.transporte),
        tokensInicialesProvider.overrideWithValue(tokensA),
        // Sin disco en la prueba: la carpeta del borrador no está disponible.
        directorioFotosBorradorProvider.overrideWithValue(
          () async => throw const FileSystemException(),
        ),
      ],
    );
    container.read(appRouterProvider).go(Rutas.cuenta);
    await asentarMaqueta(tester);

    await tester.ensureVisible(find.text('Cerrar sesión'));
    await asentarMaqueta(tester);
    await tester.tap(find.text('Cerrar sesión'));
    await asentarMaqueta(tester);
    await tester.tap(find.text('Cerrar sesión').hitTestable().last);
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(tester.takeException(), isNull);
    expect(almacen.contenido, isNot(contains('knock.maqueta.telefono')));
    // El aviso emergente se quita solo.
    await tester.pump(const Duration(seconds: 10));
  });
}
