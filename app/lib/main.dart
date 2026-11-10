import 'package:app/app.dart';
import 'package:app/core/preferencias/almacen_preferencias.dart';
import 'package:app/core/preferencias/arranque.dart';
import 'package:app/core/red/configuracion_api.dart';
import 'package:app/core/sesion/almacen_seguro.dart';
import 'package:app/core/sesion/almacen_sesion.dart';
import 'package:app/core/sesion/arranque_sesion.dart';
import 'package:app/core/sesion/sesion.dart';
import 'package:app/core/sesion/sesion_provider.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

/// Espera las preferencias guardadas detrás de la pantalla de arranque nativa
/// para que el primer cuadro ya tenga el idioma y el tema (HU-052, CA5).
Future<void> main() => arrancar();

/// Arranque de la app. Inicia Firebase (sin `google-services.json` sigue y
/// la entrada avisa) y lee si hay sesión guardada en almacenamiento seguro
/// (KNOCK-228). Los E2E pasan [overrides] para no usar Firebase ni la red.
///
/// Una compilación de tienda (`release`) sin `KNOCK_API_URL` válida no abre:
/// falla con `ApiNoConfiguradaFailure` antes de mostrar pantallas y no cae a
/// los repositorios simulados (spec 026, R-10). [urlApi] y [esRelease] son
/// para las pruebas.
Future<void> arrancar({
  List<Override> overrides = const [],
  String urlApi = urlApiDefinida,
  bool esRelease = kReleaseMode,
}) async {
  validarConfiguracionApi(url: urlApi, esRelease: esRelease);
  WidgetsFlutterBinding.ensureInitialized();
  final almacen = await crearAlmacenDeArranque();
  final firebaseListo = await iniciarFirebase();
  final almacenSeguro = AlmacenSeguroFlutterSecureStorage();
  final tokens = await leerTokensGuardados(AlmacenSesion(almacenSeguro));
  runApp(
    ProviderScope(
      overrides: [
        almacenPreferenciasProvider.overrideWithValue(almacen),
        firebaseListoProvider.overrideWithValue(firebaseListo),
        sesionInicialProvider.overrideWithValue(tokens != null),
        tokensInicialesProvider.overrideWithValue(tokens),
        almacenSeguroProvider.overrideWithValue(almacenSeguro),
        ...overrides,
      ],
      child: const KnockApp(),
    ),
  );
}
