// Spec 047: controlador de la conversación. Solo datos ficticios.
import 'package:app/core/errores/failure.dart';
import 'package:app/features/mensajes/domain/conversacion_abierta.dart';
import 'package:app/features/mensajes/presentation/conversacion_controller.dart';
import 'package:app/features/mensajes/presentation/envio_mensajes_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../soporte/conversacion_falsa.dart';
import '../../../soporte/mensajes_falsos.dart';

Future<void> _asentar() => Future<void>.delayed(Duration.zero);

void main() {
  late ConversacionFalsa api;
  late CanalDePrueba canal;
  late int marcas;

  ConversacionController crear() => ConversacionController(
    conversacionId: 'c1',
    lectura: api,
    envio: api,
    canal: canal,
    alMarcarLeido: () => marcas++,
  );

  setUp(() {
    api = ConversacionFalsa()..primera = [mensajeFalso(2), mensajeFalso(1)];
    canal = CanalDePrueba();
    marcas = 0;
  });

  test('CA_047_03 ordena del más antiguo al más reciente', () async {
    final c = crear();
    await c.cargar();
    expect(c.estado.mensajes.map((m) => m.id), ['m1', 'm2']);
    c.dispose();
  });

  test('CA_047_04 la página anterior se antepone sin repetir', () async {
    api.siguiente = 'p2';
    api.anteriores['p2'] = PaginaDeMensajes(
      items: [mensajeFalso(1), mensajeFalso(0)],
    );
    final c = crear();
    await c.cargar();
    await c.cargarAnteriores();
    expect(c.estado.mensajes.map((m) => m.id), ['m0', 'm1', 'm2']);
    expect(c.estado.siguiente, isNull);
    await c.cargarAnteriores();
    expect(api.cursores, [null, 'p2']);
    c.dispose();
  });

  test('CA_047_05 el mensaje confirmado entra una sola vez en el historial, '
      'aunque llegue también por el canal', () async {
    final c = crear();
    await c.cargar();
    await c.envio.enviar('Hola');
    final guardado = c.estado.mensajes.last;
    canal.recibir(MensajeEnVivo(conversacionId: 'c1', mensaje: guardado));
    expect(c.estado.mensajes.where((m) => m.id == guardado.id), hasLength(1));
    expect(api.enviados, ['Hola']);
    c.dispose();
  });

  test('CA_047_07 sin respuesta no reenvía hasta poder releer', () async {
    final c = crear();
    await c.cargar();
    api.errorAlEnviar = const ServicioNoDisponibleFailure();
    await c.envio.enviar('Hola');
    api.errorDeLectura = const ServicioNoDisponibleFailure();
    await c.envio.reintentar(c.envio.estado.mensajes.single.idLocal);
    expect(api.enviados, ['Hola']);
    expect(c.envio.estado.mensajes.single.estado, EstadoDeEnvio.fallido);
    c.dispose();
  });

  test('CA_047_07 si el mensaje sí había llegado, no lo manda otra '
      'vez', () async {
    final c = crear();
    await c.cargar();
    api.errorAlEnviar = const ServicioNoDisponibleFailure();
    await c.envio.enviar('Hola');
    api.primera = [
      mensajeFalso(3, autorRol: 'cliente', texto: 'Hola'),
      ...api.primera,
    ];
    await c.envio.reintentar(c.envio.estado.mensajes.single.idLocal);
    expect(api.enviados, ['Hola']);
    expect(c.envio.estado.mensajes, isEmpty);
    expect(c.estado.mensajes.last.texto, 'Hola');
    c.dispose();
  });

  test('CA_047_07 si al releer no está, entonces lo reenvía', () async {
    final c = crear();
    await c.cargar();
    api.errorAlEnviar = const ServicioNoDisponibleFailure();
    await c.envio.enviar('Hola');
    api.errorAlEnviar = null;
    await c.envio.reintentar(c.envio.estado.mensajes.single.idLocal);
    expect(api.enviados, ['Hola', 'Hola']);
    c.dispose();
  });

  test('CA_047_07 un mensaje anterior con el mismo texto no cuenta como '
      'entregado', () async {
    api.primera = [
      mensajeFalso(3, autorRol: 'cliente', texto: 'Gracias'),
      ...api.primera,
    ];
    final c = crear();
    await c.cargar();
    api.errorAlEnviar = const ServicioNoDisponibleFailure();
    await c.envio.enviar('Gracias');
    api.errorAlEnviar = null;
    await c.envio.reintentar(c.envio.estado.mensajes.single.idLocal);
    expect(api.enviados, ['Gracias', 'Gracias']);
    c.dispose();
  });

  test('CA_047_11 si al reconectar la primera página no alcanza lo que había, '
      'no deja un hueco en el historial', () async {
    final c = crear();
    await c.cargar();
    await c.canalConectado();
    c.canalCaido();
    api
      ..primera = [mensajeFalso(41), mensajeFalso(40)]
      ..siguiente = 'intermedios';
    api.anteriores['intermedios'] = PaginaDeMensajes(
      items: [mensajeFalso(39), mensajeFalso(2)],
    );
    await c.canalConectado();
    expect(c.estado.mensajes.map((m) => m.id), ['m40', 'm41']);
    await c.cargarAnteriores();
    expect(c.estado.mensajes.map((m) => m.id), ['m2', 'm39', 'm40', 'm41']);
    c.dispose();
  });

  test('CA_047_09 un 409 al enviar relee y muestra la conversación '
      'cerrada', () async {
    final c = crear();
    await c.cargar();
    api
      ..errorAlEnviar = const ConflictoFailure()
      ..actual = detalleFalso(
        estado: 'cerrada',
        motivoCierre: 'request_cancelled',
      );
    await c.envio.enviar('Hola');
    await _asentar();
    expect(c.estado.detalle?.motivoCierre, 'request_cancelled');
    expect(c.envio.estado.cerrada, isTrue);
    c.dispose();
  });

  test('CA_047_10 marca leído hasta el último mostrado y avisa al '
      'globo', () async {
    final c = crear();
    await c.cargar();
    await _asentar();
    expect(api.leidos, [mensajeFalso(2).enviadoEn]);
    expect(marcas, 1);
    canal.recibir(
      MensajeEnVivo(conversacionId: 'c1', mensaje: mensajeFalso(5)),
    );
    await _asentar();
    expect(api.leidos.last, mensajeFalso(5).enviadoEn);
    c.dispose();
  });

  test('CA_047_10 sin mensajes no marca; si la marca falla no avisa', () async {
    api.primera = [];
    final vacia = crear();
    await vacia.cargar();
    await _asentar();
    expect(api.leidos, isEmpty);
    vacia.dispose();

    api
      ..primera = [mensajeFalso(1)]
      ..errorAlMarcar = const ServicioNoDisponibleFailure();
    final c = crear();
    await c.cargar();
    await _asentar();
    expect(marcas, 0);
    c.dispose();
  });

  test('CA_047_11 se une, ignora otras conversaciones, relee al reconectar y '
      'sale al cerrar', () async {
    final c = crear();
    await c.cargar();
    await c.canalConectado();
    expect(canal.unidas, ['c1']);
    canal.recibir(
      MensajeEnVivo(conversacionId: 'otra', mensaje: mensajeFalso(9)),
    );
    expect(c.estado.mensajes, hasLength(2));
    c.canalCaido();
    expect(c.estado.sinCanal, isTrue);
    final antes = api.cursores.length;
    await c.canalConectado();
    expect(canal.unidas, ['c1', 'c1']);
    expect(api.cursores.length, antes + 1);
    c.dispose();
    expect(canal.salidas, ['c1']);
  });

  test('CA_047_12 si no puede unirse queda sin conexión en vivo', () async {
    canal.admiteUnirse = false;
    final c = crear();
    await c.cargar();
    await c.canalConectado();
    expect(c.estado.sinCanal, isTrue);
    expect(c.estado.enVivo, isFalse);
    c.dispose();
  });

  test('CA_047_11 la primera unión, aunque llegue tarde, relee lo que se '
      'perdió', () async {
    final c = crear();
    await c.cargar();
    api.primera = [mensajeFalso(3), ...api.primera];
    await c.canalConectado();
    expect(c.estado.mensajes.map((m) => m.id), ['m1', 'm2', 'm3']);
    c.dispose();
  });

  test('CA_047_07 otro mensaje ya confirmado con contacto oculto no borra el '
      'que falló', () async {
    final c = crear();
    await c.cargar();
    api.errorAlEnviar = const ServicioNoDisponibleFailure();
    await c.envio.enviar('Primero');
    api
      ..errorAlEnviar = null
      ..ocultaContacto = true
      ..guardaEnElHistorial = true;
    await c.envio.enviar('Mi número es 5550000000');
    api
      ..ocultaContacto = false
      ..guardaEnElHistorial = false;
    final fallido = c.envio.estado.mensajes.firstWhere(
      (m) => m.estado == EstadoDeEnvio.fallido,
    );
    await c.envio.reintentar(fallido.idLocal);
    expect(api.enviados.where((t) => t == 'Primero'), hasLength(2));
    c.dispose();
  });

  test('CA_047_07 escribir de nuevo lo que sí había llegado no lo '
      'duplica', () async {
    final c = crear();
    await c.cargar();
    api.errorAlEnviar = const ServicioNoDisponibleFailure();
    await c.envio.enviar('Hola');
    api
      ..errorAlEnviar = null
      ..primera = [
        mensajeFalso(3, autorRol: 'cliente', texto: 'Hola'),
        ...api.primera,
      ];
    await c.envio.enviar('Hola');
    expect(api.enviados, ['Hola']);
    expect(c.envio.estado.mensajes, isEmpty);
    c.dispose();
  });

  test('CA_047_07 sin poder releer, lo nuevo se conserva y no sale', () async {
    final c = crear();
    await c.cargar();
    api.errorAlEnviar = const ServicioNoDisponibleFailure();
    await c.envio.enviar('Uno');
    api
      ..errorAlEnviar = null
      ..errorDeLectura = const ServicioNoDisponibleFailure();
    await c.envio.enviar('Dos');
    expect(api.enviados, ['Uno']);
    expect(c.envio.estado.mensajes.map((m) => m.texto), ['Uno', 'Dos']);
    c.dispose();
  });

  test('CA_047_10 con la conversación tapada no marca leído; al volver '
      'sí', () async {
    final c = crear();
    await c.cargar();
    await _asentar();
    api.leidos.clear();
    c.visible = false;
    canal.recibir(
      MensajeEnVivo(conversacionId: 'c1', mensaje: mensajeFalso(5)),
    );
    await _asentar();
    expect(api.leidos, isEmpty);
    c.visible = true;
    await _asentar();
    expect(api.leidos, [mensajeFalso(5).enviadoEn]);
    c.dispose();
  });

  test('CA_047_11 un mensaje en vivo durante la relectura no esconde un '
      'hueco', () async {
    final c = crear();
    await c.cargar();
    await c.canalConectado();
    c.canalCaido();
    api
      ..primera = [mensajeFalso(41), mensajeFalso(40)]
      ..siguiente = 'intermedios'
      ..alLeerPrimera = () => canal.recibir(
        MensajeEnVivo(conversacionId: 'c1', mensaje: mensajeFalso(41)),
      );
    await c.canalConectado();
    expect(c.estado.mensajes.map((m) => m.id), ['m40', 'm41']);
    expect(c.estado.siguiente, 'intermedios');
    c.dispose();
  });

  test('CA_047_13 404 al pedir anteriores la deja no disponible', () async {
    api.siguiente = 'p2';
    final c = crear();
    await c.cargar();
    api.errorDeLectura = const NoEncontradoFailure();
    await c.cargarAnteriores();
    expect(c.estado.falla, isA<NoEncontradoFailure>());
    c.dispose();
  });

  test('CA_047_16 al cerrar sesión tampoco quedan textos propios '
      'pendientes', () async {
    final c = crear();
    await c.cargar();
    api.errorAlEnviar = const ServicioNoDisponibleFailure();
    await c.envio.enviar('Privado');
    c.limpiar();
    expect(c.envio.estado.mensajes, isEmpty);
    c.dispose();
  });

  test('CA_047_13 404 al cargar queda como no disponible', () async {
    api.errorDeLectura = const NoEncontradoFailure();
    final c = crear();
    await c.cargar();
    expect(c.estado.falla, isA<NoEncontradoFailure>());
    expect(c.estado.detalle, isNull);
    c.dispose();
  });

  test('CA_047_16 al cerrar sesión no queda ningún mensaje en '
      'memoria', () async {
    final c = crear();
    await c.cargar();
    c.limpiar();
    expect(c.estado.mensajes, isEmpty);
    expect(c.estado.detalle, isNull);
    c.dispose();
  });
}
