// KNOCK-228: los tokens van solo al almacenamiento seguro (security-core #10).
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/almacen_sesion.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  test(
    'guarda los dos tokens en el almacenamiento seguro y los borra',
    () async {
      const seguro = FlutterSecureStorage();
      final almacen = AlmacenSesion(AlmacenSeguroFlutterSecureStorage());

      expect(await almacen.leerRefresco(), isNull);
      await almacen.guardar(
        acceso: 'acceso-ficticio',
        refresco: 'refresco-ficticio',
      );

      expect(await seguro.readAll(), {
        AlmacenSesion.claveAcceso: 'acceso-ficticio',
        AlmacenSesion.claveRefresco: 'refresco-ficticio',
      });
      expect(await almacen.leerRefresco(), isNotNull);

      await almacen.cerrarSesion();
      expect(await seguro.readAll(), isEmpty);
      expect(await almacen.leerRefresco(), isNull);
    },
  );

  test('lee el acceso y el refresco guardados', () async {
    const seguro = FlutterSecureStorage();
    final almacen = AlmacenSesion(AlmacenSeguroFlutterSecureStorage());

    await almacen.guardar(acceso: 'acceso-ficticio', refresco: 'refresco-ficticio');

    expect(await almacen.leerAcceso(), 'acceso-ficticio');
    expect(await almacen.leerRefresco(), 'refresco-ficticio');
    expect(await seguro.readAll(), isNotEmpty);
  });
}
