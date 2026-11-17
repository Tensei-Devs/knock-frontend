import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/domain/aviso.dart';
import 'package:app/features/actividad/domain/visita.dart';

/// Convierte las respuestas de `/visitas` (backend 022) en modelos del dominio.
/// Cualquier campo que no cumpla el contrato lanza [DatosInvalidosFailure]:
/// nunca se muestra un dato a medias ni un código inventado.
abstract final class VisitaContratoMapper {
  /// `GET /visitas/{id}` en la vista del **cliente**.
  ///
  /// La vista del técnico (`rol: tecnico`) no trae al técnico y no se usa en la
  /// app del cliente: se rechaza como dato inválido.
  static Visita visita(Object? json) {
    final m = _mapa(json);
    if (m['rol'] != 'cliente') throw const DatosInvalidosFailure();
    final tecnico = _mapa(m['tecnico']);
    final lugar = _mapa(m['lugar']);
    final direccion = lugar['direccion'];
    final codigo = m['codigo'];
    final motivo = m['motivoCodigo'];
    return Visita(
      id: _texto(m['id']),
      estado: EstadoVisita.desdeTexto(_texto(m['estado'])),
      esTaller: _texto(m['modalidad']) == 'taller',
      dia: _dia(m['dia']),
      hora: _texto(m['hora']),
      tecnico: TecnicoDeVisita(
        nombre: _texto(tecnico['nombre']),
        verificado: _booleano(tecnico['verificado']),
        nivelVerificacion: _opcional(tecnico['nivelVerificacion']),
        telefono: _opcional(tecnico['telefono']),
        whatsapp: _opcional(tecnico['whatsapp']),
        fotoUrl: _opcional(tecnico['fotoUrl']),
      ),
      direccion: direccion is String ? direccion : '',
      codigo: codigo is String && RegExp(r'^\d{4}$').hasMatch(codigo)
          ? codigo
          : null,
      motivoCodigo: motivo is String ? MotivoCodigo.desdeTexto(motivo) : null,
      puedeAvisar: m['puedeAvisar'] == true,
      precio: _entero(m['precio']),
      tope: _entero(m['tope']),
    );
  }

  /// `POST /visitas/{id}/aviso`.
  static MensajeAviso aviso(Object? json) {
    final m = _mapa(json);
    return MensajeAviso(
      texto: _texto(m['texto']),
      incluyeCodigo: _booleano(m['incluyeCodigo']),
      incluyeDireccion: _booleano(m['incluyeDireccion']),
    );
  }

  static Map<Object?, Object?> _mapa(Object? valor) {
    if (valor is! Map<Object?, Object?>) throw const DatosInvalidosFailure();
    return valor;
  }

  static String _texto(Object? valor) {
    if (valor is! String || valor.trim().isEmpty) {
      throw const DatosInvalidosFailure();
    }
    return valor;
  }

  static String? _opcional(Object? valor) =>
      valor is String && valor.trim().isNotEmpty ? valor : null;

  static bool _booleano(Object? valor) {
    if (valor is! bool) throw const DatosInvalidosFailure();
    return valor;
  }

  /// Enteros del contrato: llegan como número o como texto numérico; `null`
  /// si no hay valor.
  static int? _entero(Object? valor) {
    if (valor == null) return null;
    if (valor is int) return valor;
    if (valor is String) {
      final n = int.tryParse(valor);
      if (n != null) return n;
    }
    throw const DatosInvalidosFailure();
  }

  /// `AAAA-MM-DD` del contrato, como día local sin hora.
  static DateTime _dia(Object? valor) {
    final f = valor is String ? DateTime.tryParse(valor) : null;
    if (f == null) throw const DatosInvalidosFailure();
    return DateTime(f.year, f.month, f.day);
  }
}
