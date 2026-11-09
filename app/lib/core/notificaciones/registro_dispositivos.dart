import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Registro del identificador de notificaciones en el servidor (spec 012 §5).
abstract interface class RegistroDispositivosRepository {
  Future<void> registrar(String identificador);

  Future<void> desregistrar(String identificador);
}

/// SIMULADO: el endpoint de registro de dispositivos no existe todavía en el
/// backend. Guarda los identificadores en memoria y no llama a la red. Se
/// reemplaza por un repositorio sobre `knock_api` cuando el contrato lo
/// publique.
class RegistroDispositivosSimulado implements RegistroDispositivosRepository {
  final Set<String> registrados = {};

  /// Para probar fallos del servidor: si no es `null`, se lanza.
  Exception? fallo;

  @override
  Future<void> registrar(String identificador) async {
    if (fallo != null) throw fallo!;
    registrados.add(identificador);
  }

  @override
  Future<void> desregistrar(String identificador) async {
    if (fallo != null) throw fallo!;
    registrados.remove(identificador);
  }
}

final registroDispositivosRepositoryProvider =
    Provider<RegistroDispositivosRepository>(
      (ref) => RegistroDispositivosSimulado(),
    );
