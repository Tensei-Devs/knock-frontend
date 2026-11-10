import 'package:flutter/foundation.dart' show kReleaseMode;

/// Si el modo demostración vale para esta compilación (spec 027, R-11).
///
/// La bandera `KNOCK_DEMO_DATOS` solo cuenta fuera de `release`: la tienda la
/// ignora siempre, aunque alguien la pase al compilar.
bool demoActivo({required bool bandera, required bool esRelease}) =>
    bandera && !esRelease;

/// `--dart-define=KNOCK_DEMO_DATOS=true` (spec 027, R-11 y R-12).
///
/// Es una constante de compilación: en `release` vale `false` y el compilador
/// elimina el código que solo se alcanza con `if (demoDatosActivo)`, así los
/// datos de ejemplo no quedan en el binario (CA-27).
const bool demoDatosActivo =
    !kReleaseMode && bool.fromEnvironment('KNOCK_DEMO_DATOS');
