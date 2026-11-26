import 'package:flutter/foundation.dart';

import '../domain/conversacion.dart';
import '../domain/conversaciones_repository.dart';

class EstadoConversaciones {
  const EstadoConversaciones({
    this.conversaciones = const [],
    this.totalNoLeidos,
    this.cargando = false,
    this.sinConexion = false,
    this.siguiente,
  });

  final List<Conversacion> conversaciones;
  final int? totalNoLeidos;
  final bool cargando;
  final bool sinConexion;
  final String? siguiente;
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
        siguiente: estado.siguiente,
      ),
    );
    try {
      final resultado = await _repository.consultar();
      if (_disposed || generacion != _generacion) return;
      _publicar(
        EstadoConversaciones(
          conversaciones: List.unmodifiable(resultado.conversaciones),
          totalNoLeidos: resultado.totalNoLeidos,
          siguiente: resultado.siguiente,
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
          siguiente: estado.siguiente,
        ),
      );
    }
  }

  Future<void> cargarMas() async {
    final cursor = estado.siguiente;
    if (_disposed || estado.cargando || cursor == null) return;
    final generacion = ++_generacion;
    _publicar(
      EstadoConversaciones(
        conversaciones: estado.conversaciones,
        totalNoLeidos: estado.totalNoLeidos,
        siguiente: cursor,
        sinConexion: estado.sinConexion,
        cargando: true,
      ),
    );
    try {
      final resultado = await _repository.consultar(cursor: cursor);
      if (_disposed || generacion != _generacion) return;
      final existentes = {for (final c in estado.conversaciones) c.id};
      _publicar(
        EstadoConversaciones(
          conversaciones: List.unmodifiable([
            ...estado.conversaciones,
            for (final c in resultado.conversaciones)
              if (existentes.add(c.id)) c,
          ]),
          totalNoLeidos: _canalDisponible
              ? resultado.totalNoLeidos
              : estado.totalNoLeidos,
          siguiente: resultado.siguiente,
          sinConexion: !_canalDisponible,
        ),
      );
    } on Exception {
      if (_disposed || generacion != _generacion) return;
      _publicar(
        EstadoConversaciones(
          conversaciones: estado.conversaciones,
          totalNoLeidos: estado.totalNoLeidos,
          siguiente: cursor,
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
        siguiente: estado.siguiente,
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
        siguiente: estado.siguiente,
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
