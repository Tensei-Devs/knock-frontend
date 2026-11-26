import 'conversacion.dart';

/// Puerto de lectura. No hay implementación de producción hasta integrar la API.
abstract interface class ConversacionesRepository {
  Future<ResumenConversaciones> consultar();
}
