import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/enviar_json.dart';
import 'package:app/features/explorar/domain/explorar.dart';
import 'package:http/http.dart' as http;

/// REAL: `GET /api/v1/explorar` (backend 046, TEC-14). La ruta admite sesión
/// opcional: con sesión el transporte manda el token y llegan además
/// «trabajos reales» y «cerca de ti»; sin ella, solo los bloques públicos.
/// No registra nada.
class ExplorarRepositoryApi implements ExplorarRepository {
  const ExplorarRepositoryApi({required this.transporte, required this.url});

  final http.Client transporte;
  final String url;

  @override
  Future<Explorar> cargar(FiltroExplorar filtro) async {
    final r = await enviarJson(
      transporte,
      url,
      'GET',
      'explorar',
      consulta: {'filtro': filtro.clave},
    );
    return explorarDesdeJson(r.json, filtro);
  }
}

/// Lee solo los campos del contrato (`ExploreResponse`); lo demás se ignora.
/// Si falta un bloque obligatorio o un campo obligatorio, es un dato inválido.
Explorar explorarDesdeJson(Object? json, FiltroExplorar filtro) {
  if (json is! Map<String, Object?>) throw const DatosInvalidosFailure();
  return Explorar(
    filtro: filtro,
    serviciosPopulares: _lista(json['serviciosPopulares'], _servicio),
    mejorCalificados: _lista(json['mejorCalificados'], tecnicoDesdeJson),
    ideas: _lista(json['ideas'], _idea),
    trabajosReales: json['trabajosReales'] == null
        ? null
        : _lista(json['trabajosReales'], _foto),
    cercaDeTi: json['cercaDeTi'] == null
        ? null
        : _lista(json['cercaDeTi'], tecnicoDesdeJson),
  );
}

/// `TechnicianProfileResponse`: solo el resumen; el detalle no se usa aquí.
TecnicoDestacado tecnicoDesdeJson(Object? json) {
  if (json is! Map<String, Object?>) throw const DatosInvalidosFailure();
  final oficios = json['oficios'];
  if (oficios is! List<Object?>) throw const DatosInvalidosFailure();
  return TecnicoDestacado(
    id: _texto(json['id']),
    nombre: _texto(json['nombre']),
    verificacion: _texto(json['verificacion']),
    oficios: [for (final o in oficios) _texto(o)],
    nombreNegocio: _textoOpcional(json['nombreNegocio']),
    fotoUrl: _textoOpcional(json['fotoUrl']),
    calificacion: _numero(json['calificacion'])?.toDouble(),
    anios: _numero(json['anios'])?.toInt(),
    descripcionCorta: _textoOpcional(json['descripcionCorta']),
  );
}

ServicioPopular _servicio(Object? json) {
  if (json is! Map<String, Object?>) throw const DatosInvalidosFailure();
  final tecnicos = _numero(json['tecnicos']);
  if (tecnicos == null) throw const DatosInvalidosFailure();
  return ServicioPopular(
    clave: _texto(json['clave']),
    nombre: _texto(json['nombre']),
    tecnicos: tecnicos.toInt(),
  );
}

IdeaExplorar _idea(Object? json) {
  if (json is! Map<String, Object?>) throw const DatosInvalidosFailure();
  return IdeaExplorar(
    clave: _texto(json['clave']),
    nombre: _texto(json['nombre']),
  );
}

FotoTrabajo _foto(Object? json) {
  if (json is! Map<String, Object?>) throw const DatosInvalidosFailure();
  final creado = DateTime.tryParse(_texto(json['creadoEn']));
  if (creado == null) throw const DatosInvalidosFailure();
  return FotoTrabajo(
    id: _texto(json['id']),
    url: _texto(json['url']),
    creadoEn: creado,
  );
}

List<T> _lista<T>(Object? json, T Function(Object?) leer) {
  if (json is! List<Object?>) throw const DatosInvalidosFailure();
  return json.map(leer).toList(growable: false);
}

String _texto(Object? valor) =>
    valor is String ? valor : throw const DatosInvalidosFailure();

String? _textoOpcional(Object? valor) => switch (valor) {
  null => null,
  final String s => s,
  _ => throw const DatosInvalidosFailure(),
};

/// El contrato declara los números como `integer|number|string`.
num? _numero(Object? valor) => switch (valor) {
  null => null,
  final num n => n,
  final String s => num.tryParse(s) ?? (throw const DatosInvalidosFailure()),
  _ => throw const DatosInvalidosFailure(),
};
