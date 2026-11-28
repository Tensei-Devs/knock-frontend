//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18


part of openapi.api;


class InternalNotFinishedReportApi {
  InternalNotFinishedReportApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'GET /api/v{version}/interno/visitas/{visitaId}/reporte-no-terminado' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] visitaId (required):
  ///
  /// * [String] version (required):
  Future<Response> apiVversionInternoVisitasVisitaIdReporteNoTerminadoGetWithHttpInfo(String visitaId, String version, { Future<void>? abortTrigger, }) async {
    final path = r'/api/v{version}/interno/visitas/{visitaId}/reporte-no-terminado'
      .replaceAll('{visitaId}', visitaId)
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

  /// Parameters:
  ///
  /// * [String] visitaId (required):
  ///
  /// * [String] version (required):
  Future<NotFinishedReportResponse?> apiVversionInternoVisitasVisitaIdReporteNoTerminadoGet(String visitaId, String version, { Future<void>? abortTrigger, }) async {
    final response = await apiVversionInternoVisitasVisitaIdReporteNoTerminadoGetWithHttpInfo(visitaId, version, abortTrigger: abortTrigger,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'NotFinishedReportResponse',) as NotFinishedReportResponse;
    
    }
    return null;
  }
}
