import 'package:flutter/foundation.dart';

import '../domain/conversacion.dart';
import '../domain/conversaciones_repository.dart';

class EstadoConversaciones {
  const EstadoConversaciones({
    this.conversaciones = const [],
    this.totalNoLeidos,
    this.cargando = false,
    this.sinConexion = false,
  });

  final List<Conversacion> conversaciones;
  final int? totalNoLeidos;
  final bool cargando;
  final bool sinConexion;
}

/// Mantiene solo en memoria los datos recibidos y descarta respuestas antiguas.
class ConversacionesController extends ChangeNotifier {
  ConversacionesController(this._repository);

  final ConversacionesRepository _repository;
  EstadoConversaciones estado = const EstadoConversaciones();
  int _generacion = 0;
  bool _canalDisponible = false;
  bool _disposed = false;

  Future<void> reintentar() async {
    final generacion = ++_generacion;
    _publicar(
      EstadoConversaciones(
        conversaciones: estado.conversaciones,
        totalNoLeidos: estado.totalNoLeidos,
        cargando: true,
        sinConexion: estado.sinConexion,
      ),
    );
    try {
      final resultado = await _repository.consultar();
      if (_disposed || generacion != _generacion) return;
      _publicar(
        EstadoConversaciones(
          conversaciones: List.unmodifiable(resultado.conversaciones),
          totalNoLeidos: resultado.totalNoLeidos,
          sinConexion: !_canalDisponible,
        ),
      );
    } on Exception {
      if (_disposed || generacion != _generacion) return;
      _publicar(
        EstadoConversaciones(
          conversaciones: estado.conversaciones,
          totalNoLeidos: estado.totalNoLeidos,
          sinConexion: true,
        ),
      );
    }
  }

  void canalConectado() {
    _canalDisponible = true;
  }

  void canalDesconectado() {
    _canalDisponible = false;
    _publicar(
      EstadoConversaciones(
        conversaciones: estado.conversaciones,
        totalNoLeidos: estado.totalNoLeidos,
        cargando: estado.cargando,
        sinConexion: true,
      ),
    );
  }

  void actualizarTotalDesdeServidor(int total) {
    if (!_canalDisponible || total < 0) return;
    _publicar(
      EstadoConversaciones(
        conversaciones: estado.conversaciones,
        totalNoLeidos: total,
        cargando: estado.cargando,
        sinConexion: false,
      ),
    );
  }

  void limpiar() {
    _generacion++;
    _canalDisponible = false;
    _publicar(const EstadoConversaciones());
  }

  void _publicar(EstadoConversaciones nuevo) {
    if (_disposed) return;
    estado = nuevo;
    notifyListeners();
  }

  @override
  void dispose() {
    _generacion++;
    _disposed = true;
    super.dispose();
  }
}
