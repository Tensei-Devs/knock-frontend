import 'package:app/features/mensajes/domain/canal_mensajes.dart';
import 'package:app/features/mensajes/domain/conversacion.dart';
import 'package:app/features/mensajes/domain/conversaciones_repository.dart';

/// Canal de prueba: abre, falla, emite el contador y se cae a pedido.
class CanalDePrueba implements CanalMensajes {
  Exception? error;
  int aperturas = 0;
  int cierres = 0;
  void Function(int)? _alCambiar;
  void Function()? _alCaerse;

  @override
  Future<void> abrir({
    required void Function(int total) alCambiarContador,
    required void Function() alCaerse,
  }) async {
    aperturas++;
    final fallo = error;
    if (fallo != null) throw fallo;
    _alCambiar = alCambiarContador;
    _alCaerse = alCaerse;
  }

  @override
  Future<void> cerrar() async => cierres++;

  void emitir(int total) => _alCambiar!(total);

  void caer() => _alCaerse!();
}

class ConversacionesDePrueba implements ConversacionesRepository {
  int total = 3;
  Exception? error;
  int consultas = 0;

  @override
  Future<int> contador() async {
    final fallo = error;
    if (fallo != null) throw fallo;
    return total;
  }

  @override
  Future<ResumenConversaciones> consultar({String? cursor}) async {
    consultas++;
    return ResumenConversaciones(
      conversaciones: const [
        Conversacion(
          id: 'c1',
          solicitudId: 's1',
          rol: 'cliente',
          estado: 'abierta',
          contraparte: ContraparteConversacion(nombre: 'Ana'),
          servicio: 'Plomería',
          noLeidos: 1,
          ultimoMensaje: null,
        ),
      ],
      totalNoLeidos: total,
    );
  }
}
