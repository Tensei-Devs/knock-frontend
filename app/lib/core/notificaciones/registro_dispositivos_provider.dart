import 'package:app/core/notificaciones/registro_dispositivos.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Repositorio del registro del dispositivo (spec 012, R-01).
///
/// Por omisión es el SIMULADO. La raíz de composición (`main.dart`) lo
/// sustituye por el de `features/notificaciones`, que usa el contrato real con
/// `KNOCK_API_URL` válida (ADR-007: los repositorios escritos a mano viven en
/// `features/<función>/data`).
final registroDispositivosRepositoryProvider =
    Provider<RegistroDispositivosRepository>(
      (ref) => RegistroDispositivosSimulado(),
    );
