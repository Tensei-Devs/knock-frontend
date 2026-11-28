import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/mensajes/domain/conversacion.dart';

void main() {
  test('T-02 conserva el resumen y permite ausencia de último mensaje', () {
    const conversacion = Conversacion(
      id: 'conversacion-1',
      solicitudId: 'solicitud-1',
      rol: 'cliente',
      estado: 'activa',
      contraparte: ContraparteConversacion(nombre: 'Técnico'),
      servicio: 'Plomería',
      noLeidos: 2,
    );

    expect(conversacion.solicitudId, 'solicitud-1');
    expect(conversacion.contraparte.nombre, 'Técnico');
    expect(conversacion.ultimoMensaje, isNull);
    expect(conversacion.noLeidos, 2);
  });

  test('T-02 conserva la información del último mensaje en memoria', () {
    final fecha = DateTime.utc(2026, 11, 26);
    final mensaje = UltimoMensaje(
      texto: 'Mensaje de prueba',
      enviadoEn: fecha,
      autorRol: 'tecnico',
    );

    expect(mensaje.texto, 'Mensaje de prueba');
    expect(mensaje.enviadoEn, fecha);
    expect(mensaje.autorRol, 'tecnico');
  });

  test('T-02 contador conserva el total recibido del servidor', () {
    const contador = ContadorDeNoLeidos(total: 3);
    expect(contador.total, 3);
  });
}
