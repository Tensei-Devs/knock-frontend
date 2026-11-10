import 'package:shared_preferences/shared_preferences.dart';

/// Tipos de aviso que la persona puede encender o apagar (spec 012, R-05).
///
/// [sistema] (seguridad de la cuenta, cambios importantes) no se apaga.
enum TipoAviso {
  cotizaciones,
  mensajes,
  visitas,
  sistema;

  /// Si la persona puede apagarlo en Configuración.
  bool get seElige => this != sistema;
}

/// Dónde se conserva qué avisos recibe la persona (spec 012, R-05).
///
/// Solo guarda un booleano por tipo: nunca identificadores ni datos
/// personales, porque `shared_preferences` no está cifrado.
abstract interface class AlmacenAvisos {
  /// `null` significa «sin valor guardado»: quien lee usa el valor por defecto.
  bool? leerAviso(TipoAviso tipo);

  Future<void> guardarAviso(TipoAviso tipo, {required bool recibir});
}

/// Clave en `shared_preferences` de cada aviso (nombre propio de Knock).
String claveDeAviso(TipoAviso tipo) => 'knock.preferencias.avisos.${tipo.name}';

mixin AvisosSobreShared implements AlmacenAvisos {
  SharedPreferences get preferenciasAvisos;

  @override
  bool? leerAviso(TipoAviso tipo) {
    final valor = preferenciasAvisos.get(claveDeAviso(tipo));
    return valor is bool ? valor : null;
  }

  @override
  Future<void> guardarAviso(TipoAviso tipo, {required bool recibir}) =>
      preferenciasAvisos.setBool(claveDeAviso(tipo), recibir);
}

mixin AvisosEnMemoria implements AlmacenAvisos {
  final Map<TipoAviso, bool> _avisos = {};

  @override
  bool? leerAviso(TipoAviso tipo) => _avisos[tipo];

  @override
  Future<void> guardarAviso(TipoAviso tipo, {required bool recibir}) async =>
      _avisos[tipo] = recibir;
}
