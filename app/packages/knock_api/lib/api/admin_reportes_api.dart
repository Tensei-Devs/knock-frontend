//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class AdminReportesApi {
  AdminReportesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// REP-04: la cola por gravedad (crítica primero) y antigüedad, con cursor. Muestra motivo y texto, nunca teléfono ni dirección.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] gravedad:
  ///
  /// * [String] estado:
  ///   abierto and en_apelacion by default.
  ///
  /// * [DateTime] desde:
  ///
  /// * [DateTime] hasta:
  ///
  /// * [String] cursor:
  ///   Opaque cursor returned as nextCursor by the previous page.
  ///
  /// * [int] limite:
  ///   Page size, 1 to 50. Defaults to 20.
  Future<Response> apiVversionAdminReportesGetWithHttpInfo(String version, { String? gravedad, String? estado, DateTime? desde, DateTime? hasta, String? cursor, int? limite, Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/admin/reportes'
      .replaceAll('{version}', version);

    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (gravedad != null) {
      queryParams.addAll(_queryParams('', 'gravedad', gravedad));
    }
    if (estado != null) {
      queryParams.addAll(_queryParams('', 'estado', estado));
    }
    if (desde != null) {
      queryParams.addAll(_queryParams('', 'desde', desde));
    }
    if (hasta != null) {
      queryParams.addAll(_queryParams('', 'hasta', hasta));
    }
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

  /// REP-04: la cola por gravedad (crítica primero) y antigüedad, con cursor. Muestra motivo y texto, nunca teléfono ni dirección.
  ///
  /// Parameters:
  ///
  /// * [String] version (required):
  ///
  /// * [String] gravedad:
  ///
  /// * [String] estado:
  ///   abierto and en_apelacion by default.
  ///
  /// * [DateTime] desde:
  ///
  /// * [DateTime] hasta:
  ///
  /// * [String] cursor:
  ///   Opaque cursor returned as nextCursor by the previous page.
  ///
  /// * [int] limite:
  ///   Page size, 1 to 50. Defaults to 20.
  Future<ReportQueuePage?> apiVversionAdminReportesGet(String version, { String? gravedad, String? estado, DateTime? desde, DateTime? hasta, String? cursor, int? limite, Future<void>? abortTrigger, }) async {
    final response = await apiVversionAdminReportesGetWithHttpInfo(version, gravedad: gravedad, estado: estado, desde: desde, hasta: hasta, cursor: cursor, limite: limite, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ReportQueuePage',) as ReportQueuePage;
    
    }
    return null;
  }

  /// REP-05: asigna la gravedad con motivo; la respuesta se deriva de ella. 404 `report_not_found`; 409 `report_already_decided`; 503 `audit_unavailable`.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [ReportDecisionBody] reportDecisionBody (required):
  Future<Response> apiVversionAdminReportesIdDecisionPostWithHttpInfo(String id, String version, ReportDecisionBody reportDecisionBody, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/admin/reportes/{id}/decision'
      .replaceAll('{id}', id)
      .replaceAll('{version}', version);

    Object? postBody = reportDecisionBody;

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

  /// REP-05: asigna la gravedad con motivo; la respuesta se deriva de ella. 404 `report_not_found`; 409 `report_already_decided`; 503 `audit_unavailable`.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] version (required):
  ///
  /// * [ReportDecisionBody] reportDecisionBody (required):
  Future<ReportDecisionResult?> apiVversionAdminReportesIdDecisionPost(String id, String version, ReportDecisionBody reportDecisionBody, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionAdminReportesIdDecisionPostWithHttpInfo(id, version, reportDecisionBody, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ReportDecisionResult',) as ReportDecisionResult;
    
    }
    return null;
  }
}
