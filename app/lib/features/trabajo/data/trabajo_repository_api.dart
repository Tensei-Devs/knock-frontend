import 'dart:convert';

import 'package:app/core/errores/failure.dart';
import 'package:app/core/red/configuracion_api.dart';
import 'package:app/core/red/errores_api.dart';
import 'package:app/features/trabajo/data/trabajo_mapper.dart';
import 'package:app/features/trabajo/domain/resumen_de_trabajo.dart';
import 'package:app/features/trabajo/domain/trabajo_repository.dart';
import 'package:knock_api/api.dart' as api;

final class TrabajoRepositoryApi implements TrabajoRepository {
  const TrabajoRepositoryApi({
    required this.bandejaApi,
    required this.trabajoApi,
    required this.descarteApi,
  });

  final api.BandejaApi bandejaApi;
  final api.TrabajoApi trabajoApi;
  final api.DescarteApi descarteApi;

  @override
  Future<PaginaTrabajo<SolicitudNueva>> bandeja({String? cursor}) async {
    final respuesta = await llamarApi(
      () => bandejaApi.apiVversionTecnicosMeSolicitudesGet(
        versionApi,
        cursor: cursor,
        limit: 20,
      ),
    );
    if (respuesta == null) throw const DatosInvalidosFailure();
    return TrabajoMapper.bandeja(respuesta);
  }

  @override
  Future<ResumenPaginado> resumen({String? cursorTerminadas}) async {
    final respuesta = await llamarApi(
      () => trabajoApi.apiVversionTecnicosMeTrabajoGet(
        versionApi,
        cursorTerminadas: cursorTerminadas,
        limit: 20,
      ),
    );
    if (respuesta == null) throw const DatosInvalidosFailure();
    return TrabajoMapper.resumen(respuesta);
  }

  @override
  Future<ResultadoDescarte> descartar(String id) async {
    final respuesta = await llamarApi(
      () => descarteApi.apiVversionSolicitudesIdDescartarPostWithHttpInfo(
        Uri.encodeComponent(id),
        versionApi,
      ),
    );
    if (respuesta.statusCode == 204) return ResultadoDescarte.descartada;
    if (respuesta.statusCode == 404) return ResultadoDescarte.noDisponible;
    if (respuesta.statusCode == 409 &&
        _codigo(respuesta.body) == 'request_not_dismissable') {
      return ResultadoDescarte.noDescartable;
    }
    throw mapearErrorApi(api.ApiException(respuesta.statusCode, null));
  }

  static String? _codigo(String cuerpo) {
    try {
      final json = jsonDecode(cuerpo);
      return json is Map && json['code'] is String
          ? json['code'] as String
          : null;
    } on FormatException {
      return null;
    }
  }
}
