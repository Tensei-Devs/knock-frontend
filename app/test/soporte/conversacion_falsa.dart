// Dobles de la spec 047. Solo datos ficticios.
import 'package:app/features/mensajes/domain/conversacion.dart';
import 'package:app/features/mensajes/domain/conversacion_abierta.dart';
import 'package:app/features/mensajes/domain/envio_de_mensajes.dart';
import 'package:app/features/mensajes/domain/mensaje.dart';

Mensaje mensajeFalso(
  int n, {
  String autorRol = 'tecnico',
  String? texto,
  bool contactoOculto = false,
}) => Mensaje(
  id: 'm$n',
  autorRol: autorRol,
  texto: texto ?? 'Mensaje $n',
  contactoOculto: contactoOculto,
  enviadoEn: DateTime.utc(2026, 11, 27, 12).add(Duration(minutes: n)),
);

DetalleDeConversacion detalleFalso({
  String rol = 'cliente',
  String estado = 'abierta',
  String? motivoCierre,
  String? visitaId,
}) => DetalleDeConversacion(
  id: 'c1',
  solicitudId: 's1',
  rol: rol,
  contraparte: const ContraparteConversacion(nombre: 'Ana'),
  servicio: 'Plomería',
  estado: estado,
  motivoCierre: motivoCierre,
  visitaId: visitaId,
  avisoSeguridad: 'No pagues por adelantado.',
);

class ConversacionFalsa implements LecturaDeConversacion, EnvioDeMensajes {
  DetalleDeConversacion actual = detalleFalso();

  /// Primera página, del más reciente al más antiguo (como el servidor).
  List<Mensaje> primera = [];
  String? siguiente;
  final anteriores = <String, PaginaDeMensajes>{};

  Exception? errorDeLectura;
  Exception? errorAlAbrir;
  Exception? errorAlEnviar;
  Exception? errorAlMarcar;

  bool ocultaContacto = false;
  bool guardaEnElHistorial = false;
  void Function()? alLeerPrimera;

  final aperturas = <({String solicitudId, String? tecnicoId})>[];
  final cursores = <String?>[];
  final enviados = <String>[];
  final leidos = <DateTime>[];
  int _propios = 100;

  @override
  Future<String> abrir({required String solicitudId, String? tecnicoId}) async {
    aperturas.add((solicitudId: solicitudId, tecnicoId: tecnicoId));
    final fallo = errorAlAbrir;
    if (fallo != null) throw fallo;
    return 'c1';
  }

  @override
  Future<DetalleDeConversacion> detalle(String id) async {
    final fallo = errorDeLectura;
    if (fallo != null) throw fallo;
    return actual;
  }

  @override
  Future<PaginaDeMensajes> mensajes(String id, {String? cursor}) async {
    cursores.add(cursor);
    final fallo = errorDeLectura;
    if (fallo != null) throw fallo;
    if (cursor != null) return anteriores[cursor]!;
    alLeerPrimera?.call();
    return PaginaDeMensajes(items: primera, siguiente: siguiente);
  }

  @override
  Future<void> marcarLeido(String id, DateTime hasta) async {
    final fallo = errorAlMarcar;
    if (fallo != null) throw fallo;
    leidos.add(hasta);
  }

  @override
  Future<Mensaje> enviar(String conversacionId, String texto) async {
    enviados.add(texto);
    final fallo = errorAlEnviar;
    if (fallo != null) throw fallo;
    final guardado = mensajeFalso(
      _propios++,
      autorRol: actual.rol,
      texto: ocultaContacto ? '***' : texto,
      contactoOculto: ocultaContacto,
    );
    if (guardaEnElHistorial) primera = [guardado, ...primera];
    return guardado;
  }
}
