import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/mi/domain/casa_y_auto.dart';
import 'package:http/http.dart' as http;

/// REAL: `/api/v1/me/casa-y-auto` (backend 041, CAS-01 a CAS-05). Va por el
/// transporte con sesión, que renueva el token y cierra la sesión si el 401
/// se repite (spec 026; CA-02, CA-04, CA-07, CA-10 y CA-13). Una escritura no
/// se reintenta aquí. No registra nada: ni nombres ni años.
class CasaYAutoRepositoryApi implements CasaYAutoRepository {
  const CasaYAutoRepositoryApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  static const _ruta = 'me/casa-y-auto';

  @override
  Future<List<ElementoCasa>> listar() async {
    final json = (await enviarJson(transporte, url, 'GET', _ruta)).json;
    if (json is! List<Object?>) throw const DatosInvalidosFailure();
    return json.map(elementoDesdeJson).toList(growable: false);
  }

  @override
  Future<ElementoCasa> agregar({
    required TipoElemento tipo,
    required String nombre,
    int? anio,
  }) async {
    final r = await enviarJson(
      transporte,
      url,
      'POST',
      _ruta,
      cuerpo: _cuerpo(tipo, nombre, anio),
    );
    // El único 409 de la creación es `item_limit_reached` (R-15): llega como
    // ConflictoFailure y la pantalla lo explica.
    return elementoDesdeJson(r.json);
  }

  @override
  Future<ElementoCasa> editar(
    String id, {
    required TipoElemento tipo,
    required String nombre,
    int? anio,
  }) async {
    final r = await enviarJson(
      transporte,
      url,
      'PUT',
      '$_ruta/${_id(id)}',
      cuerpo: _cuerpo(tipo, nombre, anio),
      aceptar: const {404},
    );
    // Un elemento ajeno responde 404 igual que uno que no existe (R-16).
    if (r.estado == 404) throw const NoEncontradoFailure();
    return elementoDesdeJson(r.json);
  }

  @override
  Future<void> quitar(String id) async {
    final r = await enviarJson(
      transporte,
      url,
      'DELETE',
      '$_ruta/${_id(id)}',
      aceptar: const {404},
    );
    if (r.estado == 404) throw const NoEncontradoFailure();
  }

  @override
  Future<PaginaHistorial> historial(String id, {String? cursor}) async {
    final r = await enviarJson(
      transporte,
      url,
      'GET',
      '$_ruta/${_id(id)}/historial',
      consulta: cursor == null ? null : {'cursor': cursor},
      aceptar: const {404},
    );
    if (r.estado == 404) throw const NoEncontradoFailure();
    return paginaDesdeJson(r.json);
  }

  /// El año solo viaja en los autos (R-14).
  static Map<String, Object?> _cuerpo(
    TipoElemento tipo,
    String nombre,
    int? anio,
  ) => {
    'tipo': tipo.clave,
    'nombre': nombre.trim(),
    if (tipo == TipoElemento.auto) 'anio': anio,
  };

  static String _id(String id) {
    if (id.trim().isEmpty) throw const DatosRechazadosFailure();
    return Uri.encodeComponent(id);
  }
}

/// Lee un `ItemResponse`; un campo que falta o con otro tipo es un dato
/// inválido (no se inventa nada).
ElementoCasa elementoDesdeJson(Object? json) {
  if (json is! Map<Object?, Object?>) throw const DatosInvalidosFailure();
  final id = json['id'];
  final tipo = TipoElemento.deClave(json['tipo'] as String?);
  final nombre = json['nombre'];
  final creado = json['creadoEn'];
  final fecha = creado is String ? DateTime.tryParse(creado) : null;
  final anio = switch (json['anio']) {
    final int n => n,
    final String s => int.tryParse(s),
    _ => null,
  };
  if (id is! String || id.isEmpty || tipo == null || nombre is! String) {
    throw const DatosInvalidosFailure();
  }
  if (fecha == null) throw const DatosInvalidosFailure();
  return ElementoCasa(
    id: id,
    tipo: tipo,
    nombre: nombre,
    anio: anio,
    creadoEn: fecha,
  );
}

/// Lee un `CursorPageOfHistoryItemResponse`.
PaginaHistorial paginaDesdeJson(Object? json) {
  if (json is! Map<Object?, Object?>) throw const DatosInvalidosFailure();
  final items = json['items'];
  final siguiente = json['nextCursor'];
  if (items is! List<Object?> || (siguiente != null && siguiente is! String)) {
    throw const DatosInvalidosFailure();
  }
  return PaginaHistorial(
    trabajos: items.map(_trabajo).toList(growable: false),
    siguiente: siguiente as String?,
  );
}

TrabajoDelElemento _trabajo(Object? json) {
  if (json is! Map<Object?, Object?>) throw const DatosInvalidosFailure();
  final fecha = json['fecha'];
  final oficio = json['oficio'];
  final tecnico = json['tecnico'];
  final cuando = fecha is String ? DateTime.tryParse(fecha) : null;
  if (cuando == null || oficio is! String || tecnico is! String) {
    throw const DatosInvalidosFailure();
  }
  return TrabajoDelElemento(fecha: cuando, oficio: oficio, tecnico: tecnico);
}
