// KNOCK-228: Firebase verifica, la API canjea y los tokens van al almacén seguro.
import 'package:app/core/errores/failure.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/almacen_sesion.dart';
import 'package:app/core/sesion/canje_sesion.dart';
import 'package:app/core/sesion/identificador_dispositivo.dart';
import 'package:app/core/sesion/servicio_entrada.dart';
import 'package:app/core/sesion/verificador_celular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class _VerificadorFalso implements VerificadorCelular {
  Failure? error;
  var cerrado = false;
  String? codigoVerificado;

  @override
  Future<SolicitudCodigo> enviarCodigo(
    String celular, {
    SolicitudCodigo? anterior,
  }) async => SolicitudCodigo(celular: celular, idVerificacion: 'v-1');

  @override
  Future<String> tokenDeId(SolicitudCodigo solicitud, String codigo) async {
    final e = error;
    if (e != null) throw e;
    codigoVerificado = codigo;
    return 'token-firebase-ficticio';
  }

  @override
  Future<void> cerrarSesion() async => cerrado = true;
}

class _CanjeFalso implements CanjeSesion {
  Failure? error;
  ({String token, String id, String dispositivo})? recibido;

  @override
  Future<SesionEmitida> canjear({
    required String tokenFirebase,
    required String idDispositivo,
    required String dispositivo,
  }) async {
    recibido = (
      token: tokenFirebase,
      id: idDispositivo,
      dispositivo: dispositivo,
    );
    final e = error;
    if (e != null) throw e;
    return const SesionEmitida(
      acceso: 'acceso-ficticio',
      renovacion: 'renovacion-ficticia',
      esNuevo: false,
      perfilCompleto: true,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _VerificadorFalso verificador;
  late _CanjeFalso canje;
  late ServicioEntradaReal servicio;
  const seguro = FlutterSecureStorage();
  const solicitud = SolicitudCodigo(
    celular: '5512345678',
    idVerificacion: 'v-1',
  );

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    verificador = _VerificadorFalso();
    canje = _CanjeFalso();
    // Usa una sola instancia de almacenamiento seguro para escribir y leer
    // el id de dispositivo, de modo que obtener() lo devuelva sin generar uno nuevo.
    final almacenSeguro = AlmacenSeguroFlutterSecureStorage();
    await almacenSeguro.escribir(
      IdentificadorDispositivo.clave,
      '00000000-0000-4000-8000-000000000001',
    );
    servicio = ServicioEntradaReal(
      verificador: verificador,
      canje: canje,
      almacen: AlmacenSesion(almacenSeguro),
      identificador: IdentificadorDispositivo(almacenSeguro),
      dispositivo: 'Android',
    );
  });

  test(
    'canjea el ID token y guarda los tokens en el almacenamiento seguro',
    () async {
      final resultado = await servicio.verificarCodigo(solicitud, '123456');

      expect(verificador.codigoVerificado, '123456');
      expect(canje.recibido, (
        token: 'token-firebase-ficticio',
        id: '00000000-0000-4000-8000-000000000001',
        dispositivo: 'Android',
      ));
      expect(resultado.esNuevo, isFalse);
      expect(resultado.perfilCompleto, isTrue);
      final guardado = await seguro.readAll();
      expect(guardado[AlmacenSesion.claveAcceso], 'acceso-ficticio');
      expect(guardado[AlmacenSesion.claveRefresco], 'renovacion-ficticia');
      expect(verificador.cerrado, isTrue);
    },
  );

  test('si la API rechaza el canje no se guarda ningún token', () async {
    canje.error = const CuentaSuspendidaFailure();

    await expectLater(
      servicio.verificarCodigo(solicitud, '123456'),
      throwsA(isA<CuentaSuspendidaFailure>()),
    );
    final guardado = await seguro.readAll();
    expect(guardado.containsKey(AlmacenSesion.claveAcceso), isFalse);
    expect(guardado.containsKey(AlmacenSesion.claveRefresco), isFalse);
  });

  test('si Firebase rechaza el código no se llama a la API', () async {
    verificador.error = const CodigoIncorrectoFailure();

    await expectLater(
      servicio.verificarCodigo(solicitud, '000000'),
      throwsA(isA<CodigoIncorrectoFailure>()),
    );
    expect(canje.recibido, isNull);
  });

  test(
    'sin configuración de Firebase la entrada falla con un error claro',
    () async {
      const sinFirebase = VerificadorNoConfigurado();
      await expectLater(
        sinFirebase.enviarCodigo('5512345678'),
        throwsA(isA<VerificacionNoDisponibleFailure>()),
      );
    },
  );
}
