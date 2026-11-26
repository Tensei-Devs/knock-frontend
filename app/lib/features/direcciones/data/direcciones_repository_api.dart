import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/contrato_json.dart';
import 'package:app/features/direcciones/domain/direccion.dart';
import 'package:app/features/direcciones/domain/direcciones_repository.dart';
import 'package:http/http.dart' as http;

/// REAL: `/api/v1/me/direcciones` (backend 040). [transporte] es
/// `transporteApiProvider` (Bearer y renovación). Una escritura nunca se
/// reintenta aquí (spec 026, R-13).
class DireccionesRepositoryApi implements DireccionesRepository {
  const DireccionesRepositoryApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  @override
  Future<List<Direccion>> listar() async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'GET',
      'me/direcciones',
    );
    return listaDelContrato(r.json).map(_aDireccion).toList(growable: false);
  }

  @override
  Future<Direccion> crear(DireccionNueva nueva) async {
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'POST',
      'me/direcciones',
      cuerpo: {
        'calleNumero': nueva.calleNumero.trim(),
        'colonia': nueva.colonia.trim(),
        'referencias': ?nueva.referencias,
        'principal': nueva.principal,
      },
    );
    return _aDireccion(r.json);
  }

  @override
  Future<Direccion> editar(String id, CambiosDireccion cambios) async {
    if (id.trim().isEmpty || cambios.estaVacio) {
      throw const DatosRechazadosFailure();
    }
    final r = await enviarJsonONoEncontrado(
      transporte,
      url,
      'PUT',
      'me/direcciones/${Uri.encodeComponent(id)}',
      cuerpo: {
        'calleNumero': ?cambios.calleNumero?.trim(),
        'colonia': ?cambios.colonia?.trim(),
        'referencias': ?cambios.referencias,
        'principal': ?cambios.principal,
      },
    );
    return _aDireccion(r.json);
  }

  @override
  Future<void> eliminar(String id) async {
    if (id.trim().isEmpty) throw const DatosRechazadosFailure();
    await enviarJsonONoEncontrado(
      transporte,
      url,
      'DELETE',
      'me/direcciones/${Uri.encodeComponent(id)}',
    );
  }
}

Direccion _aDireccion(Object? json) {
  final m = objetoDelContrato(json);
  String texto(String campo) => textoObligatorio(m[campo]);
  return Direccion(
    id: texto('id'),
    calleNumero: texto('calleNumero'),
    colonia: texto('colonia'),
    referencias: textoOpcional(m['referencias']),
    principal: booleanoObligatorio(m['principal']),
    creadoEn: fechaHoraObligatoria(m['creadoEn']),
  );
}
