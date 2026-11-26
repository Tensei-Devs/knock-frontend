//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class MeExportacionesApi {
  MeExportacionesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// USR-06. Pide la descarga de todos los datos propios; se entrega en 48 horas. Una sola en curso por persona.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<Response> apiVversionMeExportacionesPostWithHttpInfo(String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/exportaciones'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
      abortTrigger: abortTrigger,
    );
  }

  /// USR-06. Pide la descarga de todos los datos propios; se entrega en 48 horas. Una sola en curso por persona.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<void> apiVversionMeExportacionesPost(String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeExportacionesPostWithHttpInfo(version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// USR-06b. La app lo llama al abrir el aviso `exportacion_lista`: `en_preparacion`, `vencida` o `lista` con un enlace firmado de 24 horas que se genera en este momento. 404 `export_not_found` si nunca pidió una; 503 `export_unavailable` si el contenedor no responde. Solo la persona del token; sin caché y el enlace no se registra.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<Response> apiVversionMeExportacionesUltimaGetWithHttpInfo(String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/me/exportaciones/ultima'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

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

  /// USR-06b. La app lo llama al abrir el aviso `exportacion_lista`: `en_preparacion`, `vencida` o `lista` con un enlace firmado de 24 horas que se genera en este momento. 404 `export_not_found` si nunca pidió una; 503 `export_unavailable` si el contenedor no responde. Solo la persona del token; sin caché y el enlace no se registra.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  Future<LatestExportResponse?> apiVversionMeExportacionesUltimaGet(String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionMeExportacionesUltimaGetWithHttpInfo(version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'LatestExportResponse',) as LatestExportResponse;
    
    }
    return null;
  }
}
