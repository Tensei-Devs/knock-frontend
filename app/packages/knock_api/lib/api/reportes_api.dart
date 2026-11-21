//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class ReportesApi {
  ReportesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Apela la decisión de un reporte, una sola vez. 200; 403 si no es una de las dos partes; 409 `appeal_not_allowed` sin decisión o con una apelación previa.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [AppealBody] appealBody (required):
  Future<Response> apiVversionReportesIdApelacionPostWithHttpInfo(String id, String version, AppealBody appealBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/reportes/{id}/apelacion'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = appealBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json', 'text/json', 'application/*+json'];


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

  /// Apela la decisión de un reporte, una sola vez. 200; 403 si no es una de las dos partes; 409 `appeal_not_allowed` sin decisión o con una apelación previa.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [AppealBody] appealBody (required):
  Future<AppealResult?> apiVversionReportesIdApelacionPost(String id, String version, AppealBody appealBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionReportesIdApelacionPostWithHttpInfo(id, version, appealBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AppealResult',) as AppealResult;
    
    }
    return null;
  }

  /// Los reportes que hizo quien llama, del más reciente al más antiguo, con paginación por cursor. Nunca lleva datos de la otra parte.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursor:
  ///   Opaque cursor returned as nextCursor by the previous page.
  ///
  /// * [int] limite:
  ///   Page size, 1 to 50. Defaults to 20.
  Future<Response> apiVversionReportesMeGetWithHttpInfo(String version, { String? cursor, int? limite, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/reportes/me'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (cursor != null) {
      queryParams.addAll(_queryParams('', 'cursor', cursor));
    }
    if (limite != null) {
      queryParams.addAll(_queryParams('', 'limite', limite));
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

  /// Los reportes que hizo quien llama, del más reciente al más antiguo, con paginación por cursor. Nunca lleva datos de la otra parte.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] cursor:
  ///   Opaque cursor returned as nextCursor by the previous page.
  ///
  /// * [int] limite:
  ///   Page size, 1 to 50. Defaults to 20.
  Future<ReportPage?> apiVversionReportesMeGet(String version, { String? cursor, int? limite, Future<void>? abortTrigger, }) async {
    final response = await apiVversionReportesMeGetWithHttpInfo(version, cursor: cursor, limite: limite, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ReportPage',) as ReportPage;
    
    }
    return null;
  }

  /// Crea un reporte (`abierto`). 201 la primera vez y 200 si ya había uno abierto igual; 422 con `errors.&lt;campo&gt;` si un valor no es válido, si es contra uno mismo o contra alguien que no existe, o `report_content_rejected`; 503 `report_moderation_unavailable` si la moderación no responde. Con motivo de peligro la respuesta lleva el aviso de llamar al 911.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [CreateReportBody] createReportBody (required):
  Future<Response> apiVversionReportesPostWithHttpInfo(String version, CreateReportBody createReportBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/reportes'
      .replaceAll('{version}', version);

    Object? postBody = createReportBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json', 'text/json', 'application/*+json'];


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

  /// Crea un reporte (`abierto`). 201 la primera vez y 200 si ya había uno abierto igual; 422 con `errors.&lt;campo&gt;` si un valor no es válido, si es contra uno mismo o contra alguien que no existe, o `report_content_rejected`; 503 `report_moderation_unavailable` si la moderación no responde. Con motivo de peligro la respuesta lleva el aviso de llamar al 911.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [CreateReportBody] createReportBody (required):
  Future<ReportCreated?> apiVversionReportesPost(String version, CreateReportBody createReportBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionReportesPostWithHttpInfo(version, createReportBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ReportCreated',) as ReportCreated;
    
    }
    return null;
  }
}
