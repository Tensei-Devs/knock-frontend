//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class BusquedaApi {
  BusquedaApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'GET /api/v{version}/busqueda' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] q:
  ///   Obligatorio; texto normalizado de 2 a 80 caracteres.
  ///
  /// * [String] coloniaId:
  ///   Obligatorio; ObjectId de la colonia activa.
  ///
  /// * [String] oficio:
  ///   Clave opcional de un oficio activo.
  ///
  /// * [String] soloVerificados:
  ///   Booleano opcional true o false; por defecto false.
  ///
  /// * [String] cursor:
  ///   Cursor opaco de la consulta y versión del diccionario.
  ///
  /// * [String] limit:
  ///   Entero de 1 a 20; por defecto 20.
  Future<Response> apiVversionBusquedaGetWithHttpInfo(String version, { String? q, String? coloniaId, String? oficio, String? soloVerificados, String? cursor, String? limit, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/busqueda'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (q != null) {
      queryParams.addAll(_queryParams('', 'q', q));
    }
    if (coloniaId != null) {
      queryParams.addAll(_queryParams('', 'coloniaId', coloniaId));
    }
    if (oficio != null) {
      queryParams.addAll(_queryParams('', 'oficio', oficio));
    }
    if (soloVerificados != null) {
      queryParams.addAll(_queryParams('', 'soloVerificados', soloVerificados));
    }
    if (cursor != null) {
      queryParams.addAll(_queryParams('', 'cursor', cursor));
    }
    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] q:
  ///   Obligatorio; texto normalizado de 2 a 80 caracteres.
  ///
  /// * [String] coloniaId:
  ///   Obligatorio; ObjectId de la colonia activa.
  ///
  /// * [String] oficio:
  ///   Clave opcional de un oficio activo.
  ///
  /// * [String] soloVerificados:
  ///   Booleano opcional true o false; por defecto false.
  ///
  /// * [String] cursor:
  ///   Cursor opaco de la consulta y versión del diccionario.
  ///
  /// * [String] limit:
  ///   Entero de 1 a 20; por defecto 20.
  Future<BusquedaResponse?> apiVversionBusquedaGet(String version, { String? q, String? coloniaId, String? oficio, String? soloVerificados, String? cursor, String? limit, Future<void>? abortTrigger, }) async {
    final response = await apiVversionBusquedaGetWithHttpInfo(version, q: q, coloniaId: coloniaId, oficio: oficio, soloVerificados: soloVerificados, cursor: cursor, limit: limit, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'BusquedaResponse',) as BusquedaResponse;
    
    }
    return null;
  }
}
