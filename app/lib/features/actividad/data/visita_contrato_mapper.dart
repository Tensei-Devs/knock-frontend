import 'package:app/core/errores/failure.dart';
import 'package:app/features/actividad/data/contrato_json.dart';
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
    final m = mapaDelContrato(json);
    if (m['rol'] != 'cliente') throw const DatosInvalidosFailure();
    final tecnico = mapaDelContrato(m['tecnico']);
    final lugar = mapaDelContrato(m['lugar']);
    final direccion = lugar['direccion'];
    final codigo = m['codigo'];
    final motivo = m['motivoCodigo'];
    return Visita(
      id: textoDelContrato(m['id']),
      estado: EstadoVisita.desdeTexto(textoDelContrato(m['estado'])),
      esTaller: textoDelContrato(m['modalidad']) == 'taller',
      dia: diaLocalDelContrato(m['dia']),
      hora: textoDelContrato(m['hora']),
      tecnico: TecnicoDeVisita(
        nombre: textoDelContrato(tecnico['nombre']),
        verificado: booleanoDelContrato(tecnico['verificado']),
        nivelVerificacion: textoOpcionalDelContrato(
          tecnico['nivelVerificacion'],
        ),
        telefono: textoOpcionalDelContrato(tecnico['telefono']),
        whatsapp: textoOpcionalDelContrato(tecnico['whatsapp']),
        fotoUrl: textoOpcionalDelContrato(tecnico['fotoUrl']),
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
    final m = mapaDelContrato(json);
    return MensajeAviso(
      texto: textoDelContrato(m['texto']),
      incluyeCodigo: booleanoDelContrato(m['incluyeCodigo']),
      incluyeDireccion: booleanoDelContrato(m['incluyeDireccion']),
    );
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
}
