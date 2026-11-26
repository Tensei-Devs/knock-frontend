import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/mensajes/domain/conversacion.dart';
import 'package:app/features/mensajes/domain/conversaciones_repository.dart';
import 'package:http/http.dart' as http;

class ConversacionesRepositoryApi implements ConversacionesRepository {
  const ConversacionesRepositoryApi({
    required this.transporte,
    required this.url,
  });
  final http.Client transporte;
  final String url;

  @override
  Future<ResumenConversaciones> consultar({String? cursor}) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'GET',
      'conversaciones',
      consulta: {'limit': '20', 'cursor': ?cursor},
    );
    final m = objetoDelContrato(r.json);
    return ResumenConversaciones(
      conversaciones: List.unmodifiable([
        for (final item in listaDelContrato(m['items']))
          _conversacion(objetoDelContrato(item)),
      ]),
      totalNoLeidos: _entero(m['totalNoLeidos']),
      siguiente: textoOpcional(m['nextCursor']),
    );
  }

  Future<int> contador() async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'GET',
      'conversaciones/no-leidas',
    );
    return _entero(objetoDelContrato(r.json)['total']);
  }

  Future<void> marcarLeido(String id, DateTime hasta) async {
    await enviarJson(
      transporte,
      url,
      'POST',
      'conversaciones/${Uri.encodeComponent(id)}/leido',
      cuerpo: {'hasta': hasta.toUtc().toIso8601String()},
    );
  }

  static Conversacion _conversacion(Map<Object?, Object?> m) {
    final persona = objetoDelContrato(m['contraparte']);
    final ultimo = m['ultimoMensaje'];
    return Conversacion(
      id: textoObligatorio(m['conversacionId']),
      solicitudId: textoObligatorio(m['solicitudId']),
      visitaId: textoOpcional(m['visitaId']),
      rol: textoObligatorio(m['rol']),
      estado: textoObligatorio(m['estado']),
      contraparte: ContraparteConversacion(
        nombre: textoObligatorio(persona['nombre']),
        fotoUrl: textoOpcional(persona['fotoUrl']),
      ),
      servicio: textoObligatorio(m['servicio']),
      noLeidos: _entero(m['noLeidos']),
      ultimoMensaje: ultimo == null
          ? null
          : _mensaje(objetoDelContrato(ultimo)),
    );
  }

  static UltimoMensaje _mensaje(Map<Object?, Object?> m) => UltimoMensaje(
    texto: textoObligatorio(m['texto']),
    enviadoEn: fechaHoraObligatoria(m['enviadoEn']),
    autorRol: textoObligatorio(m['autorRol']),
  );

  static int _entero(Object? valor) {
    final n = valor is int ? valor : int.tryParse('$valor');
    if (n == null || n < 0) throw const DatosInvalidosFailure();
    return n;
  }
}
