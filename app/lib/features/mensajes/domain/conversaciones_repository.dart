import 'conversacion.dart';

/// Puerto de lectura de conversaciones.
abstract interface class ConversacionesRepository {
  Future<ResumenConversaciones> consultar({String? cursor});
}
