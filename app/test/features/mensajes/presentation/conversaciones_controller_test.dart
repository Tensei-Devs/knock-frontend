import 'dart:async';

import 'package:app/features/mensajes/domain/conversacion.dart';
import 'package:app/features/mensajes/domain/conversaciones_repository.dart';
import 'package:app/features/mensajes/presentation/conversaciones_controller.dart';
import 'package:flutter_test/flutter_test.dart';

class RepositorioDePrueba implements ConversacionesRepository {
  ResumenConversaciones respuesta = const ResumenConversaciones(
    conversaciones: [],
    totalNoLeidos: 3,
  );
  bool falla = false;
  Completer<ResumenConversaciones>? pendiente;
  String? ultimoCursor;

  @override
  Future<ResumenConversaciones> consultar({String? cursor}) async {
    ultimoCursor = cursor;
    if (falla) throw Exception('sin red');
    return pendiente?.future ?? respuesta;
  }
}

void main() {
  test('carga la siguiente página y elimina duplicados por id', () async {
    const persona = ContraparteConversacion(nombre: 'Ana');
    const primera = Conversacion(
      id: 'c1',
      solicitudId: 's1',
      rol: 'cliente',
      estado: 'abierta',
      contraparte: persona,
      servicio: 'Servicio',
      noLeidos: 1,
    );
    const segunda = Conversacion(
      id: 'c2',
      solicitudId: 's2',
      rol: 'cliente',
      estado: 'abierta',
      contraparte: persona,
      servicio: 'Servicio',
      noLeidos: 0,
    );
    final repo = RepositorioDePrueba()
      ..respuesta = const ResumenConversaciones(
        conversaciones: [primera],
        totalNoLeidos: 1,
        siguiente: 'cursor-2',
      );
    final controller = ConversacionesController(repo);
    await controller.reintentar();
    repo.respuesta = const ResumenConversaciones(
      conversaciones: [primera, segunda],
      totalNoLeidos: 1,
    );
    await controller.cargarMas();
    expect(repo.ultimoCursor, 'cursor-2');
    expect(controller.estado.conversaciones.map((e) => e.id), ['c1', 'c2']);
    expect(controller.estado.siguiente, isNull);
  });

  test('una página pendiente no restaura datos después de limpiar', () async {
    final repo = RepositorioDePrueba()
      ..respuesta = const ResumenConversaciones(
        conversaciones: [],
        totalNoLeidos: 2,
        siguiente: 'c2',
      );
    final controller = ConversacionesController(repo);
    await controller.reintentar();
    repo.pendiente = Completer<ResumenConversaciones>();
    final carga = controller.cargarMas();
    controller.limpiar();
    repo.pendiente!.complete(
      const ResumenConversaciones(conversaciones: [], totalNoLeidos: 8),
    );
    await carga;
    expect(controller.estado.totalNoLeidos, isNull);
    expect(controller.estado.siguiente, isNull);
  });
  test(
    'CA_020_13 usa el total confirmado y congela al caer el canal',
    () async {
      final repositorio = RepositorioDePrueba();
      final controller = ConversacionesController(repositorio);
      await controller.reintentar();
      controller.canalConectado();
      controller.actualizarTotalDesdeServidor(5);
      expect(controller.estado.totalNoLeidos, 5);
      controller.canalDesconectado();
      controller.actualizarTotalDesdeServidor(9);
      expect(controller.estado.totalNoLeidos, 5);
      expect(controller.estado.sinConexion, isTrue);
    },
  );

  test('CA_020_14 conserva datos al fallar y reintenta bajo demanda', () async {
    final repositorio = RepositorioDePrueba();
    final controller = ConversacionesController(repositorio);
    await controller.reintentar();
    repositorio.falla = true;
    await controller.reintentar();
    expect(controller.estado.totalNoLeidos, 3);
    expect(controller.estado.sinConexion, isTrue);
    repositorio
      ..falla = false
      ..respuesta = const ResumenConversaciones(
        conversaciones: [],
        totalNoLeidos: 1,
      );
    await controller.reintentar();
    expect(controller.estado.totalNoLeidos, 1);
  });

  test('CA_020_16 descarta una respuesta iniciada antes de limpiar', () async {
    final repositorio = RepositorioDePrueba()
      ..pendiente = Completer<ResumenConversaciones>();
    final controller = ConversacionesController(repositorio);
    final carga = controller.reintentar();
    controller.limpiar();
    repositorio.pendiente!.complete(
      const ResumenConversaciones(conversaciones: [], totalNoLeidos: 7),
    );
    await carga;
    expect(controller.estado.totalNoLeidos, isNull);
    expect(controller.estado.conversaciones, isEmpty);
  });
}
